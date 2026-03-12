::  app/bide.hoon — Bide idle RPG agent
::
::  JSON API + game tick engine. Frontend renders client-side.
::
/-  *bide
/+  dbug, verb, default-agent, server
/+  bide-xp, bide-skills, bide-items
::
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      gs=game-state
  ==
+$  versioned-state
  $%  state-0
  ==
--
::
%-  agent:dbug
%+  verb  |
=|  state-0
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
  =.  gs
    :*  :*  gp=0
            hitpoints-current=100
            hitpoints-max=100
            created=now.bowl
        ==
        ^-  (map skill-id skill-state)
        %-  ~(gas by *(map skill-id skill-state))
        :~  :-  %woodcutting
            [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]
        ==
        [items=*(map item-id @ud) slots-max=12]
        [active-set=0]
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
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+  pole  (on-peek:def pole)
      [%x %state ~]  ``json+!>(state-to-json)
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
::  Helpers return (quip card game-state) so the agent arms
::  can thread state changes with =^  cards  gs.
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
    (handle-get eyre-id site)
  ?.  =(%'POST' method.request.req)
    :_  gs
    (give-simple-payload:app:server eyre-id [[405 ~] ~])
  =^  cards  gs  (handle-post eyre-id site bowl)
  :_  gs
  %+  welp  cards
  (give-simple-payload:app:server eyre-id [[204 ~] ~])
::
++  handle-get
  |=  [eyre-id=@ta site=(list @t)]
  ^-  (list card)
  ?+  site
    (give-simple-payload:app:server eyre-id [[404 ~] ~])
  ::
      [%state ~]
    (give-json eyre-id state-to-json)
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
    ==
  %-  pairs:enjs:format
  :~  ['gp' (numb:enjs:format gp.player.gs)]
      ['hp' (numb:enjs:format hitpoints-current.player.gs)]
      ['hpMax' (numb:enjs:format hitpoints-max.player.gs)]
      ['skills' skills-json]
      ['bank' bank-json]
      ['slotsMax' (numb:enjs:format slots-max.bank.gs)]
      ['activeAction' action-json]
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
  %-  pairs:enjs:format
  :~  ['skills' [%o (~(gas by *(map @t json)) skill-defs)]]
      ['items' [%o (~(gas by *(map @t json)) item-defs)]]
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
  ==
::
++  process-tick
  |=  =bowl:gall
  ^-  (quip card game-state)
  =.  last-tick.gs  now.bowl
  ?~  active-action.gs  `gs
  =/  act  u.active-action.gs
  ?-  -.act
    %skilling  (process-skill-tick act bowl)
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
--
