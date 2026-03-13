::  lib/bide-modifiers.hoon — unified modifier engine
::
::  Collects bonuses from agility, astrology, summoning,
::  potions, prayers, and pets into a single modifier-set.
::
/-  *bide
/+  bide-agility, bide-astrology, bide-summoning, bide-potions, bide-prayers, bide-pets
|%
::
::  Compute all modifiers from all bonus sources
::
++  compute-modifiers
  |=  $:  skills=(map skill-id skill-state)
          active-familiar=(unit familiar-state)
          active-potions=(list potion-effect)
          active-prayers=(set prayer-id)
          active-pet=(unit pet-id)
      ==
  ^-  modifier-set
  ::  agility level
  =/  agility-level=@ud
    =/  ss  (~(get by skills) %agility)
    ?~(ss 1 level.u.ss)
  ::  astrology state
  =/  astrology-ss=skill-state
    (fall (~(get by skills) %astrology) [xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]])
  ::  potion boosts
  =/  pot-boosts  (compute-boosts:bide-potions active-potions)
  ::  prayer boosts
  =/  pra-boosts  (compute-prayer-boosts:bide-prayers active-prayers)
  ::  familiar combat boosts
  =/  fam-boosts  (familiar-combat-boosts:bide-summoning active-familiar)
  ::  pet modifiers
  =/  pet-mods  (pet-modifiers:bide-pets active-pet)
  ::  familiar def lookup
  =/  fam-def=(unit familiar-def:bide-summoning)
    ?~  active-familiar  ~
    (~(get by familiar-registry:bide-summoning) tablet.u.active-familiar)
  ::  xp-global: agility combat bonus + pet global + familiar all-xp
  =/  fam-all-xp=@ud  ?~(fam-def 0 all-xp.u.fam-def)
  =/  res-xp-global=@ud
    (add (combat-xp-bonus:bide-agility agility-level) (add xp-global.pet-mods fam-all-xp))
  ::  xp-gathering: familiar gathering bonus
  =/  res-xp-gathering=@ud  ?~(fam-def 0 gathering-xp.u.fam-def)
  ::  xp-artisan: familiar artisan bonus
  =/  res-xp-artisan=@ud  ?~(fam-def 0 artisan-xp.u.fam-def)
  ::  xp-combat: familiar combat xp bonus
  =/  res-xp-combat=@ud  ?~(fam-def 0 combat-xp.u.fam-def)
  ::  xp-per-skill: agility milestones + astrology + pet + familiar thieving/herblore
  =/  skill-map=(map skill-id @ud)  *(map skill-id @ud)
  ::  agility per-skill bonuses
  =.  skill-map
    =/  sids=(list skill-id)  ~[%woodcutting %mining %fishing %thieving]
    |-
    ?~  sids  skill-map
    =/  bonus=@ud  (xp-bonus:bide-agility agility-level i.sids)
    =?  skill-map  (gth bonus 0)
      =/  cur=@ud  (fall (~(get by skill-map) i.sids) 0)
      (~(put by skill-map) i.sids (add cur bonus))
    $(sids t.sids)
  ::  astrology bonuses
  =.  skill-map
    =/  consts=(list [action-id skill-id])  ~(tap by constellation-registry:bide-astrology)
    |-
    ?~  consts  skill-map
    =/  target=skill-id  +.i.consts
    =/  bonus=@ud  (xp-bonus:bide-astrology level.astrology-ss mastery.astrology-ss target)
    =?  skill-map  (gth bonus 0)
      =/  cur=@ud  (fall (~(get by skill-map) target) 0)
      (~(put by skill-map) target (add cur bonus))
    $(consts t.consts)
  ::  pet per-skill bonuses
  =.  skill-map
    =/  pet-skills=(list [skill-id @ud])  ~(tap by xp-per-skill.pet-mods)
    |-
    ?~  pet-skills  skill-map
    =/  cur=@ud  (fall (~(get by skill-map) -.i.pet-skills) 0)
    =.  skill-map  (~(put by skill-map) -.i.pet-skills (add cur +.i.pet-skills))
    $(pet-skills t.pet-skills)
  ::  familiar thieving/herblore extras
  =/  thieving-extra=@ud  ?~(fam-def 0 thieving-xp.u.fam-def)
  =?  skill-map  (gth thieving-extra 0)
    =/  cur=@ud  (fall (~(get by skill-map) %thieving) 0)
    (~(put by skill-map) %thieving (add cur thieving-extra))
  =/  herblore-extra=@ud  ?~(fam-def 0 herblore-xp.u.fam-def)
  =?  skill-map  (gth herblore-extra 0)
    =/  cur=@ud  (fall (~(get by skill-map) %herblore) 0)
    (~(put by skill-map) %herblore (add cur herblore-extra))
  ::  speed-bonus
  =/  res-speed=@ud  (add (speed-bonus:bide-agility agility-level) speed-bonus.pet-mods)
  ::  combat boosts
  =/  res-atk=@ud  (add atk-boost.pot-boosts (add atk.pra-boosts atk.fam-boosts))
  =/  res-str=@ud  (add str-boost.pot-boosts (add str.pra-boosts str.fam-boosts))
  =/  res-def=@ud  (add def-boost.pot-boosts (add def.pra-boosts def.fam-boosts))
  ::  farming yield
  =/  res-fy=@ud  (add (farming-yield-bonus:bide-agility agility-level) (add (familiar-farming-yield:bide-summoning active-familiar) farming-yield.pet-mods))
  ::  assemble modifier-set
  :*  xp-global=res-xp-global
      xp-gathering=res-xp-gathering
      xp-artisan=res-xp-artisan
      xp-combat=res-xp-combat
      xp-per-skill=skill-map
      speed-bonus=res-speed
      atk-boost=res-atk
      str-boost=res-str
      def-boost=res-def
      protect-melee=pro-melee.pra-boosts
      protect-ranged=pro-ranged.pra-boosts
      protect-magic=pro-magic.pra-boosts
      farming-yield=res-fy
      gp-bonus=gp-bonus.pet-mods
  ==
::
::  Apply XP bonus to base XP for a specific skill
::
++  apply-xp-bonus
  |=  [mods=modifier-set target=skill-id stype=skill-type base-xp=@ud]
  ^-  @ud
  =/  pct=@ud  xp-global.mods
  =?  pct  =(stype %gathering)  (add pct xp-gathering.mods)
  =?  pct  =(stype %artisan)    (add pct xp-artisan.mods)
  =?  pct  =(stype %combat)     (add pct xp-combat.mods)
  =/  skill-pct=@ud  (fall (~(get by xp-per-skill.mods) target) 0)
  =.  pct  (add pct skill-pct)
  (add base-xp (div (mul base-xp pct) 100))
::
::  Apply speed bonus to base time
::
++  apply-speed-bonus
  |=  [mods=modifier-set base-time=@ud]
  ^-  @ud
  (max 500 (sub base-time (div (mul base-time speed-bonus.mods) 100)))
::
::  Get combat stat boosts
::
++  get-combat-boosts
  |=  mods=modifier-set
  ^-  [atk=@ud str=@ud def=@ud]
  [atk-boost.mods str-boost.mods def-boost.mods]
::
::  Get protection percentage based on enemy attack style
::
++  get-protection
  |=  [mods=modifier-set enemy-style=combat-style]
  ^-  @ud
  ?-  enemy-style
    ?(%melee-attack %melee-strength %melee-defence)  protect-melee.mods
    %ranged  protect-ranged.mods
    %magic   protect-magic.mods
  ==
--
