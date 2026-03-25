import { useRef, useCallback, useEffect, useState } from 'react';
import type { GameState, GameDefs, SkillId, ActionDef } from '../shared/types';

interface ActionTimerState {
  progress: number; // 0-100
  remaining: number; // ms
  isActive: boolean;
  agilitySlot: number; // current agility obstacle slot (1-based), 0 if not agility
}

interface CycleEvent {
  skill: SkillId;
  xp: number;
  outputs: Record<string, number>; // item -> qty
  gp: number;
}

export function useActionTimer(
  state: GameState | null,
  defs: GameDefs | null,
  onCycle: (event: CycleEvent) => void,
) {
  const [timerState, setTimerState] = useState<ActionTimerState>({
    progress: 0,
    remaining: 0,
    isActive: false,
    agilitySlot: 0,
  });

  const actionKeyRef = useRef('');
  const actionStartRef = useRef(0);
  const actionDurationRef = useRef(0);
  const rafRef = useRef<number>(0);
  const progressBarRef = useRef<HTMLDivElement | null>(null);
  const timeTextRef = useRef<HTMLSpanElement | null>(null);
  const onCycleRef = useRef(onCycle);
  onCycleRef.current = onCycle;
  // Agility: per-obstacle cycling
  const agilityObstacleIdx = useRef(0);
  const agilityObstacles = useRef<{ id: string; xp: number; interval: number }[]>([]);

  // Refs for current action state (avoids stale closures in rAF)
  const stateRef = useRef(state);
  const defsRef = useRef(defs);
  stateRef.current = state;
  defsRef.current = defs;

  const getActionDef = useCallback((skillId: string, actionId: string): ActionDef | null => {
    const d = defsRef.current;
    if (!d?.skills?.[skillId]) return null;
    return d.skills[skillId].actions.find((a) => a.id === actionId) ?? null;
  }, []);

  const tick = useCallback(() => {
    const duration = actionDurationRef.current;
    const start = actionStartRef.current;

    if (!duration) {
      if (progressBarRef.current) progressBarRef.current.style.width = '0%';
      rafRef.current = requestAnimationFrame(tick);
      return;
    }

    let elapsed = Date.now() - start;

    if (elapsed >= duration) {
      // Cycle complete
      const s = stateRef.current;
      if (s?.activeAction && s.activeAction.type === 'skilling') {
        const skillId = s.activeAction.skill;
        const mods = s.modifiers;
        const skillType = defsRef.current?.skills[skillId]?.type;
        let pct = mods?.xpGlobal ?? 0;
        if (skillType === 'gathering') pct += mods?.xpGathering ?? 0;
        if (skillType === 'artisan') pct += mods?.xpArtisan ?? 0;
        if (skillType === 'combat') pct += mods?.xpCombat ?? 0;
        pct += mods?.xpPerSkill?.[skillId] ?? 0;

        // Agility: per-obstacle XP drops
        if (skillId === 'agility' && agilityObstacles.current.length > 0) {
          const obs = agilityObstacles.current;
          const idx = agilityObstacleIdx.current % obs.length;
          const o = obs[idx];
          const modXp = o.xp + Math.floor(o.xp * pct / 100);
          onCycleRef.current({ skill: skillId, xp: modXp, outputs: {}, gp: 0 });
          // Advance to next obstacle
          agilityObstacleIdx.current = (idx + 1) % obs.length;
          // Set duration for next obstacle
          const nextObs = obs[agilityObstacleIdx.current];
          const speedBonus = mods?.speedBonus ?? 0;
          let nextDur = nextObs.interval;
          if (speedBonus > 0) nextDur = Math.max(500, nextDur - Math.floor(nextDur * speedBonus / 100));
          actionDurationRef.current = nextDur;
        } else {
          // Normal skill cycle
          const ad = getActionDef(s.activeAction.skill, s.activeAction.target);
          if (ad) {
            const outputs: Record<string, number> = {};
            for (const out of ad.outputs) {
              if (out.chance < 100) continue;
              outputs[out.item] = (outputs[out.item] || 0) + out.maxQty;
            }
            const sec = s.activeAction.secondary;
            const ad2 = sec ? getActionDef(s.activeAction.skill, sec) : null;
            if (ad2) {
              for (const out of ad2.outputs) {
                if (out.chance < 100) continue;
                outputs[out.item] = (outputs[out.item] || 0) + out.maxQty;
              }
            }
            const baseXp = ad.xp + (ad2?.xp ?? 0);
            const modifiedXp = baseXp + Math.floor(baseXp * pct / 100);
            onCycleRef.current({
              skill: skillId,
              xp: modifiedXp,
              outputs,
              gp: (ad.gpPerAction ?? 0) + (ad2?.gpPerAction ?? 0),
            });
          }
        }
      }
      actionStartRef.current = Date.now();
      elapsed = 0;
    }

    const pct = Math.min(100, (elapsed / duration) * 100);
    const rem = Math.max(0, duration - elapsed);

    // Direct DOM update for progress bar (avoids React re-render at 60fps)
    if (progressBarRef.current) {
      progressBarRef.current.style.width = pct + '%';
    }
    if (timeTextRef.current) {
      timeTextRef.current.textContent = (rem / 1000).toFixed(1) + 's';
    }

    // Update React state less frequently (for components that need it)
    const curSlot = agilityObstacles.current.length > 0 ? agilityObstacleIdx.current + 1 : 0;
    setTimerState({ progress: pct, remaining: rem, isActive: true, agilitySlot: curSlot });

    rafRef.current = requestAnimationFrame(tick);
  }, [getActionDef]);

  // Sync timer with game state
  useEffect(() => {
    // Combat actions don't use client-side timer cycling
    if (state?.activeAction?.type === 'combat') {
      actionKeyRef.current = '';
      actionStartRef.current = 0;
      actionDurationRef.current = 0;
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      rafRef.current = 0;
      setTimerState({ progress: 0, remaining: 0, isActive: false, agilitySlot: 0 });
      if (progressBarRef.current) progressBarRef.current.style.width = '0%';
      return;
    }

    if (!state?.activeAction || state.activeAction.type !== 'skilling') {
      actionKeyRef.current = '';
      actionStartRef.current = 0;
      actionDurationRef.current = 0;
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      rafRef.current = 0;
      setTimerState({ progress: 0, remaining: 0, isActive: false, agilitySlot: 0 });
      if (progressBarRef.current) progressBarRef.current.style.width = '0%';
      return;
    }

    const aa = state.activeAction;
    const key = aa.skill + ':' + aa.target + (aa.secondary ? ':' + aa.secondary : '');
    if (key === actionKeyRef.current) return;

    const ad = getActionDef(aa.skill, aa.target);
    if (!ad) return;

    // Agility: build obstacle list and use first obstacle's interval
    let duration: number;
    if (aa.skill === 'agility' && state?.agilityCourse) {
      const obs: { id: string; xp: number; interval: number }[] = [];
      const d = defsRef.current;
      for (let s = 1; s <= 10; s++) {
        const oid = state.agilityCourse[String(s)];
        if (!oid) break;
        const odef = d?.obstacles?.[oid];
        if (odef) obs.push({ id: oid, xp: odef.xp, interval: odef.interval });
      }
      agilityObstacles.current = obs;
      agilityObstacleIdx.current = 0;
      duration = obs.length > 0 ? obs[0].interval : 3000;
    } else {
      agilityObstacles.current = [];
      duration = ad.baseTime;
      // Multitree: use max of primary and secondary base times
      if (aa.secondary) {
        const ad2 = getActionDef(aa.skill, aa.secondary);
        if (ad2) duration = Math.max(duration, ad2.baseTime);
      }
    }
    // Apply speed bonus
    const speedBonus = state?.modifiers?.speedBonus ?? 0;
    if (speedBonus > 0) {
      duration = Math.max(500, duration - Math.floor(duration * speedBonus / 100));
    }

    actionKeyRef.current = key;
    actionDurationRef.current = duration;
    actionStartRef.current = Date.now();

    if (!rafRef.current) {
      rafRef.current = requestAnimationFrame(tick);
    }
  }, [state, getActionDef, tick]);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
    };
  }, []);

  return {
    ...timerState,
    progressBarRef,
    timeTextRef,
    duration: actionDurationRef.current,
  };
}
