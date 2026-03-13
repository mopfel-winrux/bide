::  lib/bide-farming.hoon — farming seed registry and plot helpers
::
/-  *bide
|%
::
+$  farm-seed-def
  $:  level=@ud
      growth-time=@ud                          ::  ms to fully grow
      xp=@ud
      crop=item-id
      min-yield=@ud
      max-yield=@ud
  ==
::
++  seed-registry
  ^-  (map item-id farm-seed-def)
  %-  ~(gas by *(map item-id farm-seed-def))
  :~  ::  allotment seeds
      [%potato-seed [level=1 growth-time=120.000 xp=80 crop=%potato min-yield=3 max-yield=5]]
      [%onion-seed [level=5 growth-time=300.000 xp=150 crop=%onion min-yield=3 max-yield=5]]
      [%tomato-seed [level=12 growth-time=600.000 xp=280 crop=%tomato min-yield=3 max-yield=5]]
      [%sweetcorn-seed [level=20 growth-time=900.000 xp=450 crop=%sweetcorn min-yield=3 max-yield=5]]
      [%strawberry-seed [level=31 growth-time=1.500.000 xp=700 crop=%strawberry min-yield=3 max-yield=5]]
      [%watermelon-seed [level=47 growth-time=2.400.000 xp=1.100 crop=%watermelon min-yield=3 max-yield=5]]
      [%snape-grass-seed [level=61 growth-time=3.600.000 xp=1.600 crop=%snape-grass min-yield=3 max-yield=5]]
      ::  herb seeds
      [%guam-seed [level=9 growth-time=180.000 xp=110 crop=%grimy-guam min-yield=1 max-yield=3]]
      [%marrentill-seed [level=14 growth-time=480.000 xp=250 crop=%grimy-marrentill min-yield=1 max-yield=3]]
      [%tarromin-seed [level=19 growth-time=900.000 xp=400 crop=%grimy-tarromin min-yield=1 max-yield=3]]
      [%harralander-seed [level=26 growth-time=1.500.000 xp=650 crop=%grimy-harralander min-yield=1 max-yield=3]]
      [%ranarr-seed [level=32 growth-time=2.400.000 xp=1.000 crop=%grimy-ranarr min-yield=1 max-yield=3]]
      [%irit-seed [level=44 growth-time=3.600.000 xp=1.500 crop=%grimy-irit min-yield=1 max-yield=3]]
      [%kwuarm-seed [level=56 growth-time=5.400.000 xp=2.200 crop=%grimy-kwuarm min-yield=1 max-yield=3]]
      [%torstol-seed [level=73 growth-time=7.200.000 xp=3.500 crop=%grimy-torstol min-yield=1 max-yield=3]]
  ==
::
++  max-plots
  |=  farming-level=@ud
  ^-  @ud
  =/  base=@ud  2
  =?  base  (gte farming-level 15)  (add base 1)
  =?  base  (gte farming-level 30)  (add base 1)
  =?  base  (gte farming-level 50)  (add base 1)
  =?  base  (gte farming-level 70)  (add base 1)
  =?  base  (gte farming-level 85)  (add base 1)
  (min base 8)
::
++  ensure-plots
  |=  [plots=(list (unit farm-plot)) farming-level=@ud]
  ^-  (list (unit farm-plot))
  =/  target=@ud  (max-plots farming-level)
  =/  current=@ud  (lent plots)
  ?:  (gte current target)  plots
  %+  weld  plots
  ^-  (list (unit farm-plot))
  (reap (sub target current) *(unit farm-plot))
--
