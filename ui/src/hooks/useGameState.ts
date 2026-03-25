import { useState, useEffect, useRef, useCallback } from 'react';
import type { GameState, GameDefs, SkillId, DisplaySkill, ItemId, WelcomeBackSummary } from '../shared/types';
import { api } from '../shared/api';
import { levelFromXp } from '../shared/xp';

interface LevelUp {
  skill: string;
  level: number;
}

interface SavedSnapshot {
  gp: number;
  skills: Record<string, { xp: number; level: number }>;
  bank: Record<string, number>;
  stats: {
    actionsCompleted: Record<string, number>;
    monstersKilled: Record<string, number>;
    dungeonsCompleted: Record<string, number>;
    totalXpEarned: number;
    totalGpEarned: number;
    totalGpSpent: number;
  };
  petsFound: string[];
  hadActiveAction: boolean;
}

function snapshotFromState(s: GameState): SavedSnapshot {
  const skills: Record<string, { xp: number; level: number }> = {};
  for (const sid in s.skills) {
    skills[sid] = { xp: s.skills[sid].xp, level: s.skills[sid].level };
  }
  return {
    gp: s.gp,
    skills,
    bank: { ...s.bank },
    stats: {
      actionsCompleted: { ...s.stats.actionsCompleted },
      monstersKilled: { ...s.stats.monstersKilled },
      dungeonsCompleted: { ...s.stats.dungeonsCompleted },
      totalXpEarned: s.stats.totalXpEarned,
      totalGpEarned: s.stats.totalGpEarned,
      totalGpSpent: s.stats.totalGpSpent,
    },
    petsFound: [...(s.petsFound ?? [])],
    hadActiveAction: !!s.activeAction,
  };
}

function computeWelcomeBack(old: SavedSnapshot, cur: GameState, elapsedMs: number): WelcomeBackSummary {
  const gpEarned = cur.stats.totalGpEarned - (old.stats.totalGpEarned ?? 0);
  const gpSpent = cur.stats.totalGpSpent - (old.stats.totalGpSpent ?? 0);
  const xpEarned = cur.stats.totalXpEarned - (old.stats.totalXpEarned ?? 0);

  const skillChanges: WelcomeBackSummary['skillChanges'] = [];
  for (const sid in cur.skills) {
    const oldSkill = old.skills[sid];
    const curSkill = cur.skills[sid];
    if (!oldSkill) {
      if (curSkill.xp > 0) {
        skillChanges.push({ skillId: sid, xpGained: curSkill.xp, oldLevel: 1, newLevel: curSkill.level });
      }
    } else {
      const xpGained = curSkill.xp - oldSkill.xp;
      if (xpGained > 0) {
        skillChanges.push({ skillId: sid, xpGained, oldLevel: oldSkill.level, newLevel: curSkill.level });
      }
    }
  }

  const itemChanges: WelcomeBackSummary['itemChanges'] = [];
  const allItems = new Set([...Object.keys(old.bank), ...Object.keys(cur.bank)]);
  for (const iid of allItems) {
    const delta = (cur.bank[iid] ?? 0) - (old.bank[iid] ?? 0);
    if (delta !== 0) itemChanges.push({ itemId: iid, delta });
  }
  itemChanges.sort((a, b) => Math.abs(b.delta) - Math.abs(a.delta));

  const monstersKilled: WelcomeBackSummary['monstersKilled'] = [];
  for (const mid in cur.stats.monstersKilled) {
    const count = cur.stats.monstersKilled[mid] - (old.stats.monstersKilled[mid] ?? 0);
    if (count > 0) monstersKilled.push({ monsterId: mid, count });
  }

  const dungeonsCompleted: WelcomeBackSummary['dungeonsCompleted'] = [];
  for (const did in cur.stats.dungeonsCompleted) {
    const count = cur.stats.dungeonsCompleted[did] - (old.stats.dungeonsCompleted[did] ?? 0);
    if (count > 0) dungeonsCompleted.push({ dungeonId: did, count });
  }

  let actionsCompleted = 0;
  for (const aid in cur.stats.actionsCompleted) {
    actionsCompleted += cur.stats.actionsCompleted[aid] - (old.stats.actionsCompleted[aid] ?? 0);
  }

  const oldPetSet = new Set(old.petsFound ?? []);
  const petsFound = (cur.petsFound ?? []).filter((p) => !oldPetSet.has(p));

  const actionStopped = (old.hadActiveAction ?? false) && !cur.activeAction;

  return {
    elapsedMs,
    gpGained: cur.gp - old.gp,
    gpEarned,
    gpSpent,
    xpEarned,
    skillChanges,
    itemChanges,
    monstersKilled,
    dungeonsCompleted,
    actionsCompleted,
    petsFound,
    actionStopped,
  };
}

function hasMeaningfulChanges(s: WelcomeBackSummary): boolean {
  if (s.xpEarned < 0) return false; // state was nuked
  return (
    s.xpEarned > 0 ||
    s.gpEarned > 0 ||
    s.itemChanges.length > 0 ||
    s.actionStopped ||
    s.monstersKilled.length > 0 ||
    s.petsFound.length > 0 ||
    s.dungeonsCompleted.length > 0
  );
}

const LS_STATE_KEY = 'bide-last-state';
const LS_TS_KEY = 'bide-last-state-ts';
const MIN_AWAY_MS = 30_000;

export function useGameState() {
  const [defs, setDefs] = useState<GameDefs | null>(null);
  const [state, setState] = useState<GameState | null>(null);
  const [error, setError] = useState<string | null>(null);
  const lastPolledRef = useRef<GameState | null>(null);
  const pendingXPRef = useRef<Record<SkillId, number>>({});
  const pendingItemsRef = useRef<Record<ItemId, number>>({});
  const [levelUps, setLevelUps] = useState<LevelUp[]>([]);
  const [welcomeBack, setWelcomeBack] = useState<WelcomeBackSummary | null>(null);
  const hasCheckedWelcomeRef = useRef(false);

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

        // Welcome-back check (once per page load)
        if (!hasCheckedWelcomeRef.current) {
          hasCheckedWelcomeRef.current = true;
          try {
            const raw = localStorage.getItem(LS_STATE_KEY);
            const tsRaw = localStorage.getItem(LS_TS_KEY);
            if (raw && tsRaw) {
              const elapsed = Date.now() - Number(tsRaw);
              if (elapsed >= MIN_AWAY_MS) {
                const oldSnapshot: SavedSnapshot = JSON.parse(raw);
                const summary = computeWelcomeBack(oldSnapshot, s, elapsed);
                if (hasMeaningfulChanges(summary)) {
                  setWelcomeBack(summary);
                }
              }
            }
          } catch { /* corrupted localStorage, skip */ }
        }

        // Save snapshot for next session
        try {
          localStorage.setItem(LS_STATE_KEY, JSON.stringify(snapshotFromState(s)));
          localStorage.setItem(LS_TS_KEY, String(Date.now()));
        } catch { /* quota error, silently degrade */ }

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
  const clearWelcomeBack = useCallback(() => setWelcomeBack(null), []);

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
    welcomeBack,
    clearWelcomeBack,
  };
}
