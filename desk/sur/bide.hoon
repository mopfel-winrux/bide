::  sur/bide.hoon — core type definitions for Bide (Melvor Idle on Urbit)
::
::  Phase 1-5: Skills, Bank, Equipment, Combat
::
|%
::  ┌──────────────────────────────────────────────────────────┐
::  │  Atom aliases                                            │
::  └──────────────────────────────────────────────────────────┘
::
+$  skill-id     @tas                          ::  e.g. %woodcutting
+$  action-id    @tas                          ::  e.g. %cut-normal-logs
+$  item-id      @tas                          ::  e.g. %normal-logs
+$  monster-id   @tas                          ::  e.g. %chicken
+$  area-id      @tas                          ::  e.g. %farmlands
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Top-level game state                                    │
::  └──────────────────────────────────────────────────────────┘
::
+$  game-state
  $:  player=player-info                       ::  gold, hp, timestamps
      skills=(map skill-id skill-state)        ::  per-skill xp & level
      bank=bank-state                          ::  inventory of items
      equipment=equipment-state                ::  worn gear + auto-eat
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
::  │  Equipment & combat style                                │
::  └──────────────────────────────────────────────────────────┘
::
+$  equipment-slot  $?(%helmet %platebody %weapon %shield)
::
+$  combat-style
  $?  %melee-attack
      %melee-strength
      %melee-defence
      %ranged
      %magic
  ==
::
+$  equipment-stats
  $:  slot=equipment-slot
      attack-bonus=@ud
      strength-bonus=@ud
      ranged-attack-bonus=@ud
      ranged-strength-bonus=@ud
      magic-attack-bonus=@ud
      magic-strength-bonus=@ud
      defence-bonus=@ud
      attack-speed=@ud                         ::  ms, 0 for non-weapons
      level-reqs=(map skill-id @ud)
  ==
::
+$  equipment-state
  $:  slots=(map equipment-slot item-id)       ::  equipped items
      auto-eat-threshold=@ud                   ::  0-100 percent
      selected-food=(unit item-id)             ::  food to auto-eat
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Active action — tagged union, extended per phase        │
::  └──────────────────────────────────────────────────────────┘
::
+$  active-action
  $%  [%skilling skill=skill-id target=action-id started=@da]
      $:  %combat
          area=area-id
          monster=monster-id
          style=combat-style
          enemy-hp=@ud
          enemy-max-hp=@ud
          player-next-attack=@da               ::  absolute time of next attack
          enemy-next-attack=@da                ::  absolute time of next attack
          kills=@ud
          player-atk-count=@ud                 ::  monotonic counter
          enemy-atk-count=@ud                  ::  monotonic counter
          player-last-dmg=@ud                  ::  damage dealt in last player attack
          enemy-last-dmg=@ud                   ::  damage dealt in last enemy attack
          started=@da
      ==
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
      [%equip item=item-id]
      [%unequip slot=equipment-slot]
      [%start-combat area=area-id monster=monster-id style=combat-style]
      [%stop-combat ~]
      [%set-auto-eat threshold=@ud food=(unit item-id)]
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
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Monster & area definitions (static data)                │
::  └──────────────────────────────────────────────────────────┘
::
+$  loot-entry
  $:  item=item-id
      min-qty=@ud
      max-qty=@ud
      chance=@ud                               ::  percentage 0-100
  ==
::
+$  monster-def
  $:  id=monster-id
      name=@t
      hitpoints=@ud
      max-hit=@ud
      attack-level=@ud
      strength-level=@ud
      defence-level=@ud
      attack-speed=@ud                         ::  ms between attacks
      attack-style=combat-style
      loot-table=(list loot-entry)
      gp-min=@ud
      gp-max=@ud
      combat-xp=@ud
  ==
::
+$  area-def
  $:  id=area-id
      name=@t
      monsters=(list monster-id)
      level-req=@ud
  ==
--
