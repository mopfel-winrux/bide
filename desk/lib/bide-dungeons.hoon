::  lib/bide-dungeons.hoon — dungeon definitions
::
/-  *bide
|%
::
++  dungeon-registry
  ^-  (map dungeon-id dungeon-def)
  %-  ~(gas by *(map dungeon-id dungeon-def))
  :~  :-  %goblin-lair
      :*  id=%goblin-lair
          name='Goblin Lair'
          rooms=~[[monster=%goblin qty=5] [monster=%zombie qty=3] [monster=%skeleton qty=1]]
          level-req=10
          reward-table=~[[item=%bronze-bar min-qty=3 max-qty=5 chance=50] [item=%iron-bar min-qty=1 max-qty=3 chance=30]]
      ==
      :-  %dark-fortress
      :*  id=%dark-fortress
          name='Dark Fortress'
          rooms=~[[monster=%bandit qty=5] [monster=%dark-knight qty=3] [monster=%cave-troll qty=2] [monster=%ogre qty=1]]
          level-req=40
          reward-table=~[[item=%mithril-bar min-qty=2 max-qty=3 chance=40] [item=%adamantite-bar min-qty=1 max-qty=2 chance=25]]
      ==
      :-  %dragons-den
      :*  id=%dragons-den
          name='Dragons Den'
          rooms=~[[monster=%fire-giant qty=3] [monster=%demon qty=2] [monster=%dragon qty=1]]
          level-req=80
          reward-table=~[[item=%runite-bar min-qty=2 max-qty=3 chance=30] [item=%dragonite-bar min-qty=1 max-qty=1 chance=15] [item=%onyx min-qty=1 max-qty=1 chance=5]]
      ==
  ==
::
::  Get the monster for a given room index
::
++  room-monster
  |=  [dung=dungeon-def idx=@ud]
  ^-  (unit monster-id)
  =/  rooms=(list dungeon-room)  rooms.dung
  |-
  ?~  rooms  ~
  ?:  =(idx 0)  `monster.i.rooms
  $(rooms t.rooms, idx (dec idx))
::
::  Get kill count required for a room
::
++  room-kill-count
  |=  [dung=dungeon-def idx=@ud]
  ^-  (unit @ud)
  =/  rooms=(list dungeon-room)  rooms.dung
  |-
  ?~  rooms  ~
  ?:  =(idx 0)  `qty.i.rooms
  $(rooms t.rooms, idx (dec idx))
::
::  Total number of rooms
::
++  room-count
  |=  dung=dungeon-def
  ^-  @ud
  (lent rooms.dung)
--
