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

## Output Definition Fields

| Field | Type | Description |
|-------|------|-------------|
| `item` | `@tas` | Item ID produced |
| `min-qty` | `@ud` | Minimum quantity (currently always 1) |
| `max-qty` | `@ud` | Maximum quantity (used for production calc) |
| `chance` | `@ud` | Drop chance 0-100 (currently always 100, RNG not yet wired) |
