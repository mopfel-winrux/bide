import { fmt, } from '../../shared/format';
import { xpForLevel, xpProgress } from '../../shared/xp';

interface Props {
  xp: number;
  level: number;
  className?: string;
}

export function XpBar({ xp, level, className = '' }: Props) {
  const pct = xpProgress(xp, level);
  const next = xpForLevel(Math.min(level + 1, 99));

  return (
    <div className={`relative h-7 bg-[#1f2937] rounded-md overflow-hidden border border-[#374151] ${className}`}>
      <div
        className="h-full bg-gradient-to-r from-green-700 to-green-500 rounded-l-md transition-[width] duration-400"
        style={{ width: `${pct}%` }}
      />
      <div className="absolute inset-0 flex items-center justify-center text-xs font-semibold text-gray-100 [text-shadow:0_1px_2px_rgba(0,0,0,0.6)] pointer-events-none">
        {fmt(xp)} / {fmt(next)} XP ({pct.toFixed(0)}%)
      </div>
    </div>
  );
}
