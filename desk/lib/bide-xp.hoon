::  lib/bide/xp.hoon — XP and level calculation library for Bide
::
::  Hardcoded XP table matching the standard RuneScape/Melvor formula.
::  99 levels, index 0 = level 1 (0 XP), index 98 = level 99.
::
|%
::
::  XP thresholds: cumulative XP needed for each level (1-99).
::  Index 0 is level 1, index 1 is level 2, etc.
::
++  xp-table
  ^-  (list @ud)
  :~  0                ::  level 1
      83               ::  level 2
      174              ::  level 3
      276              ::  level 4
      388              ::  level 5
      512              ::  level 6
      650              ::  level 7
      801              ::  level 8
      969              ::  level 9
      1.154            ::  level 10
      1.358            ::  level 11
      1.584            ::  level 12
      1.833            ::  level 13
      2.107            ::  level 14
      2.411            ::  level 15
      2.746            ::  level 16
      3.115            ::  level 17
      3.523            ::  level 18
      3.973            ::  level 19
      4.470            ::  level 20
      5.018            ::  level 21
      5.624            ::  level 22
      6.291            ::  level 23
      7.028            ::  level 24
      7.842            ::  level 25
      8.740            ::  level 26
      9.730            ::  level 27
      10.824           ::  level 28
      12.031           ::  level 29
      13.363           ::  level 30
      14.833           ::  level 31
      16.456           ::  level 32
      18.247           ::  level 33
      20.224           ::  level 34
      22.406           ::  level 35
      24.815           ::  level 36
      27.473           ::  level 37
      30.408           ::  level 38
      33.648           ::  level 39
      37.224           ::  level 40
      41.171           ::  level 41
      45.529           ::  level 42
      50.339           ::  level 43
      55.649           ::  level 44
      61.512           ::  level 45
      67.983           ::  level 46
      75.127           ::  level 47
      83.014           ::  level 48
      91.721           ::  level 49
      101.333          ::  level 50
      111.945          ::  level 51
      123.660          ::  level 52
      136.594          ::  level 53
      150.872          ::  level 54
      166.636          ::  level 55
      184.040          ::  level 56
      203.254          ::  level 57
      224.466          ::  level 58
      247.886          ::  level 59
      273.742          ::  level 60
      302.288          ::  level 61
      333.804          ::  level 62
      368.599          ::  level 63
      407.015          ::  level 64
      449.428          ::  level 65
      496.254          ::  level 66
      547.953          ::  level 67
      605.032          ::  level 68
      668.051          ::  level 69
      737.627          ::  level 70
      814.445          ::  level 71
      899.257          ::  level 72
      992.895          ::  level 73
      1.096.278        ::  level 74
      1.210.421        ::  level 75
      1.336.443        ::  level 76
      1.475.581        ::  level 77
      1.629.200        ::  level 78
      1.798.808        ::  level 79
      1.986.068        ::  level 80
      2.192.818        ::  level 81
      2.421.087        ::  level 82
      2.673.114        ::  level 83
      2.951.373        ::  level 84
      3.258.594        ::  level 85
      3.597.792        ::  level 86
      3.972.294        ::  level 87
      4.385.776        ::  level 88
      4.842.295        ::  level 89
      5.346.332        ::  level 90
      5.902.831        ::  level 91
      6.517.253        ::  level 92
      7.195.629        ::  level 93
      7.944.614        ::  level 94
      8.771.558        ::  level 95
      9.684.577        ::  level 96
      10.692.629       ::  level 97
      11.805.606       ::  level 98
      13.034.431       ::  level 99
  ==
::
::  +level-from-xp: given total XP, return current level (1-99)
::
::  Walks the table from the top down; first entry where
::  our XP >= threshold is our level.
::
++  level-from-xp
  |=  xp=@ud
  ^-  @ud
  =/  tab  xp-table
  =/  lvl=@ud  99
  |-
  ?:  =(lvl 1)
    1
  =/  threshold  (snag (dec lvl) tab)
  ?:  (gte xp threshold)
    lvl
  $(lvl (dec lvl))
::
::  +xp-for-level: return the cumulative XP required for a given level
::
::  Level is clamped to 1-99.
::
++  xp-for-level
  |=  level=@ud
  ^-  @ud
  ?:  (lth level 1)  0
  ?:  (gth level 99)
    (snag 98 xp-table)
  (snag (dec level) xp-table)
::
::  +xp-to-next: given current XP, return XP remaining to next level
::
::  Returns 0 if already at level 99.
::
++  xp-to-next
  |=  xp=@ud
  ^-  @ud
  =/  current-level  (level-from-xp xp)
  ?:  (gte current-level 99)
    0
  =/  next-threshold  (snag current-level xp-table)
  (sub next-threshold xp)
--
