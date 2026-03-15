::  lib/bide-astrology.hoon — constellation registry, mastery bonuses, and star upgrades
::
::  Each constellation is linked to two skills. Studying it grants
::  mastery-based XP bonuses to those linked skills.
::  Stars can be upgraded with stardust for additional bonuses.
::
/-  *bide
|%
::
::  Maps constellation action-id to its two linked skills
::
++  constellation-registry
  ^-  (map action-id [skill-id skill-id])
  %-  ~(gas by *(map action-id [skill-id skill-id]))
  :~  [%study-deedree [%woodcutting %farming]]
      [%study-iridan [%mining %smithing]]
      [%study-ameria [%fishing %cooking]]
      [%study-ko [%firemaking %herblore]]
      [%study-vale [%cooking %thieving]]
      [%study-arach [%thieving %agility]]
      [%study-hyden [%smithing %crafting]]
      [%study-qimican [%herblore %summoning]]
      [%study-terra [%farming %runecrafting]]
      [%study-sylvan [%fletching %woodcutting]]
      [%study-murtia [%attack %strength]]
      [%study-cerberus [%defence %ranged]]
  ==
::
::  Star definitions per constellation
::  Each constellation has 3 stars (idx 0, 1, 2)
::  Stars 0 & 1: XP boost, max level 5
::  Star 2: Interval reduction, max level 3
::
+$  star-type  ?(%xp-boost %interval-reduction)
::
++  star-max-level
  |=  idx=@ud
  ^-  @ud
  ?:  (lth idx 2)  5
  3
::
++  star-type-for
  |=  idx=@ud
  ^-  star-type
  ?:  (lth idx 2)  %xp-boost
  %interval-reduction
::
::  Cost to upgrade a star to the next level
::  Stars 0 & 1: stardust — costs 5, 10, 20, 40, 80
::  Star 2: golden-stardust — costs 10, 20, 40
::
++  star-cost
  |=  [idx=@ud current-level=@ud]
  ^-  [item-id @ud]
  ?:  (lth idx 2)
    :-  %stardust
    =/  costs=(list @ud)  ~[5 10 20 40 80]
    ?:  (gte current-level (lent costs))  0
    (snag current-level costs)
  :-  %golden-stardust
  =/  costs=(list @ud)  ~[10 20 40]
  ?:  (gte current-level (lent costs))  0
  (snag current-level costs)
::
::  Compute XP bonus for a target skill from astrology
::  Checks per-constellation mastery + global level bonuses
::  Returns percentage
::
++  xp-bonus
  |=  [astrology-level=@ud mastery=mastery-state target=skill-id]
  ^-  @ud
  =/  pct=@ud  0
  ::  per-constellation mastery bonuses
  =/  constellations=(list [action-id [skill-id skill-id]])  ~(tap by constellation-registry)
  |-
  ?~  constellations  pct
  =/  skills=[skill-id skill-id]  +.i.constellations
  ?.  ?|  =(-.skills target)
          =(+.skills target)
      ==
    $(constellations t.constellations)
  =/  action=action-id  -.i.constellations
  =/  mastery-xp=@ud  (fall (~(get by actions.mastery) action) 0)
  =/  bonus=@ud  0
  =?  bonus  (gte mastery-xp 100)     (add bonus 1)
  =?  bonus  (gte mastery-xp 500)     (add bonus 2)
  =?  bonus  (gte mastery-xp 2.000)   (add bonus 3)
  $(constellations t.constellations, pct (add pct bonus))
::
::  Compute star bonuses from upgraded stars
::  Returns [xp-per-skill=(map skill-id @ud) speed-bonus=@ud]
::
++  star-bonuses
  |=  levels=(map [action-id @ud] @ud)
  ^-  [xp-per-skill=(map skill-id @ud) speed-bonus=@ud]
  =/  skill-map=(map skill-id @ud)  *(map skill-id @ud)
  =/  speed=@ud  0
  =/  entries=(list [[action-id @ud] @ud])  ~(tap by levels)
  |-
  ?~  entries  [xp-per-skill=skill-map speed-bonus=speed]
  =/  key=[action-id @ud]  -.i.entries
  =/  level=@ud  +.i.entries
  ?:  =(level 0)
    $(entries t.entries)
  =/  constellation=(unit [skill-id skill-id])  (~(get by constellation-registry) -.key)
  ?~  constellation
    $(entries t.entries)
  ?:  (lth +.key 2)
    ::  XP boost star: +1% per level to both linked skills
    =/  s1=skill-id  -.u.constellation
    =/  s2=skill-id  +.u.constellation
    =/  cur1=@ud  (fall (~(get by skill-map) s1) 0)
    =/  cur2=@ud  (fall (~(get by skill-map) s2) 0)
    =.  skill-map  (~(put by skill-map) s1 (add cur1 level))
    =.  skill-map  (~(put by skill-map) s2 (add cur2 level))
    $(entries t.entries)
  ::  Interval reduction star: +1% speed per level
  $(entries t.entries, speed (add speed level))
--
