// This is an Unreal Script

class XESItem_UtilityGrenadeEnergyShields extends X2Item config(EnergyShield);

var config int ENERGY_SHIELD_GRENADE_SUPPLY_COST;
var config int ENERGY_SHIELD_GRENADE_CORPSE_COST;
var config int ENERGY_SHIELD_GRENADE_ELERIUM_COST;
var config int ENERGY_SHIELD_GRENADE_ISOUNDRANGE;
var config int ENERGY_SHIELD_GRENADE_IENVIRONMENTDAMAGE;
var config int ENERGY_SHIELD_GRENADE_TRADINGPOSTVALUE;
var config int ENERGY_SHIELD_GRENADE_IPOINTS;
var config int ENERGY_SHIELD_GRENADE_ICLIPSIZE;
var config int ENERGY_SHIELD_GRENADE_RANGE;
var config int ENERGY_SHIELD_GRENADE_RADIUS;
var config int ENERGY_SHIELD_GRENADE_DURATION;
var config int ENERGY_SHIELD_GRENADE_HP;

function X2Effect_EnergyShield CreateShieldedEffect(int ShieldHPAmount)
{
	local X2Effect_EnergyShield ShieldedEffect;
	// A -> FriendlyName B-> LONGDESCRIPTION - TODO: maybe make this work
	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(ENERGY_SHIELD_GRENADE_DURATION, false, true, , eGameRule_PlayerTurnEnd);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, "A", "Z", "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;

	return ShieldedEffect;
}

simulated function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if (XGUnit(BuildTrack.TrackActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
	}
}

function X2ItemTemplate CreateEnergyShieldGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_EnergyShield ShieldedEffect;
	local ArtifactCost Supplies;
	local ArtifactCost Elerium;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'XES_EnergyShieldGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons..Inv_Flashbang_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");

	Template.iRange = ENERGY_SHIELD_GRENADE_RANGE;
	Template.iRadius = ENERGY_SHIELD_GRENADE_RADIUS;

	// Supposed to friendly fire + no warning.
	Template.bFriendlyFire = true;
	Template.bFriendlyFireWarning = false;

	Template.Abilities.AddItem('ThrowGrenade');

	ShieldedEffect = CreateShieldedEffect(ENERGY_SHIELD_GRENADE_HP);
	Template.ThrownGrenadeEffects.AddItem(ShieldedEffect);
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Flashbang.WP_Grenade_Flashbang";

	Template.CanBeBuilt = true;

	Template.iSoundRange = ENERGY_SHIELD_GRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = ENERGY_SHIELD_GRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 10;
	Template.PointsToComplete = 0;
	Template.iClipSize = ENERGY_SHIELD_GRENADE_ICLIPSIZE;
	Template.Tier = 1;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');

	// Cost
	Supplies.ItemTemplateName = 'Supplies';
	Supplies.Quantity = ENERGY_SHIELD_GRENADE_SUPPLY_COST;
	Template.Cost.ResourceCosts.AddItem(Supplies);

	Elerium.ItemTemplateName = 'EleriumDust';
	Elerium.Quantity = ENERGY_SHIELD_GRENADE_ELERIUM_COST;
	Template.Cost.ResourceCosts.AddItem(Elerium);

	Artifacts.ItemTemplateName = 'CorpseAdventShieldbearer';
	Artifacts.Quantity = ENERGY_SHIELD_GRENADE_CORPSE_COST;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	// Soldier Bark
	Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , ENERGY_SHIELD_GRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , ENERGY_SHIELD_GRENADE_RADIUS);

	return Template;
}