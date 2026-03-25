::  lib/bide-agility.hoon — agility course obstacle registry
::
/-  *bide
|%
::  ┌──────────────────────────────────────────────────────────┐
::  │  Obstacle registry                                       │
::  └──────────────────────────────────────────────────────────┘
::
++  obstacle-registry
  ^-  (map obstacle-id obstacle-def)
  %-  ~(gas by *(map obstacle-id obstacle-def))
  :~  ::
      ::  ── Slot 1 (Level 1) ──────────────────────────────────
      ::
      [%jog-trail jog-trail-def]
      [%balance-log balance-log-def]
      [%rope-climb rope-climb-def]
      ::
      ::  ── Slot 2 (Level 10) ─────────────────────────────────
      ::
      [%mud-crawl mud-crawl-def]
      [%hurdle-run hurdle-run-def]
      [%net-traverse net-traverse-def]
      ::
      ::  ── Slot 3 (Level 20) ─────────────────────────────────
      ::
      [%cargo-net cargo-net-def]
      [%tire-run tire-run-def]
      [%pipe-squeeze pipe-squeeze-def]
      ::
      ::  ── Slot 4 (Level 30) ─────────────────────────────────
      ::
      [%wall-scramble wall-scramble-def]
      [%monkey-bars monkey-bars-def]
      [%spike-jump spike-jump-def]
      ::
      ::  ── Slot 5 (Level 40) ─────────────────────────────────
      ::
      [%zipline zipline-def]
      [%rope-bridge rope-bridge-def]
      [%chimney-shimmy chimney-shimmy-def]
      ::
      ::  ── Slot 6 (Level 50) ─────────────────────────────────
      ::
      [%lava-hop lava-hop-def]
      [%cliff-face cliff-face-def]
      [%tightrope tightrope-def]
      ::
      ::  ── Slot 7 (Level 60) — "trap" slot ───────────────────
      ::
      [%blade-run blade-run-def]
      [%poison-pit poison-pit-def]
      [%pendulum-swing pendulum-swing-def]
      ::
      ::  ── Slot 8 (Level 70) ─────────────────────────────────
      ::
      [%ice-climb ice-climb-def]
      [%wind-tunnel wind-tunnel-def]
      [%boulder-dash boulder-dash-def]
      ::
      ::  ── Slot 9 (Level 80) ─────────────────────────────────
      ::
      [%sky-bridge sky-bridge-def]
      [%lightning-dodge lightning-dodge-def]
      [%shadow-vault shadow-vault-def]
      ::
      ::  ── Slot 10 (Level 90) ────────────────────────────────
      ::
      [%dragon-leap dragon-leap-def]
      [%inferno-dash inferno-dash-def]
      [%void-traverse void-traverse-def]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 1 obstacles (Level 1)                              │
::  └──────────────────────────────────────────────────────────┘
::
++  jog-trail-def
  ^-  obstacle-def
  :*  id=%jog-trail
      name='Jog Trail'
      slot=1
      level-req=1
      xp=8
      gp=3
      interval=3.000
      gp-cost=1.000
      item-costs=~[[item=%normal-logs qty=10]]
      bonuses=~[[%xp-skill skill=%woodcutting pct=2]]
      penalties=~[[%xp-skill skill=%mining pct=1]]
  ==
::
++  balance-log-def
  ^-  obstacle-def
  :*  id=%balance-log
      name='Balance Log'
      slot=1
      level-req=1
      xp=9
      gp=4
      interval=3.000
      gp-cost=1.500
      item-costs=~[[item=%leather qty=5]]
      bonuses=~[[%xp-skill skill=%fishing pct=2]]
      penalties=~[[%xp-skill skill=%cooking pct=1]]
  ==
::
++  rope-climb-def
  ^-  obstacle-def
  :*  id=%rope-climb
      name='Rope Climb'
      slot=1
      level-req=1
      xp=10
      gp=5
      interval=3.000
      gp-cost=2.000
      item-costs=~[[item=%normal-logs qty=15] [item=%leather qty=3]]
      bonuses=~[[%xp-skill skill=%mining pct=2]]
      penalties=~[[%xp-skill skill=%woodcutting pct=1]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 2 obstacles (Level 10)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  mud-crawl-def
  ^-  obstacle-def
  :*  id=%mud-crawl
      name='Mud Crawl'
      slot=2
      level-req=10
      xp=12
      gp=8
      interval=3.000
      gp-cost=3.000
      item-costs=~[[item=%oak-logs qty=10]]
      bonuses=~[[%xp-skill skill=%thieving pct=2]]
      penalties=~[[%xp-skill skill=%fishing pct=1]]
  ==
::
++  hurdle-run-def
  ^-  obstacle-def
  :*  id=%hurdle-run
      name='Hurdle Run'
      slot=2
      level-req=10
      xp=14
      gp=9
      interval=3.000
      gp-cost=4.000
      item-costs=~[[item=%oak-logs qty=15]]
      bonuses=~[[%xp-skill skill=%woodcutting pct=3]]
      penalties=~[[%xp-skill skill=%smithing pct=1]]
  ==
::
++  net-traverse-def
  ^-  obstacle-def
  :*  id=%net-traverse
      name='Net Traverse'
      slot=2
      level-req=10
      xp=15
      gp=10
      interval=3.000
      gp-cost=5.000
      item-costs=~[[item=%leather qty=10]]
      bonuses=~[[%xp-skill skill=%cooking pct=3]]
      penalties=~[[%xp-skill skill=%thieving pct=1]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 3 obstacles (Level 20)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  cargo-net-def
  ^-  obstacle-def
  :*  id=%cargo-net
      name='Cargo Net'
      slot=3
      level-req=20
      xp=20
      gp=15
      interval=4.000
      gp-cost=8.000
      item-costs=~[[item=%willow-logs qty=20]]
      bonuses=~[[%speed-bonus pct=1]]
      penalties=~[[%xp-skill skill=%firemaking pct=2]]
  ==
::
++  tire-run-def
  ^-  obstacle-def
  :*  id=%tire-run
      name='Tire Run'
      slot=3
      level-req=20
      xp=22
      gp=18
      interval=4.000
      gp-cost=10.000
      item-costs=~[[item=%iron-bar qty=10]]
      bonuses=~[[%farming-yield pct=2]]
      penalties=~[[%xp-skill skill=%crafting pct=1]]
  ==
::
++  pipe-squeeze-def
  ^-  obstacle-def
  :*  id=%pipe-squeeze
      name='Pipe Squeeze'
      slot=3
      level-req=20
      xp=25
      gp=20
      interval=4.000
      gp-cost=12.000
      item-costs=~[[item=%willow-logs qty=25] [item=%iron-bar qty=5]]
      bonuses=~[[%xp-skill skill=%mining pct=3] [%speed-bonus pct=1]]
      penalties=~[[%xp-skill skill=%fishing pct=2]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 4 obstacles (Level 30)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  wall-scramble-def
  ^-  obstacle-def
  :*  id=%wall-scramble
      name='Wall Scramble'
      slot=4
      level-req=30
      xp=30
      gp=25
      interval=4.000
      gp-cost=15.000
      item-costs=~[[item=%steel-bar qty=10]]
      bonuses=~[[%atk-boost pct=2] [%str-boost pct=2]]
      penalties=~[[%xp-skill skill=%herblore pct=2]]
  ==
::
++  monkey-bars-def
  ^-  obstacle-def
  :*  id=%monkey-bars
      name='Monkey Bars'
      slot=4
      level-req=30
      xp=35
      gp=30
      interval=4.000
      gp-cost=18.000
      item-costs=~[[item=%teak-logs qty=30]]
      bonuses=~[[%def-boost pct=3]]
      penalties=~[[%xp-skill skill=%runecrafting pct=2]]
  ==
::
++  spike-jump-def
  ^-  obstacle-def
  :*  id=%spike-jump
      name='Spike Jump'
      slot=4
      level-req=30
      xp=38
      gp=35
      interval=4.000
      gp-cost=20.000
      item-costs=~[[item=%steel-bar qty=15] [item=%teak-logs qty=20]]
      bonuses=~[[%ranged-boost pct=3]]
      penalties=~[[%xp-skill skill=%smithing pct=2]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 5 obstacles (Level 40)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  zipline-def
  ^-  obstacle-def
  :*  id=%zipline
      name='Zipline'
      slot=5
      level-req=40
      xp=40
      gp=40
      interval=5.000
      gp-cost=25.000
      item-costs=~[[item=%steel-bar qty=20]]
      bonuses=~[[%speed-bonus pct=2]]
      penalties=~[[%xp-skill skill=%woodcutting pct=2]]
  ==
::
++  rope-bridge-def
  ^-  obstacle-def
  :*  id=%rope-bridge
      name='Rope Bridge'
      slot=5
      level-req=40
      xp=45
      gp=50
      interval=5.000
      gp-cost=30.000
      item-costs=~[[item=%mithril-bar qty=10] [item=%maple-logs qty=30]]
      bonuses=~[[%xp-skill skill=%thieving pct=4]]
      penalties=~[[%xp-skill skill=%mining pct=2]]
  ==
::
++  chimney-shimmy-def
  ^-  obstacle-def
  :*  id=%chimney-shimmy
      name='Chimney Shimmy'
      slot=5
      level-req=40
      xp=50
      gp=55
      interval=5.000
      gp-cost=35.000
      item-costs=~[[item=%mithril-bar qty=15]]
      bonuses=~[[%atk-boost pct=3] [%str-boost pct=2]]
      penalties=~[[%farming-yield pct=2]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 6 obstacles (Level 50)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  lava-hop-def
  ^-  obstacle-def
  :*  id=%lava-hop
      name='Lava Hop'
      slot=6
      level-req=50
      xp=55
      gp=60
      interval=5.000
      gp-cost=50.000
      item-costs=~[[item=%gold-bar qty=20]]
      bonuses=~[[%gp-bonus pct=3] [%xp-skill skill=%firemaking pct=4]]
      penalties=~[[%xp-skill skill=%fishing pct=3]]
  ==
::
++  cliff-face-def
  ^-  obstacle-def
  :*  id=%cliff-face
      name='Cliff Face'
      slot=6
      level-req=50
      xp=65
      gp=70
      interval=5.000
      gp-cost=60.000
      item-costs=~[[item=%mithril-bar qty=20]]
      bonuses=~[[%speed-bonus pct=3] [%def-boost pct=3]]
      penalties=~[[%xp-skill skill=%thieving pct=3]]
  ==
::
++  tightrope-def
  ^-  obstacle-def
  :*  id=%tightrope
      name='Tightrope'
      slot=6
      level-req=50
      xp=70
      gp=80
      interval=5.000
      gp-cost=70.000
      item-costs=~[[item=%mahogany-logs qty=40]]
      bonuses=~[[%magic-boost pct=4] [%xp-skill skill=%runecrafting pct=4]]
      penalties=~[[%str-boost pct=2]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 7 obstacles (Level 60) — "trap" slot               │
::  └──────────────────────────────────────────────────────────┘
::
++  blade-run-def
  ^-  obstacle-def
  :*  id=%blade-run
      name='Blade Run'
      slot=7
      level-req=60
      xp=80
      gp=85
      interval=6.000
      gp-cost=80.000
      item-costs=~[[item=%adamantite-bar qty=10]]
      bonuses=~[[%atk-boost pct=5] [%str-boost pct=5]]
      penalties=~[[%def-boost pct=3] [%hp-bonus pct=3]]
  ==
::
++  poison-pit-def
  ^-  obstacle-def
  :*  id=%poison-pit
      name='Poison Pit'
      slot=7
      level-req=60
      xp=90
      gp=95
      interval=6.000
      gp-cost=100.000
      item-costs=~[[item=%yew-logs qty=40]]
      bonuses=~[[%xp-global pct=3]]
      penalties=~[[%speed-bonus pct=2] [%gp-bonus pct=2]]
  ==
::
++  pendulum-swing-def
  ^-  obstacle-def
  :*  id=%pendulum-swing
      name='Pendulum Swing'
      slot=7
      level-req=60
      xp=100
      gp=110
      interval=6.000
      gp-cost=120.000
      item-costs=~[[item=%adamantite-bar qty=15] [item=%yew-logs qty=30]]
      bonuses=~[[%speed-bonus pct=5] [%gp-bonus pct=3]]
      penalties=~[[%xp-global pct=2] [%def-boost pct=2]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 8 obstacles (Level 70)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  ice-climb-def
  ^-  obstacle-def
  :*  id=%ice-climb
      name='Ice Climb'
      slot=8
      level-req=70
      xp=110
      gp=120
      interval=7.000
      gp-cost=150.000
      item-costs=~[[item=%adamantite-bar qty=20]]
      bonuses=~[[%preservation pct=3] [%xp-skill skill=%mining pct=5]]
      penalties=~[[%xp-skill skill=%woodcutting pct=3]]
  ==
::
++  wind-tunnel-def
  ^-  obstacle-def
  :*  id=%wind-tunnel
      name='Wind Tunnel'
      slot=8
      level-req=70
      xp=125
      gp=140
      interval=7.000
      gp-cost=180.000
      item-costs=~[[item=%runite-bar qty=10]]
      bonuses=~[[%xp-global pct=3] [%speed-bonus pct=3]]
      penalties=~[[%farming-yield pct=3] [%gp-bonus pct=2]]
  ==
::
++  boulder-dash-def
  ^-  obstacle-def
  :*  id=%boulder-dash
      name='Boulder Dash'
      slot=8
      level-req=70
      xp=140
      gp=150
      interval=7.000
      gp-cost=200.000
      item-costs=~[[item=%runite-bar qty=15] [item=%magic-logs qty=30]]
      bonuses=~[[%preservation pct=5]]
      penalties=~[[%xp-skill skill=%herblore pct=3] [%xp-skill skill=%crafting pct=3]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 9 obstacles (Level 80)                             │
::  └──────────────────────────────────────────────────────────┘
::
++  sky-bridge-def
  ^-  obstacle-def
  :*  id=%sky-bridge
      name='Sky Bridge'
      slot=9
      level-req=80
      xp=150
      gp=170
      interval=8.000
      gp-cost=250.000
      item-costs=~[[item=%runite-bar qty=20]]
      bonuses=~[[%speed-bonus pct=5] [%xp-skill skill=%agility pct=5]]
      penalties=~[[%xp-skill skill=%cooking pct=4] [%xp-skill skill=%firemaking pct=3]]
  ==
::
++  lightning-dodge-def
  ^-  obstacle-def
  :*  id=%lightning-dodge
      name='Lightning Dodge'
      slot=9
      level-req=80
      xp=170
      gp=190
      interval=8.000
      gp-cost=300.000
      item-costs=~[[item=%dragonite-bar qty=5] [item=%runite-bar qty=15]]
      bonuses=~[[%atk-boost pct=5] [%ranged-boost pct=5] [%magic-boost pct=5]]
      penalties=~[[%preservation pct=3] [%farming-yield pct=3]]
  ==
::
++  shadow-vault-def
  ^-  obstacle-def
  :*  id=%shadow-vault
      name='Shadow Vault'
      slot=9
      level-req=80
      xp=190
      gp=200
      interval=8.000
      gp-cost=350.000
      item-costs=~[[item=%dragonite-bar qty=8]]
      bonuses=~[[%gp-bonus pct=5] [%xp-global pct=4]]
      penalties=~[[%speed-bonus pct=3] [%str-boost pct=3]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Slot 10 obstacles (Level 90)                            │
::  └──────────────────────────────────────────────────────────┘
::
++  dragon-leap-def
  ^-  obstacle-def
  :*  id=%dragon-leap
      name='Dragon Leap'
      slot=10
      level-req=90
      xp=200
      gp=220
      interval=10.000
      gp-cost=400.000
      item-costs=~[[item=%dragonite-bar qty=15]]
      bonuses=~[[%atk-boost pct=6] [%str-boost pct=6] [%hp-bonus pct=3]]
      penalties=~[[%xp-skill skill=%mining pct=5] [%xp-skill skill=%fishing pct=5]]
  ==
::
++  inferno-dash-def
  ^-  obstacle-def
  :*  id=%inferno-dash
      name='Inferno Dash'
      slot=10
      level-req=90
      xp=230
      gp=260
      interval=10.000
      gp-cost=500.000
      item-costs=~[[item=%dragonite-bar qty=20] [item=%onyx qty=3]]
      bonuses=~[[%speed-bonus pct=6] [%xp-global pct=5]]
      penalties=~[[%def-boost pct=4] [%hp-bonus pct=3]]
  ==
::
++  void-traverse-def
  ^-  obstacle-def
  :*  id=%void-traverse
      name='Void Traverse'
      slot=10
      level-req=90
      xp=250
      gp=300
      interval=10.000
      gp-cost=600.000
      item-costs=~[[item=%dragonite-bar qty=25] [item=%onyx qty=5]]
      bonuses=~[[%preservation pct=6] [%gp-bonus pct=6] [%farming-yield pct=5]]
      penalties=~[[%xp-global pct=3] [%speed-bonus pct=3]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Pillar registry                                         │
::  └──────────────────────────────────────────────────────────┘
::
++  pillar-registry
  ^-  (map pillar-id pillar-def)
  %-  ~(gas by *(map pillar-id pillar-def))
  :~  [%pillar-expertise pillar-expertise-def]
      [%pillar-combat pillar-combat-def]
      [%pillar-wealth pillar-wealth-def]
  ==
::
++  pillar-expertise-def
  ^-  pillar-def
  :*  id=%pillar-expertise
      name='Pillar of Expertise'
      gp-cost=5.000.000
      bonuses=~[[%xp-global pct=5] [%speed-bonus pct=3]]
  ==
::
++  pillar-combat-def
  ^-  pillar-def
  :*  id=%pillar-combat
      name='Pillar of Combat'
      gp-cost=5.000.000
      bonuses=~[[%atk-boost pct=5] [%str-boost pct=5] [%def-boost pct=5] [%hp-bonus pct=3]]
  ==
::
++  pillar-wealth-def
  ^-  pillar-def
  :*  id=%pillar-wealth
      name='Pillar of Wealth'
      gp-cost=5.000.000
      bonuses=~[[%gp-bonus pct=8] [%preservation pct=5]]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Course modifier computation                             │
::  └──────────────────────────────────────────────────────────┘
::
::  Computes net modifiers from an agility course.
::  An obstacle is only active if all slots 1..N-1 before it are filled.
::  Returns net values with saturating subtraction (bonuses - penalties, min 0).
::
++  course-modifiers
  |=  [course=(map @ud obstacle-id) active-pillar=(unit pillar-id)]
  ^-  $:  xp-global=@ud
          xp-per-skill=(map skill-id @ud)
          speed-bonus=@ud
          gp-bonus=@ud
          farming-yield=@ud
          preservation=@ud
          atk-boost=@ud
          str-boost=@ud
          def-boost=@ud
          ranged-boost=@ud
          magic-boost=@ud
          hp-bonus=@ud
      ==
  ::  determine highest contiguous slot
  =/  max-active=@ud
    =/  s=@ud  1
    |-
    ?:  (gth s 10)
      10
    ?.  (~(has by course) s)
      ?:  =(s 1)  0
      (dec s)
    $(s +(s))
  ::  accumulate raw bonuses and penalties
  =/  bon-xp-global=@ud     0
  =/  bon-xp-skill=(map skill-id @ud)  *(map skill-id @ud)
  =/  bon-speed=@ud          0
  =/  bon-gp=@ud             0
  =/  bon-farm=@ud           0
  =/  bon-pres=@ud           0
  =/  bon-atk=@ud            0
  =/  bon-str=@ud            0
  =/  bon-def=@ud            0
  =/  bon-rng=@ud            0
  =/  bon-mag=@ud            0
  =/  bon-hp=@ud             0
  =/  pen-xp-global=@ud     0
  =/  pen-xp-skill=(map skill-id @ud)  *(map skill-id @ud)
  =/  pen-speed=@ud          0
  =/  pen-gp=@ud             0
  =/  pen-farm=@ud           0
  =/  pen-pres=@ud           0
  =/  pen-atk=@ud            0
  =/  pen-str=@ud            0
  =/  pen-def=@ud            0
  =/  pen-rng=@ud            0
  =/  pen-mag=@ud            0
  =/  pen-hp=@ud             0
  ::  iterate active slots and accumulate obstacle bonuses/penalties
  =/  i=@ud  1
  =/  obs-reg=(map obstacle-id obstacle-def)  obstacle-registry
  |-
  ?:  (gth i max-active)
    ::  add pillar bonuses to the bon-* accumulators
    =/  pbon=(list agility-modifier)
      ?~  active-pillar  ~
      =/  pil=(unit pillar-def)  (~(get by pillar-registry) u.active-pillar)
      ?~  pil  ~
      bonuses.u.pil
    |-
    ?~  pbon
      ::  compute net values (saturating subtraction)
      =/  net-xp-global=@ud    ?:((gte bon-xp-global pen-xp-global) (sub bon-xp-global pen-xp-global) 0)
      =/  net-speed=@ud        ?:((gte bon-speed pen-speed) (sub bon-speed pen-speed) 0)
      =/  net-gp=@ud           ?:((gte bon-gp pen-gp) (sub bon-gp pen-gp) 0)
      =/  net-farm=@ud         ?:((gte bon-farm pen-farm) (sub bon-farm pen-farm) 0)
      =/  net-pres=@ud         ?:((gte bon-pres pen-pres) (sub bon-pres pen-pres) 0)
      =/  net-atk=@ud          ?:((gte bon-atk pen-atk) (sub bon-atk pen-atk) 0)
      =/  net-str=@ud          ?:((gte bon-str pen-str) (sub bon-str pen-str) 0)
      =/  net-def=@ud          ?:((gte bon-def pen-def) (sub bon-def pen-def) 0)
      =/  net-rng=@ud          ?:((gte bon-rng pen-rng) (sub bon-rng pen-rng) 0)
      =/  net-mag=@ud          ?:((gte bon-mag pen-mag) (sub bon-mag pen-mag) 0)
      =/  net-hp=@ud           ?:((gte bon-hp pen-hp) (sub bon-hp pen-hp) 0)
      ::  compute net per-skill XP (merge bonus and penalty skill maps)
      =/  all-skills=(list skill-id)
        %~  tap  in
        (~(uni in ~(key by bon-xp-skill)) ~(key by pen-xp-skill))
      =/  net-xp-skill=(map skill-id @ud)  *(map skill-id @ud)
      |-
      ?~  all-skills
        :*  xp-global=net-xp-global
            xp-per-skill=net-xp-skill
            speed-bonus=net-speed
            gp-bonus=net-gp
            farming-yield=net-farm
            preservation=net-pres
            atk-boost=net-atk
            str-boost=net-str
            def-boost=net-def
            ranged-boost=net-rng
            magic-boost=net-mag
            hp-bonus=net-hp
        ==
      =/  sk=skill-id  i.all-skills
      =/  b=@ud  (~(gut by bon-xp-skill) sk 0)
      =/  p=@ud  (~(gut by pen-xp-skill) sk 0)
      =/  net=@ud  ?:((gte b p) (sub b p) 0)
      =?  net-xp-skill  (gth net 0)
        (~(put by net-xp-skill) sk net)
      $(all-skills t.all-skills)
    ::  apply pillar bonus
    =/  pb=agility-modifier  i.pbon
    =.  bon-xp-global  ?:(?=(%xp-global -.pb) (add bon-xp-global pct.pb) bon-xp-global)
    =.  bon-xp-skill   ?:(?=(%xp-skill -.pb) (~(put by bon-xp-skill) skill.pb (add (~(gut by bon-xp-skill) skill.pb 0) pct.pb)) bon-xp-skill)
    =.  bon-speed      ?:(?=(%speed-bonus -.pb) (add bon-speed pct.pb) bon-speed)
    =.  bon-gp         ?:(?=(%gp-bonus -.pb) (add bon-gp pct.pb) bon-gp)
    =.  bon-farm       ?:(?=(%farming-yield -.pb) (add bon-farm pct.pb) bon-farm)
    =.  bon-pres       ?:(?=(%preservation -.pb) (add bon-pres pct.pb) bon-pres)
    =.  bon-atk        ?:(?=(%atk-boost -.pb) (add bon-atk pct.pb) bon-atk)
    =.  bon-str        ?:(?=(%str-boost -.pb) (add bon-str pct.pb) bon-str)
    =.  bon-def        ?:(?=(%def-boost -.pb) (add bon-def pct.pb) bon-def)
    =.  bon-rng        ?:(?=(%ranged-boost -.pb) (add bon-rng pct.pb) bon-rng)
    =.  bon-mag        ?:(?=(%magic-boost -.pb) (add bon-mag pct.pb) bon-mag)
    =.  bon-hp         ?:(?=(%hp-bonus -.pb) (add bon-hp pct.pb) bon-hp)
    $(pbon t.pbon)
  ::  process obstacle at slot i
  =/  oid=(unit obstacle-id)  (~(get by course) i)
  ?~  oid  $(i +(i))
  =/  odef=(unit obstacle-def)  (~(get by obs-reg) u.oid)
  ?~  odef  $(i +(i))
  =/  o=obstacle-def  u.odef
  ::  accumulate bonuses from this obstacle
  =/  bons=(list agility-modifier)  bonuses.o
  |-
  ?~  bons
    ::  accumulate penalties from this obstacle
    =/  pens=(list agility-modifier)  penalties.o
    |-
    ?~  pens
      ^^$(i +(i))
    =/  p=agility-modifier  i.pens
    =.  pen-xp-global  ?:(?=(%xp-global -.p) (add pen-xp-global pct.p) pen-xp-global)
    =.  pen-xp-skill   ?:(?=(%xp-skill -.p) (~(put by pen-xp-skill) skill.p (add (~(gut by pen-xp-skill) skill.p 0) pct.p)) pen-xp-skill)
    =.  pen-speed      ?:(?=(%speed-bonus -.p) (add pen-speed pct.p) pen-speed)
    =.  pen-gp         ?:(?=(%gp-bonus -.p) (add pen-gp pct.p) pen-gp)
    =.  pen-farm       ?:(?=(%farming-yield -.p) (add pen-farm pct.p) pen-farm)
    =.  pen-pres       ?:(?=(%preservation -.p) (add pen-pres pct.p) pen-pres)
    =.  pen-atk        ?:(?=(%atk-boost -.p) (add pen-atk pct.p) pen-atk)
    =.  pen-str        ?:(?=(%str-boost -.p) (add pen-str pct.p) pen-str)
    =.  pen-def        ?:(?=(%def-boost -.p) (add pen-def pct.p) pen-def)
    =.  pen-rng        ?:(?=(%ranged-boost -.p) (add pen-rng pct.p) pen-rng)
    =.  pen-mag        ?:(?=(%magic-boost -.p) (add pen-mag pct.p) pen-mag)
    =.  pen-hp         ?:(?=(%hp-bonus -.p) (add pen-hp pct.p) pen-hp)
    $(pens t.pens)
  =/  b=agility-modifier  i.bons
  =.  bon-xp-global  ?:(?=(%xp-global -.b) (add bon-xp-global pct.b) bon-xp-global)
  =.  bon-xp-skill   ?:(?=(%xp-skill -.b) (~(put by bon-xp-skill) skill.b (add (~(gut by bon-xp-skill) skill.b 0) pct.b)) bon-xp-skill)
  =.  bon-speed      ?:(?=(%speed-bonus -.b) (add bon-speed pct.b) bon-speed)
  =.  bon-gp         ?:(?=(%gp-bonus -.b) (add bon-gp pct.b) bon-gp)
  =.  bon-farm       ?:(?=(%farming-yield -.b) (add bon-farm pct.b) bon-farm)
  =.  bon-pres       ?:(?=(%preservation -.b) (add bon-pres pct.b) bon-pres)
  =.  bon-atk        ?:(?=(%atk-boost -.b) (add bon-atk pct.b) bon-atk)
  =.  bon-str        ?:(?=(%str-boost -.b) (add bon-str pct.b) bon-str)
  =.  bon-def        ?:(?=(%def-boost -.b) (add bon-def pct.b) bon-def)
  =.  bon-rng        ?:(?=(%ranged-boost -.b) (add bon-rng pct.b) bon-rng)
  =.  bon-mag        ?:(?=(%magic-boost -.b) (add bon-mag pct.b) bon-mag)
  =.  bon-hp         ?:(?=(%hp-bonus -.b) (add bon-hp pct.b) bon-hp)
  $(bons t.bons)
::
::  Compute total course XP (sum of all built obstacles in chain)
::
++  course-xp
  |=  course=(map @ud obstacle-id)
  ^-  @ud
  =/  slot=@ud  1
  =/  total=@ud  0
  |-
  ?:  (gth slot 10)  total
  =/  oid=(unit obstacle-id)  (~(get by course) slot)
  ?~  oid  total  ::  chain broken
  =/  odef=(unit obstacle-def)  (~(get by obstacle-registry) u.oid)
  ?~  odef  $(slot +(slot))
  $(slot +(slot), total (add total xp.u.odef))
::
::  Compute total course interval (sum of all built obstacles in chain)
::
++  course-interval
  |=  course=(map @ud obstacle-id)
  ^-  @ud
  =/  slot=@ud  1
  =/  total=@ud  0
  |-
  ?:  (gth slot 10)  total
  =/  oid=(unit obstacle-id)  (~(get by course) slot)
  ?~  oid  total  ::  chain broken
  =/  odef=(unit obstacle-def)  (~(get by obstacle-registry) u.oid)
  ?~  odef  $(slot +(slot))
  $(slot +(slot), total (add total interval.u.odef))
::
::  Compute total course GP (sum of all built obstacles in chain)
::
++  course-gp
  |=  course=(map @ud obstacle-id)
  ^-  @ud
  =/  slot=@ud  1
  =/  total=@ud  0
  |-
  ?:  (gth slot 10)  total
  =/  oid=(unit obstacle-id)  (~(get by course) slot)
  ?~  oid  total
  =/  odef=(unit obstacle-def)  (~(get by obstacle-registry) u.oid)
  ?~  odef  $(slot +(slot))
  $(slot +(slot), total (add total gp.u.odef))
--
