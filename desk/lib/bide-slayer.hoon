::  lib/bide-slayer.hoon — slayer task assignment system
::
/-  *bide
/+  bide-combat
|%
::
+$  slayer-assignment
  $:  monster=monster-id
      min-kills=@ud
      max-kills=@ud
      min-slayer-level=@ud
      max-slayer-level=@ud
  ==
::
++  slayer-table
  ^-  (list slayer-assignment)
  :~  [%chicken 10 20 1 99]
      [%goblin 10 20 1 99]
      [%rat 10 20 1 99]
      [%zombie 10 20 5 99]
      [%skeleton 10 20 10 99]
      [%giant-spider 10 20 15 99]
      [%bandit 10 15 25 99]
      [%dark-knight 10 15 30 99]
      [%cave-troll 10 15 40 99]
      [%ogre 8 12 50 99]
      [%demon 8 12 60 99]
      [%fire-giant 5 10 70 99]
      [%dragon 5 10 80 99]
      ::  slayer-only monsters
      [%crawling-hand 15 25 5 99]
      [%cave-bug 15 25 7 99]
      [%basilisk 10 15 40 99]
      [%gargoyle 8 12 75 99]
      [%abyssal-demon 5 10 85 99]
      [%hydra 3 7 95 99]
  ==
::
::  Assign a random slayer task based on player level
::
++  assign-task
  |=  [seed=@uvJ slayer-level=@ud]
  ^-  [task=slayer-task new-seed=@uvJ]
  =/  eligible=(list slayer-assignment)
    %+  skim  slayer-table
    |=  sa=slayer-assignment
    ?&  (gte slayer-level min-slayer-level.sa)
        (lte slayer-level max-slayer-level.sa)
    ==
  =/  len=@ud  (lent eligible)
  ?:  =(len 0)
    [[monster=%chicken qty-remaining=10 qty-total=10] seed]
  =^  idx  seed  (rng-range:bide-combat seed 0 (dec len))
  =/  chosen=slayer-assignment  (snag idx eligible)
  =^  qty  seed  (rng-range:bide-combat seed min-kills.chosen max-kills.chosen)
  [[monster=monster.chosen qty-remaining=qty qty-total=qty] seed]
--
