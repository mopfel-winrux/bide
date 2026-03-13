::  lib/bide-capes.hoon — skill cape registry and modifier computation
::
/-  *bide
|%
::
++  cape-registry
  ^-  (map item-id cape-def)
  %-  ~(gas by *(map item-id cape-def))
  :~  [%woodcutting-cape [skill=%woodcutting bonuses=~[[%xp-skill skill=%woodcutting pct=5]]]]
      [%fishing-cape [skill=%fishing bonuses=~[[%xp-skill skill=%fishing pct=5]]]]
      [%mining-cape [skill=%mining bonuses=~[[%xp-skill skill=%mining pct=5]]]]
      [%thieving-cape [skill=%thieving bonuses=~[[%xp-skill skill=%thieving pct=5] [%gp-bonus pct=5]]]]
      [%firemaking-cape [skill=%firemaking bonuses=~[[%xp-global pct=5]]]]
      [%cooking-cape [skill=%cooking bonuses=~[[%xp-skill skill=%cooking pct=5]]]]
      [%smithing-cape [skill=%smithing bonuses=~[[%xp-skill skill=%smithing pct=5]]]]
      [%fletching-cape [skill=%fletching bonuses=~[[%xp-skill skill=%fletching pct=5]]]]
      [%crafting-cape [skill=%crafting bonuses=~[[%xp-skill skill=%crafting pct=5]]]]
      [%runecrafting-cape [skill=%runecrafting bonuses=~[[%xp-skill skill=%runecrafting pct=5]]]]
      [%herblore-cape [skill=%herblore bonuses=~[[%xp-skill skill=%herblore pct=5]]]]
      [%farming-cape [skill=%farming bonuses=~[[%farming-yield pct=25]]]]
      [%agility-cape [skill=%agility bonuses=~[[%speed-bonus pct=5]]]]
      [%astrology-cape [skill=%astrology bonuses=~[[%xp-global pct=3]]]]
      [%summoning-cape [skill=%summoning bonuses=~[[%xp-skill skill=%summoning pct=5]]]]
      [%attack-cape [skill=%attack bonuses=~[[%atk-boost pct=10]]]]
      [%strength-cape [skill=%strength bonuses=~[[%str-boost pct=10]]]]
      [%defence-cape [skill=%defence bonuses=~[[%def-boost pct=10]]]]
      [%hitpoints-cape [skill=%hitpoints bonuses=~[[%xp-skill skill=%hitpoints pct=5]]]]
      [%ranged-cape [skill=%ranged bonuses=~[[%ranged-boost pct=10]]]]
      [%magic-cape [skill=%magic bonuses=~[[%magic-boost pct=10]]]]
      [%prayer-cape [skill=%prayer bonuses=~[[%protect-all pct=5]]]]
      [%slayer-cape [skill=%slayer bonuses=~[[%xp-skill skill=%slayer pct=5] [%atk-boost pct=5]]]]
  ==
::
::  Compute modifier contributions from equipped cape
::
++  cape-modifiers
  |=  equipment=(map equipment-slot item-id)
  ^-  $:  xp-global=@ud
          xp-per-skill=(map skill-id @ud)
          speed-bonus=@ud
          atk-boost=@ud
          str-boost=@ud
          def-boost=@ud
          ranged-boost=@ud
          magic-boost=@ud
          farming-yield=@ud
          gp-bonus=@ud
          protect-all=@ud
      ==
  =/  cape-id=(unit item-id)  (~(get by equipment) %cape)
  ?~  cape-id
    [0 *(map skill-id @ud) 0 0 0 0 0 0 0 0 0]
  =/  cdef=(unit cape-def)  (~(get by cape-registry) u.cape-id)
  ?~  cdef
    [0 *(map skill-id @ud) 0 0 0 0 0 0 0 0 0]
  =/  xp-g=@ud  0
  =/  xp-s=(map skill-id @ud)  *(map skill-id @ud)
  =/  spd=@ud  0
  =/  atk=@ud  0
  =/  str=@ud  0
  =/  def=@ud  0
  =/  rng=@ud  0
  =/  mag=@ud  0
  =/  fy=@ud  0
  =/  gpb=@ud  0
  =/  pra=@ud  0
  =/  effs=(list cape-bonus)  bonuses.u.cdef
  |-
  ?~  effs  [xp-g xp-s spd atk str def rng mag fy gpb pra]
  ?-  -.i.effs
    %xp-skill
      =/  cur=@ud  (fall (~(get by xp-s) skill.i.effs) 0)
      $(effs t.effs, xp-s (~(put by xp-s) skill.i.effs (add cur pct.i.effs)))
    %xp-global      $(effs t.effs, xp-g (add xp-g pct.i.effs))
    %speed-bonus    $(effs t.effs, spd (add spd pct.i.effs))
    %atk-boost      $(effs t.effs, atk (add atk pct.i.effs))
    %str-boost      $(effs t.effs, str (add str pct.i.effs))
    %def-boost      $(effs t.effs, def (add def pct.i.effs))
    %ranged-boost   $(effs t.effs, rng (add rng pct.i.effs))
    %magic-boost    $(effs t.effs, mag (add mag pct.i.effs))
    %farming-yield  $(effs t.effs, fy (add fy pct.i.effs))
    %gp-bonus       $(effs t.effs, gpb (add gpb pct.i.effs))
    %protect-all    $(effs t.effs, pra (add pra pct.i.effs))
  ==
--
