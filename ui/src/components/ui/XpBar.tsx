import { fmt } from '../../shared/format';
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
    <div className={`relative h-9 bg-[#0d1117] rounded-lg overflow-hidden border border-[#1e293b] ${className}`}>
      <div
        className="h-full bg-gradient-to-r from-green-600 to-emerald-400 transition-[width] duration-400 relative"
        style={{ width: `${pct}%` }}
      >
        {/* Shimmer */}
        <div
          className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent animate-[shimmer_3s_ease-in-out_infinite]"
        />
      </div>
      <div className="absolute inset-0 flex items-center justify-center text-[13px] font-semibold text-gray-100 [text-shadow:0_1px_3px_rgba(0,0,0,0.8)] pointer-events-none tabular-nums tracking-wide">
        {fmt(xp)} / {fmt(next)} XP
      </div>
    </div>
  );
}
