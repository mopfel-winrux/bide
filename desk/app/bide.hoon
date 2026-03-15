::  app/bide.hoon — Bide idle RPG agent
::
::  JSON API + game tick engine. Frontend renders client-side.
::
/-  *bide
/+  dbug, verb, default-agent, server
/+  bide-xp, bide-skills, bide-items
/+  bide-equipment, bide-combat, bide-monsters, bide-areas, bide-food
/+  bide-potions, bide-prayers, bide-slayer, bide-specials, bide-dungeons
/+  bide-farming, bide-agility, bide-astrology, bide-summoning
/+  bide-modifiers, bide-shop, bide-pets, bide-spells, bide-capes
/+  bide-state, bide-bank, bide-json, bide-engine
::
|%
+$  card  card:agent:gall
--
::
%-  agent:dbug
%+  verb  |
=|  state-0:bide-state
=*  state  -
^-  agent:gall
=<
::  ┌─────────────────────────────────┐
::  │  agent door (10 arms only)      │
::  └─────────────────────────────────┘
::
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  ^-  (quip card _this)
  =/  hp-xp=@ud  1.154  ::  XP for level 10
  =.  gs
    :*  :*  gp=0
            hitpoints-current=100
            hitpoints-max=100
            prayer-points=10
            prayer-max=10
            created=now.bowl
        ==
        ^-  (map skill-id skill-state)
        %-  ~(gas by *(map skill-id skill-state))
        :~  [%woodcutting [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%attack [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%strength [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%defence [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%hitpoints [xp=hp-xp level=10 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%ranged [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%magic [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%prayer [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%slayer [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%farming [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%agility [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%astrology [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
            [%summoning [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]]
        ==
        [items=*(map item-id @ud) slots-max=12]
        [slots=*(map equipment-slot item-id) auto-eat-threshold=50 selected-food=~]
        ~
        :*  actions-completed=*(map action-id @ud)
            monsters-killed=*(map monster-id @ud)
            items-produced=*(map item-id @ud)
            dungeons-completed=*(map dungeon-id @ud)
            total-xp-earned=0
            total-gp-earned=0
            total-gp-spent=0
            max-hit-dealt=0
        ==
        now.bowl
        `@uvJ`(sham now.bowl)
        ~                                      ::  active-potions
        *(set prayer-id)                       ::  active-prayers
        ~                                      ::  slayer-task
        ~[~ ~]                                 ::  farm-plots (2 empty)
        ~                                      ::  active-familiar
        *(set pet-id)                          ::  pets-found
        ~                                      ::  active-pet
        *(map [action-id @ud] @ud)             ::  star-levels
    ==
  :_  this
  :~  [%pass /eyre/connect %arvo %e %connect [~ /apps/bide/api] dap.bowl]
      [%pass /timer/tick %arvo %b [%wait (add now.bowl ~s1)]]
  ==
::
++  on-save  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state:bide-state old-vase)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  (on-poke:def mark vase)
  ::
      %handle-http-request
    =+  !<([eyre-id=@ta req=inbound-request:eyre] vase)
    =^  cards  gs  (handle-http eyre-id req bowl)
    [cards this]
  ::
      %bide-action
    =/  act  !<(action vase)
    =^  cards  gs  (handle-action act bowl)
    [cards this]
  ::
      %noun
    ?:  =(q.vase %test-setup)
      =.  skills.gs
        %-  ~(gas by skills.gs)
        :~  [%attack [xp=1.000.000 level=50 mastery=[pool-xp=0 actions=~]]]
            [%strength [xp=1.000.000 level=50 mastery=[pool-xp=0 actions=~]]]
            [%defence [xp=1.000.000 level=50 mastery=[pool-xp=0 actions=~]]]
            [%hitpoints [xp=2.000.000 level=60 mastery=[pool-xp=0 actions=~]]]
            [%farming [xp=1.000.000 level=50 mastery=[pool-xp=0 actions=~]]]
            [%agility [xp=5.000.000 level=70 mastery=[pool-xp=0 actions=~]]]
            [%astrology [xp=1.000.000 level=50 mastery=[pool-xp=0 actions=~]]]
            [%summoning [xp=2.000.000 level=60 mastery=[pool-xp=0 actions=~]]]
            [%magic [xp=10.000.000 level=80 mastery=[pool-xp=0 actions=~]]]
        ==
      =.  gp.player.gs  50.000
      =.  items.bank.gs
        %-  ~(gas by items.bank.gs)
        :~  [%potato-seed 50]
            [%onion-seed 30]
            [%tomato-seed 20]
            [%guam-seed 40]
            [%marrentill-seed 25]
            [%wolf-tablet 5]
            [%hawk-tablet 5]
            [%bear-tablet 3]
            [%dragon-tablet 2]
            [%charcoal 100]
            [%raw-shrimp 100]
            [%iron-ore 50]
            [%steel-bar 30]
            [%fire-rune 500]
            [%mind-rune 100]
            [%death-rune 100]
            [%water-rune 200]
            [%earth-rune 200]
            [%chaos-rune 100]
            [%gold-bar 50]
            [%onyx 10]
            [%dragonite-bar 5]
            [%mithril-bar 20]
            [%adamantite-bar 10]
            [%runite-bar 5]
            [%bronze-sword 1]
        ==
      =.  slots.equipment.gs
        (~(gas by *(map equipment-slot item-id)) ~[[%weapon %bronze-sword]])
      =.  hitpoints-max.player.gs  600
      =.  hitpoints-current.player.gs  600
      `this
    =.  gs  (game-state q.vase)
    `this
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%http-response *]  `this
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?+  wire  (on-arvo:def wire sign)
  ::
      [%eyre %connect ~]
    ?>  ?=([%eyre %bound *] sign)
    ?.  accepted.sign
      ~&  [%bide %eyre-bind-failed]
      `this
    `this
  ::
      [%timer %tick ~]
    ?>  ?=([%behn %wake *] sign)
    ?^  error.sign
      %-  (slog u.error.sign)
      :_  this
      ~[[%pass /timer/tick %arvo %b [%wait (add now.bowl ~s1)]]]
    =^  cards  gs  (~(process-tick bide-engine gs) bowl)
    :_  this
    (snoc cards [%pass /timer/tick %arvo %b [%wait (add now.bowl ~s1)]])
  ::
      [%combat %player @ ~]
    ?>  ?=([%behn %wake *] sign)
    ?^  error.sign
      %-  (slog u.error.sign)
      `this
    ::  ignore stale wakes
    =/  aa  active-action.gs
    ?~  aa  `this
    =/  act  u.aa
    =/  wire-time=@da  (slav %da i.t.t.wire)
    ?:  ?=(%combat -.act)
      ?.  =(wire-time player-next-attack.act)  `this
      =^  cards  gs  (~(process-combat-events bide-engine gs) bowl)
      [cards this]
    ?:  ?=(%dungeon -.act)
      ?.  =(wire-time player-next-attack.act)  `this
      =^  cards  gs  (~(process-combat-events bide-engine gs) bowl)
      [cards this]
    `this
  ::
      [%combat %enemy @ ~]
    ?>  ?=([%behn %wake *] sign)
    ?^  error.sign
      %-  (slog u.error.sign)
      `this
    =/  aa  active-action.gs
    ?~  aa  `this
    =/  act  u.aa
    =/  wire-time=@da  (slav %da i.t.t.wire)
    ?:  ?=(%combat -.act)
      ?.  =(wire-time enemy-next-attack.act)  `this
      =^  cards  gs  (~(process-combat-events bide-engine gs) bowl)
      [cards this]
    ?:  ?=(%dungeon -.act)
      ?.  =(wire-time enemy-next-attack.act)  `this
      =^  cards  gs  (~(process-combat-events bide-engine gs) bowl)
      [cards this]
    `this
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+  pole  (on-peek:def pole)
      [%x %state ~]  ``json+!>((~(state-to-json bide-json gs) now.bowl))
      [%x %defs ~]   ``json+!>(~(defs-to-json bide-json gs))
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
::  ┌─────────────────────────────────┐
::  │  helper core                    │
::  └─────────────────────────────────┘
::
|%
::
++  handle-http
  |=  [eyre-id=@ta req=inbound-request:eyre =bowl:gall]
  ^-  (quip card game-state)
  ?.  authenticated.req
    :_  gs
    (give-simple-payload:app:server eyre-id (login-redirect:gen:server request.req))
  =/  rl=request-line:server  (parse-request-line:server url.request.req)
  =/  site=(list @t)  site.rl
  =/  site=(list @t)
    ?.  ?=([%apps %bide %api *] site)  site
    t.t.t.site
  ?:  =(%'GET' method.request.req)
    :_  gs
    (handle-get eyre-id site now.bowl)
  ?.  =(%'POST' method.request.req)
    :_  gs
    (give-simple-payload:app:server eyre-id [[405 ~] ~])
  =^  cards  gs  (handle-post eyre-id site bowl)
  :_  gs
  %+  welp  cards
  (give-simple-payload:app:server eyre-id [[204 ~] ~])
::
++  handle-get
  |=  [eyre-id=@ta site=(list @t) now=@da]
  ^-  (list card)
  ?+  site
    (give-simple-payload:app:server eyre-id [[404 ~] ~])
  ::
      [%state ~]
    (give-json eyre-id (~(state-to-json bide-json gs) now))
  ::
      [%defs ~]
    (give-json eyre-id ~(defs-to-json bide-json gs))
  ==
::
++  give-json
  |=  [eyre-id=@ta =json]
  ^-  (list card)
  =/  body=@t  (en:json:html json)
  =/  data=octs  [(met 3 body) body]
  %+  give-simple-payload:app:server  eyre-id
  [[200 ['content-type' 'application/json'] ~] `data]
::
::
++  handle-post
  |=  [eyre-id=@ta site=(list @t) =bowl:gall]
  ^-  (quip card game-state)
  ?+  site  `gs
  ::
      [%start @ @ ~]
    =/  skill=@tas  i.t.site
    =/  target=@tas  i.t.t.site
    (handle-action [%start-skill skill target] bowl)
  ::
      [%stop ~]
    (handle-action [%stop-skill ~] bowl)
  ::
      [%sell @ @ ~]
    =/  item=@tas  i.t.site
    =/  qty=@ud  (slav %ud i.t.t.site)
    (handle-action [%sell item qty] bowl)
  ::
      [%sell-all @ ~]
    =/  item=@tas  i.t.site
    (handle-action [%sell-all item] bowl)
  ::
      [%equip @ ~]
    =/  item=@tas  i.t.site
    (handle-action [%equip item] bowl)
  ::
      [%unequip @ ~]
    =/  slot=@tas  i.t.site
    ?>  ?=  $?(%helmet %platebody %weapon %shield %cape)  slot
    (handle-action [%unequip slot] bowl)
  ::
      [%start-combat @ @ @ @ ~]
    =/  area=@tas  i.t.site
    =/  monster=@tas  i.t.t.site
    =/  style=@tas  i.t.t.t.site
    ?>  ?=  combat-style  style
    =/  spell-str=@tas  i.t.t.t.t.site
    =/  spell=(unit spell-id)  ?:(=(spell-str 'none') ~ `spell-str)
    (handle-action [%start-combat area monster style spell] bowl)
  ::
      [%stop-combat ~]
    (handle-action [%stop-combat ~] bowl)
  ::
      [%change-spell @ ~]
    =/  spell-str=@tas  i.t.site
    =/  spell=(unit spell-id)  ?:(=(spell-str 'none') ~ `spell-str)
    (handle-action [%change-spell spell] bowl)
  ::
      [%set-auto-eat @ @ ~]
    =/  threshold=@ud  (slav %ud i.t.site)
    =/  food-str=@tas  i.t.t.site
    =/  food=(unit item-id)
      ?:  =(food-str 'none')  ~
      `food-str
    (handle-action [%set-auto-eat threshold food] bowl)
  ::
      [%drink-potion @ ~]
    =/  item=@tas  i.t.site
    (handle-action [%drink-potion item] bowl)
  ::
      [%toggle-prayer @ ~]
    =/  prayer=@tas  i.t.site
    (handle-action [%toggle-prayer prayer] bowl)
  ::
      [%get-slayer-task ~]
    (handle-action [%get-slayer-task ~] bowl)
  ::
      [%special-attack ~]
    (handle-action [%special-attack ~] bowl)
  ::
      [%start-dungeon @ @ @ ~]
    =/  dungeon=@tas  i.t.site
    =/  style=@tas  i.t.t.site
    ?>  ?=  combat-style  style
    =/  spell-str=@tas  i.t.t.t.site
    =/  spell=(unit spell-id)  ?:(=(spell-str 'none') ~ `spell-str)
    (handle-action [%start-dungeon dungeon style spell] bowl)
  ::
      [%plant-seed @ @ ~]
    =/  plot=@ud  (slav %ud i.t.site)
    =/  seed=@tas  i.t.t.site
    (handle-action [%plant-seed plot seed] bowl)
  ::
      [%harvest-plot @ ~]
    =/  plot=@ud  (slav %ud i.t.site)
    (handle-action [%harvest-plot plot] bowl)
  ::
      [%summon-familiar @ ~]
    =/  tablet=@tas  i.t.site
    (handle-action [%summon-familiar tablet] bowl)
  ::
      [%dismiss-familiar ~]
    (handle-action [%dismiss-familiar ~] bowl)
  ::
      [%eat-food @ ~]
    =/  item=@tas  i.t.site
    (handle-action [%eat-food item] bowl)
  ::
      [%buy @ @ ~]
    =/  item=@tas  i.t.site
    =/  qty=@ud  (slav %ud i.t.t.site)
    (handle-action [%buy item qty] bowl)
  ::
      [%set-pet @ ~]
    =/  pet-str=@tas  i.t.site
    =/  pet=(unit pet-id)  ?:(=(pet-str 'none') ~ `pet-str)
    (handle-action [%set-pet pet] bowl)
  ::
      [%upgrade-star @ @ ~]
    =/  constellation=@tas  i.t.site
    =/  idx=@ud  (slav %ud i.t.t.site)
    (handle-action [%upgrade-star constellation idx] bowl)
  ==
::
++  handle-action
  |=  [act=action =bowl:gall]
  ^-  (quip card game-state)
  ?-  -.act
  ::
      %start-skill
    =/  sdef=(unit skill-def)  (~(get by skill-registry:bide-skills) skill.act)
    ?~  sdef
      ~&  [%bide %unknown-skill skill.act]
      `gs
    =/  adef=(unit action-def)
      =/  acts=(list action-def)  actions.u.sdef
      |-
      ?~  acts  ~
      ?:  =(id.i.acts target.act)  `i.acts
      $(acts t.acts)
    ?~  adef
      ~&  [%bide %unknown-action target.act]
      `gs
    =/  ss=skill-state
      (fall (~(get by skills.gs) skill.act) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    ?.  (gte level.ss level-req.u.adef)
      ~&  [%bide %level-too-low need=level-req.u.adef have=level.ss]
      `gs
    ::  check player has required inputs
    =/  has-inputs=?
      =/  inps=(list [item=item-id qty=@ud])  inputs.u.adef
      |-
      ?~  inps  %.y
      =/  have=@ud  (fall (~(get by items.bank.gs) item.i.inps) 0)
      ?.  (gte have qty.i.inps)  %.n
      $(inps t.inps)
    ?.  has-inputs
      ~&  [%bide %missing-inputs target.act]
      `gs
    =.  active-action.gs  `[%skilling skill.act target.act now.bowl]
    `gs
  ::
      %stop-skill
    =.  active-action.gs  ~
    `gs
  ::
      %sell
    =/  have=@ud  (fall (~(get by items.bank.gs) item.act) 0)
    ?:  =(have 0)  `gs
    =/  sell-qty=@ud  (min qty.act have)
    =/  idef=(unit item-def)  (~(get by item-registry:bide-items) item.act)
    ?~  idef  `gs
    =/  revenue=@ud  (mul sell-qty sell-price.u.idef)
    =.  gp.player.gs  (add gp.player.gs revenue)
    =.  total-gp-earned.stats.gs  (add total-gp-earned.stats.gs revenue)
    =/  remaining=@ud  (sub have sell-qty)
    =.  items.bank.gs
      ?:  =(remaining 0)
        (~(del by items.bank.gs) item.act)
      (~(put by items.bank.gs) item.act remaining)
    `gs
  ::
      %sell-all
    =/  have=@ud  (fall (~(get by items.bank.gs) item.act) 0)
    ?:  =(have 0)  `gs
    =/  idef=(unit item-def)  (~(get by item-registry:bide-items) item.act)
    ?~  idef  `gs
    =/  revenue=@ud  (mul have sell-price.u.idef)
    =.  gp.player.gs  (add gp.player.gs revenue)
    =.  total-gp-earned.stats.gs  (add total-gp-earned.stats.gs revenue)
    =.  items.bank.gs  (~(del by items.bank.gs) item.act)
    `gs
  ::
      %buy
    =/  buy-price=(unit @ud)  (~(get by shop-registry:bide-shop) item.act)
    ?~  buy-price  ~&([%bide %not-in-shop item.act] `gs)
    =/  total-cost=@ud  (mul u.buy-price qty.act)
    ?.  (gte gp.player.gs total-cost)  ~&([%bide %not-enough-gp] `gs)
    ::  cape level gating: require level 99 in the cape's skill
    =/  cdef=(unit cape-def)  (~(get by cape-registry:bide-capes) item.act)
    ?:  ?=(^ cdef)
      =/  skill-level=@ud
        =/  ss  (~(get by skills.gs) skill.u.cdef)
        ?~(ss 1 level.u.ss)
      ?.  (gte skill-level 99)
        ~&([%bide %cape-requires-99 skill.u.cdef] `gs)
      =.  gp.player.gs  (sub gp.player.gs total-cost)
      =.  total-gp-spent.stats.gs  (add total-gp-spent.stats.gs total-cost)
      =/  cur=@ud  (fall (~(get by items.bank.gs) item.act) 0)
      =.  items.bank.gs  (~(put by items.bank.gs) item.act (add cur qty.act))
      `gs
    =.  gp.player.gs  (sub gp.player.gs total-cost)
    =.  total-gp-spent.stats.gs  (add total-gp-spent.stats.gs total-cost)
    =/  cur=@ud  (fall (~(get by items.bank.gs) item.act) 0)
    =.  items.bank.gs  (~(put by items.bank.gs) item.act (add cur qty.act))
    `gs
  ::
      %equip
    =/  reg  equipment-registry:bide-equipment
    =/  stats=(unit equipment-stats)  (~(get by reg) item.act)
    ?~  stats
      ~&  [%bide %not-equippable item.act]
      `gs
    ::  check bank has item
    =/  have=@ud  (fall (~(get by items.bank.gs) item.act) 0)
    ?:  =(have 0)
      ~&  [%bide %item-not-in-bank item.act]
      `gs
    ::  check level requirements
    =/  reqs=(list [sid=skill-id lvl=@ud])  ~(tap by level-reqs.u.stats)
    =/  meets-reqs=?
      |-
      ?~  reqs  %.y
      =/  ss  (~(get by skills.gs) sid.i.reqs)
      =/  plvl=@ud  ?~(ss 1 level.u.ss)
      ?.  (gte plvl lvl.i.reqs)  %.n
      $(reqs t.reqs)
    ?.  meets-reqs
      ~&  [%bide %level-req-not-met item.act]
      `gs
    =/  slot  slot.u.stats
    ::  remove item from bank
    =.  items.bank.gs  (consume:bide-bank items.bank.gs item.act 1)
    ::  return old item to bank (if any)
    =/  old-item=(unit item-id)  (~(get by slots.equipment.gs) slot)
    =?  items.bank.gs  ?=(^ old-item)
      =/  old-qty=@ud  (fall (~(get by items.bank.gs) u.old-item) 0)
      (~(put by items.bank.gs) u.old-item (add old-qty 1))
    ::  equip new item
    =.  slots.equipment.gs  (~(put by slots.equipment.gs) slot item.act)
    `gs
  ::
      %unequip
    =/  cur=(unit item-id)  (~(get by slots.equipment.gs) slot.act)
    ?~  cur
      ~&  [%bide %slot-empty slot.act]
      `gs
    ::  return to bank
    =/  cur-qty=@ud  (fall (~(get by items.bank.gs) u.cur) 0)
    =.  items.bank.gs  (~(put by items.bank.gs) u.cur (add cur-qty 1))
    ::  clear slot
    =.  slots.equipment.gs  (~(del by slots.equipment.gs) slot.act)
    `gs
  ::
      %start-combat
    ::  validate area
    =/  adef=(unit area-def)  (~(get by area-registry:bide-areas) area.act)
    ?~  adef
      ~&  [%bide %unknown-area area.act]
      `gs
    ::  validate monster is in area
    =/  in-area=?
      =/  ml=(list monster-id)  monsters.u.adef
      |-
      ?~  ml  %.n
      ?:  =(i.ml monster.act)  %.y
      $(ml t.ml)
    ?.  in-area
      ~&  [%bide %monster-not-in-area monster.act]
      `gs
    ::  validate monster exists
    =/  mdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) monster.act)
    ?~  mdef
      ~&  [%bide %unknown-monster monster.act]
      `gs
    ::  validate spell if provided
    =/  spell-valid=?
      ?~  spell.act  %.y
      =/  sdef=(unit spell-def)  (~(get by spell-registry:bide-spells) u.spell.act)
      ?~  sdef  %.n
      =/  magic-level=@ud  (fall (bind (~(get by skills.gs) %magic) |=(s=skill-state level.s)) 1)
      ?.  (gte magic-level level-req.u.sdef)  %.n
      ?.  ?=(%magic style.act)  %.n
      %.y
    ?.  spell-valid
      ~&  [%bide %invalid-spell]
      `gs
    ::  validate combat style matches weapon type
    =/  weapon=(unit item-id)  (~(get by slots.equipment.gs) %weapon)
    =/  wstats=(unit equipment-stats)
      ?~  weapon  ~
      (~(get by equipment-registry:bide-equipment) u.weapon)
    =/  is-ranged=?
      ?~  wstats  %.n
      (gth ranged-attack-bonus.u.wstats 0)
    =/  is-magic=?
      ?~  wstats  %.n
      (gth magic-attack-bonus.u.wstats 0)
    =/  style-ok=?
      ?:  ?&(?=(%magic style.act) ?=(^ spell.act))  %.y
      ?:  is-ranged  ?=(%ranged style.act)
      ?:  is-magic   ?=(%magic style.act)
      ?=(?(%melee-attack %melee-strength %melee-defence) style.act)
    ?.  style-ok
      ~&  [%bide %style-mismatch style.act]
      `gs
    ::  set up combat state with independent Behn timers
    =/  ms-per=@dr  ms-per:bide-bank
    =/  weapon-spd=@ud  ?~(spell.act (weapon-speed:bide-combat slots.equipment.gs) 3.000)
    =/  p-next=@da  (add now.bowl (mul ms-per weapon-spd))
    =/  e-next=@da  (add now.bowl (mul ms-per attack-speed.u.mdef))
    =.  active-action.gs
      :-  ~
      :*  %combat
          area.act
          monster.act
          style.act
          spell.act
          hitpoints.u.mdef
          hitpoints.u.mdef
          p-next
          e-next
          0           ::  kills
          0           ::  player-atk-count
          0           ::  enemy-atk-count
          0           ::  player-last-dmg
          0           ::  enemy-last-dmg
          0           ::  special-energy
          %.n         ::  special-queued
          now.bowl
      ==
    :_  gs
    :~  [%pass /combat/player/(scot %da p-next) %arvo %b [%wait p-next]]
        [%pass /combat/enemy/(scot %da e-next) %arvo %b [%wait e-next]]
    ==
  ::
      %stop-combat
    =/  aa  active-action.gs
    ?~  aa
      `gs
    =/  act  u.aa
    =.  active-action.gs  ~
    ?:  ?=(%combat -.act)
      :_  gs
      :~  [%pass /combat/player/(scot %da player-next-attack.act) %arvo %b [%rest player-next-attack.act]]
          [%pass /combat/enemy/(scot %da enemy-next-attack.act) %arvo %b [%rest enemy-next-attack.act]]
      ==
    ?:  ?=(%dungeon -.act)
      :_  gs
      :~  [%pass /combat/player/(scot %da player-next-attack.act) %arvo %b [%rest player-next-attack.act]]
          [%pass /combat/enemy/(scot %da enemy-next-attack.act) %arvo %b [%rest enemy-next-attack.act]]
      ==
    `gs
  ::
      %set-auto-eat
    =.  auto-eat-threshold.equipment.gs  (min 100 threshold.act)
    =.  selected-food.equipment.gs  food.act
    `gs
  ::
      %drink-potion
    ::  validate potion exists in registry
    =/  pdef=(unit potion-def:bide-potions)  (~(get by potion-registry:bide-potions) item.act)
    ?~  pdef
      ~&  [%bide %not-a-potion item.act]
      `gs
    ::  duration-based potions require combat
    ?.  =(duration.u.pdef 0)
      =/  aa  active-action.gs
      ?~  aa
        ~&  [%bide %not-in-combat]
        `gs
      ?.  ?=(?(%combat %dungeon) -.u.aa)
        ~&  [%bide %not-in-combat]
        `gs
      ::  check bank has potion
      =/  have=@ud  (fall (~(get by items.bank.gs) item.act) 0)
      ?:  =(have 0)
        ~&  [%bide %no-potions-in-bank item.act]
        `gs
      ::  consume from bank
      =.  items.bank.gs  (consume:bide-bank items.bank.gs item.act 1)
      ::  timed buff — add to active potions
      =.  active-potions.gs
        [[item=item.act turns-left=duration.u.pdef] active-potions.gs]
      `gs
    ::  instant effect — no combat required
    ::  check bank has potion
    =/  have=@ud  (fall (~(get by items.bank.gs) item.act) 0)
    ?:  =(have 0)
      ~&  [%bide %no-potions-in-bank item.act]
      `gs
    ::  consume from bank
    =.  items.bank.gs  (consume:bide-bank items.bank.gs item.act 1)
    ::  apply instant effect
    ?-  effect-type.u.pdef
        %heal
      =.  hitpoints-current.player.gs
        (min hitpoints-max.player.gs (add hitpoints-current.player.gs magnitude.u.pdef))
      `gs
    ::
        %prayer-restore
      =.  prayer-points.player.gs
        (min prayer-max.player.gs (add prayer-points.player.gs magnitude.u.pdef))
      `gs
    ::
        ?(%attack-boost %strength-boost %defence-boost %ranged-boost %magic-boost)
      ::  shouldn't reach here (duration > 0), but just in case
      `gs
    ==
  ::
      %toggle-prayer
    ::  validate prayer exists
    =/  pdef=(unit prayer-def)  (~(get by prayer-registry:bide-prayers) prayer.act)
    ?~  pdef
      ~&  [%bide %unknown-prayer prayer.act]
      `gs
    ::  check prayer level requirement
    =/  prayer-level=@ud
      =/  ss  (~(get by skills.gs) %prayer)
      ?~(ss 1 level.u.ss)
    ?.  (gte prayer-level level-req.u.pdef)
      ~&  [%bide %prayer-level-too-low need=level-req.u.pdef have=prayer-level]
      `gs
    ::  toggle: if active, deactivate; if inactive, activate
    ?:  (~(has in active-prayers.gs) prayer.act)
      =.  active-prayers.gs  (~(del in active-prayers.gs) prayer.act)
      `gs
    ::  check prayer points > 0
    ?:  =(prayer-points.player.gs 0)
      ~&  [%bide %no-prayer-points]
      `gs
    =.  active-prayers.gs  (~(put in active-prayers.gs) prayer.act)
    `gs
  ::
      %get-slayer-task
    ::  can't get task if one is active
    ?.  =(~ slayer-task.gs)
      ~&  [%bide %already-have-task]
      `gs
    =/  slayer-level=@ud
      =/  ss  (~(get by skills.gs) %slayer)
      ?~(ss 1 level.u.ss)
    =^  task  rng-seed.gs  (assign-task:bide-slayer rng-seed.gs slayer-level)
    =.  slayer-task.gs  `task
    `gs
  ::
      %special-attack
    =/  aa  active-action.gs
    ?~  aa
      ~&  [%bide %not-in-combat]
      `gs
    ?.  ?=(?(%combat %dungeon) -.u.aa)
      ~&  [%bide %not-in-combat]
      `gs
    ::  check weapon has a special
    =/  weapon=(unit item-id)  (~(get by slots.equipment.gs) %weapon)
    ?~  weapon
      ~&  [%bide %no-weapon-equipped]
      `gs
    =/  sdef=(unit special-attack-def)  (~(get by special-registry:bide-specials) u.weapon)
    ?~  sdef
      ~&  [%bide %weapon-has-no-special]
      `gs
    ::  check enough energy + queue (branch for type narrowing)
    ?:  ?=(%combat -.u.aa)
      ?.  (gte special-energy.u.aa energy-cost.u.sdef)
        ~&  [%bide %not-enough-energy]
        `gs
      =.  active-action.gs  `u.aa(special-queued %.y)
      `gs
    ?>  ?=(%dungeon -.u.aa)
    ?.  (gte special-energy.u.aa energy-cost.u.sdef)
      ~&  [%bide %not-enough-energy]
      `gs
    =.  active-action.gs  `u.aa(special-queued %.y)
    `gs
  ::
      %change-spell
    =/  aa  active-action.gs
    ?~  aa
      ~&  [%bide %not-in-combat]
      `gs
    ?.  ?=(?(%combat %dungeon) -.u.aa)
      ~&  [%bide %not-in-combat]
      `gs
    ::  validate spell if provided
    ?:  ?=(^ spell.act)
      =/  sdef=(unit spell-def)  (~(get by spell-registry:bide-spells) u.spell.act)
      ?~  sdef
        ~&  [%bide %unknown-spell u.spell.act]
        `gs
      =/  magic-level=@ud  (fall (bind (~(get by skills.gs) %magic) |=(s=skill-state level.s)) 1)
      ?.  (gte magic-level level-req.u.sdef)
        ~&  [%bide %insufficient-magic-level]
        `gs
      ?:  ?=(%combat -.u.aa)
        =.  active-action.gs  `u.aa(spell spell.act, style %magic)
        `gs
      ?>  ?=(%dungeon -.u.aa)
      =.  active-action.gs  `u.aa(spell spell.act, style %magic)
      `gs
    ::  clearing spell (switching away from magic)
    ?:  ?=(%combat -.u.aa)
      =.  active-action.gs  `u.aa(spell ~)
      `gs
    ?>  ?=(%dungeon -.u.aa)
    =.  active-action.gs  `u.aa(spell ~)
    `gs
  ::
      %plant-seed
    ::  validate seed exists in registry
    =/  sdef=(unit farm-seed-def:bide-farming)  (~(get by seed-registry:bide-farming) seed.act)
    ?~  sdef
      ~&  [%bide %unknown-seed seed.act]
      `gs
    ::  validate farming level
    =/  farming-level=@ud
      =/  ss  (~(get by skills.gs) %farming)
      ?~(ss 1 level.u.ss)
    ?.  (gte farming-level level.u.sdef)
      ~&  [%bide %farming-level-too-low need=level.u.sdef have=farming-level]
      `gs
    ::  ensure plots list is correct size
    =.  farm-plots.gs  (ensure-plots:bide-farming farm-plots.gs farming-level)
    ::  validate plot index in range
    ?.  (lth plot.act (lent farm-plots.gs))
      ~&  [%bide %invalid-plot-index plot.act]
      `gs
    ::  validate plot is empty
    =/  current-plot=(unit farm-plot)  (snag plot.act farm-plots.gs)
    ?^  current-plot
      ~&  [%bide %plot-not-empty plot.act]
      `gs
    ::  validate seed in bank
    =/  have=@ud  (fall (~(get by items.bank.gs) seed.act) 0)
    ?:  =(have 0)
      ~&  [%bide %no-seeds-in-bank seed.act]
      `gs
    ::  consume seed
    =.  items.bank.gs  (consume:bide-bank items.bank.gs seed.act 1)
    ::  set plot state
    =/  new-plot=farm-plot  [seed=seed.act planted-at=now.bowl growth-time=growth-time.u.sdef harvested=%.n]
    =.  farm-plots.gs
      =/  idx=@ud  0
      =/  plots=(list (unit farm-plot))  farm-plots.gs
      =/  result=(list (unit farm-plot))  ~
      |-
      ?~  plots  (flop result)
      ?:  =(idx plot.act)
        $(plots t.plots, idx (add idx 1), result [`new-plot result])
      $(plots t.plots, idx (add idx 1), result [i.plots result])
    `gs
  ::
      %harvest-plot
    ::  ensure plots list is correct size
    =/  farming-level=@ud
      =/  ss  (~(get by skills.gs) %farming)
      ?~(ss 1 level.u.ss)
    =.  farm-plots.gs  (ensure-plots:bide-farming farm-plots.gs farming-level)
    ::  validate plot index
    ?.  (lth plot.act (lent farm-plots.gs))
      ~&  [%bide %invalid-plot-index plot.act]
      `gs
    =/  current-plot=(unit farm-plot)  (snag plot.act farm-plots.gs)
    ?~  current-plot
      ~&  [%bide %plot-is-empty plot.act]
      `gs
    ::  check if growth time has elapsed
    =/  ms-per=@dr  ms-per:bide-bank
    =/  growth-dr=@dr  (mul ms-per growth-time.u.current-plot)
    =/  ready-at=@da  (add planted-at.u.current-plot growth-dr)
    ?.  (gte now.bowl ready-at)
      ~&  [%bide %plot-not-ready-yet]
      `gs
    ::  look up seed def for crop + xp
    =/  sdef=(unit farm-seed-def:bide-farming)  (~(get by seed-registry:bide-farming) seed.u.current-plot)
    ?~  sdef
      ~&  [%bide %unknown-seed-in-plot]
      `gs
    ::  RNG for yield
    =/  range=@ud  (add (sub max-yield.u.sdef min-yield.u.sdef) 1)
    =/  yield-rng  ~(. og eny.bowl)
    =^  rng-val  yield-rng  (rads:yield-rng range)
    =/  base-yield=@ud  (add min-yield.u.sdef rng-val)
    ::  apply yield bonuses via modifier engine
    =/  mods=modifier-set
      (compute-modifiers:bide-modifiers skills.gs slots.equipment.gs active-familiar.gs active-potions.gs active-prayers.gs active-pet.gs star-levels.gs)
    =/  final-yield=@ud  (add base-yield (div (mul base-yield farming-yield.mods) 100))
    ::  award farming XP
    =/  fss=skill-state
      (fall (~(get by skills.gs) %farming) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  new-xp=@ud  (add xp.fss (mul xp.u.sdef final-yield))
    =/  new-level=@ud  (level-from-xp:bide-xp new-xp)
    =.  fss  fss(xp new-xp, level new-level)
    =.  skills.gs  (~(put by skills.gs) %farming fss)
    ::  add crops to bank
    =/  cur-crop=@ud  (fall (~(get by items.bank.gs) crop.u.sdef) 0)
    =.  items.bank.gs  (~(put by items.bank.gs) crop.u.sdef (add cur-crop final-yield))
    ::  pet drop roll (farming/harvest)
    =^  found-pet  rng-seed.gs
      (roll-pet-drop:bide-pets rng-seed.gs %skilling %farming pets-found.gs)
    =?  pets-found.gs  ?=(^ found-pet)
      (~(put in pets-found.gs) u.found-pet)
    ::  clear the plot
    =.  farm-plots.gs
      =/  idx=@ud  0
      =/  plots=(list (unit farm-plot))  farm-plots.gs
      =/  result=(list (unit farm-plot))  ~
      |-
      ?~  plots  (flop result)
      ?:  =(idx plot.act)
        $(plots t.plots, idx (add idx 1), result [~ result])
      $(plots t.plots, idx (add idx 1), result [i.plots result])
    ::  ensure plot list stays correct
    =.  farm-plots.gs  (ensure-plots:bide-farming farm-plots.gs new-level)
    `gs
  ::
      %summon-familiar
    ::  validate tablet exists in familiar registry
    =/  fdef=(unit familiar-def:bide-summoning)  (~(get by familiar-registry:bide-summoning) tablet.act)
    ?~  fdef
      ~&  [%bide %not-a-tablet tablet.act]
      `gs
    ::  check bank has tablet
    =/  have=@ud  (fall (~(get by items.bank.gs) tablet.act) 0)
    ?:  =(have 0)
      ~&  [%bide %no-tablets-in-bank tablet.act]
      `gs
    ::  consume from bank
    =.  items.bank.gs  (consume:bide-bank items.bank.gs tablet.act 1)
    ::  set familiar state
    =.  active-familiar.gs  `[tablet=tablet.act charges=charges.u.fdef]
    `gs
  ::
      %dismiss-familiar
    =.  active-familiar.gs  ~
    `gs
  ::
      %eat-food
    ::  validate food exists in registry
    =/  heal=(unit @ud)  (~(get by food-registry:bide-food) item.act)
    ?~  heal
      ~&  [%bide %not-food item.act]
      `gs
    ::  check bank has item
    =/  have=@ud  (fall (~(get by items.bank.gs) item.act) 0)
    ?:  =(have 0)
      ~&  [%bide %no-food-in-bank item.act]
      `gs
    ::  check not at max HP
    ?:  (gte hitpoints-current.player.gs hitpoints-max.player.gs)
      `gs
    ::  consume from bank
    =.  items.bank.gs  (consume:bide-bank items.bank.gs item.act 1)
    ::  heal
    =.  hitpoints-current.player.gs
      (min hitpoints-max.player.gs (add hitpoints-current.player.gs u.heal))
    `gs
  ::
      %set-pet
    ?~  pet.act
      ::  clear active pet
      =.  active-pet.gs  ~
      `gs
    ::  validate pet is in pets-found
    ?.  (~(has in pets-found.gs) u.pet.act)
      ~&  [%bide %pet-not-found u.pet.act]
      `gs
    =.  active-pet.gs  pet.act
    `gs
  ::
      %upgrade-star
    ::  validate constellation exists
    =/  cdef=(unit [skill-id skill-id])  (~(get by constellation-registry:bide-astrology) constellation.act)
    ?~  cdef
      ~&  [%bide %unknown-constellation constellation.act]
      `gs
    ::  validate star index (0, 1, or 2)
    ?.  (lth star-idx.act 3)
      ~&  [%bide %invalid-star-idx star-idx.act]
      `gs
    ::  check current level < max
    =/  current-level=@ud  (fall (~(get by star-levels.gs) [constellation.act star-idx.act]) 0)
    =/  max-level=@ud  (star-max-level:bide-astrology star-idx.act)
    ?.  (lth current-level max-level)
      ~&  [%bide %star-already-max]
      `gs
    ::  check cost and consume
    =/  cost=[item-id @ud]  (star-cost:bide-astrology star-idx.act current-level)
    =/  have=@ud  (fall (~(get by items.bank.gs) -.cost) 0)
    ?.  (gte have +.cost)
      ~&  [%bide %not-enough-stardust need=+.cost have=have]
      `gs
    =.  items.bank.gs  (consume:bide-bank items.bank.gs -.cost +.cost)
    ::  increment star level
    =.  star-levels.gs  (~(put by star-levels.gs) [constellation.act star-idx.act] (add current-level 1))
    `gs
  ::
      %start-dungeon
    ::  validate dungeon exists
    =/  ddef=(unit dungeon-def)  (~(get by dungeon-registry:bide-dungeons) dungeon.act)
    ?~  ddef
      ~&  [%bide %unknown-dungeon dungeon.act]
      `gs
    ::  get first room's monster
    =/  first-monster=(unit monster-id)  (room-monster:bide-dungeons u.ddef 0)
    ?~  first-monster
      ~&  [%bide %empty-dungeon]
      `gs
    =/  fmdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) u.first-monster)
    ?~  fmdef
      ~&  [%bide %unknown-monster u.first-monster]
      `gs
    ::  set up combat timers
    =/  ms-per=@dr  ms-per:bide-bank
    =/  weapon-spd=@ud  ?~(spell.act (weapon-speed:bide-combat slots.equipment.gs) 3.000)
    =/  p-next=@da  (add now.bowl (mul ms-per weapon-spd))
    =/  e-next=@da  (add now.bowl (mul ms-per attack-speed.u.fmdef))
    =.  active-action.gs
      :-  ~
      :*  %dungeon
          dungeon.act
          0             ::  room-idx
          0             ::  room-kills
          u.first-monster
          style.act
          spell.act
          hitpoints.u.fmdef
          hitpoints.u.fmdef
          p-next
          e-next
          0             ::  kills
          0             ::  player-atk-count
          0             ::  enemy-atk-count
          0             ::  player-last-dmg
          0             ::  enemy-last-dmg
          0             ::  special-energy
          %.n           ::  special-queued
          now.bowl
      ==
    :_  gs
    :~  [%pass /combat/player/(scot %da p-next) %arvo %b [%wait p-next]]
        [%pass /combat/enemy/(scot %da e-next) %arvo %b [%wait e-next]]
    ==
  ==
--
