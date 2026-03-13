::  lib/bide-monsters.hoon — monster definitions
::
::  13 monsters from chicken (25 HP) to dragon (1200 HP)
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
          hitpoints=25
          max-hit=1
          attack-level=1
          strength-level=1
          defence-level=1
          attack-speed=3.000
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%bones min-qty=1 max-qty=1 chance=100]
              [item=%raw-shrimp min-qty=1 max-qty=1 chance=40]
              [item=%leather min-qty=1 max-qty=1 chance=80]
          ==
          gp-min=1
          gp-max=5
          combat-xp=100
          slayer-req=0
      ==
      :-  %goblin
      :*  id=%goblin
          name='Goblin'
          hitpoints=40
          max-hit=2
          attack-level=3
          strength-level=3
          defence-level=3
          attack-speed=3.000
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%bones min-qty=1 max-qty=1 chance=100]
              [item=%copper-ore min-qty=1 max-qty=1 chance=30]
              [item=%tin-ore min-qty=1 max-qty=1 chance=30]
              [item=%leather min-qty=1 max-qty=1 chance=50]
          ==
          gp-min=5
          gp-max=15
          combat-xp=160
          slayer-req=0
      ==
      :-  %rat
      :*  id=%rat
          name='Giant Rat'
          hitpoints=60
          max-hit=4
          attack-level=6
          strength-level=5
          defence-level=4
          attack-speed=2.800
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%bones min-qty=1 max-qty=1 chance=100]
              [item=%raw-sardine min-qty=1 max-qty=1 chance=35]
              [item=%leather min-qty=1 max-qty=1 chance=30]
          ==
          gp-min=8
          gp-max=25
          combat-xp=240
          slayer-req=0
      ==
      :-  %zombie
      :*  id=%zombie
          name='Zombie'
          hitpoints=100
          max-hit=6
          attack-level=10
          strength-level=8
          defence-level=7
          attack-speed=3.200
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%bones min-qty=1 max-qty=1 chance=100]
              [item=%iron-ore min-qty=1 max-qty=1 chance=25]
              [item=%raw-herring min-qty=1 max-qty=1 chance=30]
              [item=%topaz min-qty=1 max-qty=1 chance=5]
          ==
          gp-min=15
          gp-max=50
          combat-xp=400
          slayer-req=0
      ==
      :-  %skeleton
      :*  id=%skeleton
          name='Skeleton'
          hitpoints=150
          max-hit=10
          attack-level=18
          strength-level=15
          defence-level=12
          attack-speed=3.000
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%bones min-qty=1 max-qty=1 chance=100]
              [item=%coal-ore min-qty=1 max-qty=2 chance=30]
              [item=%iron-ore min-qty=1 max-qty=1 chance=25]
              [item=%topaz min-qty=1 max-qty=1 chance=5]
              [item=%sapphire min-qty=1 max-qty=1 chance=3]
          ==
          gp-min=25
          gp-max=80
          combat-xp=600
          slayer-req=0
      ==
      :-  %giant-spider
      :*  id=%giant-spider
          name='Giant Spider'
          hitpoints=200
          max-hit=14
          attack-level=25
          strength-level=20
          defence-level=18
          attack-speed=2.600
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%big-bones min-qty=1 max-qty=1 chance=100]
              [item=%raw-lobster min-qty=1 max-qty=1 chance=25]
              [item=%silver-ore min-qty=1 max-qty=1 chance=20]
              [item=%sapphire min-qty=1 max-qty=1 chance=5]
              [item=%green-dhide min-qty=1 max-qty=1 chance=10]
          ==
          gp-min=35
          gp-max=120
          combat-xp=800
          slayer-req=0
      ==
      :-  %bandit
      :*  id=%bandit
          name='Bandit'
          hitpoints=300
          max-hit=18
          attack-level=35
          strength-level=30
          defence-level=25
          attack-speed=2.800
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%big-bones min-qty=1 max-qty=1 chance=100]
              [item=%gold-ore min-qty=1 max-qty=1 chance=20]
              [item=%raw-swordfish min-qty=1 max-qty=1 chance=25]
              [item=%ruby min-qty=1 max-qty=1 chance=5]
              [item=%green-dhide min-qty=1 max-qty=1 chance=15]
          ==
          gp-min=50
          gp-max=175
          combat-xp=1.200
          slayer-req=0
      ==
      :-  %dark-knight
      :*  id=%dark-knight
          name='Dark Knight'
          hitpoints=450
          max-hit=26
          attack-level=45
          strength-level=40
          defence-level=38
          attack-speed=3.000
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%big-bones min-qty=1 max-qty=1 chance=100]
              [item=%mithril-ore min-qty=1 max-qty=2 chance=25]
              [item=%raw-shark min-qty=1 max-qty=1 chance=20]
              [item=%ruby min-qty=1 max-qty=1 chance=5]
              [item=%blue-dhide min-qty=1 max-qty=1 chance=10]
          ==
          gp-min=80
          gp-max=250
          combat-xp=1.800
          slayer-req=0
      ==
      :-  %cave-troll
      :*  id=%cave-troll
          name='Cave Troll'
          hitpoints=600
          max-hit=34
          attack-level=55
          strength-level=50
          defence-level=45
          attack-speed=3.400
          attack-style=%melee-strength
          ^-  (list loot-entry)
          :~  [item=%big-bones min-qty=1 max-qty=1 chance=100]
              [item=%adamantite-ore min-qty=1 max-qty=2 chance=20]
              [item=%raw-shark min-qty=1 max-qty=2 chance=25]
              [item=%emerald min-qty=1 max-qty=1 chance=5]
              [item=%blue-dhide min-qty=1 max-qty=1 chance=15]
          ==
          gp-min=120
          gp-max=400
          combat-xp=2.400
          slayer-req=0
      ==
      :-  %ogre
      :*  id=%ogre
          name='Ogre'
          hitpoints=750
          max-hit=42
          attack-level=65
          strength-level=60
          defence-level=55
          attack-speed=3.600
          attack-style=%melee-strength
          ^-  (list loot-entry)
          :~  [item=%dragon-bones min-qty=1 max-qty=1 chance=100]
              [item=%runite-ore min-qty=1 max-qty=1 chance=15]
              [item=%raw-whale min-qty=1 max-qty=1 chance=20]
              [item=%emerald min-qty=1 max-qty=1 chance=3]
              [item=%red-dhide min-qty=1 max-qty=1 chance=10]
          ==
          gp-min=175
          gp-max=600
          combat-xp=3.000
          slayer-req=0
      ==
      :-  %demon
      :*  id=%demon
          name='Demon'
          hitpoints=900
          max-hit=50
          attack-level=75
          strength-level=70
          defence-level=65
          attack-speed=3.000
          attack-style=%magic
          ^-  (list loot-entry)
          :~  [item=%dragon-bones min-qty=1 max-qty=1 chance=100]
              [item=%dragonite-ore min-qty=1 max-qty=1 chance=15]
              [item=%raw-anglerfish min-qty=1 max-qty=1 chance=20]
              [item=%diamond min-qty=1 max-qty=1 chance=3]
              [item=%red-dhide min-qty=1 max-qty=1 chance=15]
          ==
          gp-min=250
          gp-max=850
          combat-xp=3.600
          slayer-req=0
      ==
      :-  %fire-giant
      :*  id=%fire-giant
          name='Fire Giant'
          hitpoints=1.050
          max-hit=58
          attack-level=82
          strength-level=80
          defence-level=75
          attack-speed=3.400
          attack-style=%melee-strength
          ^-  (list loot-entry)
          :~  [item=%dragon-bones min-qty=1 max-qty=1 chance=100]
              [item=%dragonite-ore min-qty=1 max-qty=2 chance=18]
              [item=%onyx min-qty=1 max-qty=1 chance=5]
              [item=%diamond min-qty=1 max-qty=1 chance=5]
              [item=%black-dhide min-qty=1 max-qty=1 chance=8]
          ==
          gp-min=350
          gp-max=1.100
          combat-xp=4.200
          slayer-req=0
      ==
      :-  %dragon
      :*  id=%dragon
          name='Dragon'
          hitpoints=1.200
          max-hit=72
          attack-level=90
          strength-level=88
          defence-level=85
          attack-speed=3.200
          attack-style=%melee-attack
          ^-  (list loot-entry)
          :~  [item=%dragon-bones min-qty=1 max-qty=1 chance=100]
              [item=%dragonite-ore min-qty=2 max-qty=4 chance=25]
              [item=%onyx min-qty=1 max-qty=1 chance=10]
              [item=%raw-anglerfish min-qty=1 max-qty=3 chance=30]
              [item=%diamond min-qty=1 max-qty=1 chance=8]
              [item=%black-dhide min-qty=1 max-qty=1 chance=15]
          ==
          gp-min=500
          gp-max=1.500
          combat-xp=4.800
          slayer-req=0
      ==
  ==
--
