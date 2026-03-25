::  lib/bide-equipment.hoon — equipment stats registry
::
::  Maps item-ids to their equipment stats (slot, bonuses, requirements)
::
/-  *bide
|%
::
++  equipment-registry
  ^-  (map item-id equipment-stats)
  %-  ~(gas by *(map item-id equipment-stats))
  :~  ::  ┌─────────────────────────────────┐
      ::  │  Melee weapons                   │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-sword
      :*  slot=%weapon
          attack-bonus=4  strength-bonus=5
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 1]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Shields                         │
      ::  └─────────────────────────────────┘
      ::
      :-  %wooden-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=4  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 1]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Shortbows                       │
      ::  └─────────────────────────────────┘
      ::
      :-  %normal-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=6  ranged-strength-bonus=4
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 1]])
      ==
      :-  %oak-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=10  ranged-strength-bonus=7
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 15]])
      ==
      :-  %willow-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=16  ranged-strength-bonus=12
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 30]])
      ==
      :-  %maple-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=24  ranged-strength-bonus=18
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 45]])
      ==
      :-  %yew-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=34  ranged-strength-bonus=26
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 60]])
      ==
      :-  %magic-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=46  ranged-strength-bonus=36
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 75]])
      ==
      :-  %redwood-shortbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=60  ranged-strength-bonus=48
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 90]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Longbows                        │
      ::  └─────────────────────────────────┘
      ::
      :-  %normal-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=8  ranged-strength-bonus=6
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 5]])
      ==
      :-  %oak-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=14  ranged-strength-bonus=10
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 20]])
      ==
      :-  %willow-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=22  ranged-strength-bonus=16
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 35]])
      ==
      :-  %maple-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=32  ranged-strength-bonus=24
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 50]])
      ==
      :-  %yew-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=44  ranged-strength-bonus=34
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 65]])
      ==
      :-  %magic-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=58  ranged-strength-bonus=46
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 80]])
      ==
      :-  %redwood-longbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=74  ranged-strength-bonus=60
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 95]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Helmets                         │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=3  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 1]])
      ==
      :-  %iron-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=6  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 15]])
      ==
      :-  %steel-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=12  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 30]])
      ==
      :-  %mithril-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=18  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 45]])
      ==
      :-  %adamantite-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=28  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 60]])
      ==
      :-  %runite-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=38  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 75]])
      ==
      :-  %dragonite-helmet
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=50  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 88]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Platebodies                     │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=8  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 1]])
      ==
      :-  %iron-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=16  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 20]])
      ==
      :-  %steel-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=28  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 35]])
      ==
      :-  %mithril-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=42  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 50]])
      ==
      :-  %adamantite-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=60  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 65]])
      ==
      :-  %runite-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=82  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 80]])
      ==
      :-  %dragonite-platebody
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=110  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 93]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Daggers                         │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-dagger
      :*  slot=%weapon
          attack-bonus=3  strength-bonus=2
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 1]])
      ==
      :-  %iron-dagger
      :*  slot=%weapon
          attack-bonus=6  strength-bonus=4
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 15]])
      ==
      :-  %steel-dagger
      :*  slot=%weapon
          attack-bonus=10  strength-bonus=7
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 30]])
      ==
      :-  %mithril-dagger
      :*  slot=%weapon
          attack-bonus=16  strength-bonus=12
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 45]])
      ==
      :-  %adamantite-dagger
      :*  slot=%weapon
          attack-bonus=24  strength-bonus=18
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 60]])
      ==
      :-  %runite-dagger
      :*  slot=%weapon
          attack-bonus=34  strength-bonus=26
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 75]])
      ==
      :-  %dragonite-dagger
      :*  slot=%weapon
          attack-bonus=46  strength-bonus=36
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 85]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Swords                          │
      ::  └─────────────────────────────────┘
      ::
      :-  %iron-sword
      :*  slot=%weapon
          attack-bonus=8  strength-bonus=10
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 15]])
      ==
      :-  %steel-sword
      :*  slot=%weapon
          attack-bonus=14  strength-bonus=17
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 30]])
      ==
      :-  %mithril-sword
      :*  slot=%weapon
          attack-bonus=22  strength-bonus=26
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 45]])
      ==
      :-  %adamantite-sword
      :*  slot=%weapon
          attack-bonus=32  strength-bonus=38
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 60]])
      ==
      :-  %runite-sword
      :*  slot=%weapon
          attack-bonus=44  strength-bonus=52
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 75]])
      ==
      :-  %dragonite-sword
      :*  slot=%weapon
          attack-bonus=60  strength-bonus=72
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=2.400
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 85]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Battleaxes                      │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-battleaxe
      :*  slot=%weapon
          attack-bonus=5  strength-bonus=8
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 1]])
      ==
      :-  %iron-battleaxe
      :*  slot=%weapon
          attack-bonus=10  strength-bonus=16
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 15]])
      ==
      :-  %steel-battleaxe
      :*  slot=%weapon
          attack-bonus=18  strength-bonus=28
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 30]])
      ==
      :-  %mithril-battleaxe
      :*  slot=%weapon
          attack-bonus=28  strength-bonus=42
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 45]])
      ==
      :-  %adamantite-battleaxe
      :*  slot=%weapon
          attack-bonus=40  strength-bonus=60
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 60]])
      ==
      :-  %runite-battleaxe
      :*  slot=%weapon
          attack-bonus=56  strength-bonus=82
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 75]])
      ==
      :-  %dragonite-battleaxe
      :*  slot=%weapon
          attack-bonus=76  strength-bonus=110
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.000
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 85]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  2H Swords                       │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-2h-sword
      :*  slot=%weapon
          attack-bonus=6  strength-bonus=10
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 1]])
      ==
      :-  %iron-2h-sword
      :*  slot=%weapon
          attack-bonus=12  strength-bonus=20
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 15]])
      ==
      :-  %steel-2h-sword
      :*  slot=%weapon
          attack-bonus=22  strength-bonus=34
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 30]])
      ==
      :-  %mithril-2h-sword
      :*  slot=%weapon
          attack-bonus=34  strength-bonus=52
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 45]])
      ==
      :-  %adamantite-2h-sword
      :*  slot=%weapon
          attack-bonus=50  strength-bonus=76
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 60]])
      ==
      :-  %runite-2h-sword
      :*  slot=%weapon
          attack-bonus=68  strength-bonus=102
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 75]])
      ==
      :-  %dragonite-2h-sword
      :*  slot=%weapon
          attack-bonus=92  strength-bonus=140
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.600
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 85]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Metal Shields                   │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=6  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 1]])
      ==
      :-  %iron-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=12  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 15]])
      ==
      :-  %steel-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=22  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 30]])
      ==
      :-  %mithril-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=34  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 45]])
      ==
      :-  %adamantite-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=50  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 60]])
      ==
      :-  %runite-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=68  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 75]])
      ==
      :-  %dragonite-shield
      :*  slot=%shield
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=90  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 85]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Crossbows                       │
      ::  └─────────────────────────────────┘
      ::
      :-  %normal-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=7  ranged-strength-bonus=5
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 1]])
      ==
      :-  %oak-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=12  ranged-strength-bonus=9
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 18]])
      ==
      :-  %willow-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=20  ranged-strength-bonus=15
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 33]])
      ==
      :-  %maple-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=30  ranged-strength-bonus=22
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 48]])
      ==
      :-  %yew-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=40  ranged-strength-bonus=31
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 63]])
      ==
      :-  %magic-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=52  ranged-strength-bonus=40
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 78]])
      ==
      :-  %redwood-crossbow
      :*  slot=%weapon
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=66  ranged-strength-bonus=54
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=3.200
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 93]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Leather Armor                   │
      ::  └─────────────────────────────────┘
      ::
      :-  %leather-cowl
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=2  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=2  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 1]])
      ==
      :-  %leather-body
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=4  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=4  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 1]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Dragonhide Armor                │
      ::  └─────────────────────────────────┘
      ::
      :-  %green-dhide-coif
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=8  ranged-strength-bonus=2
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=12  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 40]])
      ==
      :-  %green-dhide-body
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=14  ranged-strength-bonus=4
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=22  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 43]])
      ==
      :-  %blue-dhide-coif
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=12  ranged-strength-bonus=4
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=18  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 50]])
      ==
      :-  %blue-dhide-body
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=20  ranged-strength-bonus=8
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=32  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 53]])
      ==
      :-  %red-dhide-coif
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=16  ranged-strength-bonus=6
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=24  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 60]])
      ==
      :-  %red-dhide-body
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=28  ranged-strength-bonus=12
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=42  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 63]])
      ==
      :-  %black-dhide-coif
      :*  slot=%helmet
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=22  ranged-strength-bonus=8
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=32  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 73]])
      ==
      :-  %black-dhide-body
      :*  slot=%platebody
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=38  ranged-strength-bonus=16
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=56  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 77]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Skill Capes                     │
      ::  └─────────────────────────────────┘
      ::
      :-  %woodcutting-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%woodcutting 99]])
      ==
      :-  %fishing-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%fishing 99]])
      ==
      :-  %mining-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%mining 99]])
      ==
      :-  %thieving-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%thieving 99]])
      ==
      :-  %firemaking-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%firemaking 99]])
      ==
      :-  %cooking-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%cooking 99]])
      ==
      :-  %smithing-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%smithing 99]])
      ==
      :-  %fletching-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%fletching 99]])
      ==
      :-  %crafting-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%crafting 99]])
      ==
      :-  %runecrafting-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%runecrafting 99]])
      ==
      :-  %herblore-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%herblore 99]])
      ==
      :-  %farming-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%farming 99]])
      ==
      :-  %agility-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%agility 99]])
      ==
      :-  %astrology-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%astrology 99]])
      ==
      :-  %summoning-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%summoning 99]])
      ==
      :-  %attack-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%attack 99]])
      ==
      :-  %strength-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%strength 99]])
      ==
      :-  %defence-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%defence 99]])
      ==
      :-  %hitpoints-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%hitpoints 99]])
      ==
      :-  %ranged-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 99]])
      ==
      :-  %magic-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%magic 99]])
      ==
      :-  %prayer-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%prayer 99]])
      ==
      :-  %slayer-cape
      :*  slot=%cape
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=0
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%slayer 99]])
      ==
      ::  ┌─────────────────────────────────┐
      ::  │  Ammo (arrows)                   │
      ::  └─────────────────────────────────┘
      ::
      :-  %bronze-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=2
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 1]])
      ==
      :-  %iron-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=5
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 15]])
      ==
      :-  %steel-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=8
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 30]])
      ==
      :-  %mithril-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=12
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 45]])
      ==
      :-  %adamantite-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=18
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 55]])
      ==
      :-  %runite-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=25
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 70]])
      ==
      :-  %dragonite-arrows
      :*  slot=%ammo
          attack-bonus=0  strength-bonus=0
          ranged-attack-bonus=0  ranged-strength-bonus=35
          magic-attack-bonus=0  magic-strength-bonus=0
          defence-bonus=0  attack-speed=0
          ^-  (map skill-id @ud)
          (~(gas by *(map skill-id @ud)) ~[[%ranged 85]])
      ==
  ==
--
