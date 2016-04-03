// This is an Unreal Script

class XESItem_UtilityEnergyShieldItemHeavy extends X2Item config(EnergyShield);

var config int ENERGY_SHIELD_HEAVY_TRADE_VALUE;

function X2ItemTemplate CreateEnergyShieldHeavy()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'XES_EnergyShieldHeavy');
	Template.WeaponCat = 'heavy';
	Template.InventorySlot = eInvSlot_HeavyWeapon;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_MindShield";
	Template.EquipSound = "StrategyUI_Mindshield_Equip";
	Template.Abilities.AddItem('XComEnergyShield');
	Template.CanBeBuilt = false;
	Template.StartingItem = false;
	Template.TradingPostValue = ENERGY_SHIELD_HEAVY_TRADE_VALUE;
	Template.PointsToComplete = 0;
	Template.Tier = 1;

	return Template;
}