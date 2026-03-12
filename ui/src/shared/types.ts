// Types mirroring JSON from app/bide.hoon

export type SkillId = string;
export type ActionId = string;
export type ItemId = string;
export type MonsterId = string;
export type AreaId = string;

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

export type EquipmentSlot = 'helmet' | 'platebody' | 'weapon' | 'shield';

export type CombatStyle =
  | 'melee-attack'
  | 'melee-strength'
  | 'melee-defence'
  | 'ranged'
  | 'magic';

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

export interface LootEntry {
  item: ItemId;
  minQty: number;
  maxQty: number;
  chance: number;
}

export interface MonsterDef {
  name: string;
  hitpoints: number;
  maxHit: number;
  attackLevel: number;
  strengthLevel: number;
  defenceLevel: number;
  attackSpeed: number;
  attackStyle: CombatStyle;
  combatXp: number;
  gpMin: number;
  gpMax: number;
  lootTable: LootEntry[];
}

export interface AreaDef {
  name: string;
  monsters: MonsterId[];
  levelReq: number;
}

export interface EquipmentStats {
  slot: EquipmentSlot;
  attackBonus: number;
  strengthBonus: number;
  rangedAttackBonus: number;
  rangedStrengthBonus: number;
  magicAttackBonus: number;
  magicStrengthBonus: number;
  defenceBonus: number;
  attackSpeed: number;
  levelReqs: Record<SkillId, number>;
}

export interface SkillState {
  xp: number;
  level: number;
  poolXp: number;
}

export interface ActiveSkillingAction {
  type: 'skilling';
  skill: SkillId;
  target: ActionId;
}

export interface ActiveCombatAction {
  type: 'combat';
  area: AreaId;
  monster: MonsterId;
  style: CombatStyle;
  enemyHp: number;
  enemyMaxHp: number;
  playerAttackTimer: number;
  enemyAttackTimer: number;
  kills: number;
  playerAtkCount: number;
  enemyAtkCount: number;
  playerLastDmg: number;
  enemyLastDmg: number;
}

export type ActiveAction = ActiveSkillingAction | ActiveCombatAction;

export interface EquipmentState {
  slots: Partial<Record<EquipmentSlot, ItemId>>;
  autoEatThreshold: number;
  selectedFood: ItemId | null;
}

export interface GameState {
  gp: number;
  hp: number;
  hpMax: number;
  skills: Record<SkillId, SkillState>;
  bank: Record<ItemId, number>;
  slotsMax: number;
  activeAction: ActiveAction | null;
  equipment: EquipmentState;
}

export interface GameDefs {
  skills: Record<SkillId, SkillDef>;
  items: Record<ItemId, ItemDef>;
  monsters: Record<MonsterId, MonsterDef>;
  areas: Record<AreaId, AreaDef>;
  equipmentStats: Record<ItemId, EquipmentStats>;
  foodHealing: Record<ItemId, number>;
}

export interface DisplaySkill {
  xp: number;
  level: number;
  poolXp: number;
}
