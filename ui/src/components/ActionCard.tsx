import { useGame } from '../context/GameContext';
import { Card } from './ui/Card';
import { Button } from './ui/Button';
import { GameIcon } from './ui/GameIcon';
import { fmt, fmtTime } from '../shared/format';
import { levelFromXp, xpForLevel, xpProgress } from '../shared/xp';
import type { ActionDef, SkillId } from '../shared/types';

interface Props {
  action: ActionDef;
  skillId: SkillId;
  playerLevel: number;
}

export function ActionCard({ action, skillId, playerLevel }: Props) {
  const { state, defs, startAction, stopAction, getDisplayBank } = useGame();
  const locked = action.levelReq > playerLevel;
  const aa = state?.activeAction;
  const isActive = aa?.type === 'skilling' && aa.skill === skillId && aa.target === action.id;
  const bank = getDisplayBank();

  const hasInputs = action.inputs.every(inp => (bank[inp.item] || 0) >= inp.qty);
  const canStart = !locked && hasInputs;

  return (
    <Card active={isActive} locked={locked}>
      <div className="flex items-center gap-3 mb-3">
        {action.outputs.length > 0 && (
          <GameIcon category="items" id={action.outputs[0].item} size={48} />
        )}
        <div className="font-semibold text-[14px] text-gray-200 flex-1">{action.name}</div>
        {isActive && (
          <span className="text-[10px] font-bold text-amber-500 uppercase tracking-wider">Training</span>
        )}
      </div>

      <div className="flex flex-col gap-1.5 text-[12px] mb-4">
        <div className="flex justify-between">
          <span className="text-gray-500">Level</span>
          <span className={`font-medium tabular-nums ${locked ? 'text-red-400' : 'text-amber-500'}`}>
            {action.levelReq}
          </span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-500">XP</span>
          <span className="font-medium text-emerald-400 tabular-nums">{fmt(action.xp)}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-500">Time</span>
          <span className="font-medium text-gray-300 tabular-nums">{fmtTime(action.baseTime)}</span>
        </div>
        {action.masteryXp > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">Mastery</span>
            <span className="font-medium text-purple-400 tabular-nums">{fmt(action.masteryXp)}</span>
          </div>
        )}
        {action.inputs.length > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">Requires</span>
            <span className="font-medium">
              {action.inputs.map((inp, i) => {
                const have = bank[inp.item] || 0;
                const name = defs?.items[inp.item]?.name ?? inp.item;
                const color = have >= inp.qty ? 'text-emerald-400' : 'text-red-400';
                return (
                  <span key={inp.item}>
                    {i > 0 && ', '}
                    <span className={color}>{have}/{inp.qty} {name}</span>
                  </span>
                );
              })}
            </span>
          </div>
        )}
        {action.gpPerAction > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">GP</span>
            <span className="font-medium text-yellow-500 tabular-nums">+{fmt(action.gpPerAction)}</span>
          </div>
        )}
        {action.outputs.length > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">Output</span>
            <span className="font-medium text-gray-300">
              {action.outputs.map((out, i) => {
                const name = defs?.items[out.item]?.name ?? out.item;
                const have = bank[out.item] || 0;
                const qty = out.minQty === out.maxQty ? `${out.minQty}` : `${out.minQty}-${out.maxQty}`;
                return (
                  <span key={out.item}>
                    {i > 0 && ', '}
                    {out.chance < 100 ? `${qty} ${name} (${out.chance}%)` : `${qty} ${name}`}
                    <span className="text-gray-600 ml-1">({have})</span>
                  </span>
                );
              })}
            </span>
          </div>
        )}
      </div>

      {action.masteryXp > 0 && (() => {
        const mxp = state?.skills[skillId]?.masteryActions?.[action.id] ?? 0;
        const mlvl = levelFromXp(mxp);
        const mpct = xpProgress(mxp, mlvl);
        const mNext = xpForLevel(Math.min(mlvl + 1, 99));
        return (
          <div className="mb-4">
            <div className="flex items-center justify-between text-[11px] mb-1">
              <span className="text-purple-400 font-medium">Mastery Lv. {mlvl}</span>
              <span className="text-gray-600 tabular-nums">{fmt(mxp)} / {fmt(mNext)}</span>
            </div>
            <div className="h-1.5 bg-[#0d1117] rounded-full overflow-hidden">
              <div
                className="h-full bg-purple-500 rounded-full transition-[width] duration-300"
                style={{ width: `${mpct}%` }}
              />
            </div>
          </div>
        );
      })()}

      <div className="flex gap-3">
        {locked ? (
          <Button disabled className="flex-1">Locked</Button>
        ) : isActive ? (
          <Button variant="stop" onClick={stopAction}>Stop</Button>
        ) : (
          <Button variant="start" disabled={!canStart} onClick={() => startAction(skillId, action.id)}>
            {!hasInputs && !locked ? 'No Materials' : 'Start'}
          </Button>
        )}
      </div>
    </Card>
  );
}
