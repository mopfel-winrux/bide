import { useNavigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { xpProgress } from '../shared/xp';
import type { SkillId } from '../shared/types';

interface Props {
  skillId: SkillId;
}

export function SkillCard({ skillId }: Props) {
  const { defs, getDisplaySkill } = useGame();
  const navigate = useNavigate();
  const sd = defs?.skills[skillId];
  const ds = getDisplaySkill(skillId);

  if (!sd) return null;

  const pct = xpProgress(ds.xp, ds.level);
  // SVG ring params
  const size = 64;
  const stroke = 5;
  const radius = (size - stroke) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (pct / 100) * circumference;

  return (
    <div
      onClick={() => navigate(`/skill/${skillId}`)}
      className="bg-[#111827] border border-[#374151] rounded-[10px] p-6 cursor-pointer transition-all duration-200 hover:border-gray-500 hover:shadow-[0_0_12px_rgba(255,255,255,0.03)]"
    >
      <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-4">
        {sd.name}
      </h3>
      <div className="flex items-center gap-5">
        <svg width={size} height={size} className="shrink-0 -rotate-90">
          <circle
            cx={size / 2} cy={size / 2} r={radius}
            fill="none" stroke="#1f2937" strokeWidth={stroke}
          />
          <circle
            cx={size / 2} cy={size / 2} r={radius}
            fill="none" stroke="#22c55e" strokeWidth={stroke}
            strokeDasharray={circumference}
            strokeDashoffset={offset}
            strokeLinecap="round"
            className="transition-all duration-400"
          />
          <text
            x={size / 2} y={size / 2}
            textAnchor="middle" dominantBaseline="central"
            className="fill-gray-100 text-[18px] font-bold rotate-90"
            transform={`rotate(90 ${size / 2} ${size / 2})`}
          >
            {ds.level}
          </text>
        </svg>
        <div>
          <div className="text-xl font-bold mb-1">Level {ds.level}</div>
          <div className="text-sm text-gray-400">{pct.toFixed(0)}% to next level</div>
        </div>
      </div>
    </div>
  );
}
