::  sur/bide.hoon — core type definitions for Bide (Melvor Idle on Urbit)
::
::  Phase 1+2: Woodcutting skill, Bank, basic infrastructure.
::  Designed for extension — new skills, combat, mastery, etc.
::
|%
::  ┌──────────────────────────────────────────────────────────┐
::  │  Atom aliases                                            │
::  └──────────────────────────────────────────────────────────┘
::
+$  skill-id     @tas                          ::  e.g. %woodcutting
+$  action-id    @tas                          ::  e.g. %cut-normal-logs
+$  item-id      @tas                          ::  e.g. %normal-logs
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Top-level game state                                    │
::  └──────────────────────────────────────────────────────────┘
::
+$  game-state
  $:  player=player-info                       ::  gold, hp, timestamps
      skills=(map skill-id skill-state)        ::  per-skill xp & level
      bank=bank-state                          ::  inventory of items
      equipment=equipment-state                ::  worn gear (stub)
      active-action=(unit active-action)       ::  what we're doing now
      stats=game-stats                         ::  lifetime counters
      last-tick=@da                            ::  last processed time
      rng-seed=@uvJ                            ::  PRNG state
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Player & skill state                                    │
::  └──────────────────────────────────────────────────────────┘
::
+$  player-info
  $:  gp=@ud                                   ::  gold pieces
      hitpoints-current=@ud
      hitpoints-max=@ud
      created=@da                              ::  account creation time
  ==
::
+$  skill-state
  $:  xp=@ud                                   ::  total experience
      level=@ud                                ::  current level (cached)
      mastery=mastery-state                    ::  mastery progress
  ==
::
+$  mastery-state
  $:  pool-xp=@ud                              ::  unspent mastery pool xp
      actions=(map action-id @ud)              ::  per-action mastery xp
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Active action — tagged union, extended per phase        │
::  └──────────────────────────────────────────────────────────┘
::
+$  active-action
  $%  [%skilling skill=skill-id target=action-id started=@da]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Bank                                                    │
::  └──────────────────────────────────────────────────────────┘
::
+$  bank-state
  $:  items=(map item-id @ud)                  ::  item-id -> quantity
      slots-max=@ud                            ::  max unique item slots
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Equipment (stub for Phase 1)                            │
::  └──────────────────────────────────────────────────────────┘
::
+$  equipment-state
  $:  active-set=@ud                           ::  equipment set index
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Stats tracking                                          │
::  └──────────────────────────────────────────────────────────┘
::
+$  game-stats
  $:  actions-completed=(map action-id @ud)    ::  lifetime action counts
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Player poke actions (agent input)                       │
::  └──────────────────────────────────────────────────────────┘
::
+$  action
  $%  [%start-skill skill=skill-id target=action-id]
      [%stop-skill ~]
      [%sell item=item-id qty=@ud]
      [%sell-all item=item-id]
      [%buy item=item-id qty=@ud]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Subscription updates (agent output)                     │
::  └──────────────────────────────────────────────────────────┘
::
+$  update
  $%  [%full-state game-state]
      [%skill-xp skill=skill-id xp=@ud level=@ud]
      [%item-gained item=item-id qty=@ud]
      [%item-consumed item=item-id qty=@ud]
      [%gp-changed gp=@ud delta=@sd]
      [%level-up skill=skill-id level=@ud]
      [%action-started skill=skill-id target=action-id]
      [%action-stopped ~]
      [%bank-changed items=(map item-id @ud)]
      [%toast message=@t]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Skill & action registry (static data definitions)       │
::  └──────────────────────────────────────────────────────────┘
::
+$  skill-type
  $?  %gathering                               ::  e.g. woodcutting, mining
      %artisan                                 ::  e.g. cooking, smithing
      %combat                                  ::  melee, ranged, magic
      %passive                                 ::  e.g. hitpoints
  ==
::
+$  skill-def
  $:  id=skill-id
      name=@t
      skill-type=skill-type
      max-level=@ud
      actions=(list action-def)
  ==
::
+$  action-def
  $:  id=action-id
      name=@t
      level-req=@ud                            ::  minimum skill level
      xp=@ud                                   ::  base xp per completion
      base-time=@ud                            ::  milliseconds per action
      inputs=(list [item=item-id qty=@ud])     ::  consumed per action
      outputs=(list output-def)                ::  produced per action
      mastery-xp=@ud                           ::  mastery xp per action
  ==
::
+$  output-def
  $:  item=item-id
      min-qty=@ud
      max-qty=@ud
      chance=@ud                               ::  percentage 0-100
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Item registry (static data definitions)                 │
::  └──────────────────────────────────────────────────────────┘
::
+$  item-category
  $?  %raw-material                            ::  logs, ore, fish
      %processed                               ::  planks, bars
      %equipment                               ::  weapons, armour
      %food                                    ::  cooked fish, etc
      %gem                                     ::  onyx, sapphire, etc
      %rune                                    ::  crafted runes
      %potion                                  ::  brewed potions
      %misc                                    ::  quest items, junk
  ==
::
+$  item-def
  $:  id=item-id
      name=@t
      description=@t
      category=item-category
      sell-price=@ud                           ::  gp from selling
  ==
--
