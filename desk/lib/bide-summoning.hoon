::  lib/bide-summoning.hoon — familiar registry and bonus computation
::
/-  *bide
|%
::
+$  familiar-def
  $:  charges=@ud
      ::  xp bonuses (percentage) for specific categories
      gathering-xp=@ud
      artisan-xp=@ud
      thieving-xp=@ud
      herblore-xp=@ud
      combat-xp=@ud
      all-xp=@ud
      ::  combat stat boosts (percentage)
      atk-boost=@ud
      str-boost=@ud
      def-boost=@ud
      ::  farming yield bonus (percentage)
      farming-yield=@ud
  ==
::
++  familiar-registry
  ^-  (map item-id familiar-def)
  %-  ~(gas by *(map item-id familiar-def))
  :~  :-  %wolf-tablet
      [charges=100 gathering-xp=3 artisan-xp=0 thieving-xp=0 herblore-xp=0 combat-xp=0 all-xp=0 atk-boost=0 str-boost=0 def-boost=0 farming-yield=0]
      :-  %hawk-tablet
      [charges=100 gathering-xp=0 artisan-xp=0 thieving-xp=5 herblore-xp=0 combat-xp=0 all-xp=0 atk-boost=0 str-boost=0 def-boost=0 farming-yield=0]
      :-  %bear-tablet
      [charges=80 gathering-xp=0 artisan-xp=0 thieving-xp=0 herblore-xp=0 combat-xp=0 all-xp=0 atk-boost=0 str-boost=5 def-boost=0 farming-yield=0]
      :-  %serpent-tablet
      [charges=80 gathering-xp=0 artisan-xp=0 thieving-xp=0 herblore-xp=5 combat-xp=0 all-xp=0 atk-boost=0 str-boost=0 def-boost=0 farming-yield=5]
      :-  %phoenix-tablet
      [charges=60 gathering-xp=0 artisan-xp=8 thieving-xp=0 herblore-xp=0 combat-xp=0 all-xp=0 atk-boost=0 str-boost=0 def-boost=0 farming-yield=0]
      :-  %dragon-tablet
      [charges=60 gathering-xp=0 artisan-xp=0 thieving-xp=0 herblore-xp=0 combat-xp=0 all-xp=0 atk-boost=8 str-boost=8 def-boost=0 farming-yield=0]
      :-  %hydra-tablet
      [charges=50 gathering-xp=0 artisan-xp=0 thieving-xp=0 herblore-xp=0 combat-xp=5 all-xp=0 atk-boost=0 str-boost=0 def-boost=10 farming-yield=0]
      :-  %titan-tablet
      [charges=40 gathering-xp=0 artisan-xp=0 thieving-xp=0 herblore-xp=0 combat-xp=0 all-xp=10 atk-boost=0 str-boost=0 def-boost=0 farming-yield=0]
  ==
::
::  Compute XP bonus from active familiar for a target skill
::
++  familiar-xp-bonus
  |=  [fam=(unit familiar-state) target=skill-id stype=skill-type]
  ^-  @ud
  ?~  fam  0
  =/  fdef=(unit familiar-def)  (~(get by familiar-registry) tablet.u.fam)
  ?~  fdef  0
  =/  pct=@ud  all-xp.u.fdef
  =?  pct  =(stype %gathering)
    (add pct gathering-xp.u.fdef)
  =?  pct  =(stype %artisan)
    (add pct artisan-xp.u.fdef)
  =?  pct  ?&(=(stype %gathering) =(target %thieving))
    (add pct thieving-xp.u.fdef)
  =?  pct  ?&(=(stype %artisan) =(target %herblore))
    (add pct herblore-xp.u.fdef)
  =?  pct  =(stype %combat)
    (add pct combat-xp.u.fdef)
  pct
::
::  Compute combat stat boosts from active familiar
::
++  familiar-combat-boosts
  |=  fam=(unit familiar-state)
  ^-  [atk=@ud str=@ud def=@ud]
  ?~  fam  [0 0 0]
  =/  fdef=(unit familiar-def)  (~(get by familiar-registry) tablet.u.fam)
  ?~  fdef  [0 0 0]
  [atk-boost.u.fdef str-boost.u.fdef def-boost.u.fdef]
::
::  Compute farming yield bonus from active familiar
::
++  familiar-farming-yield
  |=  fam=(unit familiar-state)
  ^-  @ud
  ?~  fam  0
  =/  fdef=(unit familiar-def)  (~(get by familiar-registry) tablet.u.fam)
  ?~  fdef  0
  farming-yield.u.fdef
--
