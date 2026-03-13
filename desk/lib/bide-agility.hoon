::  lib/bide-agility.hoon — agility milestone bonus functions
::
::  Bonuses are computed on-the-fly from agility level.
::
/-  *bide
|%
::
::  XP bonus for a target skill from agility milestones
::  Returns percentage (e.g. 2 = +2%)
::
++  xp-bonus
  |=  [agility-level=@ud target=skill-id]
  ^-  @ud
  =/  pct=@ud  0
  ::  level 10: +2% Woodcutting XP
  =?  pct  ?&((gte agility-level 10) =(target %woodcutting))
    (add pct 2)
  ::  level 20: +2% Mining XP
  =?  pct  ?&((gte agility-level 20) =(target %mining))
    (add pct 2)
  ::  level 30: +2% Fishing XP
  =?  pct  ?&((gte agility-level 30) =(target %fishing))
    (add pct 2)
  ::  level 40: +3% Thieving XP
  =?  pct  ?&((gte agility-level 40) =(target %thieving))
    (add pct 3)
  ::  level 90: +5% all skill XP
  =?  pct  (gte agility-level 90)
    (add pct 5)
  pct
::
::  Speed bonus: percentage reduction in action time
::  Returns percentage (e.g. 5 = -5% action time)
::
++  speed-bonus
  |=  agility-level=@ud
  ^-  @ud
  =/  pct=@ud  0
  ::  level 50: -5% action time
  =?  pct  (gte agility-level 50)  (add pct 5)
  ::  level 80: -5% more (stacks to -10%)
  =?  pct  (gte agility-level 80)  (add pct 5)
  pct
::
::  Farming yield bonus from agility
::
++  farming-yield-bonus
  |=  agility-level=@ud
  ^-  @ud
  ?:  (gte agility-level 70)  5
  0
::
::  Combat XP bonus from agility
::
++  combat-xp-bonus
  |=  agility-level=@ud
  ^-  @ud
  ?:  (gte agility-level 60)  3
  0
--
