::  lib/bide-areas.hoon — combat area definitions
::
::  6 areas grouping monsters by difficulty
::
/-  *bide
|%
::
++  area-registry
  ^-  (map area-id area-def)
  %-  ~(gas by *(map area-id area-def))
  :~  :-  %farmlands
      :*  id=%farmlands
          name='Farmlands'
          monsters=~[%chicken %goblin]
          level-req=1
      ==
      :-  %forest
      :*  id=%forest
          name='Forest'
          monsters=~[%rat %zombie]
          level-req=5
      ==
      :-  %caves
      :*  id=%caves
          name='Caves'
          monsters=~[%skeleton %giant-spider]
          level-req=15
      ==
      :-  %fortress
      :*  id=%fortress
          name='Fortress'
          monsters=~[%bandit %dark-knight]
          level-req=30
      ==
      :-  %deep-caverns
      :*  id=%deep-caverns
          name='Deep Caverns'
          monsters=~[%cave-troll %ogre]
          level-req=50
      ==
      :-  %volcanic-wastes
      :*  id=%volcanic-wastes
          name='Volcanic Wastes'
          monsters=~[%demon %fire-giant %dragon]
          level-req=70
      ==
  ==
--
