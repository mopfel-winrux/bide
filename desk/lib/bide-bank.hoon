::  lib/bide-bank.hoon — bank item manipulation helpers
::
/-  *bide
|%
::
::  Remove qty of an item from bank, delete entry if zero
::
++  consume
  |=  [bank=(map item-id @ud) =item-id qty=@ud]
  ^-  (map item-id @ud)
  =/  have=@ud  (fall (~(get by bank) item-id) 0)
  ?.  (gte have qty)  bank
  =/  remaining=@ud  (sub have qty)
  ?:  =(remaining 0)
    (~(del by bank) item-id)
  (~(put by bank) item-id remaining)
::
::  Add a list of [item-id qty] pairs to bank
::
++  deposit
  |=  [bank=(map item-id @ud) items=(list [item-id @ud])]
  ^-  (map item-id @ud)
  ?~  items  bank
  =/  cur=@ud  (fall (~(get by bank) -.i.items) 0)
  $(items t.items, bank (~(put by bank) -.i.items (add cur +.i.items)))
::
++  ms-per
  ^-  @dr
  (div ~s1 1.000)
--
