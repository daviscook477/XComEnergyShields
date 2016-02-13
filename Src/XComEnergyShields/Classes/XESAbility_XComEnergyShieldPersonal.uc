// This is an Unreal Script

class XESAbility_XComEnergyShieldPersonal extends X2Ability config (EnergyShield);

// Properties from the base game.
var config int ENERGY_SHIELD_PERSONAL_DURATION;
var config int ENERGY_SHIELD_PERSONAL_CHARGES;
var config int ENERGY_SHIELD_PERSONAL_COOLDOWN;
var config int ENERGY_SHIELD_PERSONAL_GLOBAL_COOLDOWN;
var config int ENERGY_SHIELD_PERSONAL_HP;

// Most of this is carbon copied from the game file 'X2Ability_AdventShiledbearer.uc' I've made note of the changes.

// Functions are non-static in order to access config data.
function X2DataTemplate CreateXComEnergyShieldPersonalAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCharges Charges;
	local X2AbilityCost_Charges ChargeCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2Effect_PersistentStatChange ShieldedEffect;
	local X2AbilityMultiTarget_Radius MultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'XComEnergyShieldPersonal'); // Creating the ability 'XComEnergyShield'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Defensive;

	// The ability takes one action point but will end your turn.
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = ENERGY_SHIELD_PERSONAL_CHARGES; // Initial charges can be changed in the config now.
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = ENERGY_SHIELD_PERSONAL_COOLDOWN;
	Cooldown.NumGlobalTurns = ENERGY_SHIELD_PERSONAL_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	/*MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = ENERGY_SHIELD_PERSONAL_RANGE_METERS;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;*/ // Remove the multitargetting.

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Friendlies in the radius receives a shield receives a shield
	ShieldedEffect = CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), ENERGY_SHIELD_PERSONAL_HP);

	Template.AddShooterEffect(ShieldedEffect);
	Template.AddMultiTargetEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Shielded_BuildVisualization;
	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";
	
	return Template;
}

function X2Effect_PersistentStatChange CreateShieldedEffect(string FriendlyName, string LongDescription, int ShieldHPAmount)
{
	local X2Effect_EnergyShield ShieldedEffect;

	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(ENERGY_SHIELD_PERSONAL_DURATION, false, true, , eGameRule_PlayerTurnEnd);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, FriendlyName, LongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
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

simulated function Shielded_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationTrack EmptyTrack;
	local VisualizationTrack BuildTrack;
	local X2Action_PlayAnimation PlayAnimationAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, Context));
	//PlayAnimationAction.Params.AnimName = 'Pose';//'HL_EnergyShield'; // TODO: change this animation to something that XCOM soldiers can actually do.
	//OutVisualizationTracks.AddItem(BuildTrack);
}