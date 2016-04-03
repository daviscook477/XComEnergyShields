class XES_UIScreenListenerNew extends UIScreenListener;

var bool didUpdateTemplates;
 
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UIChooseProject screenSpec;

	if(!didUpdateTemplates)
	{
		// Update the game state to include our new proving grounds projects.
		UpdateTemplates();
		didUpdateTemplates = true;
		// Update the UI screen to display them. (If you don't do this, the user won't see
		//  your projects the first time they click on the proving grounds. They'll only see
		//  them when they click back to it.
		screenSpec = UIChooseProject(Screen);
		screenSpec.GetItems();
		screenSpec.PopulateData();
	}  
}

function UpdateTemplates()
{
	local XESTech_EnergyShield tech;
	local X2TechTemplate tPersonal, tGroup;
	local XComGameStateHistory History;
	local XComGameState_Tech tPersonalState, tGroupState;
	local XComGameState NewGameState, PrevGameState;
	local XComGameStateContext context;
	local XComGameState_Tech TechState;
	local bool bP, bG;

	// Check to see if the proving grounds projects have already been added to the game state:
	History = `XCOMHISTORY;
	PrevGameState = History.GetGameStateFromHistory();
	context = PrevGameState.GetContext();
	NewGameState = History.CreateNewGameState(false, context);
	foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if (TechState.GetMyTemplateName() == 'XES_EnergyShieldPersonalTech')
		{
			bP = true;
		}
		if (TechState.GetMyTemplateName() == 'XES_EnergyShieldGroupTech')
		{
			bG = true;
		}
	}
	tech = new class'XESTech_EnergyShield';
	// If any of them haven't, then add them into the game state:
	if (!bP)
	{
		tPersonal = tech.CreateEnergyShieldPersonalTemplate();
		tPersonalState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
		tPersonalState.OnCreation(tPersonal);
		NewGameState.AddStateObject(tPersonalState);
	}
	if (!bG)
	{
		tGroup = tech.CreateEnergyShieldGroupTemplate();
		tGroupState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
		tGroupState.OnCreation(tGroup);
		NewGameState.AddStateObject(tGroupState);
	}
	History.AddGameStateToHistory(NewGameState);
}
 
// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen);
 
// This event is triggered after a screen loses focus
event OnLoseFocus(UIScreen Screen);
 
// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen);
 
defaultproperties
{
	// This is assigned to trigger only on the UI screen for chosing a proving grounds project.
	// If this was just assigned to be default, then it would trigger on the opening cut scene and
	//  break the first mission.
    ScreenClass = UIChooseProject;
}