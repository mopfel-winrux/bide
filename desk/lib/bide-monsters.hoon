::  lib/bide-monsters.hoon — monster definitions
::
::  13 monsters from chicken (30 HP) to dragon (1500 HP)
::
/-  *bide
|%
::
++  monster-registry
  ^-  (map monster-id monster-def)
  %-  ~(gas by *(map monster-id monster-def))
  :~  :-  %chicken
      :*  id=%chicken
          name='Chicken'
          hitpoints=30
          max-hit=1
          attack-level=1
          strength-level=1
          defence-level=1
          attack-speed=3.000
          attack-style=%melee-attack
          loot-table=~[[item=%raw-shrimp min-qty=1 max-qty=1 chance=40]]
          gp-min=1
          gp-max=5
          combat-xp=40
          slayer-req=0
      ==
      :-  %goblin
      :*  id=%goblin
          name='Goblin'
          hitpoints=50
          max-hit=3
          attack-level=3
          strength-level=3
          defence-level=3
          attack-speed=3.000
          attack-style=%melee-attack
          loot-table=~[[item=%copper-ore min-qty=1 max-qty=1 chance=30] [item=%tin-ore min-qty=1 max-qty=1 chance=30]]
          gp-min=3
          gp-max=12
          combat-xp=80
          slayer-req=0
      ==
      :-  %rat
      :*  id=%rat
          name='Giant Rat'
          hitpoints=80
          max-hit=5
          attack-level=6
          strength-level=5
          defence-level=4
          attack-speed=2.800
          attack-style=%melee-attack
          loot-table=~[[item=%raw-sardine min-qty=1 max-qty=1 chance=35]]
          gp-min=5
          gp-max=20
          combat-xp=120
          slayer-req=0
      ==
      :-  %zombie
      :*  id=%zombie
          name='Zombie'
          hitpoints=120
          max-hit=8
          attack-level=10
          strength-level=8
          defence-level=7
          attack-speed=3.200
          attack-style=%melee-attack
          loot-table=~[[item=%iron-ore min-qty=1 max-qty=1 chance=25] [item=%raw-herring min-qty=1 max-qty=1 chance=30]]
          gp-min=10
          gp-max=35
          combat-xp=200
          slayer-req=0
      ==
      :-  %skeleton
      :*  id=%skeleton
          name='Skeleton'
          hitpoints=180
          max-hit=12
          attack-level=18
          strength-level=15
          defence-level=12
          attack-speed=3.000
          attack-style=%melee-attack
          loot-table=~[[item=%coal-ore min-qty=1 max-qty=2 chance=30] [item=%iron-ore min-qty=1 max-qty=1 chance=25]]
          gp-min=15
          gp-max=50
          combat-xp=350
          slayer-req=0
      ==
      :-  %giant-spider
      :*  id=%giant-spider
          name='Giant Spider'
          hitpoints=250
          max-hit=16
          attack-level=25
          strength-level=20
          defence-level=18
          attack-speed=2.600
          attack-style=%melee-attack
          loot-table=~[[item=%raw-lobster min-qty=1 max-qty=1 chance=25] [item=%silver-ore min-qty=1 max-qty=1 chance=20]]
          gp-min=20
          gp-max=70
          combat-xp=500
          slayer-req=0
      ==
      :-  %bandit
      :*  id=%bandit
          name='Bandit'
          hitpoints=350
          max-hit=22
          attack-level=35
          strength-level=30
          defence-level=25
          attack-speed=2.800
          attack-style=%melee-attack
          loot-table=~[[item=%gold-ore min-qty=1 max-qty=1 chance=20] [item=%raw-swordfish min-qty=1 max-qty=1 chance=25]]
          gp-min=30
          gp-max=100
          combat-xp=700
          slayer-req=0
      ==
      :-  %dark-knight
      :*  id=%dark-knight
          name='Dark Knight'
          hitpoints=500
          max-hit=30
          attack-level=45
          strength-level=40
          defence-level=38
          attack-speed=3.000
          attack-style=%melee-attack
          loot-table=~[[item=%mithril-ore min-qty=1 max-qty=2 chance=25] [item=%raw-shark min-qty=1 max-qty=1 chance=20]]
          gp-min=50
          gp-max=150
          combat-xp=1.000
          slayer-req=0
      ==
      :-  %cave-troll
      :*  id=%cave-troll
          name='Cave Troll'
          hitpoints=700
          max-hit=40
          attack-level=55
          strength-level=50
          defence-level=45
          attack-speed=3.400
          attack-style=%melee-strength
          loot-table=~[[item=%adamantite-ore min-qty=1 max-qty=2 chance=20] [item=%raw-shark min-qty=1 max-qty=2 chance=25]]
          gp-min=80
          gp-max=250
          combat-xp=1.500
          slayer-req=0
      ==
      :-  %ogre
      :*  id=%ogre
          name='Ogre'
          hitpoints=900
          max-hit=50
          attack-level=65
          strength-level=60
          defence-level=55
          attack-speed=3.600
          attack-style=%melee-strength
          loot-table=~[[item=%runite-ore min-qty=1 max-qty=1 chance=15] [item=%raw-whale min-qty=1 max-qty=1 chance=20]]
          gp-min=120
          gp-max=400
          combat-xp=2.000
          slayer-req=0
      ==
      :-  %demon
      :*  id=%demon
          name='Demon'
          hitpoints=1.100
          max-hit=60
          attack-level=75
          strength-level=70
          defence-level=65
          attack-speed=3.000
          attack-style=%magic
          loot-table=~[[item=%dragonite-ore min-qty=1 max-qty=1 chance=15] [item=%raw-anglerfish min-qty=1 max-qty=1 chance=20]]
          gp-min=180
          gp-max=600
          combat-xp=2.800
          slayer-req=0
      ==
      :-  %fire-giant
      :*  id=%fire-giant
          name='Fire Giant'
          hitpoints=1.300
          max-hit=70
          attack-level=82
          strength-level=80
          defence-level=75
          attack-speed=3.400
          attack-style=%melee-strength
          loot-table=~[[item=%dragonite-ore min-qty=1 max-qty=2 chance=18] [item=%onyx min-qty=1 max-qty=1 chance=5]]
          gp-min=250
          gp-max=800
          combat-xp=3.500
          slayer-req=0
      ==
      :-  %dragon
      :*  id=%dragon
          name='Dragon'
          hitpoints=1.500
          max-hit=85
          attack-level=90
          strength-level=88
          defence-level=85
          attack-speed=3.200
          attack-style=%melee-attack
          loot-table=~[[item=%dragonite-ore min-qty=2 max-qty=4 chance=25] [item=%onyx min-qty=1 max-qty=1 chance=10] [item=%raw-anglerfish min-qty=1 max-qty=3 chance=30]]
          gp-min=400
          gp-max=1.200
          combat-xp=5.000
          slayer-req=0
      ==
  ==
--
