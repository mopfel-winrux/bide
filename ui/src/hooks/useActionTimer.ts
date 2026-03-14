import { useRef, useCallback, useEffect, useState } from 'react';
import type { GameState, GameDefs, SkillId, ActionDef } from '../shared/types';

interface ActionTimerState {
  progress: number; // 0-100
  remaining: number; // ms
  isActive: boolean;
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
  });

  const actionKeyRef = useRef('');
  const actionStartRef = useRef(0);
  const actionDurationRef = useRef(0);
  const rafRef = useRef<number>(0);
  const progressBarRef = useRef<HTMLDivElement | null>(null);
  const timeTextRef = useRef<HTMLSpanElement | null>(null);
  const onCycleRef = useRef(onCycle);
  onCycleRef.current = onCycle;

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
        const ad = getActionDef(s.activeAction.skill, s.activeAction.target);
        if (ad) {
          const outputs: Record<string, number> = {};
          for (const out of ad.outputs) {
            if (out.chance < 100) continue;
            outputs[out.item] = (outputs[out.item] || 0) + out.maxQty;
          }
          onCycleRef.current({
            skill: s.activeAction.skill,
            xp: ad.xp,
            outputs,
            gp: ad.gpPerAction ?? 0,
          });
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
    setTimerState({ progress: pct, remaining: rem, isActive: true });

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
      setTimerState({ progress: 0, remaining: 0, isActive: false });
      if (progressBarRef.current) progressBarRef.current.style.width = '0%';
      return;
    }

    if (!state?.activeAction || state.activeAction.type !== 'skilling') {
      actionKeyRef.current = '';
      actionStartRef.current = 0;
      actionDurationRef.current = 0;
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      rafRef.current = 0;
      setTimerState({ progress: 0, remaining: 0, isActive: false });
      if (progressBarRef.current) progressBarRef.current.style.width = '0%';
      return;
    }

    const aa = state.activeAction;
    const key = aa.skill + ':' + aa.target;
    if (key === actionKeyRef.current) return;

    const ad = getActionDef(aa.skill, aa.target);
    if (!ad) return;

    actionKeyRef.current = key;
    actionDurationRef.current = ad.baseTime;
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
