// Types mirroring JSON from app/bide.hoon

export type SkillId = string;
export type ActionId = string;
export type ItemId = string;

export type ItemCategory =
  | 'raw-material'
  | 'processed'
  | 'equipment'
  | 'food'
  | 'gem'
  | 'rune'
  | 'potion'
  | 'misc';

export type SkillType = 'gathering' | 'artisan' | 'combat' | 'passive';

export interface InputDef {
  item: ItemId;
  qty: number;
}

export interface OutputDef {
  item: ItemId;
  minQty: number;
  maxQty: number;
  chance: number;
}

export interface ActionDef {
  id: ActionId;
  name: string;
  levelReq: number;
  xp: number;
  baseTime: number; // ms
  masteryXp: number;
  inputs: InputDef[];
  outputs: OutputDef[];
}

export interface SkillDef {
  name: string;
  type: SkillType;
  maxLevel: number;
  actions: ActionDef[];
}

export interface ItemDef {
  name: string;
  category: ItemCategory;
  sellPrice: number;
}

export interface SkillState {
  xp: number;
  level: number;
  poolXp: number;
}

export interface ActiveAction {
  type: 'skilling';
  skill: SkillId;
  target: ActionId;
}

export interface GameState {
  gp: number;
  hp: number;
  hpMax: number;
  skills: Record<SkillId, SkillState>;
  bank: Record<ItemId, number>;
  slotsMax: number;
  activeAction: ActiveAction | null;
}

export interface GameDefs {
  skills: Record<SkillId, SkillDef>;
  items: Record<ItemId, ItemDef>;
}

export interface DisplaySkill {
  xp: number;
  level: number;
  poolXp: number;
}
