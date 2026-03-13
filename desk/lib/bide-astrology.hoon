::  lib/bide-astrology.hoon — constellation registry and mastery bonuses
::
::  Each constellation is linked to a skill. Studying it grants
::  mastery-based XP bonuses to that linked skill.
::
/-  *bide
|%
::
::  Maps constellation action-id to its linked skill
::
++  constellation-registry
  ^-  (map action-id skill-id)
  %-  ~(gas by *(map action-id skill-id))
  :~  [%study-deedree %woodcutting]
      [%study-iridan %mining]
      [%study-ameria %fishing]
      [%study-ko %firemaking]
      [%study-vale %cooking]
      [%study-arach %thieving]
      [%study-hyden %smithing]
      [%study-qimican %herblore]
      [%study-terra %farming]
      [%study-sylvan %fletching]
      [%study-murtia %attack]
      [%study-cerberus %defence]
  ==
::
::  Compute XP bonus for a target skill from astrology
::  Checks per-constellation mastery + global level bonuses
::  Returns percentage
::
++  xp-bonus
  |=  [astrology-level=@ud mastery=mastery-state target=skill-id]
  ^-  @ud
  =/  pct=@ud  0
  ::  global level bonuses
  =?  pct  (gte astrology-level 25)  (add pct 1)
  =?  pct  (gte astrology-level 50)  (add pct 2)
  =?  pct  (gte astrology-level 75)  (add pct 1)
  =?  pct  (gte astrology-level 99)  (add pct 2)
  ::  per-constellation mastery bonuses
  =/  constellations=(list [action-id skill-id])  ~(tap by constellation-registry)
  |-
  ?~  constellations  pct
  =/  action-skill=skill-id  +.i.constellations
  ?.  =(action-skill target)
    $(constellations t.constellations)
  =/  action=action-id  -.i.constellations
  =/  mastery-xp=@ud  (fall (~(get by actions.mastery) action) 0)
  =/  bonus=@ud  0
  =?  bonus  (gte mastery-xp 100)     (add bonus 1)
  =?  bonus  (gte mastery-xp 500)     (add bonus 2)
  =?  bonus  (gte mastery-xp 2.000)   (add bonus 3)
  $(constellations t.constellations, pct (add pct bonus))
--
