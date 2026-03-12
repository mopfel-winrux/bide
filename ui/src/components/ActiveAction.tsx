import { useGame } from '../context/GameContext';
import { ProgressBar } from './ui/ProgressBar';
import { Button } from './ui/Button';
import { fmtTime } from '../shared/format';

export function ActiveAction() {
  const { state, defs, stopAction, progressBarRef, timeTextRef } = useGame();

  if (!state?.activeAction) {
    return (
      <div className="bg-[#111827] border border-[#374151] rounded-[10px] px-6 py-5 mb-8">
        <div className="flex items-center justify-between mb-3">
          <span className="font-semibold text-base text-gray-500">Idle</span>
        </div>
        <p className="text-sm text-gray-500">Choose a skill to start training.</p>
      </div>
    );
  }

  const aa = state.activeAction;
  const skillName = defs?.skills[aa.skill]?.name ?? aa.skill;
  const actionDef = defs?.skills[aa.skill]?.actions.find((a) => a.id === aa.target);
  const actionName = actionDef?.name ?? aa.target;
  const xpPerHr = actionDef ? Math.round((actionDef.xp / actionDef.baseTime) * 3600000) : 0;

  return (
    <div className="bg-[#111827] border border-amber-600 rounded-[10px] px-6 py-5 mb-8 shadow-[0_0_20px_rgba(217,119,6,0.08)]">
      <div className="flex items-center justify-between mb-3 gap-4">
        <span className="font-semibold text-base">
          {skillName}: {actionName}
        </span>
        <span className="text-gray-400 text-[13px]">
          {xpPerHr.toLocaleString()} XP/hr
        </span>
        <span ref={timeTextRef} className="text-gray-400 text-sm tabular-nums">
          {actionDef ? fmtTime(actionDef.baseTime) : ''}
        </span>
        <Button variant="stop" size="sm" onClick={stopAction} className="flex-none !flex-initial">
          Stop
        </Button>
      </div>
      <ProgressBar ref={progressBarRef} />
    </div>
  );
}
