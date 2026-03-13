::  lib/bide/data/items.hoon — item definitions
::
::  Phase 2: Woodcutting logs and starter equipment
::
/-  *bide
|%
::
++  item-registry
  ^-  (map item-id item-def)
  %-  ~(gas by *(map item-id item-def))
  :~  ::  woodcutting
      [%normal-logs normal-logs-def]
      [%oak-logs oak-logs-def]
      [%willow-logs willow-logs-def]
      [%teak-logs teak-logs-def]
      [%maple-logs maple-logs-def]
      [%mahogany-logs mahogany-logs-def]
      [%yew-logs yew-logs-def]
      [%magic-logs magic-logs-def]
      [%redwood-logs redwood-logs-def]
      ::  fishing
      [%raw-shrimp raw-shrimp-def]
      [%raw-sardine raw-sardine-def]
      [%raw-herring raw-herring-def]
      [%raw-trout raw-trout-def]
      [%raw-salmon raw-salmon-def]
      [%raw-lobster raw-lobster-def]
      [%raw-swordfish raw-swordfish-def]
      [%raw-crab raw-crab-def]
      [%raw-shark raw-shark-def]
      [%raw-whale raw-whale-def]
      [%raw-anglerfish raw-anglerfish-def]
      ::  mining
      [%copper-ore copper-ore-def]
      [%tin-ore tin-ore-def]
      [%iron-ore iron-ore-def]
      [%coal-ore coal-ore-def]
      [%silver-ore silver-ore-def]
      [%gold-ore gold-ore-def]
      [%mithril-ore mithril-ore-def]
      [%adamantite-ore adamantite-ore-def]
      [%runite-ore runite-ore-def]
      [%dragonite-ore dragonite-ore-def]
      [%onyx onyx-def]
      ::  thieving
      [%gp-pouch-small gp-pouch-small-def]
      [%gp-pouch-medium gp-pouch-medium-def]
      [%gp-pouch-large gp-pouch-large-def]
      [%gp-pouch-huge gp-pouch-huge-def]
      [%gp-pouch-royal gp-pouch-royal-def]
      [%gp-pouch-dragon gp-pouch-dragon-def]
      ::  firemaking
      [%charcoal charcoal-def]
      ::  cooking
      [%cooked-shrimp cooked-shrimp-def]
      [%cooked-sardine cooked-sardine-def]
      [%cooked-herring cooked-herring-def]
      [%cooked-trout cooked-trout-def]
      [%cooked-salmon cooked-salmon-def]
      [%cooked-lobster cooked-lobster-def]
      [%cooked-swordfish cooked-swordfish-def]
      [%cooked-crab cooked-crab-def]
      [%cooked-shark cooked-shark-def]
      [%cooked-whale cooked-whale-def]
      [%cooked-anglerfish cooked-anglerfish-def]
      ::  smithing
      [%bronze-bar bronze-bar-def]
      [%iron-bar iron-bar-def]
      [%silver-bar silver-bar-def]
      [%gold-bar gold-bar-def]
      [%steel-bar steel-bar-def]
      [%mithril-bar mithril-bar-def]
      [%adamantite-bar adamantite-bar-def]
      [%runite-bar runite-bar-def]
      [%dragonite-bar dragonite-bar-def]
      ::  fletching — bows
      [%normal-shortbow normal-shortbow-def]
      [%normal-longbow normal-longbow-def]
      [%oak-shortbow oak-shortbow-def]
      [%oak-longbow oak-longbow-def]
      [%willow-shortbow willow-shortbow-def]
      [%willow-longbow willow-longbow-def]
      [%maple-shortbow maple-shortbow-def]
      [%maple-longbow maple-longbow-def]
      [%yew-shortbow yew-shortbow-def]
      [%yew-longbow yew-longbow-def]
      [%magic-shortbow magic-shortbow-def]
      [%magic-longbow magic-longbow-def]
      [%redwood-shortbow redwood-shortbow-def]
      [%redwood-longbow redwood-longbow-def]
      ::  crafting — armor
      [%bronze-helmet bronze-helmet-def]
      [%bronze-platebody bronze-platebody-def]
      [%iron-helmet iron-helmet-def]
      [%iron-platebody iron-platebody-def]
      [%steel-helmet steel-helmet-def]
      [%steel-platebody steel-platebody-def]
      [%mithril-helmet mithril-helmet-def]
      [%mithril-platebody mithril-platebody-def]
      [%adamantite-helmet adamantite-helmet-def]
      [%adamantite-platebody adamantite-platebody-def]
      [%runite-helmet runite-helmet-def]
      [%runite-platebody runite-platebody-def]
      [%dragonite-helmet dragonite-helmet-def]
      [%dragonite-platebody dragonite-platebody-def]
      ::  runecrafting
      [%rune-essence rune-essence-def]
      [%air-rune air-rune-def]
      [%water-rune water-rune-def]
      [%earth-rune earth-rune-def]
      [%fire-rune fire-rune-def]
      [%mind-rune mind-rune-def]
      [%chaos-rune chaos-rune-def]
      [%death-rune death-rune-def]
      [%blood-rune blood-rune-def]
      [%soul-rune soul-rune-def]
      [%ancient-rune ancient-rune-def]
      ::  herblore
      [%grimy-guam grimy-guam-def]
      [%grimy-marrentill grimy-marrentill-def]
      [%grimy-tarromin grimy-tarromin-def]
      [%grimy-harralander grimy-harralander-def]
      [%grimy-ranarr grimy-ranarr-def]
      [%grimy-irit grimy-irit-def]
      [%grimy-kwuarm grimy-kwuarm-def]
      [%grimy-torstol grimy-torstol-def]
      [%vial-of-water vial-of-water-def]
      [%attack-potion attack-potion-def]
      [%strength-potion strength-potion-def]
      [%defence-potion defence-potion-def]
      [%hitpoints-potion hitpoints-potion-def]
      [%prayer-potion prayer-potion-def]
      [%super-attack-potion super-attack-potion-def]
      [%super-strength-potion super-strength-potion-def]
      [%super-defence-potion super-defence-potion-def]
      ::  equipment
      [%bronze-sword bronze-sword-def]
      [%wooden-shield wooden-shield-def]
      ::  farming seeds
      [%potato-seed potato-seed-def]
      [%onion-seed onion-seed-def]
      [%tomato-seed tomato-seed-def]
      [%sweetcorn-seed sweetcorn-seed-def]
      [%strawberry-seed strawberry-seed-def]
      [%watermelon-seed watermelon-seed-def]
      [%snape-grass-seed snape-grass-seed-def]
      [%guam-seed guam-seed-def]
      [%marrentill-seed marrentill-seed-def]
      [%tarromin-seed tarromin-seed-def]
      [%harralander-seed harralander-seed-def]
      [%ranarr-seed ranarr-seed-def]
      [%irit-seed irit-seed-def]
      [%kwuarm-seed kwuarm-seed-def]
      [%torstol-seed torstol-seed-def]
      ::  farming crops
      [%potato potato-def]
      [%onion onion-def]
      [%tomato tomato-def]
      [%sweetcorn sweetcorn-def]
      [%strawberry strawberry-def]
      [%watermelon watermelon-def]
      [%snape-grass snape-grass-def]
      ::  summoning tablets
      [%wolf-tablet wolf-tablet-def]
      [%hawk-tablet hawk-tablet-def]
      [%bear-tablet bear-tablet-def]
      [%serpent-tablet serpent-tablet-def]
      [%phoenix-tablet phoenix-tablet-def]
      [%dragon-tablet dragon-tablet-def]
      [%hydra-tablet hydra-tablet-def]
      [%titan-tablet titan-tablet-def]
      ::  enchanted bars (alt magic)
      [%enchanted-steel-bar enchanted-steel-bar-def]
      [%enchanted-mithril-bar enchanted-mithril-bar-def]
      [%enchanted-adamantite-bar enchanted-adamantite-bar-def]
      [%enchanted-runite-bar enchanted-runite-bar-def]
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Woodcutting logs                                        │
::  └──────────────────────────────────────────────────────────┘
::
++  normal-logs-def
  ^-  item-def
  :*  id=%normal-logs
      name='Normal Logs'
      description='Logs cut from a normal tree.'
      category=%raw-material
      sell-price=1
  ==
::
++  oak-logs-def
  ^-  item-def
  :*  id=%oak-logs
      name='Oak Logs'
      description='Logs cut from an oak tree.'
      category=%raw-material
      sell-price=25
  ==
::
++  willow-logs-def
  ^-  item-def
  :*  id=%willow-logs
      name='Willow Logs'
      description='Logs cut from a willow tree.'
      category=%raw-material
      sell-price=50
  ==
::
++  teak-logs-def
  ^-  item-def
  :*  id=%teak-logs
      name='Teak Logs'
      description='Logs cut from a teak tree.'
      category=%raw-material
      sell-price=75
  ==
::
++  maple-logs-def
  ^-  item-def
  :*  id=%maple-logs
      name='Maple Logs'
      description='Logs cut from a maple tree.'
      category=%raw-material
      sell-price=100
  ==
::
++  mahogany-logs-def
  ^-  item-def
  :*  id=%mahogany-logs
      name='Mahogany Logs'
      description='Logs cut from a mahogany tree.'
      category=%raw-material
      sell-price=150
  ==
::
++  yew-logs-def
  ^-  item-def
  :*  id=%yew-logs
      name='Yew Logs'
      description='Logs cut from a yew tree.'
      category=%raw-material
      sell-price=200
  ==
::
++  magic-logs-def
  ^-  item-def
  :*  id=%magic-logs
      name='Magic Logs'
      description='Logs cut from a magic tree.'
      category=%raw-material
      sell-price=500
  ==
::
++  redwood-logs-def
  ^-  item-def
  :*  id=%redwood-logs
      name='Redwood Logs'
      description='Logs cut from a redwood tree.'
      category=%raw-material
      sell-price=750
  ==
::  ┌──────────────────────────────────────────────────────────┐
::  │  Fishing — raw fish                                       │
::  └──────────────────────────────────────────────────────────┘
::
++  raw-shrimp-def
  ^-  item-def
  [id=%raw-shrimp name='Raw Shrimp' description='A small shrimp.' category=%raw-material sell-price=1]
++  raw-sardine-def
  ^-  item-def
  [id=%raw-sardine name='Raw Sardine' description='A fresh sardine.' category=%raw-material sell-price=4]
++  raw-herring-def
  ^-  item-def
  [id=%raw-herring name='Raw Herring' description='A fresh herring.' category=%raw-material sell-price=8]
++  raw-trout-def
  ^-  item-def
  [id=%raw-trout name='Raw Trout' description='A fresh trout.' category=%raw-material sell-price=20]
++  raw-salmon-def
  ^-  item-def
  [id=%raw-salmon name='Raw Salmon' description='A fresh salmon.' category=%raw-material sell-price=40]
++  raw-lobster-def
  ^-  item-def
  [id=%raw-lobster name='Raw Lobster' description='A fresh lobster.' category=%raw-material sell-price=80]
++  raw-swordfish-def
  ^-  item-def
  [id=%raw-swordfish name='Raw Swordfish' description='A raw swordfish.' category=%raw-material sell-price=150]
++  raw-crab-def
  ^-  item-def
  [id=%raw-crab name='Raw Crab' description='A large raw crab.' category=%raw-material sell-price=200]
++  raw-shark-def
  ^-  item-def
  [id=%raw-shark name='Raw Shark' description='A raw shark.' category=%raw-material sell-price=300]
++  raw-whale-def
  ^-  item-def
  [id=%raw-whale name='Raw Whale' description='A massive chunk of raw whale.' category=%raw-material sell-price=600]
++  raw-anglerfish-def
  ^-  item-def
  [id=%raw-anglerfish name='Raw Anglerfish' description='A rare anglerfish.' category=%raw-material sell-price=900]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Mining — ores and gems                                   │
::  └──────────────────────────────────────────────────────────┘
::
++  copper-ore-def
  ^-  item-def
  [id=%copper-ore name='Copper Ore' description='Unrefined copper.' category=%raw-material sell-price=2]
++  tin-ore-def
  ^-  item-def
  [id=%tin-ore name='Tin Ore' description='Unrefined tin.' category=%raw-material sell-price=2]
++  iron-ore-def
  ^-  item-def
  [id=%iron-ore name='Iron Ore' description='Unrefined iron.' category=%raw-material sell-price=15]
++  coal-ore-def
  ^-  item-def
  [id=%coal-ore name='Coal' description='A lump of coal.' category=%raw-material sell-price=25]
++  silver-ore-def
  ^-  item-def
  [id=%silver-ore name='Silver Ore' description='Unrefined silver.' category=%raw-material sell-price=30]
++  gold-ore-def
  ^-  item-def
  [id=%gold-ore name='Gold Ore' description='Unrefined gold.' category=%raw-material sell-price=60]
++  mithril-ore-def
  ^-  item-def
  [id=%mithril-ore name='Mithril Ore' description='Unrefined mithril.' category=%raw-material sell-price=100]
++  adamantite-ore-def
  ^-  item-def
  [id=%adamantite-ore name='Adamantite Ore' description='Unrefined adamantite.' category=%raw-material sell-price=175]
++  runite-ore-def
  ^-  item-def
  [id=%runite-ore name='Runite Ore' description='Unrefined runite.' category=%raw-material sell-price=350]
++  dragonite-ore-def
  ^-  item-def
  [id=%dragonite-ore name='Dragonite Ore' description='Rare dragonite ore.' category=%raw-material sell-price=700]
++  onyx-def
  ^-  item-def
  [id=%onyx name='Onyx' description='A precious onyx gem.' category=%gem sell-price=1.500]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Thieving — GP pouches                                    │
::  └──────────────────────────────────────────────────────────┘
::
++  gp-pouch-small-def
  ^-  item-def
  [id=%gp-pouch-small name='Small GP Pouch' description='A small pouch of coins.' category=%misc sell-price=10]
++  gp-pouch-medium-def
  ^-  item-def
  [id=%gp-pouch-medium name='Medium GP Pouch' description='A pouch of coins.' category=%misc sell-price=30]
++  gp-pouch-large-def
  ^-  item-def
  [id=%gp-pouch-large name='Large GP Pouch' description='A large pouch of coins.' category=%misc sell-price=75]
++  gp-pouch-huge-def
  ^-  item-def
  [id=%gp-pouch-huge name='Huge GP Pouch' description='A huge pouch of coins.' category=%misc sell-price=200]
++  gp-pouch-royal-def
  ^-  item-def
  [id=%gp-pouch-royal name='Royal GP Pouch' description='A royal pouch of coins.' category=%misc sell-price=500]
++  gp-pouch-dragon-def
  ^-  item-def
  [id=%gp-pouch-dragon name='Dragon GP Pouch' description='A dragon-hide pouch overflowing with coins.' category=%misc sell-price=1.500]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Firemaking — charcoal                                    │
::  └──────────────────────────────────────────────────────────┘
::
++  charcoal-def
  ^-  item-def
  [id=%charcoal name='Charcoal' description='A lump of charcoal.' category=%raw-material sell-price=5]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Cooking — cooked fish                                    │
::  └──────────────────────────────────────────────────────────┘
::
++  cooked-shrimp-def
  ^-  item-def
  [id=%cooked-shrimp name='Cooked Shrimp' description='A cooked shrimp.' category=%food sell-price=3]
++  cooked-sardine-def
  ^-  item-def
  [id=%cooked-sardine name='Cooked Sardine' description='A cooked sardine.' category=%food sell-price=10]
++  cooked-herring-def
  ^-  item-def
  [id=%cooked-herring name='Cooked Herring' description='A cooked herring.' category=%food sell-price=20]
++  cooked-trout-def
  ^-  item-def
  [id=%cooked-trout name='Cooked Trout' description='A cooked trout.' category=%food sell-price=50]
++  cooked-salmon-def
  ^-  item-def
  [id=%cooked-salmon name='Cooked Salmon' description='A cooked salmon.' category=%food sell-price=100]
++  cooked-lobster-def
  ^-  item-def
  [id=%cooked-lobster name='Cooked Lobster' description='A cooked lobster.' category=%food sell-price=200]
++  cooked-swordfish-def
  ^-  item-def
  [id=%cooked-swordfish name='Cooked Swordfish' description='A cooked swordfish.' category=%food sell-price=375]
++  cooked-crab-def
  ^-  item-def
  [id=%cooked-crab name='Cooked Crab' description='A cooked crab.' category=%food sell-price=500]
++  cooked-shark-def
  ^-  item-def
  [id=%cooked-shark name='Cooked Shark' description='A cooked shark.' category=%food sell-price=750]
++  cooked-whale-def
  ^-  item-def
  [id=%cooked-whale name='Cooked Whale' description='A massive cooked whale steak.' category=%food sell-price=1.500]
++  cooked-anglerfish-def
  ^-  item-def
  [id=%cooked-anglerfish name='Cooked Anglerfish' description='A cooked anglerfish.' category=%food sell-price=2.250]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Smithing — metal bars                                    │
::  └──────────────────────────────────────────────────────────┘
::
++  bronze-bar-def
  ^-  item-def
  [id=%bronze-bar name='Bronze Bar' description='A bar of bronze.' category=%processed sell-price=12]
++  iron-bar-def
  ^-  item-def
  [id=%iron-bar name='Iron Bar' description='A bar of iron.' category=%processed sell-price=45]
++  silver-bar-def
  ^-  item-def
  [id=%silver-bar name='Silver Bar' description='A bar of silver.' category=%processed sell-price=75]
++  gold-bar-def
  ^-  item-def
  [id=%gold-bar name='Gold Bar' description='A bar of gold.' category=%processed sell-price=150]
++  steel-bar-def
  ^-  item-def
  [id=%steel-bar name='Steel Bar' description='A bar of steel.' category=%processed sell-price=110]
++  mithril-bar-def
  ^-  item-def
  [id=%mithril-bar name='Mithril Bar' description='A bar of mithril.' category=%processed sell-price=250]
++  adamantite-bar-def
  ^-  item-def
  [id=%adamantite-bar name='Adamantite Bar' description='A bar of adamantite.' category=%processed sell-price=525]
++  runite-bar-def
  ^-  item-def
  [id=%runite-bar name='Runite Bar' description='A bar of runite.' category=%processed sell-price=1.100]
++  dragonite-bar-def
  ^-  item-def
  [id=%dragonite-bar name='Dragonite Bar' description='A bar of dragonite.' category=%processed sell-price=2.500]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Starter equipment                                       │
::  └──────────────────────────────────────────────────────────┘
::
++  bronze-sword-def
  ^-  item-def
  :*  id=%bronze-sword
      name='Bronze Sword'
      description='A simple bronze sword.'
      category=%equipment
      sell-price=14
  ==
::
++  wooden-shield-def
  ^-  item-def
  :*  id=%wooden-shield
      name='Wooden Shield'
      description='A basic wooden shield.'
      category=%equipment
      sell-price=10
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Fletching — bows                                        │
::  └──────────────────────────────────────────────────────────┘
::
++  normal-shortbow-def
  ^-  item-def
  [id=%normal-shortbow name='Normal Shortbow' description='A simple shortbow.' category=%equipment sell-price=5]
++  normal-longbow-def
  ^-  item-def
  [id=%normal-longbow name='Normal Longbow' description='A simple longbow.' category=%equipment sell-price=8]
++  oak-shortbow-def
  ^-  item-def
  [id=%oak-shortbow name='Oak Shortbow' description='A shortbow made of oak.' category=%equipment sell-price=55]
++  oak-longbow-def
  ^-  item-def
  [id=%oak-longbow name='Oak Longbow' description='A longbow made of oak.' category=%equipment sell-price=130]
++  willow-shortbow-def
  ^-  item-def
  [id=%willow-shortbow name='Willow Shortbow' description='A shortbow made of willow.' category=%equipment sell-price=110]
++  willow-longbow-def
  ^-  item-def
  [id=%willow-longbow name='Willow Longbow' description='A longbow made of willow.' category=%equipment sell-price=260]
++  maple-shortbow-def
  ^-  item-def
  [id=%maple-shortbow name='Maple Shortbow' description='A shortbow made of maple.' category=%equipment sell-price=225]
++  maple-longbow-def
  ^-  item-def
  [id=%maple-longbow name='Maple Longbow' description='A longbow made of maple.' category=%equipment sell-price=525]
++  yew-shortbow-def
  ^-  item-def
  [id=%yew-shortbow name='Yew Shortbow' description='A shortbow made of yew.' category=%equipment sell-price=450]
++  yew-longbow-def
  ^-  item-def
  [id=%yew-longbow name='Yew Longbow' description='A longbow made of yew.' category=%equipment sell-price=1.050]
++  magic-shortbow-def
  ^-  item-def
  [id=%magic-shortbow name='Magic Shortbow' description='A shortbow made of magic wood.' category=%equipment sell-price=1.100]
++  magic-longbow-def
  ^-  item-def
  [id=%magic-longbow name='Magic Longbow' description='A longbow made of magic wood.' category=%equipment sell-price=2.600]
++  redwood-shortbow-def
  ^-  item-def
  [id=%redwood-shortbow name='Redwood Shortbow' description='A shortbow made of redwood.' category=%equipment sell-price=1.650]
++  redwood-longbow-def
  ^-  item-def
  [id=%redwood-longbow name='Redwood Longbow' description='A longbow made of redwood.' category=%equipment sell-price=3.900]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Crafting — armor                                        │
::  └──────────────────────────────────────────────────────────┘
::
++  bronze-helmet-def
  ^-  item-def
  [id=%bronze-helmet name='Bronze Helmet' description='A helmet made of bronze.' category=%equipment sell-price=60]
++  bronze-platebody-def
  ^-  item-def
  [id=%bronze-platebody name='Bronze Platebody' description='A platebody made of bronze.' category=%equipment sell-price=135]
++  iron-helmet-def
  ^-  item-def
  [id=%iron-helmet name='Iron Helmet' description='A helmet made of iron.' category=%equipment sell-price=225]
++  iron-platebody-def
  ^-  item-def
  [id=%iron-platebody name='Iron Platebody' description='A platebody made of iron.' category=%equipment sell-price=500]
++  steel-helmet-def
  ^-  item-def
  [id=%steel-helmet name='Steel Helmet' description='A helmet made of steel.' category=%equipment sell-price=550]
++  steel-platebody-def
  ^-  item-def
  [id=%steel-platebody name='Steel Platebody' description='A platebody made of steel.' category=%equipment sell-price=1.200]
++  mithril-helmet-def
  ^-  item-def
  [id=%mithril-helmet name='Mithril Helmet' description='A helmet made of mithril.' category=%equipment sell-price=1.250]
++  mithril-platebody-def
  ^-  item-def
  [id=%mithril-platebody name='Mithril Platebody' description='A platebody made of mithril.' category=%equipment sell-price=2.750]
++  adamantite-helmet-def
  ^-  item-def
  [id=%adamantite-helmet name='Adamantite Helmet' description='A helmet made of adamantite.' category=%equipment sell-price=2.625]
++  adamantite-platebody-def
  ^-  item-def
  [id=%adamantite-platebody name='Adamantite Platebody' description='A platebody made of adamantite.' category=%equipment sell-price=5.775]
++  runite-helmet-def
  ^-  item-def
  [id=%runite-helmet name='Runite Helmet' description='A helmet made of runite.' category=%equipment sell-price=5.500]
++  runite-platebody-def
  ^-  item-def
  [id=%runite-platebody name='Runite Platebody' description='A platebody made of runite.' category=%equipment sell-price=12.100]
++  dragonite-helmet-def
  ^-  item-def
  [id=%dragonite-helmet name='Dragonite Helmet' description='A helmet made of dragonite.' category=%equipment sell-price=12.500]
++  dragonite-platebody-def
  ^-  item-def
  [id=%dragonite-platebody name='Dragonite Platebody' description='A platebody made of dragonite.' category=%equipment sell-price=27.500]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Runecrafting — rune essence and runes                   │
::  └──────────────────────────────────────────────────────────┘
::
++  rune-essence-def
  ^-  item-def
  [id=%rune-essence name='Rune Essence' description='A blank rune essence.' category=%raw-material sell-price=1]
++  air-rune-def
  ^-  item-def
  [id=%air-rune name='Air Rune' description='A rune of air.' category=%rune sell-price=2]
++  water-rune-def
  ^-  item-def
  [id=%water-rune name='Water Rune' description='A rune of water.' category=%rune sell-price=4]
++  earth-rune-def
  ^-  item-def
  [id=%earth-rune name='Earth Rune' description='A rune of earth.' category=%rune sell-price=7]
++  fire-rune-def
  ^-  item-def
  [id=%fire-rune name='Fire Rune' description='A rune of fire.' category=%rune sell-price=12]
++  mind-rune-def
  ^-  item-def
  [id=%mind-rune name='Mind Rune' description='A rune of mind.' category=%rune sell-price=22]
++  chaos-rune-def
  ^-  item-def
  [id=%chaos-rune name='Chaos Rune' description='A rune of chaos.' category=%rune sell-price=40]
++  death-rune-def
  ^-  item-def
  [id=%death-rune name='Death Rune' description='A rune of death.' category=%rune sell-price=75]
++  blood-rune-def
  ^-  item-def
  [id=%blood-rune name='Blood Rune' description='A rune of blood.' category=%rune sell-price=140]
++  soul-rune-def
  ^-  item-def
  [id=%soul-rune name='Soul Rune' description='A rune of the soul.' category=%rune sell-price=275]
++  ancient-rune-def
  ^-  item-def
  [id=%ancient-rune name='Ancient Rune' description='An ancient rune of great power.' category=%rune sell-price=500]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Herblore — herbs, vials, and potions                    │
::  └──────────────────────────────────────────────────────────┘
::
++  grimy-guam-def
  ^-  item-def
  [id=%grimy-guam name='Grimy Guam' description='A grimy guam herb.' category=%raw-material sell-price=5]
++  grimy-marrentill-def
  ^-  item-def
  [id=%grimy-marrentill name='Grimy Marrentill' description='A grimy marrentill herb.' category=%raw-material sell-price=15]
++  grimy-tarromin-def
  ^-  item-def
  [id=%grimy-tarromin name='Grimy Tarromin' description='A grimy tarromin herb.' category=%raw-material sell-price=30]
++  grimy-harralander-def
  ^-  item-def
  [id=%grimy-harralander name='Grimy Harralander' description='A grimy harralander herb.' category=%raw-material sell-price=55]
++  grimy-ranarr-def
  ^-  item-def
  [id=%grimy-ranarr name='Grimy Ranarr' description='A grimy ranarr herb.' category=%raw-material sell-price=100]
++  grimy-irit-def
  ^-  item-def
  [id=%grimy-irit name='Grimy Irit' description='A grimy irit herb.' category=%raw-material sell-price=175]
++  grimy-kwuarm-def
  ^-  item-def
  [id=%grimy-kwuarm name='Grimy Kwuarm' description='A grimy kwuarm herb.' category=%raw-material sell-price=300]
++  grimy-torstol-def
  ^-  item-def
  [id=%grimy-torstol name='Grimy Torstol' description='A grimy torstol herb.' category=%raw-material sell-price=550]
++  vial-of-water-def
  ^-  item-def
  [id=%vial-of-water name='Vial of Water' description='A vial filled with water.' category=%misc sell-price=1]
++  attack-potion-def
  ^-  item-def
  [id=%attack-potion name='Attack Potion' description='A potion that boosts attack.' category=%potion sell-price=15]
++  strength-potion-def
  ^-  item-def
  [id=%strength-potion name='Strength Potion' description='A potion that boosts strength.' category=%potion sell-price=40]
++  defence-potion-def
  ^-  item-def
  [id=%defence-potion name='Defence Potion' description='A potion that boosts defence.' category=%potion sell-price=80]
++  hitpoints-potion-def
  ^-  item-def
  [id=%hitpoints-potion name='Hitpoints Potion' description='A potion that restores hitpoints.' category=%potion sell-price=150]
++  prayer-potion-def
  ^-  item-def
  [id=%prayer-potion name='Prayer Potion' description='A potion that restores prayer.' category=%potion sell-price=275]
++  super-attack-potion-def
  ^-  item-def
  [id=%super-attack-potion name='Super Attack Potion' description='A potent potion that boosts attack.' category=%potion sell-price=475]
++  super-strength-potion-def
  ^-  item-def
  [id=%super-strength-potion name='Super Strength Potion' description='A potent potion that boosts strength.' category=%potion sell-price=825]
++  super-defence-potion-def
  ^-  item-def
  [id=%super-defence-potion name='Super Defence Potion' description='A potent potion that boosts defence.' category=%potion sell-price=1.500]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Farming — seeds                                        │
::  └──────────────────────────────────────────────────────────┘
::
++  potato-seed-def
  ^-  item-def
  [id=%potato-seed name='Potato Seed' description='A seed for growing potatoes.' category=%seed sell-price=1]
++  onion-seed-def
  ^-  item-def
  [id=%onion-seed name='Onion Seed' description='A seed for growing onions.' category=%seed sell-price=3]
++  tomato-seed-def
  ^-  item-def
  [id=%tomato-seed name='Tomato Seed' description='A seed for growing tomatoes.' category=%seed sell-price=8]
++  sweetcorn-seed-def
  ^-  item-def
  [id=%sweetcorn-seed name='Sweetcorn Seed' description='A seed for growing sweetcorn.' category=%seed sell-price=15]
++  strawberry-seed-def
  ^-  item-def
  [id=%strawberry-seed name='Strawberry Seed' description='A seed for growing strawberries.' category=%seed sell-price=25]
++  watermelon-seed-def
  ^-  item-def
  [id=%watermelon-seed name='Watermelon Seed' description='A seed for growing watermelons.' category=%seed sell-price=50]
++  snape-grass-seed-def
  ^-  item-def
  [id=%snape-grass-seed name='Snape Grass Seed' description='A seed for growing snape grass.' category=%seed sell-price=100]
++  guam-seed-def
  ^-  item-def
  [id=%guam-seed name='Guam Seed' description='A seed for growing guam herbs.' category=%seed sell-price=5]
++  marrentill-seed-def
  ^-  item-def
  [id=%marrentill-seed name='Marrentill Seed' description='A seed for growing marrentill herbs.' category=%seed sell-price=10]
++  tarromin-seed-def
  ^-  item-def
  [id=%tarromin-seed name='Tarromin Seed' description='A seed for growing tarromin herbs.' category=%seed sell-price=20]
++  harralander-seed-def
  ^-  item-def
  [id=%harralander-seed name='Harralander Seed' description='A seed for growing harralander herbs.' category=%seed sell-price=35]
++  ranarr-seed-def
  ^-  item-def
  [id=%ranarr-seed name='Ranarr Seed' description='A seed for growing ranarr herbs.' category=%seed sell-price=60]
++  irit-seed-def
  ^-  item-def
  [id=%irit-seed name='Irit Seed' description='A seed for growing irit herbs.' category=%seed sell-price=100]
++  kwuarm-seed-def
  ^-  item-def
  [id=%kwuarm-seed name='Kwuarm Seed' description='A seed for growing kwuarm herbs.' category=%seed sell-price=175]
++  torstol-seed-def
  ^-  item-def
  [id=%torstol-seed name='Torstol Seed' description='A seed for growing torstol herbs.' category=%seed sell-price=300]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Farming — crops                                        │
::  └──────────────────────────────────────────────────────────┘
::
++  potato-def
  ^-  item-def
  [id=%potato name='Potato' description='A freshly harvested potato.' category=%food sell-price=5]
++  onion-def
  ^-  item-def
  [id=%onion name='Onion' description='A freshly harvested onion.' category=%food sell-price=10]
++  tomato-def
  ^-  item-def
  [id=%tomato name='Tomato' description='A ripe tomato.' category=%food sell-price=20]
++  sweetcorn-def
  ^-  item-def
  [id=%sweetcorn name='Sweetcorn' description='A golden ear of sweetcorn.' category=%food sell-price=35]
++  strawberry-def
  ^-  item-def
  [id=%strawberry name='Strawberry' description='A juicy strawberry.' category=%food sell-price=55]
++  watermelon-def
  ^-  item-def
  [id=%watermelon name='Watermelon' description='A large watermelon.' category=%food sell-price=100]
++  snape-grass-def
  ^-  item-def
  [id=%snape-grass name='Snape Grass' description='A tall blade of snape grass.' category=%food sell-price=175]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Summoning — tablets                                    │
::  └──────────────────────────────────────────────────────────┘
::
++  wolf-tablet-def
  ^-  item-def
  [id=%wolf-tablet name='Wolf Tablet' description='A tablet to summon a wolf familiar.' category=%tablet sell-price=25]
++  hawk-tablet-def
  ^-  item-def
  [id=%hawk-tablet name='Hawk Tablet' description='A tablet to summon a hawk familiar.' category=%tablet sell-price=75]
++  bear-tablet-def
  ^-  item-def
  [id=%bear-tablet name='Bear Tablet' description='A tablet to summon a bear familiar.' category=%tablet sell-price=150]
++  serpent-tablet-def
  ^-  item-def
  [id=%serpent-tablet name='Serpent Tablet' description='A tablet to summon a serpent familiar.' category=%tablet sell-price=300]
++  phoenix-tablet-def
  ^-  item-def
  [id=%phoenix-tablet name='Phoenix Tablet' description='A tablet to summon a phoenix familiar.' category=%tablet sell-price=600]
++  dragon-tablet-def
  ^-  item-def
  [id=%dragon-tablet name='Dragon Tablet' description='A tablet to summon a dragon familiar.' category=%tablet sell-price=1.200]
++  hydra-tablet-def
  ^-  item-def
  [id=%hydra-tablet name='Hydra Tablet' description='A tablet to summon a hydra familiar.' category=%tablet sell-price=2.500]
++  titan-tablet-def
  ^-  item-def
  [id=%titan-tablet name='Titan Tablet' description='A tablet to summon a titan familiar.' category=%tablet sell-price=5.000]
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Enchanted bars (Alt Magic)                              │
::  └──────────────────────────────────────────────────────────┘
::
++  enchanted-steel-bar-def
  ^-  item-def
  [id=%enchanted-steel-bar name='Enchanted Steel Bar' description='A magically enhanced steel bar.' category=%processed sell-price=330]
++  enchanted-mithril-bar-def
  ^-  item-def
  [id=%enchanted-mithril-bar name='Enchanted Mithril Bar' description='A magically enhanced mithril bar.' category=%processed sell-price=750]
++  enchanted-adamantite-bar-def
  ^-  item-def
  [id=%enchanted-adamantite-bar name='Enchanted Adamantite Bar' description='A magically enhanced adamantite bar.' category=%processed sell-price=1.575]
++  enchanted-runite-bar-def
  ^-  item-def
  [id=%enchanted-runite-bar name='Enchanted Runite Bar' description='A magically enhanced runite bar.' category=%processed sell-price=3.300]
--
