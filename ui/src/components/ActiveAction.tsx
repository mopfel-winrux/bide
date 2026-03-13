import { useGame } from '../context/GameContext';
import { ProgressBar } from './ui/ProgressBar';
import { Button } from './ui/Button';
import { fmtTime } from '../shared/format';

export function ActiveAction() {
  const { state, defs, stopAction, progressBarRef, timeTextRef } = useGame();

  if (!state?.activeAction) {
    return (
      <div className="bg-[#111827] border border-[#1e293b] rounded-lg px-5 py-4 mb-6">
        <span className="text-[13px] text-gray-500">No active action. Choose a skill to start training.</span>
      </div>
    );
  }

  const aa = state.activeAction;

  if (aa.type === 'combat' || aa.type === 'dungeon') {
    const monsterName = defs?.monsters[aa.monster]?.name ?? aa.monster;
    const label = aa.type === 'dungeon'
      ? `Dungeon: ${defs?.dungeons?.[aa.dungeon]?.name ?? aa.dungeon}`
      : `Fighting: ${monsterName}`;
    return (
      <div className="bg-[#111827] border border-red-500/30 rounded-lg px-5 py-4 mb-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-[status-pulse_2s_ease-in-out_infinite]" />
            <span className="text-[13px] font-medium text-gray-200">{label}</span>
          </div>
          <span className="text-[12px] text-gray-500 tabular-nums">{aa.kills} kills</span>
        </div>
      </div>
    );
  }

  const skillName = defs?.skills[aa.skill]?.name ?? aa.skill;
  const actionDef = defs?.skills[aa.skill]?.actions.find((a) => a.id === aa.target);
  const actionName = actionDef?.name ?? aa.target;
  const xpPerHr = actionDef ? Math.round((actionDef.xp / actionDef.baseTime) * 3600000) : 0;

  return (
    <div className="bg-[#111827] border border-amber-600/30 rounded-lg px-5 py-4 mb-6">
      <div className="flex items-center justify-between mb-3 gap-4">
        <div className="flex items-center gap-2 min-w-0">
          <span className="w-1.5 h-1.5 rounded-full bg-amber-500 animate-[status-pulse_2s_ease-in-out_infinite] shrink-0" />
          <span className="text-[13px] font-medium text-gray-200 truncate">
            {skillName}: {actionName}
          </span>
        </div>
        <div className="flex items-center gap-4 shrink-0">
          <span className="text-[11px] text-gray-500 tabular-nums">
            {xpPerHr.toLocaleString()} XP/hr
          </span>
          <span ref={timeTextRef} className="text-[12px] text-gray-400 tabular-nums">
            {actionDef ? fmtTime(actionDef.baseTime) : ''}
          </span>
          <Button variant="stop" size="sm" onClick={stopAction} className="flex-none !flex-initial">
            Stop
          </Button>
        </div>
      </div>
      <ProgressBar ref={progressBarRef} />
    </div>
  );
}
