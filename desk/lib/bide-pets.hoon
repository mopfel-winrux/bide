::  lib/bide-pets.hoon — pet registry, drop rolling, and modifiers
::
/-  *bide
|%
::
++  pet-registry
  ^-  (map pet-id pet-def)
  %-  ~(gas by *(map pet-id pet-def))
  :~  :-  %rocky
      [name='Rocky' source-type=%skilling source-id=%mining chance=2.000 effects=~[[%xp-skill skill=%mining pct=2]]]
      :-  %beaver
      [name='Beaver' source-type=%skilling source-id=%woodcutting chance=2.000 effects=~[[%xp-skill skill=%woodcutting pct=2]]]
      :-  %heron
      [name='Heron' source-type=%skilling source-id=%fishing chance=2.000 effects=~[[%xp-skill skill=%fishing pct=2]]]
      :-  %ember
      [name='Ember' source-type=%skilling source-id=%firemaking chance=2.000 effects=~[[%xp-skill skill=%firemaking pct=2]]]
      :-  %nibbles
      [name='Nibbles' source-type=%skilling source-id=%thieving chance=2.500 effects=~[[%xp-skill skill=%thieving pct=3]]]
      :-  %golem
      [name='Golem' source-type=%skilling source-id=%smithing chance=2.500 effects=~[[%xp-skill skill=%smithing pct=3]]]
      :-  %chompy
      [name='Chompy' source-type=%skilling source-id=%cooking chance=2.000 effects=~[[%xp-skill skill=%cooking pct=2]]]
      :-  %sprout
      [name='Sprout' source-type=%skilling source-id=%farming chance=1.500 effects=~[[%farming-yield pct=5]]]
      :-  %rune-sprite
      [name='Rune Sprite' source-type=%skilling source-id=%runecrafting chance=3.000 effects=~[[%xp-skill skill=%runecrafting pct=3]]]
      :-  %phoenix-chick
      [name='Phoenix Chick' source-type=%combat source-id=%fire-giant chance=3.000 effects=~[[%xp-global pct=1]]]
      :-  %dragon-whelp
      [name='Dragon Whelp' source-type=%combat source-id=%dragon chance=5.000 effects=~[[%xp-global pct=2]]]
      :-  %goblin-runt
      [name='Goblin Runt' source-type=%combat source-id=%goblin chance=1.000 effects=~[[%gp-bonus pct=3]]]
  ==
::
::  Roll for pet drops based on source type and source id
::
++  roll-pet-drop
  |=  [seed=@uvJ source-type=?(%skilling %combat) source-id=@tas pets-found=(set pet-id)]
  ^-  [(unit pet-id) @uvJ]
  =/  candidates=(list [pid=pet-id pdef=pet-def])
    %+  murn  ~(tap by pet-registry)
    |=  [pid=pet-id pdef=pet-def]
    ?.  =(source-type.pdef source-type)  ~
    ?.  =(source-id.pdef source-id)  ~
    ?:  (~(has in pets-found) pid)  ~
    `[pid pdef]
  |-
  ?~  candidates  [~ seed]
  =/  rng  ~(. og seed)
  =^  roll  rng  (rads:rng chance.pdef.i.candidates)
  =/  new-seed=@uvJ  `@uvJ`a.rng
  ?:  =(roll 0)
    [`pid.i.candidates new-seed]
  $(candidates t.candidates, seed new-seed)
::
::  Compute modifier contributions from ALL found pets
::
++  pet-modifiers
  |=  found=(set pet-id)
  ^-  $:  xp-global=@ud
          xp-per-skill=(map skill-id @ud)
          speed-bonus=@ud
          farming-yield=@ud
          gp-bonus=@ud
      ==
  ::  collect all effects from all found pets
  =/  all-effs=(list pet-bonus)
    =/  pids=(list pet-id)  ~(tap in found)
    =/  acc=(list pet-bonus)  ~
    |-
    ?~  pids  acc
    =/  pdef=(unit pet-def)  (~(get by pet-registry) i.pids)
    ?~  pdef  $(pids t.pids)
    $(pids t.pids, acc (weld effects.u.pdef acc))
  ::  process all effects
  =/  xp-g=@ud  0
  =/  xp-s=(map skill-id @ud)  *(map skill-id @ud)
  =/  spd=@ud  0
  =/  fy=@ud  0
  =/  gpb=@ud  0
  =/  effs=(list pet-bonus)  all-effs
  |-
  ?~  effs  [xp-g xp-s spd fy gpb]
  ?-  -.i.effs
    %xp-skill
      =/  cur=@ud  (fall (~(get by xp-s) skill.i.effs) 0)
      $(effs t.effs, xp-s (~(put by xp-s) skill.i.effs (add cur pct.i.effs)))
    %xp-global
      $(effs t.effs, xp-g (add xp-g pct.i.effs))
    %gp-bonus
      $(effs t.effs, gpb (add gpb pct.i.effs))
    %speed-bonus
      $(effs t.effs, spd (add spd pct.i.effs))
    %farming-yield
      $(effs t.effs, fy (add fy pct.i.effs))
  ==
--
