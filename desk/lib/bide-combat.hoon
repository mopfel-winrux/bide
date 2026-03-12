::  lib/bide-combat.hoon — pure combat math functions
::
::  PRNG, accuracy, damage, loot rolling. No side effects.
::
/-  *bide
/+  bide-equipment
|%
::
::  ┌─────────────────────────────────┐
::  │  PRNG — xorshift128+            │
::  └─────────────────────────────────┘
::
++  rng-next
  |=  seed=@uvJ
  ^-  [@ud @uvJ]
  =/  s0=@  (end [0 64] seed)
  =/  s1=@  (end [0 64] (rsh [0 64] seed))
  =/  s1  (mix s1 (lsh [0 23] s1))
  =/  s1  (end [0 64] s1)
  =/  s1  (mix s1 (rsh [0 17] s1))
  =/  s1  (end [0 64] s1)
  =/  s1  (mix s1 s0)
  =/  s1  (end [0 64] s1)
  =/  s1  (mix s1 (rsh [0 26] s0))
  =/  s1  (end [0 64] s1)
  =/  result=@  (end [0 64] (add s0 s1))
  =/  new-seed=@uvJ  (con (lsh [0 64] s1) s0)
  [result new-seed]
::
++  rng-range
  |=  [seed=@uvJ min=@ud max=@ud]
  ^-  [@ud @uvJ]
  ?:  (gte min max)  [min seed]
  =^  raw  seed  (rng-next seed)
  =/  range=@ud  (add 1 (sub max min))
  [(add min (mod raw range)) seed]
::
::  ┌─────────────────────────────────┐
::  │  Equipment bonus totals          │
::  └─────────────────────────────────┘
::
++  total-equipment-bonuses
  |=  slots=(map equipment-slot item-id)
  ^-  [atk=@ud str=@ud ratk=@ud rstr=@ud matk=@ud mstr=@ud def=@ud]
  =/  reg  equipment-registry:bide-equipment
  =/  items=(list [s=equipment-slot iid=item-id])  ~(tap by slots)
  =/  atk=@ud  0
  =/  str=@ud  0
  =/  ratk=@ud  0
  =/  rstr=@ud  0
  =/  matk=@ud  0
  =/  mstr=@ud  0
  =/  def=@ud  0
  |-
  ?~  items  [atk str ratk rstr matk mstr def]
  =/  stats=(unit equipment-stats)  (~(get by reg) iid.i.items)
  ?~  stats  $(items t.items)
  =.  atk  (add atk attack-bonus.u.stats)
  =.  str  (add str strength-bonus.u.stats)
  =.  ratk  (add ratk ranged-attack-bonus.u.stats)
  =.  rstr  (add rstr ranged-strength-bonus.u.stats)
  =.  matk  (add matk magic-attack-bonus.u.stats)
  =.  mstr  (add mstr magic-strength-bonus.u.stats)
  =.  def  (add def defence-bonus.u.stats)
  $(items t.items)
::
::  ┌─────────────────────────────────┐
::  │  Effective levels                │
::  └─────────────────────────────────┘
::
++  effective-attack-level
  |=  [skills=(map skill-id skill-state) style=combat-style]
  ^-  @ud
  =/  base=@ud
    ?-  style
      %melee-attack    (fall (bind (~(get by skills) %attack) |=(s=skill-state level.s)) 1)
      %melee-strength  (fall (bind (~(get by skills) %attack) |=(s=skill-state level.s)) 1)
      %melee-defence   (fall (bind (~(get by skills) %attack) |=(s=skill-state level.s)) 1)
      %ranged          (fall (bind (~(get by skills) %ranged) |=(s=skill-state level.s)) 1)
      %magic           (fall (bind (~(get by skills) %magic) |=(s=skill-state level.s)) 1)
    ==
  ?:  =(style %melee-attack)  (add base 3)
  base
::
++  effective-strength-level
  |=  [skills=(map skill-id skill-state) style=combat-style]
  ^-  @ud
  =/  base=@ud
    ?-  style
      %melee-attack    (fall (bind (~(get by skills) %strength) |=(s=skill-state level.s)) 1)
      %melee-strength  (fall (bind (~(get by skills) %strength) |=(s=skill-state level.s)) 1)
      %melee-defence   (fall (bind (~(get by skills) %strength) |=(s=skill-state level.s)) 1)
      %ranged          (fall (bind (~(get by skills) %ranged) |=(s=skill-state level.s)) 1)
      %magic           (fall (bind (~(get by skills) %magic) |=(s=skill-state level.s)) 1)
    ==
  ?:  =(style %melee-strength)  (add base 3)
  base
::
++  effective-defence-level
  |=  [skills=(map skill-id skill-state) style=combat-style]
  ^-  @ud
  =/  base=@ud
    ?-  style
      %melee-attack    (fall (bind (~(get by skills) %defence) |=(s=skill-state level.s)) 1)
      %melee-strength  (fall (bind (~(get by skills) %defence) |=(s=skill-state level.s)) 1)
      %melee-defence   (fall (bind (~(get by skills) %defence) |=(s=skill-state level.s)) 1)
      %ranged          (fall (bind (~(get by skills) %defence) |=(s=skill-state level.s)) 1)
      %magic           (fall (bind (~(get by skills) %magic) |=(s=skill-state level.s)) 1)
    ==
  ?:  =(style %melee-defence)  (add base 3)
  base
::
::  ┌─────────────────────────────────┐
::  │  Damage & accuracy               │
::  └─────────────────────────────────┘
::
++  calc-max-hit
  |=  [eff-str=@ud str-bonus=@ud]
  ^-  @ud
  (div (add (mul (add eff-str 8) (add str-bonus 64)) 320) 640)
::
++  calc-attack-roll
  |=  [eff-atk=@ud atk-bonus=@ud]
  ^-  @ud
  (mul (add eff-atk 8) (add atk-bonus 64))
::
++  calc-defence-roll
  |=  [eff-def=@ud def-bonus=@ud]
  ^-  @ud
  (mul (add eff-def 8) (add def-bonus 64))
::
++  calc-accuracy
  |=  [atk-roll=@ud def-roll=@ud]
  ^-  @ud  ::  basis points 0-10.000
  ?:  (gth atk-roll def-roll)
    (sub 10.000 (div (mul 5.000 def-roll) atk-roll))
  ?:  =(atk-roll 0)  0
  (div (mul 5.000 atk-roll) def-roll)
::
++  roll-hit
  |=  [seed=@uvJ accuracy=@ud]
  ^-  [hit=? new-seed=@uvJ]
  =^  roll  seed  (rng-range seed 0 9.999)
  [(lth roll accuracy) seed]
::
++  roll-damage
  |=  [seed=@uvJ max-hit=@ud]
  ^-  [dmg=@ud new-seed=@uvJ]
  ?:  =(max-hit 0)  [0 seed]
  (rng-range seed 0 max-hit)
::
::  ┌─────────────────────────────────┐
::  │  Full attack computations        │
::  └─────────────────────────────────┘
::
++  player-attack
  |=  [seed=@uvJ skills=(map skill-id skill-state) slots=(map equipment-slot item-id) style=combat-style enemy-def-level=@ud]
  ^-  [dmg=@ud new-seed=@uvJ]
  =/  bonuses  (total-equipment-bonuses slots)
  =/  eff-atk=@ud  (effective-attack-level skills style)
  =/  eff-str=@ud  (effective-strength-level skills style)
  =/  atk-bonus=@ud
    ?-  style
      %ranged  ratk.bonuses
      %magic   matk.bonuses
      ?(%melee-attack %melee-strength %melee-defence)  atk.bonuses
    ==
  =/  str-bonus=@ud
    ?-  style
      %ranged  rstr.bonuses
      %magic   mstr.bonuses
      ?(%melee-attack %melee-strength %melee-defence)  str.bonuses
    ==
  =/  max-hit=@ud  (calc-max-hit eff-str str-bonus)
  ::  unarmed kick: guarantee min max-hit of 2
  =/  has-weapon=?  (~(has by slots) %weapon)
  =?  max-hit  ?&  !has-weapon
                   ?=(?(%melee-attack %melee-strength %melee-defence) style)
                   (lth max-hit 2)
               ==
    2
  =/  atk-roll=@ud  (calc-attack-roll eff-atk atk-bonus)
  =/  def-roll=@ud  (calc-defence-roll enemy-def-level 0)
  =/  accuracy=@ud  (calc-accuracy atk-roll def-roll)
  =^  hit  seed  (roll-hit seed accuracy)
  ?.  hit  [0 seed]
  (roll-damage seed max-hit)
::
++  enemy-attack
  |=  [seed=@uvJ mdef=monster-def skills=(map skill-id skill-state) slots=(map equipment-slot item-id) style=combat-style]
  ^-  [dmg=@ud new-seed=@uvJ]
  =/  bonuses  (total-equipment-bonuses slots)
  =/  eff-def=@ud  (effective-defence-level skills style)
  =/  atk-roll=@ud  (calc-attack-roll attack-level.mdef 0)
  =/  def-roll=@ud  (calc-defence-roll eff-def def.bonuses)
  =/  accuracy=@ud  (calc-accuracy atk-roll def-roll)
  =^  hit  seed  (roll-hit seed accuracy)
  ?.  hit  [0 seed]
  (rng-range seed 0 max-hit.mdef)
::
::  ┌─────────────────────────────────┐
::  │  Weapon speed                    │
::  └─────────────────────────────────┘
::
++  weapon-speed
  |=  slots=(map equipment-slot item-id)
  ^-  @ud
  =/  weapon=(unit item-id)  (~(get by slots) %weapon)
  ?~  weapon  2.400  ::  unarmed kick: 2.4s
  =/  reg  equipment-registry:bide-equipment
  =/  stats=(unit equipment-stats)  (~(get by reg) u.weapon)
  ?~  stats  3.000
  ?:  =(attack-speed.u.stats 0)  3.000
  attack-speed.u.stats
::
::  ┌─────────────────────────────────┐
::  │  Loot & GP rolling               │
::  └─────────────────────────────────┘
::
++  roll-loot
  |=  [seed=@uvJ table=(list loot-entry)]
  ^-  [(list [item-id @ud]) @uvJ]
  =/  results=(list [item-id @ud])  ~
  |-
  ?~  table  [results seed]
  =^  roll  seed  (rng-range seed 1 100)
  ?.  (lte roll chance.i.table)
    $(table t.table)
  =^  qty  seed  (rng-range seed min-qty.i.table max-qty.i.table)
  $(table t.table, results [[item.i.table qty] results])
::
++  roll-gp
  |=  [seed=@uvJ min=@ud max=@ud]
  ^-  [@ud @uvJ]
  (rng-range seed min max)
--
