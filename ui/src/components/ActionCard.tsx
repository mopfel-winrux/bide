import { useGame } from '../context/GameContext';
import { Card } from './ui/Card';
import { Button } from './ui/Button';
import { GameIcon } from './ui/GameIcon';
import { fmt, fmtTime } from '../shared/format';
import { levelFromXp, xpForLevel, xpProgress } from '../shared/xp';
import type { ActionDef, ActionId, SkillId } from '../shared/types';

interface Props {
  action: ActionDef;
  skillId: SkillId;
  playerLevel: number;
}

export function ActionCard({ action, skillId, playerLevel }: Props) {
  const { state, defs, startAction, stopAction, getDisplayBank, upgradeStar } = useGame();
  const locked = action.levelReq > playerLevel;
  const aa = state?.activeAction;
  const isActive = aa?.type === 'skilling' && aa.skill === skillId && aa.target === action.id;
  const bank = getDisplayBank();

  const hasInputs = action.inputs.every(inp => (bank[inp.item] || 0) >= inp.qty);
  const canStart = !locked && hasInputs;

  return (
    <Card active={isActive} locked={locked}>
      <div className="flex items-center gap-3 mb-3">
        {action.id.startsWith('study-') ? (
          <GameIcon category="constellation" id={action.id} size={48} />
        ) : action.inputs.length > 0 && skillId === 'firemaking' ? (
          <GameIcon category="items" id={action.inputs[0].item} size={48} />
        ) : action.outputs.length > 0 ? (
          <GameIcon category="items" id={action.outputs[0].item} size={48} />
        ) : (
          <GameIcon category="skill-icon" id={skillId} size={48} />
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
          <span className="font-medium text-gray-300 tabular-nums">
            {(() => {
              const speedBonus = state?.modifiers?.speedBonus ?? 0;
              const modifiedTime = speedBonus > 0
                ? Math.max(500, action.baseTime - Math.floor(action.baseTime * speedBonus / 100))
                : action.baseTime;
              return modifiedTime !== action.baseTime
                ? <>{fmtTime(modifiedTime)} <span className="line-through text-gray-600">{fmtTime(action.baseTime)}</span></>
                : fmtTime(action.baseTime);
            })()}
          </span>
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

      {skillId === 'astrology' && defs?.constellations[action.id] && state && defs.starDefs && (() => {
        const linkedSkills = defs.constellations[action.id];
        const [s1, s2] = linkedSkills;
        const name1 = defs.skills[s1]?.name ?? s1;
        const name2 = defs.skills[s2]?.name ?? s2;
        return (
          <div className="mb-4">
            <div className="text-[11px] text-gray-500 mb-2">
              Linked: <span className="text-blue-400">{name1}</span> / <span className="text-blue-400">{name2}</span>
            </div>
            <div className="flex gap-1.5">
              {defs.starDefs.stars.map((star, idx) => {
                const key = `${action.id}/${idx}`;
                const level = state.starLevels?.[key] ?? 0;
                const isMax = level >= star.maxLevel;
                const cost = isMax ? null : star.costs[level];
                const currencyName = defs.items[star.currency]?.name ?? star.currency;
                const have = state.bank[star.currency] ?? 0;
                const canAfford = cost !== null && have >= cost;
                const typeLabel = star.type === 'xp-boost' ? 'XP' : 'Speed';
                const bonusLabel = star.type === 'xp-boost'
                  ? `+${level}%`
                  : `+${level}%`;

                return (
                  <button
                    key={idx}
                    disabled={isMax || !canAfford || locked}
                    onClick={() => upgradeStar(action.id as ActionId, idx)}
                    className={`flex-1 rounded p-1.5 text-[10px] text-center border transition-colors ${
                      isMax
                        ? 'border-amber-700/50 bg-amber-900/10 text-amber-400 cursor-default'
                        : canAfford && !locked
                          ? 'border-blue-700/50 bg-blue-900/10 text-blue-300 hover:bg-blue-800/20 cursor-pointer'
                          : 'border-gray-700/50 bg-gray-900/10 text-gray-600 cursor-not-allowed'
                    }`}
                    title={isMax ? `${typeLabel} maxed` : `Cost: ${cost} ${currencyName}`}
                  >
                    <div className="font-medium">{typeLabel}</div>
                    <div className="mt-0.5">{level}/{star.maxLevel} {bonusLabel}</div>
                    {!isMax && cost !== null && (
                      <div className={`mt-0.5 ${canAfford ? 'text-green-400' : 'text-red-400'}`}>
                        {cost} {currencyName}
                      </div>
                    )}
                  </button>
                );
              })}
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
