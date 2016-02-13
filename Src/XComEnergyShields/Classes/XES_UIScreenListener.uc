// This is an Unreal Script

class XES_UIScreenListener extends UIScreenListener;

var bool didUpdateTemplates;
 
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
    if(!didUpdateTemplates)
    {
        UpdateTemplates();
        didUpdateTemplates = true;
    }   
}

function UpdateTemplates()
{
	local X2ItemTemplateManager itemMan;
	local X2AbilityTemplateManager abilityMan;
	local XESItem_UtilityEnergyShieldItem xesI;
	local XESItem_UtilityEnergyShieldItemPersonal xesIP;
	local XESAbility_XComEnergyShield xesA;
	local XESAbility_XComEnergyShieldPersonal xesAP;

	xesI = new class'XESItem_UtilityEnergyShieldItem';
	xesIP = new class'XESItem_UtilityEnergyShieldItemPersonal';
	xesA = new class'XESAbility_XComEnergyShield';
	xesAP = new class'XESAbility_XComEnergyShieldPersonal';

	abilityMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	abilityMan.AddAbilityTemplate(X2AbilityTemplate(xesA.CreateXComEnergyShieldAbility()));
	abilityMan.AddAbilityTemplate(X2AbilityTemplate(xesAP.CreateXComEnergyShieldPersonalAbility()));

	itemMan = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	itemMan.AddItemTemplate(X2ItemTemplate(xesI.CreateEnergyShield()));
	itemMan.AddItemTemplate(X2ItemTemplate(xesIP.CreateEnergyShieldPersonal()));
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