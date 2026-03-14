import { useGame } from '../context/GameContext';
import { ActiveAction } from '../components/ActiveAction';
import { SkillCard } from '../components/SkillCard';
import { fmt, fmtGP } from '../shared/format';
import { SKILL_TYPE_ORDER, SKILL_TYPE_LABELS, SKILL_TYPE_COLORS } from '../shared/constants';
import type { SkillType } from '../shared/types';

export function OverviewPage() {
  const { defs, state } = useGame();

  if (!defs || !state) return null;

  const totalLevel = Object.keys(defs.skills).reduce((sum, sid) => {
    return sum + (state.skills[sid]?.level ?? 1);
  }, 0);

  const maxTotalLevel = Object.keys(defs.skills).length * 99;
  const itemCount = state.bank ? Object.keys(state.bank).length : 0;

  // Group skills by type
  const groups: Record<string, string[]> = {};
  for (const type of SKILL_TYPE_ORDER) groups[type] = [];
  for (const sid in defs.skills) {
    const type = defs.skills[sid].type;
    if (!groups[type]) groups[type] = [];
    groups[type].push(sid);
  }

  return (
    <div>
      <ActiveAction />

      {/* Stats row */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 mb-8">
        <StatCard label="Total Level" value={fmt(totalLevel)} sub={`/ ${fmt(maxTotalLevel)}`} color="#e5e7eb" />
        <StatCard label="Gold" value={fmtGP(state.gp)} sub="GP" color="#eab308" />
        <StatCard label="Hitpoints" value={`${fmt(state.hp)} / ${fmt(state.hpMax)}`} sub="HP" color="#ef4444" />
        <StatCard label="Bank" value={`${itemCount}`} sub="items" color="#6b7280" />
      </div>

      {/* Skills by type */}
      {SKILL_TYPE_ORDER.map((type) => {
        const sids = groups[type];
        if (!sids || sids.length === 0) return null;
        const typeColor = SKILL_TYPE_COLORS[type as SkillType];

        return (
          <div key={type} className="mb-8">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-1.5 h-1.5 rounded-full" style={{ backgroundColor: typeColor }} />
              <h2 className="text-[11px] font-semibold uppercase tracking-[0.1em] text-gray-500">
                {SKILL_TYPE_LABELS[type as SkillType]}
              </h2>
              <div className="flex-1 h-px bg-[#1e293b]" />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-3">
              {sids.map((sid) => (
                <SkillCard key={sid} skillId={sid} />
              ))}
            </div>
          </div>
        );
      })}
    </div>
  );
}

function StatCard({ label, value, sub, color }: { label: string; value: string; sub: string; color: string }) {
  return (
    <div className="bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3">
      <div className="text-[11px] font-medium uppercase tracking-wider text-gray-500 mb-1">{label}</div>
      <div className="flex items-baseline gap-1.5">
        <span className="text-lg font-bold tabular-nums" style={{ color }}>{value}</span>
        <span className="text-[12px] text-gray-500">{sub}</span>
      </div>
    </div>
  );
}
