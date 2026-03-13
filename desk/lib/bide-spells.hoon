::  lib/bide-spells.hoon — combat spell definitions
::
/-  *bide
|%
++  spell-registry
  ^-  (map spell-id spell-def)
  %-  malt  ^-  (list [spell-id spell-def])
  :~  ::  Strike spells (beginner)
      ::
      :-  %wind-strike
      [name='Wind Strike' level-req=1 max-hit=2 runes=~[[item=%air-rune qty=2] [item=%mind-rune qty=1]]]
      ::
      :-  %water-strike
      [name='Water Strike' level-req=5 max-hit=4 runes=~[[item=%water-rune qty=2] [item=%air-rune qty=2] [item=%mind-rune qty=1]]]
      ::
      :-  %earth-strike
      [name='Earth Strike' level-req=9 max-hit=6 runes=~[[item=%earth-rune qty=2] [item=%air-rune qty=2] [item=%mind-rune qty=1]]]
      ::
      :-  %fire-strike
      [name='Fire Strike' level-req=13 max-hit=8 runes=~[[item=%fire-rune qty=3] [item=%air-rune qty=2] [item=%mind-rune qty=1]]]
      ::  Bolt spells (intermediate)
      ::
      :-  %air-bolt
      [name='Air Bolt' level-req=17 max-hit=10 runes=~[[item=%air-rune qty=3] [item=%chaos-rune qty=1]]]
      ::
      :-  %water-bolt
      [name='Water Bolt' level-req=23 max-hit=13 runes=~[[item=%water-rune qty=3] [item=%air-rune qty=2] [item=%chaos-rune qty=1]]]
      ::
      :-  %earth-bolt
      [name='Earth Bolt' level-req=29 max-hit=16 runes=~[[item=%earth-rune qty=3] [item=%air-rune qty=2] [item=%chaos-rune qty=1]]]
      ::
      :-  %fire-bolt
      [name='Fire Bolt' level-req=35 max-hit=19 runes=~[[item=%fire-rune qty=4] [item=%air-rune qty=3] [item=%chaos-rune qty=1]]]
      ::  Blast spells (advanced)
      ::
      :-  %air-blast
      [name='Air Blast' level-req=41 max-hit=22 runes=~[[item=%air-rune qty=4] [item=%death-rune qty=1]]]
      ::
      :-  %fire-blast
      [name='Fire Blast' level-req=59 max-hit=28 runes=~[[item=%fire-rune qty=5] [item=%air-rune qty=4] [item=%death-rune qty=1]]]
      ::  Surge spells (expert)
      ::
      :-  %air-surge
      [name='Air Surge' level-req=75 max-hit=36 runes=~[[item=%air-rune qty=7] [item=%blood-rune qty=1]]]
      ::
      :-  %fire-surge
      [name='Fire Surge' level-req=90 max-hit=46 runes=~[[item=%fire-rune qty=10] [item=%air-rune qty=7] [item=%blood-rune qty=1]]]
  ==
--
