::  lib/bide-food.hoon — food healing amounts
::
::  Maps cooked food item-ids to HP healed per bite
::
/-  *bide
|%
::
++  food-registry
  ^-  (map item-id @ud)
  %-  ~(gas by *(map item-id @ud))
  :~  [%cooked-shrimp 30]
      [%cooked-sardine 50]
      [%cooked-herring 70]
      [%cooked-trout 100]
      [%cooked-salmon 130]
      [%cooked-lobster 160]
      [%cooked-swordfish 200]
      [%cooked-crab 220]
      [%cooked-shark 260]
      [%cooked-whale 300]
      [%cooked-anglerfish 320]
      ::  farming crops
      [%potato 20]
      [%onion 35]
      [%tomato 55]
      [%sweetcorn 80]
      [%strawberry 110]
      [%watermelon 150]
      [%snape-grass 200]
  ==
--
