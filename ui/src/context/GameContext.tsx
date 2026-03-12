import { createContext, useContext, useCallback, useEffect, useState, type ReactNode } from 'react';
import type { GameState, GameDefs, SkillId, ActionId, ItemId, DisplaySkill, AreaId, MonsterId, CombatStyle, EquipmentSlot } from '../shared/types';
import { api } from '../shared/api';
import { useGameState } from '../hooks/useGameState';
import { useActionTimer } from '../hooks/useActionTimer';
import { useToast, type Toast, type ToastType } from '../hooks/useToast';

export interface XpDrop {
  id: number;
  text: string;
  isItem: boolean;
}

interface GameContextValue {
  defs: GameDefs | null;
  state: GameState | null;
  error: string | null;
  getDisplaySkill: (sid: SkillId) => DisplaySkill;
  getDisplayBank: () => Record<ItemId, number>;
  startAction: (skill: SkillId, action: ActionId) => void;
  stopAction: () => void;
  sellAll: (item: ItemId) => void;
  equip: (item: ItemId) => void;
  unequip: (slot: EquipmentSlot) => void;
  startCombat: (area: AreaId, monster: MonsterId, style: CombatStyle) => void;
  stopCombat: () => void;
  setAutoEat: (threshold: number, food: ItemId | null) => void;
  actionProgress: number;
  actionRemaining: number;
  actionIsActive: boolean;
  actionDuration: number;
  progressBarRef: React.RefObject<HTMLDivElement | null>;
  timeTextRef: React.RefObject<HTMLSpanElement | null>;
  toasts: Toast[];
  addToast: (message: string, type?: ToastType) => void;
  removeToast: (id: number) => void;
  xpDrops: XpDrop[];
}

const GameContext = createContext<GameContextValue | null>(null);

let xpDropId = 0;

function useXpDrops(): [XpDrop[], (drops: XpDrop[]) => void] {
  const [drops, setDropsState] = useState<XpDrop[]>([]);

  const setDrops = useCallback((newDrops: XpDrop[]) => {
    setDropsState((prev) => [...prev, ...newDrops]);
    setTimeout(() => {
      setDropsState((prev) => prev.filter((d) => !newDrops.find((nd) => nd.id === d.id)));
    }, 1300);
  }, []);

  return [drops, setDrops];
}

export function GameProvider({ children }: { children: ReactNode }) {
  const {
    defs, state, error,
    levelUps, clearLevelUps,
    addPendingXP, addPendingItems,
    getDisplaySkill, getDisplayBank,
  } = useGameState();

  const { toasts, addToast, removeToast } = useToast();
  const [xpDrops, setXpDrops] = useXpDrops();

  const onCycle = useCallback((event: { skill: SkillId; xp: number; outputs: Record<string, number> }) => {
    addPendingXP(event.skill, event.xp);
    addPendingItems(event.outputs);

    const drops: XpDrop[] = [];
    drops.push({ id: ++xpDropId, text: '+' + event.xp.toLocaleString() + ' XP', isItem: false });
    if (defs) {
      for (const itemId in event.outputs) {
        const name = defs.items[itemId]?.name ?? itemId;
        drops.push({ id: ++xpDropId, text: '+' + event.outputs[itemId] + ' ' + name, isItem: true });
      }
    }
    setXpDrops(drops);
  }, [addPendingXP, addPendingItems, defs, setXpDrops]);

  const timer = useActionTimer(state, defs, onCycle);

  useEffect(() => {
    if (levelUps.length > 0) {
      for (const lu of levelUps) {
        addToast(`${lu.skill} level ${lu.level}!`, 'levelup');
      }
      clearLevelUps();
    }
  }, [levelUps, addToast, clearLevelUps]);

  const startAction = useCallback((skill: SkillId, action: ActionId) => {
    api.startAction(skill, action);
  }, []);

  const stopAction = useCallback(() => {
    api.stopAction();
  }, []);

  const sellAll = useCallback((item: ItemId) => {
    api.sellAll(item);
  }, []);

  const equip = useCallback((item: ItemId) => {
    api.equip(item);
  }, []);

  const unequip = useCallback((slot: EquipmentSlot) => {
    api.unequip(slot);
  }, []);

  const startCombat = useCallback((area: AreaId, monster: MonsterId, style: CombatStyle) => {
    api.startCombat(area, monster, style);
  }, []);

  const stopCombat = useCallback(() => {
    api.stopCombat();
  }, []);

  const setAutoEat = useCallback((threshold: number, food: ItemId | null) => {
    api.setAutoEat(threshold, food);
  }, []);

  return (
    <GameContext.Provider value={{
      defs, state, error,
      getDisplaySkill, getDisplayBank,
      startAction, stopAction, sellAll,
      equip, unequip,
      startCombat, stopCombat, setAutoEat,
      actionProgress: timer.progress,
      actionRemaining: timer.remaining,
      actionIsActive: timer.isActive,
      actionDuration: timer.duration,
      progressBarRef: timer.progressBarRef,
      timeTextRef: timer.timeTextRef,
      toasts, addToast, removeToast,
      xpDrops,
    }}>
      {children}
    </GameContext.Provider>
  );
}

export function useGame() {
  const ctx = useContext(GameContext);
  if (!ctx) throw new Error('useGame must be used within GameProvider');
  return ctx;
}
