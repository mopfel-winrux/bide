::  lib/bide-shop.hoon — shop item registry
::
::  Maps item-ids to their buy prices.
::
/-  *bide
|%
::
++  shop-registry
  ^-  (map item-id @ud)
  %-  ~(gas by *(map item-id @ud))
  :~  ::  raw materials (2-3x sell)
      [%copper-ore 5]
      [%tin-ore 5]
      [%iron-ore 40]
      [%coal-ore 60]
      [%normal-logs 3]
      [%oak-logs 60]
      ::  runes (3x sell)
      [%air-rune 6]
      [%water-rune 12]
      [%earth-rune 21]
      [%fire-rune 36]
      [%mind-rune 66]
      [%chaos-rune 120]
      [%death-rune 225]
      [%blood-rune 420]
      [%soul-rune 825]
      [%ancient-rune 1.500]
      [%rune-essence 3]
      ::  seeds (3-4x sell)
      [%potato-seed 3]
      [%onion-seed 10]
      [%tomato-seed 25]
      [%sweetcorn-seed 50]
      [%strawberry-seed 85]
      [%watermelon-seed 175]
      [%snape-grass-seed 350]
      [%guam-seed 15]
      [%marrentill-seed 35]
      [%tarromin-seed 70]
      [%harralander-seed 120]
      [%ranarr-seed 200]
      [%irit-seed 350]
      [%kwuarm-seed 600]
      [%torstol-seed 1.000]
      [%avantoe-seed 250]
      [%lantadyme-seed 400]
      [%cadantine-seed 800]
      [%snapdragon-seed 1.500]
      ::  food (2x sell)
      [%cooked-shrimp 6]
      [%cooked-sardine 20]
      [%cooked-herring 40]
      [%cooked-trout 100]
      [%cooked-salmon 200]
      ::  misc
      [%vial-of-water 3]
      [%charcoal 15]
      ::  skill capes (1,000,000 GP each, level 99 required)
      [%woodcutting-cape 1.000.000]
      [%fishing-cape 1.000.000]
      [%mining-cape 1.000.000]
      [%thieving-cape 1.000.000]
      [%firemaking-cape 1.000.000]
      [%cooking-cape 1.000.000]
      [%smithing-cape 1.000.000]
      [%fletching-cape 1.000.000]
      [%crafting-cape 1.000.000]
      [%runecrafting-cape 1.000.000]
      [%herblore-cape 1.000.000]
      [%farming-cape 1.000.000]
      [%agility-cape 1.000.000]
      [%astrology-cape 1.000.000]
      [%summoning-cape 1.000.000]
      [%attack-cape 1.000.000]
      [%strength-cape 1.000.000]
      [%defence-cape 1.000.000]
      [%hitpoints-cape 1.000.000]
      [%ranged-cape 1.000.000]
      [%magic-cape 1.000.000]
      [%prayer-cape 1.000.000]
      [%slayer-cape 1.000.000]
      ::  arrows
      [%bronze-arrows 30]
      [%iron-arrows 90]
      [%steel-arrows 240]
      [%mithril-arrows 450]
      [%adamantite-arrows 900]
      [%runite-arrows 1.800]
      [%dragonite-arrows 3.600]
  ==
::
::  Skill upgrade tier definitions
::  Returns (price, bonus-pct) for a given tier (1-3)
::
++  skill-upgrade-price
  |=  [type=?(%xp %speed %preservation) tier=@ud]
  ^-  @ud
  ?-  type
    %xp
      ?:  =(tier 1)  100.000
      ?:  =(tier 2)  500.000
      2.000.000
    ?(%speed %preservation)
      ?:  =(tier 1)  150.000
      ?:  =(tier 2)  750.000
      3.000.000
  ==
::
++  skill-upgrade-bonus
  |=  [type=?(%xp %speed %preservation) tier=@ud]
  ^-  @ud
  ?-  type
    %xp
      ?:  =(tier 1)  3
      ?:  =(tier 2)  5
      8
    ?(%speed %preservation)
      ?:  =(tier 1)  3
      ?:  =(tier 2)  5
      8
  ==
::
::  Valid skill+type combinations
::  Gathering: xp + speed, Artisan: xp + preservation
::
++  valid-skill-upgrade
  |=  [skill=skill-id type=?(%xp %speed %preservation)]
  ^-  ?
  ?-  type
    %xp  (valid-upgrade-skill skill)
    %speed
      ?|  =(skill %woodcutting)
          =(skill %fishing)
          =(skill %mining)
          =(skill %thieving)
          =(skill %firemaking)
      ==
    %preservation
      ?|  =(skill %cooking)
          =(skill %smithing)
          =(skill %fletching)
          =(skill %crafting)
          =(skill %runecrafting)
          =(skill %herblore)
      ==
  ==
::
++  valid-upgrade-skill
  |=  skill=skill-id
  ^-  ?
  ?|  =(skill %woodcutting)
      =(skill %fishing)
      =(skill %mining)
      =(skill %thieving)
      =(skill %firemaking)
      =(skill %cooking)
      =(skill %smithing)
      =(skill %fletching)
      =(skill %crafting)
      =(skill %runecrafting)
      =(skill %herblore)
  ==
::
++  multitree-price  ^-  @ud  1.000.000
--
