::  sur/bide.hoon — core type definitions for Bide (Melvor Idle on Urbit)
::
::  Phase 1-8: Skills, Bank, Equipment, Combat, Passive Skills, Economy
::
|%
::  ┌──────────────────────────────────────────────────────────┐
::  │  Atom aliases                                            │
::  └──────────────────────────────────────────────────────────┘
::
+$  skill-id     @tas
+$  action-id    @tas
+$  item-id      @tas
+$  monster-id   @tas
+$  area-id      @tas
+$  prayer-id    @tas
+$  dungeon-id   @tas
+$  pet-id       @tas
+$  spell-id     @tas
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
      active-potions=(list potion-effect)      ::  timed combat buffs
      active-prayers=(set prayer-id)           ::  toggled prayers
      slayer-task=(unit slayer-task)            ::  current slayer assignment
      farm-plots=(list (unit farm-plot))       ::  farming plots
      active-familiar=(unit familiar-state)    ::  summoned familiar
      pets-found=(set pet-id)                  ::  discovered pets
      active-pet=(unit pet-id)                 ::  equipped pet
      star-levels=(map [action-id @ud] @ud)    ::  constellation star upgrade levels
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
      prayer-points=@ud                        ::  current prayer points
      prayer-max=@ud                           ::  max prayer points (level * 10)
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
+$  potion-effect
  $:  item=item-id                             ::  which potion
      turns-left=@ud                           ::  player attacks remaining
  ==
::
+$  slayer-task
  $:  monster=monster-id
      qty-remaining=@ud
      qty-total=@ud
  ==
::
+$  farm-plot
  $:  seed=item-id
      planted-at=@da
      growth-time=@ud                          ::  ms to fully grow
      harvested=?
  ==
::
+$  familiar-state
  $:  tablet=item-id
      charges=@ud
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Equipment & combat style                                │
::  └──────────────────────────────────────────────────────────┘
::
+$  equipment-slot  $?(%helmet %platebody %weapon %shield %cape)
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
          spell=(unit spell-id)
          enemy-hp=@ud
          enemy-max-hp=@ud
          player-next-attack=@da               ::  absolute time of next attack
          enemy-next-attack=@da                ::  absolute time of next attack
          kills=@ud
          player-atk-count=@ud                 ::  monotonic counter
          enemy-atk-count=@ud                  ::  monotonic counter
          player-last-dmg=@ud                  ::  damage dealt in last player attack
          enemy-last-dmg=@ud                   ::  damage dealt in last enemy attack
          special-energy=@ud                   ::  0-100 energy bar
          special-queued=?                     ::  use special on next attack
          started=@da
      ==
      $:  %dungeon
          dungeon=dungeon-id
          room-idx=@ud                         ::  current room (0-indexed)
          room-kills=@ud                       ::  kills in current room
          monster=monster-id
          style=combat-style
          spell=(unit spell-id)
          enemy-hp=@ud
          enemy-max-hp=@ud
          player-next-attack=@da
          enemy-next-attack=@da
          kills=@ud                            ::  total kills this dungeon
          player-atk-count=@ud
          enemy-atk-count=@ud
          player-last-dmg=@ud
          enemy-last-dmg=@ud
          special-energy=@ud
          special-queued=?
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
      monsters-killed=(map monster-id @ud)     ::  lifetime kill counts
      items-produced=(map item-id @ud)         ::  lifetime items crafted
      dungeons-completed=(map dungeon-id @ud)  ::  lifetime dungeon clears
      total-xp-earned=@ud                      ::  lifetime xp
      total-gp-earned=@ud                      ::  lifetime gp earned
      total-gp-spent=@ud                       ::  lifetime gp spent
      max-hit-dealt=@ud                        ::  highest single hit
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
      [%start-combat area=area-id monster=monster-id style=combat-style spell=(unit spell-id)]
      [%stop-combat ~]
      [%set-auto-eat threshold=@ud food=(unit item-id)]
      [%drink-potion item=item-id]
      [%toggle-prayer prayer=prayer-id]
      [%get-slayer-task ~]
      [%special-attack ~]
      [%change-spell spell=(unit spell-id)]
      [%start-dungeon dungeon=dungeon-id style=combat-style spell=(unit spell-id)]
      [%plant-seed plot=@ud seed=item-id]
      [%harvest-plot plot=@ud]
      [%summon-familiar tablet=item-id]
      [%dismiss-familiar ~]
      [%eat-food item=item-id]
      [%set-pet pet=(unit pet-id)]
      [%upgrade-star constellation=action-id star-idx=@ud]
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
      gp-per-action=@ud                        ::  GP produced per action (0 = none)
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
      %seed                                    ::  farming seeds
      %tablet                                  ::  summoning tablets
      %bones                                   ::  bones for prayer
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
      slayer-req=@ud                           ::  0 = no requirement
  ==
::
+$  area-def
  $:  id=area-id
      name=@t
      monsters=(list monster-id)
      level-req=@ud
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Prayer definitions (static data)                        │
::  └──────────────────────────────────────────────────────────┘
::
+$  prayer-def
  $:  id=prayer-id
      name=@t
      level-req=@ud
      drain-per-attack=@ud                     ::  prayer points drained per player attack
      effects=(list prayer-bonus)
  ==
::
+$  prayer-bonus
  $%  [%attack-pct boost=@ud]
      [%strength-pct boost=@ud]
      [%defence-pct boost=@ud]
      [%protect-melee reduce=@ud]
      [%protect-ranged reduce=@ud]
      [%protect-magic reduce=@ud]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Dungeon definitions (static data)                       │
::  └──────────────────────────────────────────────────────────┘
::
+$  dungeon-def
  $:  id=dungeon-id
      name=@t
      rooms=(list dungeon-room)
      level-req=@ud
      reward-table=(list loot-entry)
  ==
::
+$  dungeon-room
  $:  monster=monster-id
      qty=@ud
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Special attack definitions (static data)                │
::  └──────────────────────────────────────────────────────────┘
::
+$  special-attack-def
  $:  name=@t
      energy-cost=@ud                          ::  percent of 100
      damage-mult=@ud                          ::  percentage (150 = 1.5x)
      accuracy-mult=@ud                        ::  percentage (100 = normal)
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Modifier engine (Phase 8)                               │
::  └──────────────────────────────────────────────────────────┘
::
+$  modifier-set
  $:  xp-global=@ud                            ::  +% to all skills
      xp-gathering=@ud                         ::  +% gathering skills
      xp-artisan=@ud                           ::  +% artisan skills
      xp-combat=@ud                            ::  +% combat skills
      xp-per-skill=(map skill-id @ud)          ::  specific skill overrides
      speed-bonus=@ud                          ::  -% action time
      atk-boost=@ud                            ::  +% melee attack
      str-boost=@ud                            ::  +% melee strength
      def-boost=@ud                            ::  +% defence
      ranged-boost=@ud                         ::  +% ranged attack
      magic-boost=@ud                          ::  +% magic attack
      protect-melee=@ud                        ::  -% melee damage taken
      protect-ranged=@ud                       ::  -% ranged damage taken
      protect-magic=@ud                        ::  -% magic damage taken
      farming-yield=@ud                        ::  +% farming yield
      gp-bonus=@ud                             ::  +% GP from monsters
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Pet definitions (Phase 8)                               │
::  └──────────────────────────────────────────────────────────┘
::
+$  pet-def
  $:  name=@t
      source-type=?(%skilling %combat)
      source-id=@tas                           ::  skill-id or monster-id
      chance=@ud                               ::  1 in N
      effects=(list pet-bonus)
  ==
::
+$  pet-bonus
  $%  [%xp-skill skill=skill-id pct=@ud]
      [%xp-global pct=@ud]
      [%gp-bonus pct=@ud]
      [%speed-bonus pct=@ud]
      [%farming-yield pct=@ud]
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Combat spell definitions (Phase 9)                      │
::  └──────────────────────────────────────────────────────────┘
::
+$  spell-def
  $:  name=@t
      level-req=@ud                           ::  magic level required
      max-hit=@ud                             ::  fixed max damage per cast
      runes=(list [item=item-id qty=@ud])     ::  runes consumed per attack
  ==
::
::  ┌──────────────────────────────────────────────────────────┐
::  │  Skill cape definitions (Phase 10)                       │
::  └──────────────────────────────────────────────────────────┘
::
+$  cape-bonus
  $%  [%xp-skill skill=skill-id pct=@ud]
      [%xp-global pct=@ud]
      [%speed-bonus pct=@ud]
      [%atk-boost pct=@ud]
      [%str-boost pct=@ud]
      [%def-boost pct=@ud]
      [%ranged-boost pct=@ud]
      [%magic-boost pct=@ud]
      [%farming-yield pct=@ud]
      [%gp-bonus pct=@ud]
      [%protect-all pct=@ud]
  ==
::
+$  cape-def
  $:  skill=skill-id
      bonuses=(list cape-bonus)
  ==
--
