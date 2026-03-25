::  lib/bide-state.hoon — agent state definitions
::
/-  *bide
|%
::
::  Old active-action type (without secondary field on %skilling)
+$  old-active-action
  $%  [%skilling skill=skill-id target=action-id started=@da]
      $:  %combat
          area=area-id  monster=monster-id  style=combat-style  spell=(unit spell-id)
          enemy-hp=@ud  enemy-max-hp=@ud
          player-next-attack=@da  enemy-next-attack=@da  kills=@ud
          player-atk-count=@ud  enemy-atk-count=@ud
          player-last-dmg=@ud  enemy-last-dmg=@ud
          special-energy=@ud  special-queued=?
          started=@da
      ==
      $:  %dungeon
          dungeon=dungeon-id  room-idx=@ud  room-kills=@ud
          monster=monster-id  style=combat-style  spell=(unit spell-id)
          enemy-hp=@ud  enemy-max-hp=@ud
          player-next-attack=@da  enemy-next-attack=@da  kills=@ud
          player-atk-count=@ud  enemy-atk-count=@ud
          player-last-dmg=@ud  enemy-last-dmg=@ud
          special-energy=@ud  special-queued=?
          started=@da
      ==
  ==
::
::  Old game-state (without skill-upgrades, multitree-unlocked)
+$  old-game-state
  $:  player=player-info
      skills=(map skill-id skill-state)
      bank=bank-state
      equipment=equipment-state
      active-action=(unit old-active-action)
      stats=game-stats
      last-tick=@da
      rng-seed=@uvJ
      active-potions=(list potion-effect)
      active-prayers=(set prayer-id)
      slayer-task=(unit slayer-task)
      farm-plots=(list (unit farm-plot))
      active-familiar=(unit familiar-state)
      pets-found=(set pet-id)
      active-pet=(unit pet-id)
      star-levels=(map [action-id @ud] @ud)
  ==
::
+$  state-0  [%0 gs=old-game-state]
+$  state-1  [%1 gs=game-state]
::
+$  versioned-state
  $%  state-0
      state-1
  ==
--
