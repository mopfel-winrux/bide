import { useState, useEffect, useRef, useCallback } from 'react';
import type { GameState, GameDefs, SkillId, DisplaySkill, ItemId } from '../shared/types';
import { api } from '../shared/api';
import { levelFromXp } from '../shared/xp';

interface LevelUp {
  skill: string;
  level: number;
}

export function useGameState() {
  const [defs, setDefs] = useState<GameDefs | null>(null);
  const [state, setState] = useState<GameState | null>(null);
  const [error, setError] = useState<string | null>(null);
  const lastPolledRef = useRef<GameState | null>(null);
  const pendingXPRef = useRef<Record<SkillId, number>>({});
  const pendingItemsRef = useRef<Record<ItemId, number>>({});
  const [levelUps, setLevelUps] = useState<LevelUp[]>([]);

  // Fetch defs once on mount
  useEffect(() => {
    api.getDefs().then(setDefs).catch(() => setError('Failed to load game data. Is the bide agent running?'));
  }, []);

  // Poll state every 1s
  useEffect(() => {
    if (!defs) return;

    const poll = () => {
      api.getState().then((s) => {
        const prev = lastPolledRef.current;
        // Reduce pending by server's confirmed progress (prevents double-counting)
        if (prev) {
          for (const sid in pendingXPRef.current) {
            const delta = (s.skills?.[sid]?.xp ?? 0) - (prev.skills?.[sid]?.xp ?? 0);
            pendingXPRef.current[sid] = Math.max(0, (pendingXPRef.current[sid] || 0) - delta);
            if (pendingXPRef.current[sid] === 0) delete pendingXPRef.current[sid];
          }
          for (const iid in pendingItemsRef.current) {
            const delta = Math.max(0, (s.bank?.[iid] ?? 0) - (prev.bank?.[iid] ?? 0));
            pendingItemsRef.current[iid] = Math.max(0, (pendingItemsRef.current[iid] || 0) - delta);
            if (pendingItemsRef.current[iid] === 0) delete pendingItemsRef.current[iid];
          }
        } else {
          pendingXPRef.current = {};
          pendingItemsRef.current = {};
        }
        // Detect level-ups
        if (prev?.skills && s.skills) {
          const ups: LevelUp[] = [];
          for (const sid in s.skills) {
            const prevSkill = prev.skills[sid];
            const curSkill = s.skills[sid];
            if (prevSkill && curSkill && curSkill.level > prevSkill.level) {
              const skillName = defs.skills[sid]?.name ?? sid;
              ups.push({ skill: skillName, level: curSkill.level });
            }
          }
          if (ups.length > 0) setLevelUps(ups);
        }
        lastPolledRef.current = s;
        setState(s);
      }).catch(() => { /* silently retry next tick */ });
    };

    poll();
    const id = setInterval(poll, 1000);
    return () => clearInterval(id);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [defs]);

  const clearLevelUps = useCallback(() => setLevelUps([]), []);

  const addPendingXP = useCallback((skill: SkillId, xp: number) => {
    pendingXPRef.current[skill] = (pendingXPRef.current[skill] || 0) + xp;
  }, []);

  const addPendingItems = useCallback((items: Record<ItemId, number>) => {
    for (const id in items) {
      pendingItemsRef.current[id] = (pendingItemsRef.current[id] || 0) + items[id];
    }
  }, []);

  const getDisplaySkill = useCallback((sid: SkillId): DisplaySkill => {
    const ss = state?.skills?.[sid] ?? { xp: 0, level: 1, poolXp: 0 };
    const xp = ss.xp + (pendingXPRef.current[sid] || 0);
    return { xp, level: levelFromXp(xp), poolXp: ss.poolXp };
  }, [state]);

  const getDisplayBank = useCallback((): Record<ItemId, number> => {
    const bank: Record<ItemId, number> = {};
    if (state?.bank) {
      for (const iid in state.bank) bank[iid] = state.bank[iid];
    }
    for (const iid in pendingItemsRef.current) {
      bank[iid] = (bank[iid] || 0) + pendingItemsRef.current[iid];
    }
    return bank;
  }, [state]);

  return {
    defs,
    state,
    error,
    levelUps,
    clearLevelUps,
    addPendingXP,
    addPendingItems,
    getDisplaySkill,
    getDisplayBank,
  };
}
