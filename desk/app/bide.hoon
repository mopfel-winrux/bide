::  app/bide.hoon — Bide idle RPG agent
::
::  JSON API + game tick engine. Frontend renders client-side.
::
/-  *bide
/+  dbug, verb, default-agent, server
/+  bide-xp, bide-skills, bide-items
/+  bide-equipment, bide-combat, bide-monsters, bide-areas, bide-food
::
|%
+$  card  card:agent:gall
::
+$  state-0
  $:  %0
      gs=game-state-0
  ==
::
+$  game-state-0
  $:  player=player-info
      skills=(map skill-id skill-state)
      bank=bank-state
      equipment=[active-set=@ud]
      active-action=(unit active-action-0)
      stats=game-stats
      last-tick=@da
      rng-seed=@uvJ
  ==
::
+$  active-action-0
  $%  [%skilling skill=skill-id target=action-id started=@da]
  ==
::
+$  active-action-1
  $%  [%skilling skill=skill-id target=action-id started=@da]
      $:  %combat
          area=area-id
          monster=monster-id
          style=combat-style
          enemy-hp=@ud
          enemy-max-hp=@ud
          player-attack-timer=@ud
          enemy-attack-timer=@ud
          kills=@ud
          started=@da
      ==
  ==
::
+$  game-state-1
  $:  player=player-info
      skills=(map skill-id skill-state)
      bank=bank-state
      equipment=equipment-state
      active-action=(unit active-action-1)
      stats=game-stats
      last-tick=@da
      rng-seed=@uvJ
  ==
::
+$  state-1
  $:  %1
      gs=game-state-1
  ==
::
+$  active-action-2
  $%  [%skilling skill=skill-id target=action-id started=@da]
      $:  %combat
          area=area-id
          monster=monster-id
          style=combat-style
          enemy-hp=@ud
          enemy-max-hp=@ud
          player-next-attack=@da
          enemy-next-attack=@da
          kills=@ud
          started=@da
      ==
  ==
::
+$  game-state-2
  $:  player=player-info
      skills=(map skill-id skill-state)
      bank=bank-state
      equipment=equipment-state
      active-action=(unit active-action-2)
      stats=game-stats
      last-tick=@da
      rng-seed=@uvJ
  ==
::
+$  state-2
  $:  %2
      gs=game-state-2
  ==
::
+$  state-3
  $:  %3
      gs=game-state
  ==
::
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
  ==
--
::
%-  agent:dbug
%+  verb  |
=|  state-3
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
        ==
        [items=*(map item-id @ud) slots-max=12]
        [slots=*(map equipment-slot item-id) auto-eat-threshold=50 selected-food=~]
        ~
        [actions-completed=*(map action-id @ud)]
        now.bowl
        `@uvJ`(sham now.bowl)
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
  =/  old  !<(versioned-state old-vase)
  ?-  -.old
    %3  `this(state old)
  ::
      %2
    ::  Migrate state-2 → state-3 (combat counters added)
    =/  old-gs  gs.old
    =/  new-aa=(unit active-action)
      ?~  active-action.old-gs  ~
      =/  aa  u.active-action.old-gs
      ?-  -.aa
        %skilling  `[%skilling skill.aa target.aa started.aa]
        %combat    ~  :: clear combat (structure changed)
      ==
    =/  new-gs=game-state
      :*  player.old-gs
          skills.old-gs
          bank.old-gs
          equipment.old-gs
          new-aa
          stats.old-gs
          last-tick.old-gs
          rng-seed.old-gs
      ==
    `this(state [%3 new-gs])
  ::
      %1
    ::  Migrate state-1 → state-3 (combat timer type changed + counters)
    =/  old-gs  gs.old
    =/  new-aa=(unit active-action)
      ?~  active-action.old-gs  ~
      =/  aa  u.active-action.old-gs
      ?-  -.aa
        %skilling  `[%skilling skill.aa target.aa started.aa]
        %combat    ~  :: clear combat (timer structure changed)
      ==
    =/  new-gs=game-state
      :*  player.old-gs
          skills.old-gs
          bank.old-gs
          equipment.old-gs
          new-aa
          stats.old-gs
          last-tick.old-gs
          rng-seed.old-gs
      ==
    `this(state [%3 new-gs])
  ::
      %0
    ::  Migrate state-0 → state-3
    =/  hp-xp=@ud  1.154
    =/  old-gs  gs.old
    =/  new-aa=(unit active-action)
      ?~  active-action.old-gs  ~
      =/  aa  u.active-action.old-gs
      ?-  -.aa
        %skilling  `[%skilling skill.aa target.aa started.aa]
      ==
    =/  new-skills=(map skill-id skill-state)  skills.old-gs
    =?  new-skills  !(~(has by new-skills) %attack)
      (~(put by new-skills) %attack [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =?  new-skills  !(~(has by new-skills) %strength)
      (~(put by new-skills) %strength [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =?  new-skills  !(~(has by new-skills) %defence)
      (~(put by new-skills) %defence [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =?  new-skills  !(~(has by new-skills) %hitpoints)
      (~(put by new-skills) %hitpoints [xp=hp-xp level=10 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =?  new-skills  !(~(has by new-skills) %ranged)
      (~(put by new-skills) %ranged [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =?  new-skills  !(~(has by new-skills) %magic)
      (~(put by new-skills) %magic [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
    =/  new-gs=game-state
      :*  player.old-gs
          new-skills
          bank.old-gs
          [slots=*(map equipment-slot item-id) auto-eat-threshold=50 selected-food=~]
          new-aa
          stats.old-gs
          last-tick.old-gs
          rng-seed.old-gs
      ==
    `this(state [%3 new-gs])
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
    =^  cards  gs  (process-tick bowl)
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
    ?.  ?=(%combat -.act)  `this
    =/  wire-time=@da  (slav %da i.t.t.wire)
    ?.  =(wire-time player-next-attack.act)  `this
    =^  cards  gs  (process-combat-events bowl)
    [cards this]
  ::
      [%combat %enemy @ ~]
    ?>  ?=([%behn %wake *] sign)
    ?^  error.sign
      %-  (slog u.error.sign)
      `this
    =/  aa  active-action.gs
    ?~  aa  `this
    =/  act  u.aa
    ?.  ?=(%combat -.act)  `this
    =/  wire-time=@da  (slav %da i.t.t.wire)
    ?.  =(wire-time enemy-next-attack.act)  `this
    =^  cards  gs  (process-combat-events bowl)
    [cards this]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+  pole  (on-peek:def pole)
      [%x %state ~]  ``json+!>((state-to-json now.bowl))
      [%x %defs ~]   ``json+!>(defs-to-json)
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
++  action-to-json
  |=  ad=action-def
  ^-  json
  %-  pairs:enjs:format
  :~  ['id' [%s id.ad]]
      ['name' [%s name.ad]]
      ['levelReq' (numb:enjs:format level-req.ad)]
      ['xp' (numb:enjs:format xp.ad)]
      ['baseTime' (numb:enjs:format base-time.ad)]
      ['masteryXp' (numb:enjs:format mastery-xp.ad)]
      ['inputs' [%a (turn inputs.ad input-to-json)]]
      ['outputs' [%a (turn outputs.ad output-to-json)]]
  ==
::
++  input-to-json
  |=  inp=[item=item-id qty=@ud]
  ^-  json
  %-  pairs:enjs:format
  :~  ['item' [%s item.inp]]
      ['qty' (numb:enjs:format qty.inp)]
  ==
::
++  output-to-json
  |=  od=output-def
  ^-  json
  %-  pairs:enjs:format
  :~  ['item' [%s item.od]]
      ['minQty' (numb:enjs:format min-qty.od)]
      ['maxQty' (numb:enjs:format max-qty.od)]
      ['chance' (numb:enjs:format chance.od)]
  ==
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
    (give-json eyre-id (state-to-json now))
  ::
      [%defs ~]
    (give-json eyre-id defs-to-json)
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
++  state-to-json
  |=  now=@da
  ^-  json
  =/  skill-pairs=(list [@t json])
    %+  turn  ~(tap by skills.gs)
    |=  [sid=skill-id ss=skill-state]
    ^-  [@t json]
    :-  sid
    %-  pairs:enjs:format
    :~  ['xp' (numb:enjs:format xp.ss)]
        ['level' (numb:enjs:format level.ss)]
        ['poolXp' (numb:enjs:format pool-xp.mastery.ss)]
    ==
  =/  skills-json=json  [%o (~(gas by *(map @t json)) skill-pairs)]
  =/  bank-pairs=(list [@t json])
    %+  turn  ~(tap by items.bank.gs)
    |=  [iid=item-id qty=@ud]
    ^-  [@t json]
    [iid (numb:enjs:format qty)]
  =/  bank-json=json  [%o (~(gas by *(map @t json)) bank-pairs)]
  =/  action-json=json
    ?~  active-action.gs  ~
    =/  aa  u.active-action.gs
    ?-  -.aa
      %skilling
      %-  pairs:enjs:format
      :~  ['type' [%s 'skilling']]
          ['skill' [%s skill.aa]]
          ['target' [%s target.aa]]
      ==
    ::
      %combat
      ::  compute elapsed timer values from absolute next-attack times
      =/  ms-per=@dr  (div ~s1 1.000)
      =/  weapon-spd=@ud  (weapon-speed:bide-combat slots.equipment.gs)
      =/  p-remaining=@dr
        ?:  (gth player-next-attack.aa now)
          (sub player-next-attack.aa now)
        *@dr
      =/  p-remaining-ms=@ud  (div p-remaining ms-per)
      =/  p-elapsed=@ud  (sub weapon-spd (min weapon-spd p-remaining-ms))
      =/  mdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) monster.aa)
      =/  enemy-spd=@ud  ?~(mdef 3.000 attack-speed.u.mdef)
      =/  e-remaining=@dr
        ?:  (gth enemy-next-attack.aa now)
          (sub enemy-next-attack.aa now)
        *@dr
      =/  e-remaining-ms=@ud  (div e-remaining ms-per)
      =/  e-elapsed=@ud  (sub enemy-spd (min enemy-spd e-remaining-ms))
      %-  pairs:enjs:format
      :~  ['type' [%s 'combat']]
          ['area' [%s area.aa]]
          ['monster' [%s monster.aa]]
          ['style' [%s style.aa]]
          ['enemyHp' (numb:enjs:format enemy-hp.aa)]
          ['enemyMaxHp' (numb:enjs:format enemy-max-hp.aa)]
          ['playerAttackTimer' (numb:enjs:format p-elapsed)]
          ['enemyAttackTimer' (numb:enjs:format e-elapsed)]
          ['kills' (numb:enjs:format kills.aa)]
          ['playerAtkCount' (numb:enjs:format player-atk-count.aa)]
          ['enemyAtkCount' (numb:enjs:format enemy-atk-count.aa)]
          ['playerLastDmg' (numb:enjs:format player-last-dmg.aa)]
          ['enemyLastDmg' (numb:enjs:format enemy-last-dmg.aa)]
      ==
    ==
  ::  equipment slots to json
  =/  eq-pairs=(list [@t json])
    %+  turn  ~(tap by slots.equipment.gs)
    |=  [slot=equipment-slot iid=item-id]
    ^-  [@t json]
    [(scot %tas slot) [%s iid]]
  =/  eq-json=json
    %-  pairs:enjs:format
    :~  ['slots' [%o (~(gas by *(map @t json)) eq-pairs)]]
        ['autoEatThreshold' (numb:enjs:format auto-eat-threshold.equipment.gs)]
        :-  'selectedFood'
        ?~  selected-food.equipment.gs  ~
        [%s u.selected-food.equipment.gs]
    ==
  %-  pairs:enjs:format
  :~  ['gp' (numb:enjs:format gp.player.gs)]
      ['hp' (numb:enjs:format hitpoints-current.player.gs)]
      ['hpMax' (numb:enjs:format hitpoints-max.player.gs)]
      ['skills' skills-json]
      ['bank' bank-json]
      ['slotsMax' (numb:enjs:format slots-max.bank.gs)]
      ['activeAction' action-json]
      ['equipment' eq-json]
  ==
::
++  defs-to-json
  ^-  json
  =/  skill-defs=(list [@t json])
    %+  turn  ~(tap by skill-registry:bide-skills)
    |=  [sid=skill-id sd=skill-def]
    ^-  [@t json]
    :-  sid
    %-  pairs:enjs:format
    :~  ['name' [%s name.sd]]
        ['type' [%s skill-type.sd]]
        ['maxLevel' (numb:enjs:format max-level.sd)]
        ['actions' [%a (turn actions.sd action-to-json)]]
    ==
  =/  item-defs=(list [@t json])
    %+  turn  ~(tap by item-registry:bide-items)
    |=  [iid=item-id idef=item-def]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['name' [%s name.idef]]
        ['category' [%s category.idef]]
        ['sellPrice' (numb:enjs:format sell-price.idef)]
    ==
  ::  monster defs
  =/  monster-defs=(list [@t json])
    %+  turn  ~(tap by monster-registry:bide-monsters)
    |=  [mid=monster-id md=monster-def]
    ^-  [@t json]
    :-  mid
    %-  pairs:enjs:format
    :~  ['name' [%s name.md]]
        ['hitpoints' (numb:enjs:format hitpoints.md)]
        ['maxHit' (numb:enjs:format max-hit.md)]
        ['attackLevel' (numb:enjs:format attack-level.md)]
        ['strengthLevel' (numb:enjs:format strength-level.md)]
        ['defenceLevel' (numb:enjs:format defence-level.md)]
        ['attackSpeed' (numb:enjs:format attack-speed.md)]
        ['attackStyle' [%s attack-style.md]]
        ['combatXp' (numb:enjs:format combat-xp.md)]
        ['gpMin' (numb:enjs:format gp-min.md)]
        ['gpMax' (numb:enjs:format gp-max.md)]
        :-  'lootTable'
        :-  %a
        %+  turn  loot-table.md
        |=  le=loot-entry
        %-  pairs:enjs:format
        :~  ['item' [%s item.le]]
            ['minQty' (numb:enjs:format min-qty.le)]
            ['maxQty' (numb:enjs:format max-qty.le)]
            ['chance' (numb:enjs:format chance.le)]
        ==
    ==
  ::  area defs
  =/  area-defs=(list [@t json])
    %+  turn  ~(tap by area-registry:bide-areas)
    |=  [aid=area-id ad=area-def]
    ^-  [@t json]
    :-  aid
    %-  pairs:enjs:format
    :~  ['name' [%s name.ad]]
        ['monsters' [%a (turn monsters.ad |=(m=monster-id [%s m]))]]
        ['levelReq' (numb:enjs:format level-req.ad)]
    ==
  ::  equipment stats
  =/  equip-stat-defs=(list [@t json])
    %+  turn  ~(tap by equipment-registry:bide-equipment)
    |=  [iid=item-id es=equipment-stats]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['slot' [%s slot.es]]
        ['attackBonus' (numb:enjs:format attack-bonus.es)]
        ['strengthBonus' (numb:enjs:format strength-bonus.es)]
        ['rangedAttackBonus' (numb:enjs:format ranged-attack-bonus.es)]
        ['rangedStrengthBonus' (numb:enjs:format ranged-strength-bonus.es)]
        ['magicAttackBonus' (numb:enjs:format magic-attack-bonus.es)]
        ['magicStrengthBonus' (numb:enjs:format magic-strength-bonus.es)]
        ['defenceBonus' (numb:enjs:format defence-bonus.es)]
        ['attackSpeed' (numb:enjs:format attack-speed.es)]
        :-  'levelReqs'
        :-  %o
        %-  ~(gas by *(map @t json))
        %+  turn  ~(tap by level-reqs.es)
        |=  [sid=skill-id lvl=@ud]
        ^-  [@t json]
        [sid (numb:enjs:format lvl)]
    ==
  ::  food healing
  =/  food-defs=(list [@t json])
    %+  turn  ~(tap by food-registry:bide-food)
    |=  [iid=item-id heal=@ud]
    ^-  [@t json]
    [iid (numb:enjs:format heal)]
  %-  pairs:enjs:format
  :~  ['skills' [%o (~(gas by *(map @t json)) skill-defs)]]
      ['items' [%o (~(gas by *(map @t json)) item-defs)]]
      ['monsters' [%o (~(gas by *(map @t json)) monster-defs)]]
      ['areas' [%o (~(gas by *(map @t json)) area-defs)]]
      ['equipmentStats' [%o (~(gas by *(map @t json)) equip-stat-defs)]]
      ['foodHealing' [%o (~(gas by *(map @t json)) food-defs)]]
  ==
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
    ?>  ?=  $?(%helmet %platebody %weapon %shield)  slot
    (handle-action [%unequip slot] bowl)
  ::
      [%start-combat @ @ @ ~]
    =/  area=@tas  i.t.site
    =/  monster=@tas  i.t.t.site
    =/  style=@tas  i.t.t.t.site
    ?>  ?=  combat-style  style
    (handle-action [%start-combat area monster style] bowl)
  ::
      [%stop-combat ~]
    (handle-action [%stop-combat ~] bowl)
  ::
      [%set-auto-eat @ @ ~]
    =/  threshold=@ud  (slav %ud i.t.site)
    =/  food-str=@tas  i.t.t.site
    =/  food=(unit item-id)
      ?:  =(food-str 'none')  ~
      `food-str
    (handle-action [%set-auto-eat threshold food] bowl)
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
    =.  items.bank.gs  (~(del by items.bank.gs) item.act)
    `gs
  ::
      %buy
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
    =/  new-have=@ud  (sub have 1)
    =.  items.bank.gs
      ?:  =(new-have 0)
        (~(del by items.bank.gs) item.act)
      (~(put by items.bank.gs) item.act new-have)
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
      ?:  is-ranged  ?=(%ranged style.act)
      ?:  is-magic   ?=(%magic style.act)
      ?=(?(%melee-attack %melee-strength %melee-defence) style.act)
    ?.  style-ok
      ~&  [%bide %style-mismatch style.act]
      `gs
    ::  set up combat state with independent Behn timers
    =/  ms-per=@dr  (div ~s1 1.000)
    =/  weapon-spd=@ud  (weapon-speed:bide-combat slots.equipment.gs)
    =/  p-next=@da  (add now.bowl (mul ms-per weapon-spd))
    =/  e-next=@da  (add now.bowl (mul ms-per attack-speed.u.mdef))
    =.  active-action.gs
      :-  ~
      :*  %combat
          area.act
          monster.act
          style.act
          hitpoints.u.mdef
          hitpoints.u.mdef
          p-next
          e-next
          0           ::  kills
          0           ::  player-atk-count
          0           ::  enemy-atk-count
          0           ::  player-last-dmg
          0           ::  enemy-last-dmg
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
    ?.  ?=(%combat -.act)
      `gs
    ::  cancel pending combat timers
    :_  gs
    :~  [%pass /combat/player/(scot %da player-next-attack.act) %arvo %b [%rest player-next-attack.act]]
        [%pass /combat/enemy/(scot %da enemy-next-attack.act) %arvo %b [%rest enemy-next-attack.act]]
    ==
  ::
      %set-auto-eat
    =.  auto-eat-threshold.equipment.gs  (min 100 threshold.act)
    =.  selected-food.equipment.gs  food.act
    `gs
  ==
::
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
  =/  base-dr=@dr  (div (mul ~s1 base-time.u.adef) 1.000)
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
  =/  total-xp=@ud  (mul xp.u.adef num-actions)
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
  =/  outputs=(list output-def)  outputs.u.adef
  =.  bank.gs
    |-
    ?~  outputs  bank.gs
    =/  cur-qty=@ud  (fall (~(get by items.bank.gs) item.i.outputs) 0)
    =/  add-qty=@ud  (mul num-actions max-qty.i.outputs)
    =.  items.bank.gs
      (~(put by items.bank.gs) item.i.outputs (add cur-qty add-qty))
    $(outputs t.outputs)
  =/  prev-count=@ud
    (fall (~(get by actions-completed.stats.gs) target.act) 0)
  =.  actions-completed.stats.gs
    (~(put by actions-completed.stats.gs) target.act (add prev-count num-actions))
  =/  leftover=@dr  (mod elapsed base-dr)
  =.  active-action.gs
    `[%skilling skill.act target.act (sub now.bowl leftover)]
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
  ?>  ?=(%combat -.act)
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
  =/  seed=@uvJ  rng-seed.gs
  =/  p-hp=@ud  hitpoints-current.player.gs
  =/  p-hp-max=@ud  hitpoints-max.player.gs
  =/  weapon-spd=@ud  (weapon-speed:bide-combat slots.equipment.gs)
  =/  ms-per=@dr  (div ~s1 1.000)
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
      `[%combat area.act monster.act style.act e-hp e-max p-next e-next k p-atk-count e-atk-count p-last-dmg e-last-dmg started.act]
    :_  gs
    :~  [%pass /combat/player/(scot %da p-next) %arvo %b [%wait p-next]]
        [%pass /combat/enemy/(scot %da e-next) %arvo %b [%wait e-next]]
    ==
  ::
  ::  player attacks next
  ::
  ?:  p-first
    =^  dmg  seed
      (player-attack:bide-combat seed skills.gs slots.equipment.gs style.act defence-level.u.mdef)
    =.  p-atk-count  (add p-atk-count 1)
    =.  p-last-dmg  dmg
    =.  e-hp  ?:((gte e-hp dmg) (sub e-hp dmg) 0)
    =.  p-next  (add p-next weapon-dr)
    ::  enemy killed?
    ?.  =(e-hp 0)
      $(iterations (add iterations 1))
    ::  award xp
    =/  xp-total=@ud  combat-xp.u.mdef
    =/  style-xp=@ud  (div (mul xp-total 2) 3)
    =/  hp-xp=@ud  (div xp-total 3)
    =/  style-skill=skill-id
      ?-  style.act
        %melee-attack    %attack
        %melee-strength  %strength
        %melee-defence   %defence
        %ranged          %ranged
        %magic           %magic
      ==
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
    ::  roll gp
    =^  gp-drop  seed  (roll-gp:bide-combat seed gp-min.u.mdef gp-max.u.mdef)
    =.  gp.player.gs  (add gp.player.gs gp-drop)
    ::  spawn next monster
    =.  e-hp  hitpoints.u.mdef
    =.  e-max  hitpoints.u.mdef
    =.  e-next  (add p-next enemy-dr)
    =.  k  (add k 1)
    $(iterations (add iterations 1))
  ::
  ::  enemy attacks next
  ::
  =^  dmg  seed
    (enemy-attack:bide-combat seed u.mdef skills.gs slots.equipment.gs style.act)
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
--
