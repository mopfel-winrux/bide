import { useGame } from '../context/GameContext';
import { Card } from './ui/Card';
import { Button } from './ui/Button';
import { fmt, fmtTime } from '../shared/format';
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
      <div className="flex items-center justify-between mb-3">
        <div className="font-semibold text-[15px]">{action.name}</div>
        {isActive && (
          <span className="text-[10px] font-bold text-amber-500 uppercase tracking-wider">Training</span>
        )}
      </div>

      <div className="flex flex-col gap-2 text-[13px] text-gray-400 mb-4">
        <div className="flex justify-between">
          <span className="text-gray-500">Level</span>
          <span className={`font-medium ${locked ? 'text-red-500' : 'text-amber-500'}`}>
            {action.levelReq}
          </span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-500">XP</span>
          <span className="font-medium text-green-500">{fmt(action.xp)}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-500">Time</span>
          <span className="font-medium text-gray-100">{fmtTime(action.baseTime)}</span>
        </div>
        {action.masteryXp > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">Mastery</span>
            <span className="font-medium text-purple-400">{fmt(action.masteryXp)}</span>
          </div>
        )}
        {action.inputs.length > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">Requires</span>
            <span className="font-medium">
              {action.inputs.map((inp, i) => {
                const have = bank[inp.item] || 0;
                const name = defs?.items[inp.item]?.name ?? inp.item;
                const color = have >= inp.qty ? 'text-green-500' : 'text-red-500';
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
        {action.outputs.length > 0 && (
          <div className="flex justify-between">
            <span className="text-gray-500">Output</span>
            <span className="font-medium text-gray-100">
              {action.outputs.map((out, i) => {
                const name = defs?.items[out.item]?.name ?? out.item;
                const have = bank[out.item] || 0;
                const qty = out.minQty === out.maxQty ? `${out.minQty}` : `${out.minQty}-${out.maxQty}`;
                return (
                  <span key={out.item}>
                    {i > 0 && ', '}
                    {out.chance < 100 ? `${qty} ${name} (${out.chance}%)` : `${qty} ${name}`}
                    <span className="text-gray-500 ml-1">({have})</span>
                  </span>
                );
              })}
            </span>
          </div>
        )}
      </div>

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
