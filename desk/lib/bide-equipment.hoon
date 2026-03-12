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
  ==
--
