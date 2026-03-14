::  lib/bide-bank.hoon — bank item manipulation helpers
::
/-  *bide
|%
::
::  Remove qty of an item from bank, delete entry if zero
::
++  consume
  |=  [bk=(map item-id @ud) iid=item-id qty=@ud]
  ^-  (map item-id @ud)
  =/  have=@ud  (fall (~(get by bk) iid) 0)
  ?.  (gte have qty)  bk
  =/  remaining=@ud  (sub have qty)
  ?:  =(remaining 0)
    (~(del by bk) iid)
  (~(put by bk) iid remaining)
::
::  Add a list of [item-id qty] pairs to bank
::
++  deposit
  |=  [bk=(map item-id @ud) li=(list [item-id @ud])]
  ^-  (map item-id @ud)
  ?~  li  bk
  =/  cur=@ud  (fall (~(get by bk) -.i.li) 0)
  $(li t.li, bk (~(put by bk) -.i.li (add cur +.i.li)))
::
::  Milliseconds-per as @dr constant (used in time calculations)
::
++  ms-per
  ^-  @dr
  (div ~s1 1.000)
--
