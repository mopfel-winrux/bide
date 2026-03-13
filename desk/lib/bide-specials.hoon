::  lib/bide-specials.hoon — special attack definitions
::
/-  *bide
|%
::
++  special-registry
  ^-  (map item-id special-attack-def)
  %-  ~(gas by *(map item-id special-attack-def))
  :~  [%maple-shortbow [name='Quick Shot' energy-cost=25 damage-mult=115 accuracy-mult=115]]
      [%yew-longbow [name='Power Shot' energy-cost=50 damage-mult=150 accuracy-mult=90]]
      [%magic-shortbow [name='Rapid Fire' energy-cost=50 damage-mult=130 accuracy-mult=120]]
      [%redwood-longbow [name='Annihilate' energy-cost=100 damage-mult=200 accuracy-mult=80]]
  ==
--
