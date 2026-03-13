::  lib/bide-potions.hoon — potion effect registry
::
::  Maps potion item-ids to their effect definitions.
::  Used by combat engine for boost application.
::
/-  *bide
|%
::
+$  potion-effect-type
  $?  %attack-boost
      %strength-boost
      %defence-boost
      %heal
      %prayer-restore
  ==
::
+$  potion-def
  $:  effect-type=potion-effect-type
      magnitude=@ud                            ::  pct for boosts, hp for heal
      duration=@ud                             ::  player attacks (0 = instant)
  ==
::
++  potion-registry
  ^-  (map item-id potion-def)
  %-  ~(gas by *(map item-id potion-def))
  :~  [%attack-potion [%attack-boost 10 50]]
      [%strength-potion [%strength-boost 10 50]]
      [%defence-potion [%defence-boost 10 50]]
      [%hitpoints-potion [%heal 150 0]]
      [%prayer-potion [%prayer-restore 30 0]]
      [%super-attack-potion [%attack-boost 15 50]]
      [%super-strength-potion [%strength-boost 15 50]]
      [%super-defence-potion [%defence-boost 15 50]]
  ==
::
::  Compute max boost percentages from active potion list
::
++  compute-boosts
  |=  potions=(list potion-effect)
  ^-  [atk-boost=@ud str-boost=@ud def-boost=@ud]
  =/  atk=@ud  0
  =/  str=@ud  0
  =/  def=@ud  0
  |-
  ?~  potions  [atk str def]
  =/  pdef=(unit potion-def)  (~(get by potion-registry) item.i.potions)
  ?~  pdef  $(potions t.potions)
  ?-  effect-type.u.pdef
    %attack-boost    $(potions t.potions, atk (max atk magnitude.u.pdef))
    %strength-boost  $(potions t.potions, str (max str magnitude.u.pdef))
    %defence-boost   $(potions t.potions, def (max def magnitude.u.pdef))
    %heal            $(potions t.potions)
    %prayer-restore  $(potions t.potions)
  ==
::
::  Decrement turns on all active potions, remove expired
::
++  tick-potions
  |=  potions=(list potion-effect)
  ^-  (list potion-effect)
  %+  murn  potions
  |=  pe=potion-effect
  =/  new-turns=@ud  (dec turns-left.pe)
  ?:(=(new-turns 0) ~ `pe(turns-left new-turns))
--
