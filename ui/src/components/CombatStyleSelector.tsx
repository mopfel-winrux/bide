import type { CombatStyle } from '../shared/types';

interface CombatStyleSelectorProps {
  selected: CombatStyle;
  onSelect: (style: CombatStyle) => void;
}

const STYLES: { value: CombatStyle; label: string; desc: string }[] = [
  { value: 'melee-attack', label: 'Attack', desc: 'Train Attack' },
  { value: 'melee-strength', label: 'Strength', desc: 'Train Strength' },
  { value: 'melee-defence', label: 'Defence', desc: 'Train Defence' },
  { value: 'ranged', label: 'Ranged', desc: 'Train Ranged' },
  { value: 'magic', label: 'Magic', desc: 'Train Magic' },
];

export function CombatStyleSelector({ selected, onSelect }: CombatStyleSelectorProps) {
  return (
    <div>
      <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-2">Combat Style</h2>
      <div className="flex flex-wrap gap-2">
        {STYLES.map((s) => (
          <button
            key={s.value}
            onClick={() => onSelect(s.value)}
            className={`px-3 py-2 rounded-lg text-sm border transition-colors cursor-pointer ${
              selected === s.value
                ? 'bg-amber-600/20 border-amber-600 text-amber-400'
                : 'bg-[#111827] border-[#374151] text-gray-400 hover:border-gray-500'
            }`}
          >
            <div className="font-medium">{s.label}</div>
            <div className="text-[10px] opacity-60">{s.desc}</div>
          </button>
        ))}
      </div>
    </div>
  );
}
