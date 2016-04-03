// This is an Unreal Script

class XESItem_UtilityEnergyShieldItem extends X2Item config(EnergyShield);

var config int ENERGY_SHIELD_TRADE_VALUE;

function X2ItemTemplate CreateEnergyShield()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'XES_EnergyShield');
	Template.ItemCat = 'utility';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_MindShield";
	Template.EquipSound = "StrategyUI_Mindshield_Equip";
	Template.Abilities.AddItem('XComEnergyShield');
	Template.CanBeBuilt = false;
	Template.StartingItem = false;
	Template.TradingPostValue = ENERGY_SHIELD_TRADE_VALUE;
	Template.PointsToComplete = 0;
	Template.Tier = 1;

	return Template;
}