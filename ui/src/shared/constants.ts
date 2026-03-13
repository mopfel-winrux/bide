import type { SkillType, ItemCategory } from './types';

export const SKILL_TYPE_LABELS: Record<SkillType, string> = {
  gathering: 'Gathering',
  artisan: 'Artisan',
  combat: 'Combat',
  passive: 'Passive',
};

export const SKILL_TYPE_ORDER: SkillType[] = ['gathering', 'artisan', 'combat', 'passive'];

export const CATEGORY_LABELS: Record<ItemCategory, string> = {
  'raw-material': 'Raw Materials',
  processed: 'Processed',
  equipment: 'Equipment',
  food: 'Food',
  gem: 'Gems',
  rune: 'Runes',
  potion: 'Potions',
  seed: 'Seeds',
  tablet: 'Tablets',
  bones: 'Bones',
  misc: 'Misc',
};

export const SKILL_TYPE_COLORS: Record<SkillType, string> = {
  gathering: '#10b981',
  artisan: '#0ea5e9',
  combat: '#ef4444',
  passive: '#8b5cf6',
};

export const CATEGORY_COLORS: Record<ItemCategory, string> = {
  'raw-material': '#22c55e',
  processed: '#3b82f6',
  equipment: '#a855f7',
  food: '#f97316',
  gem: '#ec4899',
  rune: '#6366f1',
  potion: '#14b8a6',
  seed: '#84cc16',
  tablet: '#f59e0b',
  bones: '#d4d4d4',
  misc: '#6b7280',
};
