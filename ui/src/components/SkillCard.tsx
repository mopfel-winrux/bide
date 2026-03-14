import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { xpProgress } from '../shared/xp';
import { SKILL_TYPE_COLORS } from '../shared/constants';
import { GameIcon } from './ui/GameIcon';
import type { SkillId, SkillType } from '../shared/types';

interface Props {
  skillId: SkillId;
}

const COMBAT_SKILLS = new Set(['attack', 'strength', 'defence', 'hitpoints', 'ranged', 'magic']);
const CUSTOM_ROUTES: Record<string, string> = { farming: '/farming' };

export function SkillCard({ skillId }: Props) {
  const { defs, getDisplaySkill } = useGame();
  const navigate = useNavigate();
  const sd = defs?.skills[skillId];
  const ds = getDisplaySkill(skillId);

  if (!sd) return null;

  const pct = xpProgress(ds.xp, ds.level);
  const typeColor = SKILL_TYPE_COLORS[sd.type as SkillType] ?? '#6b7280';
  const isMaxed = ds.level >= 99;

  const linkTo = CUSTOM_ROUTES[skillId] ?? (COMBAT_SKILLS.has(skillId) ? '/combat' : `/skill/${skillId}`);

  // SVG ring
  const size = 56;
  const stroke = 4;
  const radius = (size - stroke) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (pct / 100) * circumference;

  return (
    <div
      onClick={() => navigate(linkTo)}
      className="group bg-[#111827] border border-[#1e293b] rounded-lg p-4 cursor-pointer transition-all duration-200 hover:border-[#374151] hover:bg-[#131b2e]"
      style={{ borderLeftColor: typeColor, borderLeftWidth: '2px' }}
    >
      <div className="flex items-center gap-4">
        <div className="relative shrink-0">
          <svg width={size} height={size} className="-rotate-90">
            <circle
              cx={size / 2} cy={size / 2} r={radius}
              fill="none" stroke="#1e293b" strokeWidth={stroke}
            />
            <circle
              cx={size / 2} cy={size / 2} r={radius}
              fill="none" stroke={isMaxed ? '#f59e0b' : typeColor} strokeWidth={stroke}
              strokeDasharray={circumference}
              strokeDashoffset={offset}
              strokeLinecap="round"
              className="transition-all duration-500"
              style={{ filter: isMaxed ? 'drop-shadow(0 0 4px rgba(245, 158, 11, 0.4))' : undefined }}
            />
          </svg>
          <div className="absolute inset-0 flex items-center justify-center">
            <GameIcon category="skill-icon" id={skillId} size={28} className="shrink-0" />
          </div>
        </div>

        <div className="flex-1 min-w-0">
          <div className="flex items-center justify-between mb-1">
            <span className="text-[13px] font-semibold text-gray-200">{sd.name}</span>
            <span className={`text-[14px] font-bold tabular-nums ${isMaxed ? 'text-amber-400' : 'text-gray-300'}`}>{ds.level}</span>
          </div>
          <div className="h-1.5 bg-[#1e293b] rounded-full overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-500"
              style={{
                width: `${pct}%`,
                backgroundColor: isMaxed ? '#f59e0b' : typeColor,
              }}
            />
          </div>
          <div className="text-[11px] text-gray-500 mt-1 tabular-nums">
            {isMaxed ? 'Maxed' : `${pct.toFixed(0)}% to ${ds.level + 1}`}
          </div>
        </div>
      </div>
    </div>
  );
}
