::  lib/bide/data/skills.hoon — skill and action definitions
::
::  Phase 2-7: Gathering, Artisan, Combat, and Passive skills
::
/-  *bide
|%
::
++  skill-registry
  ^-  (map skill-id skill-def)
  %-  ~(gas by *(map skill-id skill-def))
  :~  [%woodcutting woodcutting-def]
      [%fishing fishing-def]
      [%mining mining-def]
      [%thieving thieving-def]
      [%firemaking firemaking-def]
      [%cooking cooking-def]
      [%smithing smithing-def]
      [%fletching fletching-def]
      [%crafting crafting-def]
      [%runecrafting runecrafting-def]
      [%herblore herblore-def]
      ::  passive/new skills
      [%farming farming-def]
      [%agility agility-def]
      [%astrology astrology-def]
      [%summoning summoning-def]
      ::  combat skills
      [%attack attack-def]
      [%strength strength-def]
      [%defence defence-def]
      [%hitpoints hitpoints-def]
      [%ranged ranged-def]
      [%magic magic-def]
      [%prayer prayer-skill-def]
      [%slayer slayer-skill-def]
  ==
::
++  woodcutting-def
  ^-  skill-def
  :*  id=%woodcutting
      name='Woodcutting'
      skill-type=%gathering
      max-level=99
      actions=woodcutting-actions
  ==
::
++  woodcutting-actions
  ^-  (list action-def)
  :~  :*  id=%cut-normal-tree
          name='Normal Tree'
          level-req=1
          xp=100
          base-time=3.000
          inputs=~
          outputs=~[[item=%normal-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%cut-oak-tree
          name='Oak Tree'
          level-req=15
          xp=350
          base-time=3.000
          inputs=~
          outputs=~[[item=%oak-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=35
          gp-per-action=0
      ==
      :*  id=%cut-willow-tree
          name='Willow Tree'
          level-req=30
          xp=625
          base-time=3.500
          inputs=~
          outputs=~[[item=%willow-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=63
          gp-per-action=0
      ==
      :*  id=%cut-teak-tree
          name='Teak Tree'
          level-req=35
          xp=850
          base-time=3.800
          inputs=~
          outputs=~[[item=%teak-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=85
          gp-per-action=0
      ==
      :*  id=%cut-maple-tree
          name='Maple Tree'
          level-req=45
          xp=1.000
          base-time=4.000
          inputs=~
          outputs=~[[item=%maple-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=100
          gp-per-action=0
      ==
      :*  id=%cut-mahogany-tree
          name='Mahogany Tree'
          level-req=55
          xp=1.250
          base-time=4.500
          inputs=~
          outputs=~[[item=%mahogany-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=125
          gp-per-action=0
      ==
      :*  id=%cut-yew-tree
          name='Yew Tree'
          level-req=60
          xp=1.500
          base-time=5.000
          inputs=~
          outputs=~[[item=%yew-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=150
          gp-per-action=0
      ==
      :*  id=%cut-magic-tree
          name='Magic Tree'
          level-req=75
          xp=2.500
          base-time=6.000
          inputs=~
          outputs=~[[item=%magic-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=250
          gp-per-action=0
      ==
      :*  id=%cut-redwood-tree
          name='Redwood Tree'
          level-req=90
          xp=3.500
          base-time=8.000
          inputs=~
          outputs=~[[item=%redwood-logs min-qty=1 max-qty=1 chance=100]]
          mastery-xp=350
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Fishing                                                  │
::  └──────────────────────────────────────────────────────────┘
::
++  fishing-def
  ^-  skill-def
  :*  id=%fishing
      name='Fishing'
      skill-type=%gathering
      max-level=99
      actions=fishing-actions
  ==
::
++  fishing-actions
  ^-  (list action-def)
  :~  :*  id=%collect-vials
          name='Vials'
          level-req=1
          xp=10
          base-time=1.500
          inputs=~
          outputs=~[[item=%vial-of-water min-qty=1 max-qty=1 chance=100]]
          mastery-xp=1
          gp-per-action=0
      ==
      :*  id=%catch-shrimp
          name='Shrimp'
          level-req=1
          xp=100
          base-time=3.000
          inputs=~
          outputs=~[[item=%raw-shrimp min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%catch-sardine
          name='Sardine'
          level-req=5
          xp=200
          base-time=3.200
          inputs=~
          outputs=~[[item=%raw-sardine min-qty=1 max-qty=1 chance=100]]
          mastery-xp=20
          gp-per-action=0
      ==
      :*  id=%catch-herring
          name='Herring'
          level-req=10
          xp=300
          base-time=3.500
          inputs=~
          outputs=~[[item=%raw-herring min-qty=1 max-qty=1 chance=100]]
          mastery-xp=30
          gp-per-action=0
      ==
      :*  id=%catch-trout
          name='Trout'
          level-req=20
          xp=500
          base-time=4.000
          inputs=~
          outputs=~[[item=%raw-trout min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      :*  id=%catch-salmon
          name='Salmon'
          level-req=30
          xp=700
          base-time=4.500
          inputs=~
          outputs=~[[item=%raw-salmon min-qty=1 max-qty=1 chance=100]]
          mastery-xp=70
          gp-per-action=0
      ==
      :*  id=%catch-lobster
          name='Lobster'
          level-req=40
          xp=900
          base-time=5.000
          inputs=~
          outputs=~[[item=%raw-lobster min-qty=1 max-qty=1 chance=100]]
          mastery-xp=90
          gp-per-action=0
      ==
      :*  id=%catch-swordfish
          name='Swordfish'
          level-req=50
          xp=1.100
          base-time=5.500
          inputs=~
          outputs=~[[item=%raw-swordfish min-qty=1 max-qty=1 chance=100]]
          mastery-xp=110
          gp-per-action=0
      ==
      :*  id=%catch-crab
          name='Crab'
          level-req=55
          xp=1.250
          base-time=5.000
          inputs=~
          outputs=~[[item=%raw-crab min-qty=1 max-qty=1 chance=100]]
          mastery-xp=125
          gp-per-action=0
      ==
      :*  id=%catch-shark
          name='Shark'
          level-req=65
          xp=1.500
          base-time=6.000
          inputs=~
          outputs=~[[item=%raw-shark min-qty=1 max-qty=1 chance=100]]
          mastery-xp=150
          gp-per-action=0
      ==
      :*  id=%catch-whale
          name='Whale'
          level-req=80
          xp=2.500
          base-time=7.000
          inputs=~
          outputs=~[[item=%raw-whale min-qty=1 max-qty=1 chance=100]]
          mastery-xp=250
          gp-per-action=0
      ==
      :*  id=%catch-anglerfish
          name='Anglerfish'
          level-req=90
          xp=3.500
          base-time=8.000
          inputs=~
          outputs=~[[item=%raw-anglerfish min-qty=1 max-qty=1 chance=100]]
          mastery-xp=350
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Mining                                                   │
::  └──────────────────────────────────────────────────────────┘
::
++  mining-def
  ^-  skill-def
  :*  id=%mining
      name='Mining'
      skill-type=%gathering
      max-level=99
      actions=mining-actions
  ==
::
++  mining-actions
  ^-  (list action-def)
  :~  :*  id=%mine-rune-essence
          name='Rune Essence'
          level-req=1
          xp=50
          base-time=2.500
          inputs=~
          outputs=~[[item=%rune-essence min-qty=1 max-qty=1 chance=100]]
          mastery-xp=5
          gp-per-action=0
      ==
      :*  id=%mine-copper
          name='Copper Ore'
          level-req=1
          xp=100
          base-time=3.000
          inputs=~
          outputs=~[[item=%copper-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%mine-tin
          name='Tin Ore'
          level-req=1
          xp=100
          base-time=3.000
          inputs=~
          outputs=~[[item=%tin-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%mine-iron
          name='Iron Ore'
          level-req=15
          xp=350
          base-time=3.500
          inputs=~
          outputs=~[[item=%iron-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=35
          gp-per-action=0
      ==
      :*  id=%mine-coal
          name='Coal'
          level-req=30
          xp=500
          base-time=4.000
          inputs=~
          outputs=~[[item=%coal-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      :*  id=%mine-silver
          name='Silver Ore'
          level-req=20
          xp=400
          base-time=3.800
          inputs=~
          outputs=~[[item=%silver-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%mine-gold
          name='Gold Ore'
          level-req=40
          xp=650
          base-time=4.500
          inputs=~
          outputs=~[[item=%gold-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=65
          gp-per-action=0
      ==
      :*  id=%mine-mithril
          name='Mithril Ore'
          level-req=50
          xp=850
          base-time=5.000
          inputs=~
          outputs=~[[item=%mithril-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=85
          gp-per-action=0
      ==
      :*  id=%mine-adamantite
          name='Adamantite Ore'
          level-req=60
          xp=1.250
          base-time=5.500
          inputs=~
          outputs=~[[item=%adamantite-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=125
          gp-per-action=0
      ==
      :*  id=%mine-runite
          name='Runite Ore'
          level-req=70
          xp=1.750
          base-time=6.000
          inputs=~
          outputs=~[[item=%runite-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=175
          gp-per-action=0
      ==
      :*  id=%mine-dragonite
          name='Dragonite Ore'
          level-req=80
          xp=2.750
          base-time=7.000
          inputs=~
          outputs=~[[item=%dragonite-ore min-qty=1 max-qty=1 chance=100]]
          mastery-xp=275
          gp-per-action=0
      ==
      :*  id=%mine-onyx
          name='Onyx'
          level-req=90
          xp=4.000
          base-time=8.000
          inputs=~
          outputs=~[[item=%onyx min-qty=1 max-qty=1 chance=100]]
          mastery-xp=400
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Thieving                                                 │
::  └──────────────────────────────────────────────────────────┘
::
++  thieving-def
  ^-  skill-def
  :*  id=%thieving
      name='Thieving'
      skill-type=%gathering
      max-level=99
      actions=thieving-actions
  ==
::
++  thieving-actions
  ^-  (list action-def)
  :~  :*  id=%pickpocket-man
          name='Man'
          level-req=1
          xp=80
          base-time=2.500
          inputs=~
          outputs=~[[item=%gp-pouch-small min-qty=1 max-qty=1 chance=100] [item=%potato-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=8
          gp-per-action=0
      ==
      :*  id=%pickpocket-farmer
          name='Farmer'
          level-req=10
          xp=150
          base-time=2.500
          inputs=~
          outputs=~[[item=%gp-pouch-medium min-qty=1 max-qty=1 chance=100] [item=%grimy-guam min-qty=1 max-qty=1 chance=100] [item=%onion-seed min-qty=1 max-qty=1 chance=15] [item=%guam-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=15
          gp-per-action=0
      ==
      :*  id=%pickpocket-warrior
          name='Warrior'
          level-req=25
          xp=260
          base-time=3.000
          inputs=~
          outputs=~[[item=%gp-pouch-large min-qty=1 max-qty=1 chance=100] [item=%grimy-marrentill min-qty=1 max-qty=1 chance=100] [item=%tomato-seed min-qty=1 max-qty=1 chance=12] [item=%marrentill-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=26
          gp-per-action=0
      ==
      :*  id=%pickpocket-merchant
          name='Merchant'
          level-req=35
          xp=400
          base-time=3.000
          inputs=~
          outputs=~[[item=%gp-pouch-large min-qty=1 max-qty=1 chance=100] [item=%grimy-tarromin min-qty=1 max-qty=1 chance=100] [item=%sweetcorn-seed min-qty=1 max-qty=1 chance=12] [item=%tarromin-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%pickpocket-knight
          name='Knight'
          level-req=45
          xp=550
          base-time=3.500
          inputs=~
          outputs=~[[item=%gp-pouch-huge min-qty=1 max-qty=1 chance=100] [item=%grimy-harralander min-qty=1 max-qty=1 chance=100] [item=%strawberry-seed min-qty=1 max-qty=1 chance=12] [item=%harralander-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=55
          gp-per-action=0
      ==
      :*  id=%pickpocket-noble
          name='Noble'
          level-req=55
          xp=750
          base-time=3.500
          inputs=~
          outputs=~[[item=%gp-pouch-huge min-qty=1 max-qty=1 chance=100] [item=%grimy-ranarr min-qty=1 max-qty=1 chance=100] [item=%watermelon-seed min-qty=1 max-qty=1 chance=12] [item=%ranarr-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=75
          gp-per-action=0
      ==
      :*  id=%pickpocket-princess
          name='Princess'
          level-req=65
          xp=1.050
          base-time=4.000
          inputs=~
          outputs=~[[item=%gp-pouch-royal min-qty=1 max-qty=1 chance=100] [item=%grimy-irit min-qty=1 max-qty=1 chance=100] [item=%snape-grass-seed min-qty=1 max-qty=1 chance=10] [item=%irit-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=105
          gp-per-action=0
      ==
      :*  id=%pickpocket-king
          name='King'
          level-req=75
          xp=1.500
          base-time=4.500
          inputs=~
          outputs=~[[item=%gp-pouch-royal min-qty=1 max-qty=1 chance=100] [item=%grimy-kwuarm min-qty=1 max-qty=1 chance=100] [item=%kwuarm-seed min-qty=1 max-qty=1 chance=10]]
          mastery-xp=150
          gp-per-action=0
      ==
      :*  id=%pickpocket-dragon
          name='Dragon'
          level-req=90
          xp=3.000
          base-time=5.000
          inputs=~
          outputs=~[[item=%gp-pouch-dragon min-qty=1 max-qty=1 chance=100] [item=%grimy-torstol min-qty=1 max-qty=1 chance=100] [item=%torstol-seed min-qty=1 max-qty=1 chance=15]]
          mastery-xp=300
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Firemaking                                               │
::  └──────────────────────────────────────────────────────────┘
::
++  firemaking-def
  ^-  skill-def
  :*  id=%firemaking
      name='Firemaking'
      skill-type=%artisan
      max-level=99
      actions=firemaking-actions
  ==
::
++  firemaking-actions
  ^-  (list action-def)
  :~  :*  id=%burn-normal-logs
          name='Burn Normal Logs'
          level-req=1
          xp=400
          base-time=2.000
          inputs=~[[item=%normal-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%burn-oak-logs
          name='Burn Oak Logs'
          level-req=15
          xp=600
          base-time=2.000
          inputs=~[[item=%oak-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=60
          gp-per-action=0
      ==
      :*  id=%burn-willow-logs
          name='Burn Willow Logs'
          level-req=30
          xp=900
          base-time=2.000
          inputs=~[[item=%willow-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=90
          gp-per-action=0
      ==
      :*  id=%burn-teak-logs
          name='Burn Teak Logs'
          level-req=35
          xp=1.050
          base-time=2.000
          inputs=~[[item=%teak-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=105
          gp-per-action=0
      ==
      :*  id=%burn-maple-logs
          name='Burn Maple Logs'
          level-req=45
          xp=1.350
          base-time=2.000
          inputs=~[[item=%maple-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=135
          gp-per-action=0
      ==
      :*  id=%burn-mahogany-logs
          name='Burn Mahogany Logs'
          level-req=55
          xp=1.600
          base-time=2.000
          inputs=~[[item=%mahogany-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=160
          gp-per-action=0
      ==
      :*  id=%burn-yew-logs
          name='Burn Yew Logs'
          level-req=60
          xp=2.025
          base-time=2.000
          inputs=~[[item=%yew-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=203
          gp-per-action=0
      ==
      :*  id=%burn-magic-logs
          name='Burn Magic Logs'
          level-req=75
          xp=3.090
          base-time=2.000
          inputs=~[[item=%magic-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=309
          gp-per-action=0
      ==
      :*  id=%burn-redwood-logs
          name='Burn Redwood Logs'
          level-req=90
          xp=4.050
          base-time=2.000
          inputs=~[[item=%redwood-logs qty=1]]
          outputs=~[[item=%charcoal min-qty=1 max-qty=1 chance=100]]
          mastery-xp=405
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Cooking                                                  │
::  └──────────────────────────────────────────────────────────┘
::
++  cooking-def
  ^-  skill-def
  :*  id=%cooking
      name='Cooking'
      skill-type=%artisan
      max-level=99
      actions=cooking-actions
  ==
::
++  cooking-actions
  ^-  (list action-def)
  :~  :*  id=%cook-shrimp
          name='Cook Shrimp'
          level-req=1
          xp=100
          base-time=2.500
          inputs=~[[item=%raw-shrimp qty=1]]
          outputs=~[[item=%cooked-shrimp min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%cook-sardine
          name='Cook Sardine'
          level-req=5
          xp=200
          base-time=2.500
          inputs=~[[item=%raw-sardine qty=1]]
          outputs=~[[item=%cooked-sardine min-qty=1 max-qty=1 chance=100]]
          mastery-xp=20
          gp-per-action=0
      ==
      :*  id=%cook-herring
          name='Cook Herring'
          level-req=10
          xp=300
          base-time=2.500
          inputs=~[[item=%raw-herring qty=1]]
          outputs=~[[item=%cooked-herring min-qty=1 max-qty=1 chance=100]]
          mastery-xp=30
          gp-per-action=0
      ==
      :*  id=%cook-trout
          name='Cook Trout'
          level-req=20
          xp=500
          base-time=3.000
          inputs=~[[item=%raw-trout qty=1]]
          outputs=~[[item=%cooked-trout min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      :*  id=%cook-salmon
          name='Cook Salmon'
          level-req=30
          xp=700
          base-time=3.000
          inputs=~[[item=%raw-salmon qty=1]]
          outputs=~[[item=%cooked-salmon min-qty=1 max-qty=1 chance=100]]
          mastery-xp=70
          gp-per-action=0
      ==
      :*  id=%cook-lobster
          name='Cook Lobster'
          level-req=40
          xp=900
          base-time=3.500
          inputs=~[[item=%raw-lobster qty=1]]
          outputs=~[[item=%cooked-lobster min-qty=1 max-qty=1 chance=100]]
          mastery-xp=90
          gp-per-action=0
      ==
      :*  id=%cook-swordfish
          name='Cook Swordfish'
          level-req=50
          xp=1.400
          base-time=3.500
          inputs=~[[item=%raw-swordfish qty=1]]
          outputs=~[[item=%cooked-swordfish min-qty=1 max-qty=1 chance=100]]
          mastery-xp=140
          gp-per-action=0
      ==
      :*  id=%cook-crab
          name='Cook Crab'
          level-req=55
          xp=1.600
          base-time=3.500
          inputs=~[[item=%raw-crab qty=1]]
          outputs=~[[item=%cooked-crab min-qty=1 max-qty=1 chance=100]]
          mastery-xp=160
          gp-per-action=0
      ==
      :*  id=%cook-shark
          name='Cook Shark'
          level-req=65
          xp=2.100
          base-time=4.000
          inputs=~[[item=%raw-shark qty=1]]
          outputs=~[[item=%cooked-shark min-qty=1 max-qty=1 chance=100]]
          mastery-xp=210
          gp-per-action=0
      ==
      :*  id=%cook-whale
          name='Cook Whale'
          level-req=80
          xp=3.500
          base-time=4.500
          inputs=~[[item=%raw-whale qty=1]]
          outputs=~[[item=%cooked-whale min-qty=1 max-qty=1 chance=100]]
          mastery-xp=350
          gp-per-action=0
      ==
      :*  id=%cook-anglerfish
          name='Cook Anglerfish'
          level-req=90
          xp=5.000
          base-time=5.000
          inputs=~[[item=%raw-anglerfish qty=1]]
          outputs=~[[item=%cooked-anglerfish min-qty=1 max-qty=1 chance=100]]
          mastery-xp=500
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Smithing                                                 │
::  └──────────────────────────────────────────────────────────┘
::
++  smithing-def
  ^-  skill-def
  :*  id=%smithing
      name='Smithing'
      skill-type=%artisan
      max-level=99
      actions=smithing-actions
  ==
::
++  smithing-actions
  ^-  (list action-def)
  :~  :*  id=%smelt-bronze-bar
          name='Bronze Bar'
          level-req=1
          xp=120
          base-time=3.000
          inputs=~[[item=%copper-ore qty=1] [item=%tin-ore qty=1]]
          outputs=~[[item=%bronze-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=12
          gp-per-action=0
      ==
      :*  id=%smelt-iron-bar
          name='Iron Bar'
          level-req=15
          xp=350
          base-time=3.500
          inputs=~[[item=%iron-ore qty=1] [item=%coal-ore qty=1]]
          outputs=~[[item=%iron-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=35
          gp-per-action=0
      ==
      :*  id=%smelt-silver-bar
          name='Silver Bar'
          level-req=20
          xp=400
          base-time=3.500
          inputs=~[[item=%silver-ore qty=1]]
          outputs=~[[item=%silver-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%smelt-gold-bar
          name='Gold Bar'
          level-req=40
          xp=650
          base-time=3.500
          inputs=~[[item=%gold-ore qty=1]]
          outputs=~[[item=%gold-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=65
          gp-per-action=0
      ==
      :*  id=%smelt-steel-bar
          name='Steel Bar'
          level-req=30
          xp=600
          base-time=4.000
          inputs=~[[item=%iron-ore qty=1] [item=%coal-ore qty=2]]
          outputs=~[[item=%steel-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=60
          gp-per-action=0
      ==
      :*  id=%smelt-mithril-bar
          name='Mithril Bar'
          level-req=50
          xp=1.000
          base-time=4.500
          inputs=~[[item=%mithril-ore qty=1] [item=%coal-ore qty=2]]
          outputs=~[[item=%mithril-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=100
          gp-per-action=0
      ==
      :*  id=%smelt-adamantite-bar
          name='Adamantite Bar'
          level-req=60
          xp=1.500
          base-time=5.000
          inputs=~[[item=%adamantite-ore qty=1] [item=%coal-ore qty=3]]
          outputs=~[[item=%adamantite-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=150
          gp-per-action=0
      ==
      :*  id=%smelt-runite-bar
          name='Runite Bar'
          level-req=70
          xp=2.100
          base-time=5.500
          inputs=~[[item=%runite-ore qty=1] [item=%coal-ore qty=4]]
          outputs=~[[item=%runite-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=210
          gp-per-action=0
      ==
      :*  id=%smelt-dragonite-bar
          name='Dragonite Bar'
          level-req=80
          xp=3.250
          base-time=6.000
          inputs=~[[item=%dragonite-ore qty=1] [item=%coal-ore qty=5]]
          outputs=~[[item=%dragonite-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=325
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Fletching                                               │
::  └──────────────────────────────────────────────────────────┘
::
++  fletching-def
  ^-  skill-def
  :*  id=%fletching
      name='Fletching'
      skill-type=%artisan
      max-level=99
      actions=fletching-actions
  ==
::
++  fletching-actions
  ^-  (list action-def)
  :~  :*  id=%fletch-normal-shortbow
          name='Normal Shortbow'
          level-req=1
          xp=100
          base-time=2.000
          inputs=~[[item=%normal-logs qty=1]]
          outputs=~[[item=%normal-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%fletch-normal-longbow
          name='Normal Longbow'
          level-req=5
          xp=200
          base-time=3.000
          inputs=~[[item=%normal-logs qty=2]]
          outputs=~[[item=%normal-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=20
          gp-per-action=0
      ==
      :*  id=%fletch-oak-shortbow
          name='Oak Shortbow'
          level-req=15
          xp=350
          base-time=2.500
          inputs=~[[item=%oak-logs qty=1]]
          outputs=~[[item=%oak-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=35
          gp-per-action=0
      ==
      :*  id=%fletch-oak-longbow
          name='Oak Longbow'
          level-req=20
          xp=500
          base-time=3.500
          inputs=~[[item=%oak-logs qty=2]]
          outputs=~[[item=%oak-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      :*  id=%fletch-willow-shortbow
          name='Willow Shortbow'
          level-req=30
          xp=650
          base-time=3.000
          inputs=~[[item=%willow-logs qty=1]]
          outputs=~[[item=%willow-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=65
          gp-per-action=0
      ==
      :*  id=%fletch-willow-longbow
          name='Willow Longbow'
          level-req=35
          xp=850
          base-time=4.000
          inputs=~[[item=%willow-logs qty=2]]
          outputs=~[[item=%willow-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=85
          gp-per-action=0
      ==
      :*  id=%fletch-maple-shortbow
          name='Maple Shortbow'
          level-req=45
          xp=1.000
          base-time=3.000
          inputs=~[[item=%maple-logs qty=1]]
          outputs=~[[item=%maple-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=100
          gp-per-action=0
      ==
      :*  id=%fletch-maple-longbow
          name='Maple Longbow'
          level-req=50
          xp=1.350
          base-time=4.000
          inputs=~[[item=%maple-logs qty=2]]
          outputs=~[[item=%maple-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=135
          gp-per-action=0
      ==
      :*  id=%fletch-yew-shortbow
          name='Yew Shortbow'
          level-req=60
          xp=1.600
          base-time=3.500
          inputs=~[[item=%yew-logs qty=1]]
          outputs=~[[item=%yew-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=160
          gp-per-action=0
      ==
      :*  id=%fletch-yew-longbow
          name='Yew Longbow'
          level-req=65
          xp=2.100
          base-time=4.500
          inputs=~[[item=%yew-logs qty=2]]
          outputs=~[[item=%yew-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=210
          gp-per-action=0
      ==
      :*  id=%fletch-magic-shortbow
          name='Magic Shortbow'
          level-req=75
          xp=2.600
          base-time=4.000
          inputs=~[[item=%magic-logs qty=1]]
          outputs=~[[item=%magic-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=260
          gp-per-action=0
      ==
      :*  id=%fletch-magic-longbow
          name='Magic Longbow'
          level-req=80
          xp=3.400
          base-time=5.000
          inputs=~[[item=%magic-logs qty=2]]
          outputs=~[[item=%magic-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=340
          gp-per-action=0
      ==
      :*  id=%fletch-redwood-shortbow
          name='Redwood Shortbow'
          level-req=90
          xp=3.750
          base-time=4.500
          inputs=~[[item=%redwood-logs qty=1]]
          outputs=~[[item=%redwood-shortbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=375
          gp-per-action=0
      ==
      :*  id=%fletch-redwood-longbow
          name='Redwood Longbow'
          level-req=95
          xp=5.000
          base-time=5.500
          inputs=~[[item=%redwood-logs qty=2]]
          outputs=~[[item=%redwood-longbow min-qty=1 max-qty=1 chance=100]]
          mastery-xp=500
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Crafting                                                │
::  └──────────────────────────────────────────────────────────┘
::
++  crafting-def
  ^-  skill-def
  :*  id=%crafting
      name='Crafting'
      skill-type=%artisan
      max-level=99
      actions=crafting-actions
  ==
::
++  crafting-actions
  ^-  (list action-def)
  :~  :*  id=%craft-bronze-helmet
          name='Bronze Helmet'
          level-req=1
          xp=150
          base-time=3.000
          inputs=~[[item=%bronze-bar qty=2]]
          outputs=~[[item=%bronze-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=15
          gp-per-action=0
      ==
      :*  id=%craft-bronze-platebody
          name='Bronze Platebody'
          level-req=5
          xp=300
          base-time=4.000
          inputs=~[[item=%bronze-bar qty=5]]
          outputs=~[[item=%bronze-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=30
          gp-per-action=0
      ==
      :*  id=%craft-iron-helmet
          name='Iron Helmet'
          level-req=15
          xp=400
          base-time=3.500
          inputs=~[[item=%iron-bar qty=2]]
          outputs=~[[item=%iron-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%craft-iron-platebody
          name='Iron Platebody'
          level-req=20
          xp=700
          base-time=4.500
          inputs=~[[item=%iron-bar qty=5]]
          outputs=~[[item=%iron-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=70
          gp-per-action=0
      ==
      :*  id=%craft-steel-helmet
          name='Steel Helmet'
          level-req=30
          xp=700
          base-time=4.000
          inputs=~[[item=%steel-bar qty=2]]
          outputs=~[[item=%steel-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=70
          gp-per-action=0
      ==
      :*  id=%craft-steel-platebody
          name='Steel Platebody'
          level-req=35
          xp=1.200
          base-time=5.000
          inputs=~[[item=%steel-bar qty=5]]
          outputs=~[[item=%steel-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=120
          gp-per-action=0
      ==
      :*  id=%craft-mithril-helmet
          name='Mithril Helmet'
          level-req=45
          xp=1.100
          base-time=4.000
          inputs=~[[item=%mithril-bar qty=2]]
          outputs=~[[item=%mithril-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=110
          gp-per-action=0
      ==
      :*  id=%craft-mithril-platebody
          name='Mithril Platebody'
          level-req=50
          xp=1.800
          base-time=5.000
          inputs=~[[item=%mithril-bar qty=5]]
          outputs=~[[item=%mithril-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=180
          gp-per-action=0
      ==
      :*  id=%craft-adamantite-helmet
          name='Adamantite Helmet'
          level-req=60
          xp=1.700
          base-time=4.500
          inputs=~[[item=%adamantite-bar qty=2]]
          outputs=~[[item=%adamantite-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=170
          gp-per-action=0
      ==
      :*  id=%craft-adamantite-platebody
          name='Adamantite Platebody'
          level-req=65
          xp=2.800
          base-time=5.500
          inputs=~[[item=%adamantite-bar qty=5]]
          outputs=~[[item=%adamantite-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=280
          gp-per-action=0
      ==
      :*  id=%craft-runite-helmet
          name='Runite Helmet'
          level-req=75
          xp=2.500
          base-time=5.000
          inputs=~[[item=%runite-bar qty=2]]
          outputs=~[[item=%runite-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=250
          gp-per-action=0
      ==
      :*  id=%craft-runite-platebody
          name='Runite Platebody'
          level-req=80
          xp=4.000
          base-time=6.000
          inputs=~[[item=%runite-bar qty=5]]
          outputs=~[[item=%runite-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=400
          gp-per-action=0
      ==
      :*  id=%craft-dragonite-helmet
          name='Dragonite Helmet'
          level-req=88
          xp=3.800
          base-time=5.500
          inputs=~[[item=%dragonite-bar qty=2]]
          outputs=~[[item=%dragonite-helmet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=380
          gp-per-action=0
      ==
      :*  id=%craft-dragonite-platebody
          name='Dragonite Platebody'
          level-req=93
          xp=6.000
          base-time=6.500
          inputs=~[[item=%dragonite-bar qty=5]]
          outputs=~[[item=%dragonite-platebody min-qty=1 max-qty=1 chance=100]]
          mastery-xp=600
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Runecrafting                                            │
::  └──────────────────────────────────────────────────────────┘
::
++  runecrafting-def
  ^-  skill-def
  :*  id=%runecrafting
      name='Runecrafting'
      skill-type=%artisan
      max-level=99
      actions=runecrafting-actions
  ==
::
++  runecrafting-actions
  ^-  (list action-def)
  :~  :*  id=%craft-air-rune
          name='Air Rune'
          level-req=1
          xp=50
          base-time=2.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%air-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=5
          gp-per-action=0
      ==
      :*  id=%craft-water-rune
          name='Water Rune'
          level-req=5
          xp=80
          base-time=2.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%water-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=8
          gp-per-action=0
      ==
      :*  id=%craft-earth-rune
          name='Earth Rune'
          level-req=10
          xp=120
          base-time=2.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%earth-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=12
          gp-per-action=0
      ==
      :*  id=%craft-fire-rune
          name='Fire Rune'
          level-req=15
          xp=175
          base-time=2.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%fire-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=18
          gp-per-action=0
      ==
      :*  id=%craft-mind-rune
          name='Mind Rune'
          level-req=25
          xp=300
          base-time=2.500
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%mind-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=30
          gp-per-action=0
      ==
      :*  id=%craft-chaos-rune
          name='Chaos Rune'
          level-req=35
          xp=500
          base-time=3.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%chaos-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      :*  id=%craft-death-rune
          name='Death Rune'
          level-req=50
          xp=850
          base-time=3.500
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%death-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=85
          gp-per-action=0
      ==
      :*  id=%craft-blood-rune
          name='Blood Rune'
          level-req=65
          xp=1.400
          base-time=4.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%blood-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=140
          gp-per-action=0
      ==
      :*  id=%craft-soul-rune
          name='Soul Rune'
          level-req=80
          xp=2.300
          base-time=4.500
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%soul-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=230
          gp-per-action=0
      ==
      :*  id=%craft-ancient-rune
          name='Ancient Rune'
          level-req=95
          xp=4.000
          base-time=5.000
          inputs=~[[item=%rune-essence qty=1]]
          outputs=~[[item=%ancient-rune min-qty=1 max-qty=1 chance=100]]
          mastery-xp=400
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Herblore                                                │
::  └──────────────────────────────────────────────────────────┘
::
++  herblore-def
  ^-  skill-def
  :*  id=%herblore
      name='Herblore'
      skill-type=%artisan
      max-level=99
      actions=herblore-actions
  ==
::
++  herblore-actions
  ^-  (list action-def)
  :~  :*  id=%brew-attack-potion
          name='Attack Potion'
          level-req=1
          xp=100
          base-time=2.500
          inputs=~[[item=%grimy-guam qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%attack-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%brew-strength-potion
          name='Strength Potion'
          level-req=10
          xp=225
          base-time=2.500
          inputs=~[[item=%grimy-marrentill qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%strength-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=23
          gp-per-action=0
      ==
      :*  id=%brew-defence-potion
          name='Defence Potion'
          level-req=20
          xp=400
          base-time=3.000
          inputs=~[[item=%grimy-tarromin qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%defence-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%brew-hitpoints-potion
          name='Hitpoints Potion'
          level-req=35
          xp=700
          base-time=3.000
          inputs=~[[item=%grimy-harralander qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%hitpoints-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=70
          gp-per-action=0
      ==
      :*  id=%brew-prayer-potion
          name='Prayer Potion'
          level-req=45
          xp=1.050
          base-time=3.500
          inputs=~[[item=%grimy-ranarr qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%prayer-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=105
          gp-per-action=0
      ==
      :*  id=%brew-super-attack-potion
          name='Super Attack Potion'
          level-req=55
          xp=1.500
          base-time=3.500
          inputs=~[[item=%grimy-irit qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%super-attack-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=150
          gp-per-action=0
      ==
      :*  id=%brew-super-strength-potion
          name='Super Strength Potion'
          level-req=70
          xp=2.250
          base-time=4.000
          inputs=~[[item=%grimy-kwuarm qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%super-strength-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=225
          gp-per-action=0
      ==
      :*  id=%brew-super-defence-potion
          name='Super Defence Potion'
          level-req=90
          xp=4.000
          base-time=4.500
          inputs=~[[item=%grimy-torstol qty=1] [item=%vial-of-water qty=1]]
          outputs=~[[item=%super-defence-potion min-qty=1 max-qty=1 chance=100]]
          mastery-xp=400
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Farming (passive — uses farm plots, not normal actions) │
::  └──────────────────────────────────────────────────────────┘
::
++  farming-def
  ^-  skill-def
  :*  id=%farming
      name='Farming'
      skill-type=%gathering
      max-level=99
      actions=~
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Agility                                                 │
::  └──────────────────────────────────────────────────────────┘
::
++  agility-def
  ^-  skill-def
  :*  id=%agility
      name='Agility'
      skill-type=%gathering
      max-level=99
      actions=agility-actions
  ==
::
++  agility-actions
  ^-  (list action-def)
  :~  :*  id=%jog-trail
          name='Jog Trail'
          level-req=1
          xp=80
          base-time=3.000
          inputs=~
          outputs=~
          mastery-xp=8
          gp-per-action=0
      ==
      :*  id=%balance-beam
          name='Balance Beam'
          level-req=10
          xp=200
          base-time=3.500
          inputs=~
          outputs=~
          mastery-xp=20
          gp-per-action=0
      ==
      :*  id=%rope-swing
          name='Rope Swing'
          level-req=20
          xp=400
          base-time=4.000
          inputs=~
          outputs=~
          mastery-xp=40
          gp-per-action=0
      ==
      :*  id=%wall-climb
          name='Wall Climb'
          level-req=30
          xp=650
          base-time=4.500
          inputs=~
          outputs=~
          mastery-xp=65
          gp-per-action=0
      ==
      :*  id=%pipe-balance
          name='Pipe Balance'
          level-req=40
          xp=950
          base-time=5.000
          inputs=~
          outputs=~
          mastery-xp=95
          gp-per-action=0
      ==
      :*  id=%rooftop-run
          name='Rooftop Run'
          level-req=50
          xp=1.300
          base-time=5.500
          inputs=~
          outputs=~
          mastery-xp=130
          gp-per-action=0
      ==
      :*  id=%cliff-scramble
          name='Cliff Scramble'
          level-req=60
          xp=1.800
          base-time=6.000
          inputs=~
          outputs=~
          mastery-xp=180
          gp-per-action=0
      ==
      :*  id=%tower-climb
          name='Tower Climb'
          level-req=70
          xp=2.400
          base-time=6.500
          inputs=~
          outputs=~
          mastery-xp=240
          gp-per-action=0
      ==
      :*  id=%canyon-leap
          name='Canyon Leap'
          level-req=80
          xp=3.200
          base-time=7.000
          inputs=~
          outputs=~
          mastery-xp=320
          gp-per-action=0
      ==
      :*  id=%dragon-gauntlet
          name='Dragon Gauntlet'
          level-req=90
          xp=4.500
          base-time=8.000
          inputs=~
          outputs=~
          mastery-xp=450
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Astrology                                               │
::  └──────────────────────────────────────────────────────────┘
::
++  astrology-def
  ^-  skill-def
  :*  id=%astrology
      name='Astrology'
      skill-type=%gathering
      max-level=99
      actions=astrology-actions
  ==
::
++  astrology-actions
  ^-  (list action-def)
  :~  :*  id=%study-deedree
          name='Study Deedree'
          level-req=1
          xp=80
          base-time=4.000
          inputs=~
          outputs=~
          mastery-xp=8
          gp-per-action=0
      ==
      :*  id=%study-iridan
          name='Study Iridan'
          level-req=5
          xp=150
          base-time=4.500
          inputs=~
          outputs=~
          mastery-xp=15
          gp-per-action=0
      ==
      :*  id=%study-ameria
          name='Study Ameria'
          level-req=15
          xp=300
          base-time=5.000
          inputs=~
          outputs=~
          mastery-xp=30
          gp-per-action=0
      ==
      :*  id=%study-ko
          name='Study Ko'
          level-req=20
          xp=450
          base-time=5.000
          inputs=~
          outputs=~
          mastery-xp=45
          gp-per-action=0
      ==
      :*  id=%study-vale
          name='Study Vale'
          level-req=25
          xp=600
          base-time=5.500
          inputs=~
          outputs=~
          mastery-xp=60
          gp-per-action=0
      ==
      :*  id=%study-arach
          name='Study Arach'
          level-req=30
          xp=800
          base-time=5.500
          inputs=~
          outputs=~
          mastery-xp=80
          gp-per-action=0
      ==
      :*  id=%study-hyden
          name='Study Hyden'
          level-req=40
          xp=1.100
          base-time=6.000
          inputs=~
          outputs=~
          mastery-xp=110
          gp-per-action=0
      ==
      :*  id=%study-qimican
          name='Study Qimican'
          level-req=50
          xp=1.500
          base-time=6.500
          inputs=~
          outputs=~
          mastery-xp=150
          gp-per-action=0
      ==
      :*  id=%study-terra
          name='Study Terra'
          level-req=55
          xp=1.700
          base-time=6.500
          inputs=~
          outputs=~
          mastery-xp=170
          gp-per-action=0
      ==
      :*  id=%study-sylvan
          name='Study Sylvan'
          level-req=60
          xp=2.000
          base-time=7.000
          inputs=~
          outputs=~
          mastery-xp=200
          gp-per-action=0
      ==
      :*  id=%study-murtia
          name='Study Murtia'
          level-req=70
          xp=2.600
          base-time=7.500
          inputs=~
          outputs=~
          mastery-xp=260
          gp-per-action=0
      ==
      :*  id=%study-cerberus
          name='Study Cerberus'
          level-req=80
          xp=3.400
          base-time=8.000
          inputs=~
          outputs=~
          mastery-xp=340
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Summoning                                               │
::  └──────────────────────────────────────────────────────────┘
::
++  summoning-def
  ^-  skill-def
  :*  id=%summoning
      name='Summoning'
      skill-type=%artisan
      max-level=99
      actions=summoning-actions
  ==
::
++  summoning-actions
  ^-  (list action-def)
  :~  :*  id=%make-wolf-tablet
          name='Wolf Tablet'
          level-req=1
          xp=100
          base-time=3.000
          inputs=~[[item=%charcoal qty=1] [item=%raw-shrimp qty=5]]
          outputs=~[[item=%wolf-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%make-hawk-tablet
          name='Hawk Tablet'
          level-req=10
          xp=250
          base-time=3.500
          inputs=~[[item=%charcoal qty=1] [item=%iron-ore qty=3]]
          outputs=~[[item=%hawk-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=25
          gp-per-action=0
      ==
      :*  id=%make-bear-tablet
          name='Bear Tablet'
          level-req=20
          xp=500
          base-time=4.000
          inputs=~[[item=%charcoal qty=2] [item=%steel-bar qty=2]]
          outputs=~[[item=%bear-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      :*  id=%make-serpent-tablet
          name='Serpent Tablet'
          level-req=30
          xp=800
          base-time=4.500
          inputs=~[[item=%charcoal qty=2] [item=%grimy-ranarr qty=1]]
          outputs=~[[item=%serpent-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=80
          gp-per-action=0
      ==
      :*  id=%make-phoenix-tablet
          name='Phoenix Tablet'
          level-req=45
          xp=1.200
          base-time=5.000
          inputs=~[[item=%charcoal qty=3] [item=%gold-bar qty=1] [item=%fire-rune qty=1]]
          outputs=~[[item=%phoenix-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=120
          gp-per-action=0
      ==
      :*  id=%make-dragon-tablet
          name='Dragon Tablet'
          level-req=60
          xp=1.800
          base-time=5.500
          inputs=~[[item=%charcoal qty=4] [item=%adamantite-bar qty=1] [item=%death-rune qty=1]]
          outputs=~[[item=%dragon-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=180
          gp-per-action=0
      ==
      :*  id=%make-hydra-tablet
          name='Hydra Tablet'
          level-req=75
          xp=2.800
          base-time=6.000
          inputs=~[[item=%charcoal qty=5] [item=%runite-bar qty=1] [item=%blood-rune qty=1]]
          outputs=~[[item=%hydra-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=280
          gp-per-action=0
      ==
      :*  id=%make-titan-tablet
          name='Titan Tablet'
          level-req=90
          xp=4.500
          base-time=7.000
          inputs=~[[item=%charcoal qty=6] [item=%dragonite-bar qty=1] [item=%soul-rune qty=1]]
          outputs=~[[item=%titan-tablet min-qty=1 max-qty=1 chance=100]]
          mastery-xp=450
          gp-per-action=0
      ==
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Combat Skills (leveled via combat, empty action lists)   │
::  └──────────────────────────────────────────────────────────┘
::
++  attack-def
  ^-  skill-def
  :*  id=%attack
      name='Attack'
      skill-type=%combat
      max-level=99
      actions=~
  ==
::
++  strength-def
  ^-  skill-def
  :*  id=%strength
      name='Strength'
      skill-type=%combat
      max-level=99
      actions=~
  ==
::
++  defence-def
  ^-  skill-def
  :*  id=%defence
      name='Defence'
      skill-type=%combat
      max-level=99
      actions=~
  ==
::
++  hitpoints-def
  ^-  skill-def
  :*  id=%hitpoints
      name='Hitpoints'
      skill-type=%passive
      max-level=99
      actions=~
  ==
::
++  ranged-def
  ^-  skill-def
  :*  id=%ranged
      name='Ranged'
      skill-type=%combat
      max-level=99
      actions=~
  ==
::
++  magic-def
  ^-  skill-def
  :*  id=%magic
      name='Magic'
      skill-type=%combat
      max-level=99
      actions=magic-actions
  ==
::
++  magic-actions
  ^-  (list action-def)
  :~  ::  alchemy — convert items to GP
      :*  id=%alch-gold-bar
          name='Alchemise Gold Bar'
          level-req=21
          xp=80
          base-time=3.000
          inputs=~[[item=%fire-rune qty=5] [item=%mind-rune qty=1] [item=%gold-bar qty=1]]
          outputs=~
          mastery-xp=8
          gp-per-action=225
      ==
      :*  id=%alch-onyx
          name='Alchemise Onyx'
          level-req=40
          xp=150
          base-time=3.000
          inputs=~[[item=%fire-rune qty=5] [item=%death-rune qty=1] [item=%onyx qty=1]]
          outputs=~
          mastery-xp=15
          gp-per-action=2.250
      ==
      :*  id=%alch-dragonite-bar
          name='Alchemise Dragonite Bar'
          level-req=55
          xp=250
          base-time=3.000
          inputs=~[[item=%fire-rune qty=5] [item=%death-rune qty=2] [item=%dragonite-bar qty=1]]
          outputs=~
          mastery-xp=25
          gp-per-action=5.000
      ==
      ::  superheat — smelt with fire runes
      :*  id=%superheat-iron
          name='Superheat Iron'
          level-req=33
          xp=100
          base-time=3.000
          inputs=~[[item=%fire-rune qty=4] [item=%mind-rune qty=1] [item=%iron-ore qty=1]]
          outputs=~[[item=%iron-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=10
          gp-per-action=0
      ==
      :*  id=%superheat-steel
          name='Superheat Steel'
          level-req=43
          xp=180
          base-time=4.000
          inputs=~[[item=%fire-rune qty=6] [item=%chaos-rune qty=1] [item=%iron-ore qty=1]]
          outputs=~[[item=%steel-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=18
          gp-per-action=0
      ==
      :*  id=%superheat-mithril
          name='Superheat Mithril'
          level-req=53
          xp=280
          base-time=5.000
          inputs=~[[item=%fire-rune qty=8] [item=%death-rune qty=1] [item=%mithril-ore qty=1]]
          outputs=~[[item=%mithril-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=28
          gp-per-action=0
      ==
      :*  id=%superheat-runite
          name='Superheat Runite'
          level-req=75
          xp=500
          base-time=6.000
          inputs=~[[item=%fire-rune qty=12] [item=%death-rune qty=2] [item=%runite-ore qty=1]]
          outputs=~[[item=%runite-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=50
          gp-per-action=0
      ==
      ::  enchant — upgrade bars to enchanted versions
      :*  id=%enchant-steel
          name='Enchant Steel Bar'
          level-req=35
          xp=200
          base-time=5.000
          inputs=~[[item=%water-rune qty=5] [item=%earth-rune qty=5] [item=%steel-bar qty=1]]
          outputs=~[[item=%enchanted-steel-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=20
          gp-per-action=0
      ==
      :*  id=%enchant-mithril
          name='Enchant Mithril Bar'
          level-req=50
          xp=300
          base-time=5.000
          inputs=~[[item=%water-rune qty=5] [item=%earth-rune qty=5] [item=%mind-rune qty=2] [item=%mithril-bar qty=1]]
          outputs=~[[item=%enchanted-mithril-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=30
          gp-per-action=0
      ==
      :*  id=%enchant-adamantite
          name='Enchant Adamantite Bar'
          level-req=65
          xp=450
          base-time=6.000
          inputs=~[[item=%water-rune qty=5] [item=%earth-rune qty=5] [item=%chaos-rune qty=3] [item=%adamantite-bar qty=1]]
          outputs=~[[item=%enchanted-adamantite-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=45
          gp-per-action=0
      ==
      :*  id=%enchant-runite
          name='Enchant Runite Bar'
          level-req=80
          xp=650
          base-time=6.000
          inputs=~[[item=%water-rune qty=10] [item=%earth-rune qty=10] [item=%death-rune qty=5] [item=%runite-bar qty=1]]
          outputs=~[[item=%enchanted-runite-bar min-qty=1 max-qty=1 chance=100]]
          mastery-xp=65
          gp-per-action=0
      ==
  ==
::
++  prayer-skill-def
  ^-  skill-def
  :*  id=%prayer
      name='Prayer'
      skill-type=%passive
      max-level=99
      actions=~
  ==
::
++  slayer-skill-def
  ^-  skill-def
  :*  id=%slayer
      name='Slayer'
      skill-type=%combat
      max-level=99
      actions=~
  ==
--
