# Content Guide

Adding new skills, items, and actions requires only data changes — no engine modifications.

## Adding a New Skill

1. **Define actions** in `lib/bide-skills.hoon`. Create a `++<name>-actions` arm returning `(list action-def)` and a `++<name>-def` arm returning `skill-def`:

```hoon
++  farming-def
  ^-  skill-def
  :*  id=%farming
      name='Farming'
      skill-type=%gathering    ::  or %artisan
      max-level=99
      actions=farming-actions
  ==
```

2. **Register it** by adding `[%farming farming-def]` to the list in `++skill-registry`.

3. **Initialize state.** In `app/bide.hoon` `++on-init`, add the skill to the initial `skills` map so new installs start with level 1:

```hoon
:-  %farming
[xp=0 level=1 mastery=[pool-xp=0 actions=*(map action-id @ud)]]
```

Existing ships will get the skill automatically when they start an action — `++handle-action` uses `(fall (~(get by skills.gs) ...))` with a default.

## Adding New Items

Add item definitions in `lib/bide-items.hoon`:

```hoon
++  tomato-seed-def
  ^-  item-def
  [id=%tomato-seed name='Tomato Seed' description='A tomato seed.' category=%raw-material sell-price=3]
```

Then register it in `++item-registry`:

```hoon
[%tomato-seed tomato-seed-def]
```

## Adding an Item Category

Edit `sur/bide.hoon` and add to the `item-category` union:

```hoon
+$  item-category
  $?  %raw-material
      %processed
      %equipment
      %food
      %gem
      %rune
      %potion
      %seed              ::  new category
      %misc
  ==
```

The frontend will need a corresponding display treatment if you want category-specific styling.

## Adding Actions to an Existing Skill

Append to the skill's action list in `lib/bide-skills.hoon`:

```hoon
:*  id=%catch-minnow
    name='Minnow'
    level-req=95
    xp=4.500
    base-time=9.000
    inputs=~                                   ::  gathering: no inputs
    outputs=~[[item=%raw-minnow min-qty=1 max-qty=1 chance=100]]
    mastery-xp=450
==
```

For artisan actions, specify `inputs`:

```hoon
inputs=~[[item=%gold-bar qty=1] [item=%onyx qty=1]]
```

## Action Definition Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | `@tas` | Unique action ID (e.g. `%cut-oak-tree`) |
| `name` | `@t` | Display name |
| `level-req` | `@ud` | Minimum skill level to start |
| `xp` | `@ud` | XP awarded per completion |
| `base-time` | `@ud` | Milliseconds per action (3000 = 3s) |
| `inputs` | `(list [item=item-id qty=@ud])` | Items consumed per action (empty for gathering) |
| `outputs` | `(list output-def)` | Items produced per action |
| `mastery-xp` | `@ud` | Mastery XP per action |
| `gp-per-action` | `@ud` | GP produced per action (0 for most; used by alchemy spells) |

## Output Definition Fields

| Field | Type | Description |
|-------|------|-------------|
| `item` | `@tas` | Item ID produced |
| `min-qty` | `@ud` | Minimum quantity (currently always 1) |
| `max-qty` | `@ud` | Maximum quantity (used for production calc) |
| `chance` | `@ud` | Drop chance 0-100 (currently always 100, RNG not yet wired) |

## Adding a Monster

Add the monster definition in `lib/bide-monsters.hoon`:

```hoon
++  my-monster-def
  ^-  monster-def
  :*  id=%my-monster
      name='My Monster'
      hitpoints=500
      attack-level=40
      strength-level=40
      defence-level=40
      attack-speed=2.400  ::  ms between attacks
      combat-xp=200
      loot-table=~[[item=%bones min-qty=1 max-qty=1 chance=100]]
      gp-min=50
      gp-max=150
  ==
```

Register it in `++monster-registry` and add it to an area in `lib/bide-areas.hoon`.

## Adding an Area

Add area definitions in `lib/bide-areas.hoon`:

```hoon
++  my-area-def
  ^-  area-def
  [id=%my-area name='My Area' level-req=30 monsters=~[%monster-a %monster-b]]
```

Register it in `++area-registry`.

## Adding Equipment

Add equipment stat definitions in `lib/bide-equipment.hoon`:

```hoon
[%my-sword [attack-bonus=20 strength-bonus=15 defence-bonus=0 ranged-attack-bonus=0 ranged-strength-bonus=0 magic-attack-bonus=0 magic-strength-bonus=0 attack-speed=2.400]]
```

The item itself must also exist in `lib/bide-items.hoon` with `category=%equipment`.

## Adding a Potion

Add to `++potion-registry` in `lib/bide-potions.hoon`:

```hoon
[%my-potion [%attack-boost 10 50]]  ::  [effect-type magnitude duration]
```

Effect types: `%attack-boost`, `%strength-boost`, `%defence-boost` (timed, magnitude is percent), `%heal` (instant, magnitude is HP), `%prayer-restore` (instant, magnitude is points).

The potion item must exist in `lib/bide-items.hoon` and be craftable via a Herblore recipe in `lib/bide-skills.hoon`.

## Adding a Prayer

Add to `++prayer-registry` in `lib/bide-prayers.hoon`:

```hoon
[%my-prayer [id=%my-prayer name='My Prayer' level-req=20 drain-per-attack=2 bonuses=~[[%strength-pct 10]]]]
```

Bonus types: `%attack-pct`, `%strength-pct`, `%defence-pct` (additive percent boost), `%protect-melee`, `%protect-ranged`, `%protect-magic` (damage reduction percent).

## Adding a Special Attack

Add to `++special-registry` in `lib/bide-specials.hoon`:

```hoon
[%my-weapon [name='Power Strike' energy-cost=50 damage-mult=150 accuracy-mult=100 effect=[%none ~]]]
```

The weapon item must already exist in the equipment registry. `damage-mult` and `accuracy-mult` are percentages (100 = normal).

## Adding a Dungeon

Add to `++dungeon-registry` in `lib/bide-dungeons.hoon`:

```hoon
++  my-dungeon-def
  ^-  dungeon-def
  :*  id=%my-dungeon
      name='My Dungeon'
      level-req=50
      rooms=~[[monster=%ogre qty=5] [monster=%demon qty=3] [monster=%dragon qty=1]]
      reward-table=~[[item=%runite-bar min-qty=1 max-qty=3 chance=30]]
  ==
```

All monsters referenced in rooms must exist in `++monster-registry`.

## Adding a Farm Seed

Add to `++seed-registry` in `lib/bide-farming.hoon`:

```hoon
[%my-seed [level=25 growth-time=600.000 xp=400 crop=%my-crop min-yield=2 max-yield=4]]
```

The seed item must exist in `lib/bide-items.hoon` with `category=%seed`, and the crop item must also exist (typically `category=%food` for allotments or `category=%raw-material` for herbs).

If the crop is edible, add a healing value in `lib/bide-food.hoon`.

## Adding a Familiar

1. Add the tablet recipe to `++summoning-actions` in `lib/bide-skills.hoon`:

```hoon
:*  id=%make-my-tablet
    name='My Tablet'
    level-req=40
    xp=800
    base-time=4.500
    inputs=~[[item=%charcoal qty=3] [item=%some-material qty=1]]
    outputs=~[[item=%my-tablet min-qty=1 max-qty=1 chance=100]]
    mastery-xp=80
==
```

2. Add the tablet item in `lib/bide-items.hoon` with `category=%tablet`.

3. Register the familiar in `++familiar-registry` in `lib/bide-summoning.hoon`:

```hoon
:-  %my-tablet
[charges=60 gathering-xp=0 artisan-xp=5 thieving-xp=0 herblore-xp=0 combat-xp=0 all-xp=0 atk-boost=0 str-boost=0 def-boost=0 farming-yield=0]
```

Fields are percentage bonuses. `charges` is the number of actions/attacks before the familiar auto-dismisses.

## Adding a Pet

1. Add the pet definition in `lib/bide-pets.hoon` to `++pet-registry`:

```hoon
:-  %my-pet
:*  name='My Pet'
    source-type=%skilling       ::  or %combat
    source-id=%mining           ::  skill-id or monster-id
    chance=2.000                ::  1 in 2000
    effects=~[[%xp-skill %mining 2]]  ::  +2% mining XP
==
```

Effect types: `%xp-skill` (skill-specific XP %), `%xp-global` (all XP %), `%gp-bonus` (GP from monsters %), `%speed-bonus` (action speed %), `%farming-yield` (farming yield %).

Pet drops are rolled automatically in `process-skill-tick` (for skilling pets) and `process-combat-events` (for combat pets). The `source-type` and `source-id` must match the action context for the pet to be eligible.

## Adding a Shop Item

Add to `++shop-registry` in `lib/bide-shop.hoon`:

```hoon
[%my-item 150]  ::  buy price in GP
```

The item must already exist in `lib/bide-items.hoon`. Pricing convention: 2-3x the item's sell price.

## Adding an Alt Magic Spell

Add to `++magic-actions` in `lib/bide-skills.hoon`:

```hoon
:*  id=%my-spell
    name='My Spell'
    level-req=45
    xp=200
    base-time=4.000
    inputs=~[[item=%fire-rune qty=5] [item=%death-rune qty=1] [item=%some-bar qty=1]]
    outputs=~[[item=%enchanted-bar min-qty=1 max-qty=1 chance=100]]
    mastery-xp=20
    gp-per-action=0             ::  set >0 for alchemy spells that produce GP
==
```

For alchemy spells, set `outputs=~` and `gp-per-action` to the GP amount. The engine handles GP production in `process-skill-tick`.
