::  lib/bide-engine.hoon — game tick processing engine
::
::  Extracts tick processing from the main agent into a
::  reusable door parameterised on game-state.
::
/-  *bide
/+  bide-skills, bide-combat, bide-monsters, bide-modifiers
/+  bide-xp, bide-potions, bide-prayers, bide-specials
/+  bide-spells, bide-pets, bide-food, bide-farming
/+  bide-dungeons, bide-bank, bide-equipment, bide-slayer
|%
+$  card  card:agent:gall
--
|_  gs=game-state
++  process-tick
  |=  =bowl:gall
  ^-  (quip card game-state)
  =.  last-tick.gs  now.bowl
  =/  aa  active-action.gs
  ?~  aa  `gs
  =/  act  u.aa
  ?-  -.act
    %skilling  (process-skill-tick act bowl)
    %combat    `gs  :: combat uses its own Behn timers
    %dungeon   `gs  :: dungeons use combat timers
  ==
::
++  process-skill-tick
  |=  [act=active-action =bowl:gall]
  ^-  (quip card game-state)
  ?>  ?=(%skilling -.act)
  =/  sdef=(unit skill-def)  (~(get by skill-registry:bide-skills) skill.act)
  ?~  sdef  `gs
  =/  adef=(unit action-def)
    =/  acts=(list action-def)  actions.u.sdef
    |-
    ?~  acts  ~
    ?:  =(id.i.acts target.act)  `i.acts
    $(acts t.acts)
  ?~  adef  `gs
  ::  look up secondary action def (multitree)
  =/  adef2=(unit action-def)
    ?~  secondary.act  ~
    =/  acts=(list action-def)  actions.u.sdef
    |-
    ?~  acts  ~
    ?:  =(id.i.acts u.secondary.act)  `i.acts
    $(acts t.acts)
  ::  compute unified modifiers
  =/  mods=modifier-set
    (compute-modifiers:bide-modifiers skills.gs slots.equipment.gs active-familiar.gs active-potions.gs active-prayers.gs pets-found.gs star-levels.gs skill-upgrades.gs `skill.act)
  =/  adjusted-time=@ud  (apply-speed-bonus:bide-modifiers mods base-time.u.adef)
  ::  multitree: use max of both action times
  =?  adjusted-time  ?=(^ adef2)
    (max adjusted-time (apply-speed-bonus:bide-modifiers mods base-time.u.adef2))
  =/  base-dr=@dr  (div (mul ~s1 (max adjusted-time 500)) 1.000)
  ?:  =(base-dr *@dr)  `gs
  =/  elapsed=@dr  (sub now.bowl started.act)
  ?:  (lth elapsed base-dr)  `gs
  =/  num-actions=@ud  (div elapsed base-dr)
  ::  cap by available inputs (artisan skills)
  =/  inputs=(list [item=item-id qty=@ud])  inputs.u.adef
  =.  num-actions
    |-
    ?~  inputs  num-actions
    =/  have=@ud  (fall (~(get by items.bank.gs) item.i.inputs) 0)
    =/  can-do=@ud  (div have qty.i.inputs)
    $(inputs t.inputs, num-actions (min num-actions can-do))
  ?:  =(num-actions 0)
    =.  active-action.gs  ~
    `gs
  ::  consume inputs
  =.  bank.gs
    |-
    ?~  inputs  bank.gs
    =/  have=@ud  (fall (~(get by items.bank.gs) item.i.inputs) 0)
    =/  used=@ud  (mul num-actions qty.i.inputs)
    =/  remaining=@ud  (sub have used)
    =.  items.bank.gs
      ?:  =(remaining 0)
        (~(del by items.bank.gs) item.i.inputs)
      (~(put by items.bank.gs) item.i.inputs remaining)
    $(inputs t.inputs)
  =/  ss=skill-state
    (fall (~(get by skills.gs) skill.act) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
  =/  base-xp=@ud  (mul xp.u.adef num-actions)
  ::  apply XP bonuses via modifier engine
  =/  total-xp=@ud  (apply-xp-bonus:bide-modifiers mods skill.act skill-type.u.sdef base-xp)
  ::  decrement familiar charges per action
  =?  active-familiar.gs  ?=(^ active-familiar.gs)
    =/  af  u.active-familiar.gs
    =/  new-charges=@ud  ?:((gth charges.af num-actions) (sub charges.af num-actions) 0)
    ?:  =(new-charges 0)  ~
    `af(charges new-charges)
  =/  new-xp=@ud  (add xp.ss total-xp)
  =/  new-level=@ud  (level-from-xp:bide-xp new-xp)
  =.  ss  ss(xp new-xp, level new-level)
  =/  mastery-gained=@ud  (mul mastery-xp.u.adef num-actions)
  =/  cur-action-mastery=@ud  (fall (~(get by actions.mastery.ss) target.act) 0)
  =.  actions.mastery.ss
    (~(put by actions.mastery.ss) target.act (add cur-action-mastery mastery-gained))
  =/  pool-gain=@ud  (div mastery-gained 4)
  =.  pool-xp.mastery.ss  (add pool-xp.mastery.ss pool-gain)
  =.  skills.gs  (~(put by skills.gs) skill.act ss)
  ::  update prayer max when prayer levels up
  =?  prayer-max.player.gs  =(skill.act %prayer)
    new-level
  =/  outputs=(list output-def)  outputs.u.adef
  ::  roll outputs respecting chance field (og door + eny entropy)
  =/  produced=(list [item-id @ud])
    =/  outs  outputs
    =/  rng  ~(. og eny.bowl)
    =/  acc=(list [item-id @ud])  ~
    |-
    ?~  outs  acc
    ?:  =(chance.i.outs 100)
      $(outs t.outs, acc [[item.i.outs (mul num-actions max-qty.i.outs)] acc])
    =/  total=@ud  (mul num-actions chance.i.outs)
    =/  full-drops=@ud  (div total 100)
    =/  remainder=@ud  (mod total 100)
    =^  roll  rng  (rads:rng 100)
    =/  drops=@ud  ?:((lth roll remainder) (add full-drops 1) full-drops)
    ?:  =(drops 0)  $(outs t.outs)
    $(outs t.outs, acc [[item.i.outs (mul drops max-qty.i.outs)] acc])
  ::  add produced items to bank
  =.  items.bank.gs
    =/  prod  produced
    |-
    ?~  prod  items.bank.gs
    =/  cur=@ud  (fall (~(get by items.bank.gs) -.i.prod) 0)
    =.  items.bank.gs  (~(put by items.bank.gs) -.i.prod (add cur +.i.prod))
    $(prod t.prod)
  ::  GP per action (alt magic alchemy)
  =?  gp.player.gs  (gth gp-per-action.u.adef 0)
    (add gp.player.gs (mul gp-per-action.u.adef num-actions))
  =?  total-gp-earned.stats.gs  (gth gp-per-action.u.adef 0)
    (add total-gp-earned.stats.gs (mul gp-per-action.u.adef num-actions))
  ::  stats: actions completed
  =/  prev-count=@ud
    (fall (~(get by actions-completed.stats.gs) target.act) 0)
  =.  actions-completed.stats.gs
    (~(put by actions-completed.stats.gs) target.act (add prev-count num-actions))
  ::  stats: items produced
  =.  items-produced.stats.gs
    =/  prod  produced
    |-
    ?~  prod  items-produced.stats.gs
    =/  prev=@ud  (fall (~(get by items-produced.stats.gs) -.i.prod) 0)
    =.  items-produced.stats.gs
      (~(put by items-produced.stats.gs) -.i.prod (add prev +.i.prod))
    $(prod t.prod)
  ::  stats: total XP earned
  =.  total-xp-earned.stats.gs  (add total-xp-earned.stats.gs total-xp)
  ::  multitree: process secondary action XP + outputs
  =?  gs  ?=(^ adef2)
    =/  sec-id=action-id  (need secondary.act)
    =/  ss2=skill-state
      (fall (~(get by skills.gs) skill.act) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  base-xp2=@ud  (mul xp.u.adef2 num-actions)
    =/  total-xp2=@ud  (apply-xp-bonus:bide-modifiers mods skill.act skill-type.u.sdef base-xp2)
    =/  new-xp2=@ud  (add xp.ss2 total-xp2)
    =.  ss2  ss2(xp new-xp2, level (level-from-xp:bide-xp new-xp2))
    =/  m-gain2=@ud  (mul mastery-xp.u.adef2 num-actions)
    =/  cur-m2=@ud  (fall (~(get by actions.mastery.ss2) sec-id) 0)
    =.  actions.mastery.ss2  (~(put by actions.mastery.ss2) sec-id (add cur-m2 m-gain2))
    =.  pool-xp.mastery.ss2  (add pool-xp.mastery.ss2 (div m-gain2 4))
    =.  skills.gs  (~(put by skills.gs) skill.act ss2)
    =.  total-xp-earned.stats.gs  (add total-xp-earned.stats.gs total-xp2)
    ::  roll secondary outputs
    =/  outs2  outputs.u.adef2
    =/  rng2  ~(. og eny.bowl)
    =/  prod2=(list [item-id @ud])
      |-
      ?~  outs2  ~
      ?:  =(chance.i.outs2 100)
        [[item.i.outs2 (mul num-actions max-qty.i.outs2)] $(outs2 t.outs2)]
      =/  total=@ud  (mul num-actions chance.i.outs2)
      =/  full=@ud  (div total 100)
      =/  rem=@ud  (mod total 100)
      =^  roll  rng2  (rads:rng2 100)
      =/  drops=@ud  ?:((lth roll rem) (add full 1) full)
      ?:  =(drops 0)  $(outs2 t.outs2)
      [[item.i.outs2 (mul drops max-qty.i.outs2)] $(outs2 t.outs2)]
    =.  items.bank.gs
      =/  prod  prod2
      |-
      ?~  prod  items.bank.gs
      =/  cur=@ud  (fall (~(get by items.bank.gs) -.i.prod) 0)
      =.  items.bank.gs  (~(put by items.bank.gs) -.i.prod (add cur +.i.prod))
      $(prod t.prod)
    gs
  ::  pet drop roll
  =^  found-pet  rng-seed.gs
    (roll-pet-drop:bide-pets rng-seed.gs %skilling skill.act pets-found.gs)
  =?  pets-found.gs  ?=(^ found-pet)
    (~(put in pets-found.gs) u.found-pet)
  =/  leftover=@dr  (mod elapsed base-dr)
  =.  active-action.gs
    `[%skilling skill.act target.act secondary.act (sub now.bowl leftover)]
  `gs
::
::  ┌─────────────────────────────────┐
::  │  Combat event processing         │
::  └─────────────────────────────────┘
::
::  Two independent Behn timers drive combat. This arm processes
::  all overdue events in chronological order (handles offline catch-up).
::
++  process-combat-events
  |=  =bowl:gall
  ^-  (quip card game-state)
  =/  aa  active-action.gs
  ?~  aa  `gs
  =/  act  u.aa
  ?:  ?=(%dungeon -.act)  (process-dungeon-events act bowl)
  ?.  ?=(%combat -.act)  `gs
  =/  mdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) monster.act)
  ?~  mdef
    =.  active-action.gs  ~
    `gs
  =/  e-hp=@ud  enemy-hp.act
  =/  e-max=@ud  enemy-max-hp.act
  =/  p-next=@da  player-next-attack.act
  =/  e-next=@da  enemy-next-attack.act
  =/  k=@ud  kills.act
  =/  p-atk-count=@ud  player-atk-count.act
  =/  e-atk-count=@ud  enemy-atk-count.act
  =/  p-last-dmg=@ud   player-last-dmg.act
  =/  e-last-dmg=@ud   enemy-last-dmg.act
  =/  sp-energy=@ud  special-energy.act
  =/  sp-queued=?  special-queued.act
  =/  seed=@uvJ  `@uvJ`(mix rng-seed.gs eny.bowl)
  =/  p-hp=@ud  hitpoints-current.player.gs
  =/  p-hp-max=@ud  hitpoints-max.player.gs
  =/  weapon-spd=@ud  ?~(spell.act (weapon-speed:bide-combat slots.equipment.gs) 3.000)
  =/  ms-per=@dr  ms-per:bide-bank
  =/  weapon-dr=@dr  (mul ms-per weapon-spd)
  =/  enemy-dr=@dr  (mul ms-per attack-speed.u.mdef)
  =/  iterations=@ud  0
  |-
  ::  find next event
  =/  p-first=?  (lte p-next e-next)
  =/  next-event=@da  ?:(p-first p-next e-next)
  ::  nothing overdue? write back state & schedule timers
  ?:  |((gth next-event now.bowl) (gte iterations 300))
    =.  rng-seed.gs  seed
    =.  hitpoints-current.player.gs  p-hp
    =.  active-action.gs
      `[%combat area.act monster.act style.act spell.act e-hp e-max p-next e-next k p-atk-count e-atk-count p-last-dmg e-last-dmg sp-energy sp-queued started.act]
    :_  gs
    :~  [%pass /combat/player/(scot %da p-next) %arvo %b [%wait p-next]]
        [%pass /combat/enemy/(scot %da e-next) %arvo %b [%wait e-next]]
    ==
  ::
  ::  player attacks next
  ::
  ?:  p-first
    ::  check arrows before ranged attack
    =/  has-arrows=?
      ?.  =(style.act %ranged)  %.y
      =/  ammo=(unit item-id)  (~(get by slots.equipment.gs) %ammo)
      ?~  ammo  %.n
      =/  cur=@ud  (fall (~(get by items.bank.gs) u.ammo) 0)
      (gte cur 1)
    ?.  has-arrows
      ::  out of arrows — stop combat
      =.  active-action.gs  ~
      =.  rng-seed.gs  seed
      =.  hitpoints-current.player.gs  p-hp
      `gs
    ::  check runes before spell attack
    =/  has-runes=?
      ?~  spell.act  %.y
      =/  sdef  (~(got by spell-registry:bide-spells) u.spell.act)
      =/  rune-list=(list [item=item-id qty=@ud])  runes.sdef
      |-
      ?~  rune-list  %.y
      =/  cur=@ud  (fall (~(get by items.bank.gs) item.i.rune-list) 0)
      ?.  (gte cur qty.i.rune-list)  %.n
      $(rune-list t.rune-list)
    ?.  has-runes
      ::  out of runes — stop combat
      =.  active-action.gs  ~
      =.  rng-seed.gs  seed
      =.  hitpoints-current.player.gs  p-hp
      `gs
    ::  compute unified modifiers
    =/  mods=modifier-set
      (compute-modifiers:bide-modifiers skills.gs slots.equipment.gs active-familiar.gs active-potions.gs active-prayers.gs pets-found.gs star-levels.gs skill-upgrades.gs ~)
    =/  cboosts  (get-combat-boosts:bide-modifiers mods style.act)
    =^  dmg  seed
      ?~  spell.act
        (player-attack:bide-combat seed skills.gs slots.equipment.gs style.act defence-level.u.mdef atk.cboosts str.cboosts)
      =/  sdef  (~(got by spell-registry:bide-spells) u.spell.act)
      (player-spell-attack:bide-combat seed skills.gs slots.equipment.gs max-hit.sdef defence-level.u.mdef atk.cboosts)
    ::  consume runes for spell cast
    =?  bank.gs  ?=(^ spell.act)
      =/  sdef  (~(got by spell-registry:bide-spells) u.spell.act)
      =/  rune-list=(list [item=item-id qty=@ud])  runes.sdef
      |-
      ?~  rune-list  bank.gs
      =/  cur=@ud  (fall (~(get by items.bank.gs) item.i.rune-list) 0)
      =/  need=@ud  qty.i.rune-list
      =.  items.bank.gs
        ?:  (lte cur need)
          (~(del by items.bank.gs) item.i.rune-list)
        (~(put by items.bank.gs) item.i.rune-list (sub cur need))
      $(rune-list t.rune-list)
    ::  consume 1 arrow for ranged attack
    =?  bank.gs  =(style.act %ranged)
      =/  ammo=(unit item-id)  (~(get by slots.equipment.gs) %ammo)
      ?~  ammo  bank.gs
      =/  cur=@ud  (fall (~(get by items.bank.gs) u.ammo) 0)
      =.  items.bank.gs
        ?:  (lte cur 1)
          (~(del by items.bank.gs) u.ammo)
        (~(put by items.bank.gs) u.ammo (sub cur 1))
      bank.gs
    ::  special attack multiplier
    =/  weapon=(unit item-id)  (~(get by slots.equipment.gs) %weapon)
    =/  sdef=(unit special-attack-def)
      ?~  weapon  ~
      (~(get by special-registry:bide-specials) u.weapon)
    =?  dmg  ?&(sp-queued ?=(^ sdef))
      (div (mul dmg damage-mult.u.sdef) 100)
    =?  sp-energy  ?&(sp-queued ?=(^ sdef))
      (sub sp-energy energy-cost.u.sdef)
    =.  sp-queued  %.n
    ::  regen special energy (+10 per hit, cap 100)
    =.  sp-energy  (min 100 (add sp-energy 10))
    ::  tick potion durations
    =.  active-potions.gs  (tick-potions:bide-potions active-potions.gs)
    ::  drain prayer points
    =/  drain=@ud  (total-drain:bide-prayers active-prayers.gs)
    =.  prayer-points.player.gs
      ?:  (gte prayer-points.player.gs drain)
        (sub prayer-points.player.gs drain)
      0
    ::  deactivate all prayers if points hit 0
    =?  active-prayers.gs  =(prayer-points.player.gs 0)
      *(set prayer-id)
    ::  decrement familiar charges
    =?  active-familiar.gs  ?=(^ active-familiar.gs)
      =/  af  u.active-familiar.gs
      =/  new-charges=@ud  ?:((gth charges.af 1) (sub charges.af 1) 0)
      ?:  =(new-charges 0)  ~
      `af(charges new-charges)
    =.  p-atk-count  (add p-atk-count 1)
    =.  p-last-dmg  dmg
    ::  stats: max hit dealt
    =?  max-hit-dealt.stats.gs  (gth dmg max-hit-dealt.stats.gs)
      dmg
    =.  e-hp  ?:((gte e-hp dmg) (sub e-hp dmg) 0)
    =.  p-next  (add p-next weapon-dr)
    ::  enemy killed?
    ?.  =(e-hp 0)
      $(iterations (add iterations 1))
    ::  award xp via modifier engine
    =/  xp-total=@ud  combat-xp.u.mdef
    =/  xp-bonus-pct=@ud  (add xp-global.mods xp-combat.mods)
    =.  xp-total  (add xp-total (div (mul xp-total xp-bonus-pct) 100))
    =/  style-xp=@ud  (div (mul xp-total 2) 3)
    =/  hp-xp=@ud  (div xp-total 3)
    =/  style-skill=skill-id  (style-to-skill:bide-combat style.act)
    =/  sss=skill-state
      (fall (~(get by skills.gs) style-skill) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  new-sxp=@ud  (add xp.sss style-xp)
    =.  sss  sss(xp new-sxp, level (level-from-xp:bide-xp new-sxp))
    =.  skills.gs  (~(put by skills.gs) style-skill sss)
    =/  hss=skill-state
      (fall (~(get by skills.gs) %hitpoints) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  new-hxp=@ud  (add xp.hss hp-xp)
    =/  new-hp-level=@ud  (level-from-xp:bide-xp new-hxp)
    =.  hss  hss(xp new-hxp, level new-hp-level)
    =.  skills.gs  (~(put by skills.gs) %hitpoints hss)
    =.  p-hp-max  (mul new-hp-level 10)
    =.  hitpoints-max.player.gs  p-hp-max
    ::  roll loot
    =^  loot-items  seed  (roll-loot:bide-combat seed loot-table.u.mdef)
    =.  bank.gs
      =/  li=(list [iid=item-id qty=@ud])  loot-items
      |-
      ?~  li  bank.gs
      =/  cur=@ud  (fall (~(get by items.bank.gs) iid.i.li) 0)
      =.  items.bank.gs  (~(put by items.bank.gs) iid.i.li (add cur qty.i.li))
      $(li t.li)
    ::  roll gp (with gp bonus from pet)
    =^  gp-drop  seed  (roll-gp:bide-combat seed gp-min.u.mdef gp-max.u.mdef)
    =?  gp-drop  (gth gp-bonus.mods 0)
      (add gp-drop (div (mul gp-drop gp-bonus.mods) 100))
    =.  gp.player.gs  (add gp.player.gs gp-drop)
    ::  stats: monsters killed, gp earned, xp earned
    =/  prev-kills=@ud  (fall (~(get by monsters-killed.stats.gs) monster.act) 0)
    =.  monsters-killed.stats.gs
      (~(put by monsters-killed.stats.gs) monster.act (add prev-kills 1))
    =.  total-gp-earned.stats.gs  (add total-gp-earned.stats.gs gp-drop)
    =.  total-xp-earned.stats.gs  (add total-xp-earned.stats.gs xp-total)
    ::  pet drop roll (combat)
    =^  found-pet  seed
      (roll-pet-drop:bide-pets seed %combat monster.act pets-found.gs)
    =?  pets-found.gs  ?=(^ found-pet)
      (~(put in pets-found.gs) u.found-pet)
    ::  slayer XP (separate =? so skills.gs update persists)
    =?  skills.gs  ?&  ?=(^ slayer-task.gs)
                       =(monster.u.slayer-task.gs monster.act)
                   ==
      =/  slayer-ss=skill-state
        (fall (~(get by skills.gs) %slayer) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
      =/  new-slayer-xp=@ud  (add xp.slayer-ss combat-xp.u.mdef)
      =.  slayer-ss  slayer-ss(xp new-slayer-xp, level (level-from-xp:bide-xp new-slayer-xp))
      (~(put by skills.gs) %slayer slayer-ss)
    ::  slayer task tracking (decrement/complete)
    =?  slayer-task.gs  ?=(^ slayer-task.gs)
      =/  st  u.slayer-task.gs
      ?.  =(monster.st monster.act)  slayer-task.gs
      =/  new-rem=@ud  (dec qty-remaining.st)
      ?:  =(new-rem 0)
        ~  ::  task complete
      `st(qty-remaining new-rem)
    ::  spawn next monster
    =.  e-hp  hitpoints.u.mdef
    =.  e-max  hitpoints.u.mdef
    =.  e-next  (add p-next enemy-dr)
    =.  k  (add k 1)
    $(iterations (add iterations 1))
  ::
  ::  enemy attacks next
  ::
  =/  mods=modifier-set
    (compute-modifiers:bide-modifiers skills.gs slots.equipment.gs active-familiar.gs active-potions.gs active-prayers.gs pets-found.gs star-levels.gs skill-upgrades.gs ~)
  =/  cboosts  (get-combat-boosts:bide-modifiers mods style.act)
  =^  dmg  seed
    (enemy-attack:bide-combat seed u.mdef skills.gs slots.equipment.gs style.act def.cboosts)
  ::  apply protection prayer damage reduction
  =/  protect-pct=@ud  (get-protection:bide-modifiers mods attack-style.u.mdef)
  =?  dmg  (gth protect-pct 0)
    (sub dmg (div (mul dmg protect-pct) 100))
  =.  e-atk-count  (add e-atk-count 1)
  =.  e-last-dmg  dmg
  =.  p-hp  ?:((gte p-hp dmg) (sub p-hp dmg) 0)
  =.  e-next  (add e-next enemy-dr)
  ::  auto-eat
  =^  heal-amt  items.bank.gs
    ?.  ?&  (gth auto-eat-threshold.equipment.gs 0)
            ?=(^ selected-food.equipment.gs)
            (lte (mul p-hp 100) (mul p-hp-max auto-eat-threshold.equipment.gs))
        ==
      [0 items.bank.gs]
    =/  food-id  u.selected-food.equipment.gs
    =/  food-qty=@ud  (fall (~(get by items.bank.gs) food-id) 0)
    =/  heal=@ud  (fall (~(get by food-registry:bide-food) food-id) 0)
    ?.  ?&((gth food-qty 0) (gth heal 0))
      [0 items.bank.gs]
    =/  new-qty=@ud  (sub food-qty 1)
    :-  heal
    ?:  =(new-qty 0)
      (~(del by items.bank.gs) food-id)
    (~(put by items.bank.gs) food-id new-qty)
  =?  p-hp  (gth heal-amt 0)
    (min p-hp-max (add p-hp heal-amt))
  ::  death check
  ?:  =(p-hp 0)
    =.  hitpoints-current.player.gs  p-hp-max
    =.  rng-seed.gs  seed
    =.  active-action.gs  ~
    `gs
  $(iterations (add iterations 1))
::
::  ┌─────────────────────────────────┐
::  │  Dungeon combat processing       │
::  └─────────────────────────────────┘
::
++  process-dungeon-events
  |=  [act=active-action =bowl:gall]
  ^-  (quip card game-state)
  ?>  ?=(%dungeon -.act)
  =/  ddef=(unit dungeon-def)  (~(get by dungeon-registry:bide-dungeons) dungeon.act)
  ?~  ddef
    =.  active-action.gs  ~
    `gs
  =/  mdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) monster.act)
  ?~  mdef
    =.  active-action.gs  ~
    `gs
  =/  e-hp=@ud  enemy-hp.act
  =/  e-max=@ud  enemy-max-hp.act
  =/  p-next=@da  player-next-attack.act
  =/  e-next=@da  enemy-next-attack.act
  =/  k=@ud  kills.act
  =/  room-idx=@ud  room-idx.act
  =/  room-kills=@ud  room-kills.act
  =/  p-atk-count=@ud  player-atk-count.act
  =/  e-atk-count=@ud  enemy-atk-count.act
  =/  p-last-dmg=@ud  player-last-dmg.act
  =/  e-last-dmg=@ud  enemy-last-dmg.act
  =/  sp-energy=@ud  special-energy.act
  =/  sp-queued=?  special-queued.act
  =/  seed=@uvJ  `@uvJ`(mix rng-seed.gs eny.bowl)
  =/  p-hp=@ud  hitpoints-current.player.gs
  =/  p-hp-max=@ud  hitpoints-max.player.gs
  =/  weapon-spd=@ud  ?~(spell.act (weapon-speed:bide-combat slots.equipment.gs) 3.000)
  =/  ms-per=@dr  ms-per:bide-bank
  =/  weapon-dr=@dr  (mul ms-per weapon-spd)
  =/  enemy-dr=@dr  (mul ms-per attack-speed.u.mdef)
  =/  iterations=@ud  0
  |-
  =/  p-first=?  (lte p-next e-next)
  =/  next-event=@da  ?:(p-first p-next e-next)
  ::  nothing overdue? write back state
  ?:  |((gth next-event now.bowl) (gte iterations 300))
    =.  rng-seed.gs  seed
    =.  hitpoints-current.player.gs  p-hp
    =.  active-action.gs
      `[%dungeon dungeon.act room-idx room-kills monster.act style.act spell.act e-hp e-max p-next e-next k p-atk-count e-atk-count p-last-dmg e-last-dmg sp-energy sp-queued started.act]
    :_  gs
    :~  [%pass /combat/player/(scot %da p-next) %arvo %b [%wait p-next]]
        [%pass /combat/enemy/(scot %da e-next) %arvo %b [%wait e-next]]
    ==
  ::  player attacks
  ?:  p-first
    ::  check arrows before ranged attack
    =/  has-arrows=?
      ?.  =(style.act %ranged)  %.y
      =/  ammo=(unit item-id)  (~(get by slots.equipment.gs) %ammo)
      ?~  ammo  %.n
      =/  cur=@ud  (fall (~(get by items.bank.gs) u.ammo) 0)
      (gte cur 1)
    ?.  has-arrows
      ::  out of arrows — stop dungeon
      =.  active-action.gs  ~
      =.  rng-seed.gs  seed
      =.  hitpoints-current.player.gs  p-hp
      `gs
    ::  check runes before spell attack
    =/  has-runes=?
      ?~  spell.act  %.y
      =/  sdef  (~(got by spell-registry:bide-spells) u.spell.act)
      =/  rune-list=(list [item=item-id qty=@ud])  runes.sdef
      |-
      ?~  rune-list  %.y
      =/  cur=@ud  (fall (~(get by items.bank.gs) item.i.rune-list) 0)
      ?.  (gte cur qty.i.rune-list)  %.n
      $(rune-list t.rune-list)
    ?.  has-runes
      ::  out of runes — stop dungeon
      =.  active-action.gs  ~
      =.  rng-seed.gs  seed
      =.  hitpoints-current.player.gs  p-hp
      `gs
    =/  mods=modifier-set
      (compute-modifiers:bide-modifiers skills.gs slots.equipment.gs active-familiar.gs active-potions.gs active-prayers.gs pets-found.gs star-levels.gs skill-upgrades.gs ~)
    =/  cboosts  (get-combat-boosts:bide-modifiers mods style.act)
    =^  dmg  seed
      ?~  spell.act
        (player-attack:bide-combat seed skills.gs slots.equipment.gs style.act defence-level.u.mdef atk.cboosts str.cboosts)
      =/  sdef  (~(got by spell-registry:bide-spells) u.spell.act)
      (player-spell-attack:bide-combat seed skills.gs slots.equipment.gs max-hit.sdef defence-level.u.mdef atk.cboosts)
    ::  consume runes for spell cast
    =?  bank.gs  ?=(^ spell.act)
      =/  sdef  (~(got by spell-registry:bide-spells) u.spell.act)
      =/  rune-list=(list [item=item-id qty=@ud])  runes.sdef
      |-
      ?~  rune-list  bank.gs
      =/  cur=@ud  (fall (~(get by items.bank.gs) item.i.rune-list) 0)
      =/  need=@ud  qty.i.rune-list
      =.  items.bank.gs
        ?:  (lte cur need)
          (~(del by items.bank.gs) item.i.rune-list)
        (~(put by items.bank.gs) item.i.rune-list (sub cur need))
      $(rune-list t.rune-list)
    ::  consume 1 arrow for ranged attack
    =?  bank.gs  =(style.act %ranged)
      =/  ammo=(unit item-id)  (~(get by slots.equipment.gs) %ammo)
      ?~  ammo  bank.gs
      =/  cur=@ud  (fall (~(get by items.bank.gs) u.ammo) 0)
      =.  items.bank.gs
        ?:  (lte cur 1)
          (~(del by items.bank.gs) u.ammo)
        (~(put by items.bank.gs) u.ammo (sub cur 1))
      bank.gs
    =.  active-potions.gs  (tick-potions:bide-potions active-potions.gs)
    =/  drain=@ud  (total-drain:bide-prayers active-prayers.gs)
    =.  prayer-points.player.gs
      ?:  (gte prayer-points.player.gs drain)
        (sub prayer-points.player.gs drain)
      0
    =?  active-prayers.gs  =(prayer-points.player.gs 0)
      *(set prayer-id)
    ::  decrement familiar charges
    =?  active-familiar.gs  ?=(^ active-familiar.gs)
      =/  af  u.active-familiar.gs
      =/  new-charges=@ud  ?:((gth charges.af 1) (sub charges.af 1) 0)
      ?:  =(new-charges 0)  ~
      `af(charges new-charges)
    =?  dmg  ?&(sp-queued !=(~ (~(get by special-registry:bide-specials) (fall (~(get by slots.equipment.gs) %weapon) %$))))
      =/  weapon=(unit item-id)  (~(get by slots.equipment.gs) %weapon)
      ?~  weapon  dmg
      =/  sdef=(unit special-attack-def)  (~(get by special-registry:bide-specials) u.weapon)
      ?~  sdef  dmg
      (div (mul dmg damage-mult.u.sdef) 100)
    =.  sp-queued  %.n
    =.  sp-energy  (min 100 (add sp-energy 10))
    =.  p-atk-count  (add p-atk-count 1)
    =.  p-last-dmg  dmg
    ::  stats: max hit
    =?  max-hit-dealt.stats.gs  (gth dmg max-hit-dealt.stats.gs)
      dmg
    =.  e-hp  ?:((gte e-hp dmg) (sub e-hp dmg) 0)
    =.  p-next  (add p-next weapon-dr)
    ::  enemy killed?
    ?.  =(e-hp 0)
      $(iterations (add iterations 1))
    ::  award combat XP via modifier engine
    =/  xp-total=@ud  combat-xp.u.mdef
    =/  xp-bonus-pct=@ud  (add xp-global.mods xp-combat.mods)
    =.  xp-total  (add xp-total (div (mul xp-total xp-bonus-pct) 100))
    =/  style-skill=skill-id  (style-to-skill:bide-combat style.act)
    =/  sss=skill-state
      (fall (~(get by skills.gs) style-skill) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  new-sxp=@ud  (add xp.sss (div (mul xp-total 2) 3))
    =.  sss  sss(xp new-sxp, level (level-from-xp:bide-xp new-sxp))
    =.  skills.gs  (~(put by skills.gs) style-skill sss)
    =/  hss=skill-state
      (fall (~(get by skills.gs) %hitpoints) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  new-hxp=@ud  (add xp.hss (div xp-total 3))
    =/  new-hp-level=@ud  (level-from-xp:bide-xp new-hxp)
    =.  hss  hss(xp new-hxp, level new-hp-level)
    =.  skills.gs  (~(put by skills.gs) %hitpoints hss)
    =.  p-hp-max  (mul new-hp-level 10)
    =.  hitpoints-max.player.gs  p-hp-max
    ::  stats: monsters killed, xp earned
    =/  prev-kills=@ud  (fall (~(get by monsters-killed.stats.gs) monster.act) 0)
    =.  monsters-killed.stats.gs
      (~(put by monsters-killed.stats.gs) monster.act (add prev-kills 1))
    =.  total-xp-earned.stats.gs  (add total-xp-earned.stats.gs xp-total)
    =.  k  (add k 1)
    =.  room-kills  (add room-kills 1)
    ::  check if room is cleared
    =/  room-qty=(unit @ud)  (room-kill-count:bide-dungeons u.ddef room-idx)
    =/  room-done=?  ?~(room-qty %.y (gte room-kills u.room-qty))
    ?.  room-done
      ::  spawn same monster type
      =.  e-hp  hitpoints.u.mdef
      =.  e-max  hitpoints.u.mdef
      =.  e-next  (add p-next enemy-dr)
      $(iterations (add iterations 1))
    ::  advance to next room
    =/  next-room=@ud  (add room-idx 1)
    =/  total-rooms=@ud  (room-count:bide-dungeons u.ddef)
    ?:  (gte next-room total-rooms)
      ::  dungeon complete — award rewards + stats
      =/  prev-dc=@ud  (fall (~(get by dungeons-completed.stats.gs) dungeon.act) 0)
      =.  dungeons-completed.stats.gs
        (~(put by dungeons-completed.stats.gs) dungeon.act (add prev-dc 1))
      =^  reward-items  seed  (roll-loot:bide-combat seed reward-table.u.ddef)
      =.  bank.gs
        =/  li=(list [iid=item-id qty=@ud])  reward-items
        |-
        ?~  li  bank.gs
        =/  cur=@ud  (fall (~(get by items.bank.gs) iid.i.li) 0)
        =.  items.bank.gs  (~(put by items.bank.gs) iid.i.li (add cur qty.i.li))
        $(li t.li)
      =.  rng-seed.gs  seed
      =.  hitpoints-current.player.gs  p-hp
      =.  active-action.gs  ~
      `gs
    ::  enter next room
    =/  next-monster=(unit monster-id)  (room-monster:bide-dungeons u.ddef next-room)
    ?~  next-monster
      =.  active-action.gs  ~
      `gs
    =/  nmdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) u.next-monster)
    ?~  nmdef
      =.  active-action.gs  ~
      `gs
    =.  room-idx  next-room
    =.  room-kills  0
    =.  e-hp  hitpoints.u.nmdef
    =.  e-max  hitpoints.u.nmdef
    =.  enemy-dr  (mul ms-per attack-speed.u.nmdef)
    =.  e-next  (add p-next enemy-dr)
    $(iterations (add iterations 1), mdef `u.nmdef)
  ::  enemy attacks
  =/  mods=modifier-set
    (compute-modifiers:bide-modifiers skills.gs slots.equipment.gs active-familiar.gs active-potions.gs active-prayers.gs pets-found.gs star-levels.gs skill-upgrades.gs ~)
  =/  cboosts  (get-combat-boosts:bide-modifiers mods style.act)
  =^  dmg  seed
    (enemy-attack:bide-combat seed u.mdef skills.gs slots.equipment.gs style.act def.cboosts)
  =/  protect-pct=@ud  (get-protection:bide-modifiers mods attack-style.u.mdef)
  =?  dmg  (gth protect-pct 0)
    (sub dmg (div (mul dmg protect-pct) 100))
  =.  e-atk-count  (add e-atk-count 1)
  =.  e-last-dmg  dmg
  =.  p-hp  ?:((gte p-hp dmg) (sub p-hp dmg) 0)
  =.  e-next  (add e-next enemy-dr)
  ::  auto-eat
  =^  heal-amt  items.bank.gs
    ?.  ?&  (gth auto-eat-threshold.equipment.gs 0)
            ?=(^ selected-food.equipment.gs)
            (lte (mul p-hp 100) (mul p-hp-max auto-eat-threshold.equipment.gs))
        ==
      [0 items.bank.gs]
    =/  food-id  u.selected-food.equipment.gs
    =/  food-qty=@ud  (fall (~(get by items.bank.gs) food-id) 0)
    =/  heal=@ud  (fall (~(get by food-registry:bide-food) food-id) 0)
    ?.  ?&((gth food-qty 0) (gth heal 0))
      [0 items.bank.gs]
    =/  new-qty=@ud  (sub food-qty 1)
    :-  heal
    ?:  =(new-qty 0)
      (~(del by items.bank.gs) food-id)
    (~(put by items.bank.gs) food-id new-qty)
  =?  p-hp  (gth heal-amt 0)
    (min p-hp-max (add p-hp heal-amt))
  ::  death = dungeon failed
  ?:  =(p-hp 0)
    =.  hitpoints-current.player.gs  p-hp-max
    =.  rng-seed.gs  seed
    =.  active-action.gs  ~
    `gs
  $(iterations (add iterations 1))
--
