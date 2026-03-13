import type { CombatStyle } from '../shared/types';

export type WeaponType = 'melee' | 'ranged' | 'magic';

interface CombatStyleSelectorProps {
  selected: CombatStyle;
  onSelect: (style: CombatStyle) => void;
  weaponType: WeaponType;
}

const STYLES: { value: CombatStyle; label: string; desc: string; type: WeaponType }[] = [
  { value: 'melee-attack', label: 'Attack', desc: 'Train Attack', type: 'melee' },
  { value: 'melee-strength', label: 'Strength', desc: 'Train Strength', type: 'melee' },
  { value: 'melee-defence', label: 'Defence', desc: 'Train Defence', type: 'melee' },
  { value: 'ranged', label: 'Ranged', desc: 'Train Ranged', type: 'ranged' },
  { value: 'magic', label: 'Magic', desc: 'Train Magic', type: 'magic' },
];

export function CombatStyleSelector({ selected, onSelect, weaponType }: CombatStyleSelectorProps) {
  // Show weapon-appropriate styles + always show magic (can cast spells without a magic weapon)
  const available = STYLES.filter((s) => s.type === weaponType || s.type === 'magic');

  return (
    <div>
      <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-2">Combat Style</h2>
      <div className="flex flex-wrap gap-2">
        {available.map((s) => (
          <button
            key={s.value}
            onClick={() => onSelect(s.value)}
            className={`px-3 py-2 rounded-lg text-sm border transition-colors cursor-pointer ${
              selected === s.value
                ? 'bg-amber-600/20 border-amber-600 text-amber-400'
                : 'bg-[#111827] border-[#1e293b] text-gray-400 hover:border-gray-500'
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
