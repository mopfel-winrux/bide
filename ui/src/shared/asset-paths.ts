const BASE = import.meta.env.BASE_URL + 'img';

export type AssetCategory =
  | 'items'
  | 'skill-icon'
  | 'monster'
  | 'cape'
  | 'spell'
  | 'pet'
  | 'constellation'
  | 'agility'
  | 'prayer'
  | 'area-bg'
  | 'dungeon-bg';

export function assetUrl(category: AssetCategory, id: string): string {
  return `${BASE}/${category}/${id}.png`;
}
