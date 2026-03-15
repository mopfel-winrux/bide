::  lib/bide-json.hoon — JSON serialization for game state and definitions
::
/-  *bide
/+  bide-skills, bide-items, bide-monsters, bide-areas, bide-equipment
/+  bide-food, bide-potions, bide-prayers, bide-dungeons, bide-farming
/+  bide-summoning, bide-astrology, bide-specials, bide-shop, bide-pets
/+  bide-spells, bide-capes, bide-combat, bide-bank
::
|_  gs=game-state
::
++  action-to-json
  |=  ad=action-def
  ^-  json
  %-  pairs:enjs:format
  :~  ['id' [%s id.ad]]
      ['name' [%s name.ad]]
      ['levelReq' (numb:enjs:format level-req.ad)]
      ['xp' (numb:enjs:format xp.ad)]
      ['baseTime' (numb:enjs:format base-time.ad)]
      ['masteryXp' (numb:enjs:format mastery-xp.ad)]
      ['inputs' [%a (turn inputs.ad input-to-json)]]
      ['outputs' [%a (turn outputs.ad output-to-json)]]
      ['gpPerAction' (numb:enjs:format gp-per-action.ad)]
  ==
::
++  input-to-json
  |=  inp=[item=item-id qty=@ud]
  ^-  json
  %-  pairs:enjs:format
  :~  ['item' [%s item.inp]]
      ['qty' (numb:enjs:format qty.inp)]
  ==
::
++  output-to-json
  |=  od=output-def
  ^-  json
  %-  pairs:enjs:format
  :~  ['item' [%s item.od]]
      ['minQty' (numb:enjs:format min-qty.od)]
      ['maxQty' (numb:enjs:format max-qty.od)]
      ['chance' (numb:enjs:format chance.od)]
  ==
::
++  state-to-json
  |=  now=@da
  ^-  json
  =/  skill-pairs=(list [@t json])
    %+  turn  ~(tap by skills.gs)
    |=  [sid=skill-id ss=skill-state]
    ^-  [@t json]
    :-  sid
    %-  pairs:enjs:format
    :~  ['xp' (numb:enjs:format xp.ss)]
        ['level' (numb:enjs:format level.ss)]
        ['poolXp' (numb:enjs:format pool-xp.mastery.ss)]
        :-  'masteryActions'
        :-  %o
        %-  ~(gas by *(map @t json))
        %+  turn  ~(tap by actions.mastery.ss)
        |=  [aid=action-id mxp=@ud]
        ^-  [@t json]
        [aid (numb:enjs:format mxp)]
    ==
  =/  skills-json=json  [%o (~(gas by *(map @t json)) skill-pairs)]
  =/  bank-pairs=(list [@t json])
    %+  turn  ~(tap by items.bank.gs)
    |=  [iid=item-id qty=@ud]
    ^-  [@t json]
    [iid (numb:enjs:format qty)]
  =/  bank-json=json  [%o (~(gas by *(map @t json)) bank-pairs)]
  =/  action-json=json
    ?~  active-action.gs  ~
    =/  aa  u.active-action.gs
    ?-  -.aa
      %skilling
      %-  pairs:enjs:format
      :~  ['type' [%s 'skilling']]
          ['skill' [%s skill.aa]]
          ['target' [%s target.aa]]
      ==
    ::
      %combat
      =/  ms-per=@dr  ms-per:bide-bank
      =/  weapon-spd=@ud  ?~(spell.aa (weapon-speed:bide-combat slots.equipment.gs) 3.000)
      =/  p-remaining=@dr
        ?:  (gth player-next-attack.aa now)
          (sub player-next-attack.aa now)
        *@dr
      =/  p-remaining-ms=@ud  (div p-remaining ms-per)
      =/  p-elapsed=@ud  (sub weapon-spd (min weapon-spd p-remaining-ms))
      =/  mdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) monster.aa)
      =/  enemy-spd=@ud  ?~(mdef 3.000 attack-speed.u.mdef)
      =/  e-remaining=@dr
        ?:  (gth enemy-next-attack.aa now)
          (sub enemy-next-attack.aa now)
        *@dr
      =/  e-remaining-ms=@ud  (div e-remaining ms-per)
      =/  e-elapsed=@ud  (sub enemy-spd (min enemy-spd e-remaining-ms))
      %-  pairs:enjs:format
      :~  ['type' [%s 'combat']]
          ['area' [%s area.aa]]
          ['monster' [%s monster.aa]]
          ['style' [%s style.aa]]
          ['spell' ?~(spell.aa ~ [%s u.spell.aa])]
          ['enemyHp' (numb:enjs:format enemy-hp.aa)]
          ['enemyMaxHp' (numb:enjs:format enemy-max-hp.aa)]
          ['playerAttackTimer' (numb:enjs:format p-elapsed)]
          ['enemyAttackTimer' (numb:enjs:format e-elapsed)]
          ['kills' (numb:enjs:format kills.aa)]
          ['playerAtkCount' (numb:enjs:format player-atk-count.aa)]
          ['enemyAtkCount' (numb:enjs:format enemy-atk-count.aa)]
          ['playerLastDmg' (numb:enjs:format player-last-dmg.aa)]
          ['enemyLastDmg' (numb:enjs:format enemy-last-dmg.aa)]
          ['specialEnergy' (numb:enjs:format special-energy.aa)]
          ['specialQueued' [%b special-queued.aa]]
      ==
    ::
      %dungeon
      =/  ms-per=@dr  ms-per:bide-bank
      =/  weapon-spd=@ud  ?~(spell.aa (weapon-speed:bide-combat slots.equipment.gs) 3.000)
      =/  p-remaining=@dr
        ?:  (gth player-next-attack.aa now)
          (sub player-next-attack.aa now)
        *@dr
      =/  p-remaining-ms=@ud  (div p-remaining ms-per)
      =/  p-elapsed=@ud  (sub weapon-spd (min weapon-spd p-remaining-ms))
      =/  mdef=(unit monster-def)  (~(get by monster-registry:bide-monsters) monster.aa)
      =/  enemy-spd=@ud  ?~(mdef 3.000 attack-speed.u.mdef)
      =/  e-remaining=@dr
        ?:  (gth enemy-next-attack.aa now)
          (sub enemy-next-attack.aa now)
        *@dr
      =/  e-remaining-ms=@ud  (div e-remaining ms-per)
      =/  e-elapsed=@ud  (sub enemy-spd (min enemy-spd e-remaining-ms))
      %-  pairs:enjs:format
      :~  ['type' [%s 'dungeon']]
          ['dungeon' [%s dungeon.aa]]
          ['roomIdx' (numb:enjs:format room-idx.aa)]
          ['roomKills' (numb:enjs:format room-kills.aa)]
          ['monster' [%s monster.aa]]
          ['style' [%s style.aa]]
          ['spell' ?~(spell.aa ~ [%s u.spell.aa])]
          ['enemyHp' (numb:enjs:format enemy-hp.aa)]
          ['enemyMaxHp' (numb:enjs:format enemy-max-hp.aa)]
          ['playerAttackTimer' (numb:enjs:format p-elapsed)]
          ['enemyAttackTimer' (numb:enjs:format e-elapsed)]
          ['kills' (numb:enjs:format kills.aa)]
          ['playerAtkCount' (numb:enjs:format player-atk-count.aa)]
          ['enemyAtkCount' (numb:enjs:format enemy-atk-count.aa)]
          ['playerLastDmg' (numb:enjs:format player-last-dmg.aa)]
          ['enemyLastDmg' (numb:enjs:format enemy-last-dmg.aa)]
          ['specialEnergy' (numb:enjs:format special-energy.aa)]
          ['specialQueued' [%b special-queued.aa]]
      ==
    ==
  ::  equipment slots to json
  =/  eq-pairs=(list [@t json])
    %+  turn  ~(tap by slots.equipment.gs)
    |=  [slot=equipment-slot iid=item-id]
    ^-  [@t json]
    [(scot %tas slot) [%s iid]]
  =/  eq-json=json
    %-  pairs:enjs:format
    :~  ['slots' [%o (~(gas by *(map @t json)) eq-pairs)]]
        ['autoEatThreshold' (numb:enjs:format auto-eat-threshold.equipment.gs)]
        :-  'selectedFood'
        ?~  selected-food.equipment.gs  ~
        [%s u.selected-food.equipment.gs]
    ==
  ::  active potions
  =/  potions-json=json
    :-  %a
    %+  turn  active-potions.gs
    |=  pe=potion-effect
    %-  pairs:enjs:format
    :~  ['item' [%s item.pe]]
        ['turnsLeft' (numb:enjs:format turns-left.pe)]
    ==
  ::  active prayers
  =/  prayers-json=json
    [%a (turn ~(tap in active-prayers.gs) |=(p=prayer-id [%s p]))]
  ::  slayer task
  =/  slayer-json=json
    ?~  slayer-task.gs  ~
    =/  st  u.slayer-task.gs
    %-  pairs:enjs:format
    :~  ['monster' [%s monster.st]]
        ['qtyRemaining' (numb:enjs:format qty-remaining.st)]
        ['qtyTotal' (numb:enjs:format qty-total.st)]
    ==
  ::  farm plots
  =/  ms-per=@dr  ms-per:bide-bank
  =/  farm-json=json
    :-  %a
    %+  turn  farm-plots.gs
    |=  plot=(unit farm-plot)
    ?~  plot  ~
    =/  growth-dr=@dr  (mul ms-per growth-time.u.plot)
    =/  ready-at=@da  (add planted-at.u.plot growth-dr)
    =/  is-ready=?  (gte now ready-at)
    %-  pairs:enjs:format
    :~  ['seed' [%s seed.u.plot]]
        ['plantedAt' (numb:enjs:format (div (sub planted-at.u.plot ~1970.1.1) ms-per))]
        ['growthTime' (numb:enjs:format growth-time.u.plot)]
        ['ready' [%b is-ready]]
    ==
  ::  active familiar
  =/  familiar-json=json
    ?~  active-familiar.gs  ~
    =/  af  u.active-familiar.gs
    %-  pairs:enjs:format
    :~  ['tablet' [%s tablet.af]]
        ['charges' (numb:enjs:format charges.af)]
    ==
  ::  pets
  =/  pets-found-json=json
    [%a (turn ~(tap in pets-found.gs) |=(p=pet-id [%s p]))]
  =/  active-pet-json=json
    ?~(active-pet.gs ~ [%s u.active-pet.gs])
  ::  stats
  =/  stats-json=json
    %-  pairs:enjs:format
    :~  :-  'actionsCompleted'
        [%o (~(gas by *(map @t json)) (turn ~(tap by actions-completed.stats.gs) |=([a=action-id n=@ud] [a (numb:enjs:format n)])))]
        :-  'monstersKilled'
        [%o (~(gas by *(map @t json)) (turn ~(tap by monsters-killed.stats.gs) |=([m=monster-id n=@ud] [m (numb:enjs:format n)])))]
        :-  'itemsProduced'
        [%o (~(gas by *(map @t json)) (turn ~(tap by items-produced.stats.gs) |=([i=item-id n=@ud] [i (numb:enjs:format n)])))]
        :-  'dungeonsCompleted'
        [%o (~(gas by *(map @t json)) (turn ~(tap by dungeons-completed.stats.gs) |=([d=dungeon-id n=@ud] [d (numb:enjs:format n)])))]
        ['totalXpEarned' (numb:enjs:format total-xp-earned.stats.gs)]
        ['totalGpEarned' (numb:enjs:format total-gp-earned.stats.gs)]
        ['totalGpSpent' (numb:enjs:format total-gp-spent.stats.gs)]
        ['maxHitDealt' (numb:enjs:format max-hit-dealt.stats.gs)]
    ==
  %-  pairs:enjs:format
  :~  ['gp' (numb:enjs:format gp.player.gs)]
      ['hp' (numb:enjs:format hitpoints-current.player.gs)]
      ['hpMax' (numb:enjs:format hitpoints-max.player.gs)]
      ['prayerPoints' (numb:enjs:format prayer-points.player.gs)]
      ['prayerMax' (numb:enjs:format prayer-max.player.gs)]
      ['skills' skills-json]
      ['bank' bank-json]
      ['slotsMax' (numb:enjs:format slots-max.bank.gs)]
      ['activeAction' action-json]
      ['equipment' eq-json]
      ['activePotions' potions-json]
      ['activePrayers' prayers-json]
      ['slayerTask' slayer-json]
      ['farmPlots' farm-json]
      ['activeFamiliar' familiar-json]
      ['petsFound' pets-found-json]
      ['activePet' active-pet-json]
      ['stats' stats-json]
      :-  'starLevels'
      :-  %o
      %-  ~(gas by *(map @t json))
      %+  turn  ~(tap by star-levels.gs)
      |=  [key=[action-id @ud] level=@ud]
      ^-  [@t json]
      =/  key-str=@t  (crip "{(trip -.key)}/{(a-co:co +.key)}")
      [key-str (numb:enjs:format level)]
  ==
::
++  defs-to-json
  ^-  json
  =/  skill-defs=(list [@t json])
    %+  turn  ~(tap by skill-registry:bide-skills)
    |=  [sid=skill-id sd=skill-def]
    ^-  [@t json]
    :-  sid
    %-  pairs:enjs:format
    :~  ['name' [%s name.sd]]
        ['type' [%s skill-type.sd]]
        ['maxLevel' (numb:enjs:format max-level.sd)]
        ['actions' [%a (turn actions.sd action-to-json)]]
    ==
  =/  item-defs=(list [@t json])
    %+  turn  ~(tap by item-registry:bide-items)
    |=  [iid=item-id idef=item-def]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['name' [%s name.idef]]
        ['category' [%s category.idef]]
        ['sellPrice' (numb:enjs:format sell-price.idef)]
    ==
  ::  monster defs
  =/  monster-defs=(list [@t json])
    %+  turn  ~(tap by monster-registry:bide-monsters)
    |=  [mid=monster-id md=monster-def]
    ^-  [@t json]
    :-  mid
    %-  pairs:enjs:format
    :~  ['name' [%s name.md]]
        ['hitpoints' (numb:enjs:format hitpoints.md)]
        ['maxHit' (numb:enjs:format max-hit.md)]
        ['attackLevel' (numb:enjs:format attack-level.md)]
        ['strengthLevel' (numb:enjs:format strength-level.md)]
        ['defenceLevel' (numb:enjs:format defence-level.md)]
        ['attackSpeed' (numb:enjs:format attack-speed.md)]
        ['attackStyle' [%s attack-style.md]]
        ['combatXp' (numb:enjs:format combat-xp.md)]
        ['slayerReq' (numb:enjs:format slayer-req.md)]
        ['gpMin' (numb:enjs:format gp-min.md)]
        ['gpMax' (numb:enjs:format gp-max.md)]
        :-  'lootTable'
        :-  %a
        %+  turn  loot-table.md
        |=  le=loot-entry
        %-  pairs:enjs:format
        :~  ['item' [%s item.le]]
            ['minQty' (numb:enjs:format min-qty.le)]
            ['maxQty' (numb:enjs:format max-qty.le)]
            ['chance' (numb:enjs:format chance.le)]
        ==
    ==
  ::  area defs
  =/  area-defs=(list [@t json])
    %+  turn  ~(tap by area-registry:bide-areas)
    |=  [aid=area-id ad=area-def]
    ^-  [@t json]
    :-  aid
    %-  pairs:enjs:format
    :~  ['name' [%s name.ad]]
        ['monsters' [%a (turn monsters.ad |=(m=monster-id [%s m]))]]
        ['levelReq' (numb:enjs:format level-req.ad)]
    ==
  ::  equipment stats
  =/  equip-stat-defs=(list [@t json])
    %+  turn  ~(tap by equipment-registry:bide-equipment)
    |=  [iid=item-id es=equipment-stats]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['slot' [%s slot.es]]
        ['attackBonus' (numb:enjs:format attack-bonus.es)]
        ['strengthBonus' (numb:enjs:format strength-bonus.es)]
        ['rangedAttackBonus' (numb:enjs:format ranged-attack-bonus.es)]
        ['rangedStrengthBonus' (numb:enjs:format ranged-strength-bonus.es)]
        ['magicAttackBonus' (numb:enjs:format magic-attack-bonus.es)]
        ['magicStrengthBonus' (numb:enjs:format magic-strength-bonus.es)]
        ['defenceBonus' (numb:enjs:format defence-bonus.es)]
        ['attackSpeed' (numb:enjs:format attack-speed.es)]
        :-  'levelReqs'
        :-  %o
        %-  ~(gas by *(map @t json))
        %+  turn  ~(tap by level-reqs.es)
        |=  [sid=skill-id lvl=@ud]
        ^-  [@t json]
        [sid (numb:enjs:format lvl)]
    ==
  ::  food healing
  =/  food-defs=(list [@t json])
    %+  turn  ~(tap by food-registry:bide-food)
    |=  [iid=item-id heal=@ud]
    ^-  [@t json]
    [iid (numb:enjs:format heal)]
  ::  prayer defs
  =/  prayer-defs=(list [@t json])
    %+  turn  ~(tap by prayer-registry:bide-prayers)
    |=  [pid=prayer-id pd=prayer-def]
    ^-  [@t json]
    :-  pid
    %-  pairs:enjs:format
    :~  ['name' [%s name.pd]]
        ['levelReq' (numb:enjs:format level-req.pd)]
        ['drainPerAttack' (numb:enjs:format drain-per-attack.pd)]
    ==
  ::  potion defs
  =/  pot-defs=(list [@t json])
    %+  turn  ~(tap by potion-registry:bide-potions)
    |=  [iid=item-id pd=potion-def:bide-potions]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['effectType' [%s effect-type.pd]]
        ['magnitude' (numb:enjs:format magnitude.pd)]
        ['duration' (numb:enjs:format duration.pd)]
    ==
  ::  farm seed defs
  =/  farm-seed-defs=(list [@t json])
    %+  turn  ~(tap by seed-registry:bide-farming)
    |=  [iid=item-id sd=farm-seed-def:bide-farming]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['level' (numb:enjs:format level.sd)]
        ['growthTime' (numb:enjs:format growth-time.sd)]
        ['xp' (numb:enjs:format xp.sd)]
        ['crop' [%s crop.sd]]
        ['minYield' (numb:enjs:format min-yield.sd)]
        ['maxYield' (numb:enjs:format max-yield.sd)]
    ==
  ::  familiar defs
  =/  fam-defs=(list [@t json])
    %+  turn  ~(tap by familiar-registry:bide-summoning)
    |=  [iid=item-id fd=familiar-def:bide-summoning]
    ^-  [@t json]
    :-  iid
    %-  pairs:enjs:format
    :~  ['charges' (numb:enjs:format charges.fd)]
        ['gatheringXp' (numb:enjs:format gathering-xp.fd)]
        ['artisanXp' (numb:enjs:format artisan-xp.fd)]
        ['thievingXp' (numb:enjs:format thieving-xp.fd)]
        ['herbloreXp' (numb:enjs:format herblore-xp.fd)]
        ['combatXp' (numb:enjs:format combat-xp.fd)]
        ['allXp' (numb:enjs:format all-xp.fd)]
        ['atkBoost' (numb:enjs:format atk-boost.fd)]
        ['strBoost' (numb:enjs:format str-boost.fd)]
        ['defBoost' (numb:enjs:format def-boost.fd)]
        ['farmingYield' (numb:enjs:format farming-yield.fd)]
    ==
  ::  astrology constellation defs (dual-skill)
  =/  constellation-defs=(list [@t json])
    %+  turn  ~(tap by constellation-registry:bide-astrology)
    |=  [aid=action-id skills=[skill-id skill-id]]
    ^-  [@t json]
    [aid [%a ~[[%s -.skills] [%s +.skills]]]]
  %-  pairs:enjs:format
  :~  ['skills' [%o (~(gas by *(map @t json)) skill-defs)]]
      ['items' [%o (~(gas by *(map @t json)) item-defs)]]
      ['monsters' [%o (~(gas by *(map @t json)) monster-defs)]]
      ['areas' [%o (~(gas by *(map @t json)) area-defs)]]
      ['equipmentStats' [%o (~(gas by *(map @t json)) equip-stat-defs)]]
      ['foodHealing' [%o (~(gas by *(map @t json)) food-defs)]]
      ['prayers' [%o (~(gas by *(map @t json)) prayer-defs)]]
      ['potions' [%o (~(gas by *(map @t json)) pot-defs)]]
      ['dungeons' [%o (~(gas by *(map @t json)) dungeon-defs-to-json)]]
      ['farmSeeds' [%o (~(gas by *(map @t json)) farm-seed-defs)]]
      ['familiars' [%o (~(gas by *(map @t json)) fam-defs)]]
      ['constellations' [%o (~(gas by *(map @t json)) constellation-defs)]]
      :-  'starDefs'
      %-  pairs:enjs:format
      :~  :-  'stars'
          :-  %a
          :~  %-  pairs:enjs:format
              :~  ['type' [%s 'xp-boost']]
                  ['maxLevel' (numb:enjs:format 5)]
                  ['costs' [%a ~[(numb:enjs:format 5) (numb:enjs:format 10) (numb:enjs:format 20) (numb:enjs:format 40) (numb:enjs:format 80)]]]
                  ['currency' [%s 'stardust']]
              ==
              %-  pairs:enjs:format
              :~  ['type' [%s 'xp-boost']]
                  ['maxLevel' (numb:enjs:format 5)]
                  ['costs' [%a ~[(numb:enjs:format 5) (numb:enjs:format 10) (numb:enjs:format 20) (numb:enjs:format 40) (numb:enjs:format 80)]]]
                  ['currency' [%s 'stardust']]
              ==
              %-  pairs:enjs:format
              :~  ['type' [%s 'interval-reduction']]
                  ['maxLevel' (numb:enjs:format 3)]
                  ['costs' [%a ~[(numb:enjs:format 10) (numb:enjs:format 20) (numb:enjs:format 40)]]]
                  ['currency' [%s 'golden-stardust']]
              ==
          ==
      ==
      :-  'specials'
      :-  %o
      %-  ~(gas by *(map @t json))
      %+  turn  ~(tap by special-registry:bide-specials)
      |=  [iid=item-id sd=special-attack-def]
      ^-  [@t json]
      :-  iid
      %-  pairs:enjs:format
      :~  ['name' [%s name.sd]]
          ['energyCost' (numb:enjs:format energy-cost.sd)]
          ['damageMult' (numb:enjs:format damage-mult.sd)]
          ['accuracyMult' (numb:enjs:format accuracy-mult.sd)]
      ==
      ::  shop registry
      :-  'shop'
      :-  %o
      %-  ~(gas by *(map @t json))
      %+  turn  ~(tap by shop-registry:bide-shop)
      |=  [iid=item-id price=@ud]
      ^-  [@t json]
      [iid (numb:enjs:format price)]
      ::  pet registry
      :-  'pets'
      :-  %o
      %-  ~(gas by *(map @t json))
      %+  turn  ~(tap by pet-registry:bide-pets)
      |=  [pid=pet-id pd=pet-def]
      ^-  [@t json]
      :-  pid
      %-  pairs:enjs:format
      :~  ['name' [%s name.pd]]
          ['sourceType' [%s source-type.pd]]
          ['sourceId' [%s source-id.pd]]
          ['chance' (numb:enjs:format chance.pd)]
          :-  'effects'
          :-  %a
          %+  turn  effects.pd
          |=  pb=pet-bonus
          ?-  -.pb
            %xp-skill       (pairs:enjs:format ~[['type' [%s 'xp-skill']] ['skill' [%s skill.pb]] ['pct' (numb:enjs:format pct.pb)]])
            %xp-global      (pairs:enjs:format ~[['type' [%s 'xp-global']] ['pct' (numb:enjs:format pct.pb)]])
            %gp-bonus       (pairs:enjs:format ~[['type' [%s 'gp-bonus']] ['pct' (numb:enjs:format pct.pb)]])
            %speed-bonus    (pairs:enjs:format ~[['type' [%s 'speed-bonus']] ['pct' (numb:enjs:format pct.pb)]])
            %farming-yield  (pairs:enjs:format ~[['type' [%s 'farming-yield']] ['pct' (numb:enjs:format pct.pb)]])
          ==
      ==
      ::  spell registry
      :-  'spells'
      :-  %o
      %-  ~(gas by *(map @t json))
      %+  turn  ~(tap by spell-registry:bide-spells)
      |=  [sid=spell-id sd=spell-def]
      ^-  [@t json]
      :-  sid
      %-  pairs:enjs:format
      :~  ['name' [%s name.sd]]
          ['levelReq' (numb:enjs:format level-req.sd)]
          ['maxHit' (numb:enjs:format max-hit.sd)]
          :-  'runes'
          :-  %a
          %+  turn  runes.sd
          |=  [item=item-id qty=@ud]
          %-  pairs:enjs:format
          :~  ['item' [%s item]]
              ['qty' (numb:enjs:format qty)]
          ==
      ==
      ::  cape registry
      :-  'capes'
      :-  %o
      %-  ~(gas by *(map @t json))
      %+  turn  ~(tap by cape-registry:bide-capes)
      |=  [iid=item-id cd=cape-def]
      ^-  [@t json]
      :-  iid
      %-  pairs:enjs:format
      :~  ['skill' [%s skill.cd]]
          :-  'bonuses'
          :-  %a
          %+  turn  bonuses.cd
          |=  cb=cape-bonus
          ?-  -.cb
            %xp-skill       (pairs:enjs:format ~[['type' [%s 'xp-skill']] ['skill' [%s skill.cb]] ['pct' (numb:enjs:format pct.cb)]])
            %xp-global      (pairs:enjs:format ~[['type' [%s 'xp-global']] ['pct' (numb:enjs:format pct.cb)]])
            %speed-bonus    (pairs:enjs:format ~[['type' [%s 'speed-bonus']] ['pct' (numb:enjs:format pct.cb)]])
            %atk-boost      (pairs:enjs:format ~[['type' [%s 'atk-boost']] ['pct' (numb:enjs:format pct.cb)]])
            %str-boost      (pairs:enjs:format ~[['type' [%s 'str-boost']] ['pct' (numb:enjs:format pct.cb)]])
            %def-boost      (pairs:enjs:format ~[['type' [%s 'def-boost']] ['pct' (numb:enjs:format pct.cb)]])
            %ranged-boost   (pairs:enjs:format ~[['type' [%s 'ranged-boost']] ['pct' (numb:enjs:format pct.cb)]])
            %magic-boost    (pairs:enjs:format ~[['type' [%s 'magic-boost']] ['pct' (numb:enjs:format pct.cb)]])
            %farming-yield  (pairs:enjs:format ~[['type' [%s 'farming-yield']] ['pct' (numb:enjs:format pct.cb)]])
            %gp-bonus       (pairs:enjs:format ~[['type' [%s 'gp-bonus']] ['pct' (numb:enjs:format pct.cb)]])
            %protect-all    (pairs:enjs:format ~[['type' [%s 'protect-all']] ['pct' (numb:enjs:format pct.cb)]])
          ==
      ==
  ==
::
++  dungeon-defs-to-json
  ^-  (list [@t json])
  %+  turn  ~(tap by dungeon-registry:bide-dungeons)
  |=  [did=dungeon-id dd=dungeon-def]
  ^-  [@t json]
  :-  did
  %-  pairs:enjs:format
  :~  ['name' [%s name.dd]]
      ['levelReq' (numb:enjs:format level-req.dd)]
      :-  'rooms'
      :-  %a
      %+  turn  rooms.dd
      |=  dr=dungeon-room
      %-  pairs:enjs:format
      :~  ['monster' [%s monster.dr]]
          ['qty' (numb:enjs:format qty.dr)]
      ==
      :-  'rewardTable'
      :-  %a
      %+  turn  reward-table.dd
      |=  le=loot-entry
      %-  pairs:enjs:format
      :~  ['item' [%s item.le]]
          ['minQty' (numb:enjs:format min-qty.le)]
          ['maxQty' (numb:enjs:format max-qty.le)]
          ['chance' (numb:enjs:format chance.le)]
      ==
  ==
--
