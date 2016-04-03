// This is an Unreal Script

class XES_UIScreenListener extends UIScreenListener;

var bool didUpdateTemplates;
 
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	if (IsStrategyState())
	{
		if(!didUpdateTemplates)
		{
			UpdateTemplates();
			didUpdateTemplates = true;
		}   
	}
}

function bool IsStrategyState()
{
	return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

function UpdateTemplates()
{
	local X2ItemTemplateManager itemMan;
	local X2AbilityTemplateManager abilityMan;
	local X2StrategyElementTemplateManager stratMan;
	local XESItem_UtilityEnergyShieldItemPersonal xesIP;
	local XESItem_UtilityEnergyShieldItemHeavy xesIH;
	local XESAbility_XComEnergyShield xesA;
	local XESAbility_XComEnergyShieldPersonal xesAP;
	local XESItem_UtilityGrenadeEnergyShields xesG;
	local XESTech_EnergyShield tech;

	// Add all of the templates to the game with the replaceDuplicates parameter set to true in order to avoid duplicate items.
	tech = new class'XESTech_EnergyShield';

	xesIP = new class'XESItem_UtilityEnergyShieldItemPersonal';
	xesIH = new class'XESItem_UtilityEnergyShieldItemHeavy';
	xesA = new class'XESAbility_XComEnergyShield';
	xesAP = new class'XESAbility_XComEnergyShieldPersonal';
	xesG = new class'XESItem_UtilityGrenadeEnergyShields';


	// Abilities
	abilityMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	abilityMan.AddAbilityTemplate(xesA.CreateXComEnergyShieldAbility(), true);
	abilityMan.AddAbilityTemplate(xesAP.CreateXComEnergyShieldPersonalAbility(), true);

	// Items
	itemMan = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	itemMan.AddItemTemplate(xesIP.CreateEnergyShieldPersonal(), true);
	itemMan.AddItemTemplate(xesIH.CreateEnergyShieldHeavy(), true);
	itemMan.AddItemTemplate(xesG.CreateEnergyShieldGrenade(), true);

	// Foundry Projects
	stratMan = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	stratMan.AddStrategyElementTemplate(tech.CreateEnergyShieldPersonalTemplate(), true);
	stratMan.AddStrategyElementTemplate(tech.CreateEnergyShieldGroupTemplate(), true);
}
 
// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen);
 
// This event is triggered after a screen loses focus
event OnLoseFocus(UIScreen Screen);
 
// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen);
 
defaultproperties
{
    // Leaving this assigned to none will cause every screen to trigger its signals on this class
    ScreenClass = none;
}