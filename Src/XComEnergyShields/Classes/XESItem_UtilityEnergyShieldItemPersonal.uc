// This is an Unreal Script

class XESItem_UtilityEnergyShieldItemPersonal extends X2Item config(EnergyShield);

var config int ENERGY_SHIELD_PERSONAL_SUPPLY_COST;
var config int ENERGY_SHIELD_PERSONAL_CORPSE_COST;
var config int ENERGY_SHIELD_PERSONAL_ELERIUM_COST;

function X2DataTemplate CreateEnergyShieldPersonal()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Supplies;
	local ArtifactCost Elerium;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'XES_EnergyShieldPersonal');
	Template.ItemCat = 'utility';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_MindShield";
	Template.EquipSound = "StrategyUI_Mindshield_Equip";

	Template.Abilities.AddItem('XComEnergyShieldPersonal');

	Template.CanBeBuilt = true; // Item is built in engineering.
	Template.TradingPostValue = 12;
	Template.PointsToComplete = 0;
	Template.Tier = 1;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	// Cost
	Supplies.ItemTemplateName = 'Supplies';
	Supplies.Quantity = ENERGY_SHIELD_PERSONAL_SUPPLY_COST;
	Template.Cost.ResourceCosts.AddItem(Supplies);

	Elerium.ItemTemplateName = 'EleriumDust';
	Elerium.Quantity = ENERGY_SHIELD_PERSONAL_ELERIUM_COST;
	Template.Cost.ResourceCosts.AddItem(Elerium);

	Artifacts.ItemTemplateName = 'CorpseAdventShieldbearer';
	Artifacts.Quantity = ENERGY_SHIELD_PERSONAL_CORPSE_COST;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	
	return Template;
}