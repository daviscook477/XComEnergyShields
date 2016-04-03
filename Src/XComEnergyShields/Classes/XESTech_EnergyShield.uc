// This is an Unreal Script

class XESTech_EnergyShield extends Object config (EnergyShield);

var config int ENERGY_SHIELD_SUPPLY_COST;
var config int ENERGY_SHIELD_CORE_COST;
var config int ENERGY_SHIELD_ELERIUM_COST;
var config int ENERGY_SHIELD_PERSONAL_SUPPLY_COST;
var config int ENERGY_SHIELD_PERSONAL_CORE_COST;
var config int ENERGY_SHIELD_PERSONAL_ELERIUM_COST;

// A bunch of this code is just copied from the X2 tech something or other class.
static function int StafferXDays(int iNumScientists, int iNumDays)
{
	return (iNumScientists * 5) * (24 * iNumDays); // Scientists at base skill level
}

function GiveRandomItemReward(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local array<name> ItemRewards;
	local int iRandIndex;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemRewards = TechState.GetMyTemplate().ItemRewards;
	iRandIndex = `SYNC_RAND(ItemRewards.Length);
	ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemRewards[iRandIndex]);

	GiveItemReward(NewGameState, TechState, ItemTemplate);
}

function GiveItemReward(XComGameState NewGameState, XComGameState_Tech TechState, X2ItemTemplate ItemTemplate)
{	
	class'XComGameState_HeadquartersXCom'.static.GiveItem(NewGameState, ItemTemplate);

	TechState.ItemReward = ItemTemplate; // Needed for UI Alert display info
	TechState.bSeenResearchCompleteScreen = false; // Reset the research report for techs that are repeatable
}

function X2TechTemplate CreateEnergyShieldPersonalTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Supplies;
	local ArtifactCost Elerium;
	local ArtifactCost Cores;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'XES_EnergyShieldPersonalTech');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = GiveRandomItemReward;

	// Randomized Item Rewards
	Template.ItemRewards.AddItem('XES_EnergyShieldPersonal');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	// Cost
	Supplies.ItemTemplateName = 'Supplies';
	Supplies.Quantity = ENERGY_SHIELD_PERSONAL_SUPPLY_COST;
	Template.Cost.ResourceCosts.AddItem(Supplies);

	Elerium.ItemTemplateName = 'EleriumDust';
	Elerium.Quantity = ENERGY_SHIELD_PERSONAL_ELERIUM_COST;
	Template.Cost.ResourceCosts.AddItem(Elerium);

	Cores.ItemTemplateName = 'EleriumCore';
	Cores.Quantity = ENERGY_SHIELD_PERSONAL_CORE_COST;
	Template.Cost.ArtifactCosts.AddItem(Cores);

	return Template;
}

function X2TechTemplate CreateEnergyShieldGroupTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Supplies;
	local ArtifactCost Elerium;
	local ArtifactCost Cores;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'XES_EnergyShieldGroupTech');
	/*Template.PointsToComplete = StafferXDays(1, 10);*/
	Template.PointsToComplete = StafferXDays(1, 1);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = GiveRandomItemReward;

	// Randomized Item Rewards
	Template.ItemRewards.AddItem('XES_EnergyShieldHeavy');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	// Cost
	Supplies.ItemTemplateName = 'Supplies';
	Supplies.Quantity = ENERGY_SHIELD_SUPPLY_COST;
	Template.Cost.ResourceCosts.AddItem(Supplies);

	Elerium.ItemTemplateName = 'EleriumDust';
	Elerium.Quantity = ENERGY_SHIELD_ELERIUM_COST;
	Template.Cost.ResourceCosts.AddItem(Elerium);

	Cores.ItemTemplateName = 'EleriumCore';
	Cores.Quantity = ENERGY_SHIELD_CORE_COST;
	Template.Cost.ArtifactCosts.AddItem(Cores);

	return Template;
}