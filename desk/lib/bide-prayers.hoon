::  lib/bide-prayers.hoon — prayer definitions and utility functions
::
/-  *bide
|%
::
++  prayer-registry
  ^-  (map prayer-id prayer-def)
  %-  ~(gas by *(map prayer-id prayer-def))
  :~  :-  %thick-skin
      [id=%thick-skin name='Thick Skin' level-req=1 drain-per-attack=1 effects=~[[%defence-pct 5]]]
      :-  %burst-of-strength
      [id=%burst-of-strength name='Burst of Strength' level-req=4 drain-per-attack=1 effects=~[[%strength-pct 5]]]
      :-  %clarity-of-thought
      [id=%clarity-of-thought name='Clarity of Thought' level-req=7 drain-per-attack=1 effects=~[[%attack-pct 5]]]
      :-  %superhuman-strength
      [id=%superhuman-strength name='Superhuman Strength' level-req=13 drain-per-attack=2 effects=~[[%strength-pct 10]]]
      :-  %improved-reflexes
      [id=%improved-reflexes name='Improved Reflexes' level-req=16 drain-per-attack=2 effects=~[[%attack-pct 10]]]
      :-  %protect-from-melee
      [id=%protect-from-melee name='Protect from Melee' level-req=37 drain-per-attack=4 effects=~[[%protect-melee 40]]]
      :-  %protect-from-ranged
      [id=%protect-from-ranged name='Protect from Ranged' level-req=40 drain-per-attack=4 effects=~[[%protect-ranged 40]]]
      :-  %protect-from-magic
      [id=%protect-from-magic name='Protect from Magic' level-req=43 drain-per-attack=4 effects=~[[%protect-magic 40]]]
  ==
::
::  Compute combined prayer bonuses from active prayers
::
++  compute-prayer-boosts
  |=  prayers=(set prayer-id)
  ^-  [atk=@ud str=@ud def=@ud pro-melee=@ud pro-ranged=@ud pro-magic=@ud]
  =/  pids=(list prayer-id)  ~(tap in prayers)
  =|  atk=@ud
  =|  str=@ud
  =|  def=@ud
  =|  pm=@ud
  =|  pr=@ud
  =|  pmg=@ud
  |-
  ?~  pids  [atk str def pm pr pmg]
  =/  pdef=(unit prayer-def)  (~(get by prayer-registry) i.pids)
  ?~  pdef  $(pids t.pids)
  =/  effs=(list prayer-bonus)  effects.u.pdef
  ?~  effs  $(pids t.pids)
  ?-  -.i.effs
    %attack-pct      $(pids t.pids, atk (max atk boost.i.effs))
    %strength-pct    $(pids t.pids, str (max str boost.i.effs))
    %defence-pct     $(pids t.pids, def (max def boost.i.effs))
    %protect-melee   $(pids t.pids, pm (max pm reduce.i.effs))
    %protect-ranged  $(pids t.pids, pr (max pr reduce.i.effs))
    %protect-magic   $(pids t.pids, pmg (max pmg reduce.i.effs))
  ==
::
::  Total prayer drain per player attack
::
++  total-drain
  |=  prayers=(set prayer-id)
  ^-  @ud
  =/  pids=(list prayer-id)  ~(tap in prayers)
  =|  total=@ud
  |-
  ?~  pids  total
  =/  pdef=(unit prayer-def)  (~(get by prayer-registry) i.pids)
  ?~  pdef  $(pids t.pids)
  $(pids t.pids, total (add total drain-per-attack.u.pdef))
--
