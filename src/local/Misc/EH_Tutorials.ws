// Tutorials

function ACSAdditionalFeaturesTutorialsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodAdditionalFeaturesTutorials', nam);

	return value;
}

function ACSCombatTutorialsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodCombatTutorials', nam);

	return value;
}

function ACSItemTutorialsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodItemTutorials', nam);

	return value;
}

function ACSMovementTutorialsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodMovementTutorials', nam);

	return value;
}

function ACSWitcherSchoolTutorialsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodWitcherSchoolTutorials', nam);

	return value;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



function ACSRageTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodRageTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWeaponArtsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodWeaponArtsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDynamicEnemyBehaviorSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodDynamicEnemyBehaviorSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGuardsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodGuardsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSTransformationWerewolfTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodTransformationWerewolfTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGlideTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMovementTutorialsGetConfigValue('EHmodGlideTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBruxaDashTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMovementTutorialsGetConfigValue('EHmodBruxaDashTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWraithModeTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMovementTutorialsGetConfigValue('EHmodWraithModeTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLightsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodLightsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSQuickMeditationTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodQuickMeditationTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPerfectDodgesCountersTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodPerfectDodgesCountersTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSArmorSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodArmorSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSElementalComboSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodElementalComboSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSQuestTrackingSwapTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodQuestTrackingSwapTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCloakWeaponHideTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodCloakWeaponHideTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWitcherSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodWitcherSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWolfSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodWolfSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBearSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodBearSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCatSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodCatSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSViperSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodViperSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGriffinSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodGriffinSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSManticoreSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodManticoreSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSForgottenWolfSchoolTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSWitcherSchoolTutorialsGetConfigValue('EHmodForgottenWolfSchoolTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSZirealTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodZirealTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSMaskTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodMaskTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDurabilityTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodDurabilityTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSReadingAllItemsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodReadingAllItemsyTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLightningTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodLightningTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSAllBlackTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodAllBlackTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFinisherTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodFinisherTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWispTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel05TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWispLevel05TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel10TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWispLevel10TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel15TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWispLevel15TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel20TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWispLevel20TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWispLevel25TutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWispLevel25TutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWolfHeartTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodWolfHeartTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSVampireNecklaceTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodVampireNecklaceTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSPirateAmuletTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodPirateAmuletTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSHoodAndMaskTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodHoodAndMaskTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSParryTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodParryTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSBruxaFangTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodBruxaFangTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVampireRingTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodVampireRingTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSneakingTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSCombatTutorialsGetConfigValue('EHmodSneakingTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBowOfArtemisTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodBowOfArtemisTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCrossbowOfArtemisTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodCrossbowOfArtemisTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSToadPrinceVenomTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodToadPrinceVenomTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSHoldToRollTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSMovementTutorialsGetConfigValue('EHmodHoldToRollTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSRedMiasmalFragmentTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSItemTutorialsGetConfigValue('EHmodRedMiasmalFragmentTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNightVisionTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalFeaturesTutorialsGetConfigValue('EHmodNightVisionTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



function ACS_Rage_Tutorial() 
{
	if (FactsQuerySum("ACS_Rage_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Rage_Tutorial_Menu();

	FactsAdd("ACS_Rage_Tutorial_Shown", 1, -1);
}

function ACS_Rage_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035359);

	Message = GetLocStringById(2117035360);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Dynamic_Enemy_Behavior_System_Tutorial() 
{
	if (FactsQuerySum("ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Dynamic_Enemy_Behavior_System_Tutorial_Menu();

	FactsAdd("ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown", 1, -1);
}

function ACS_Dynamic_Enemy_Behavior_System_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035361);

	Message = GetLocStringById(2117035362);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Guards_Tutorial() 
{
	if (FactsQuerySum("ACS_Guards_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Guards_Tutorial_Menu();

	FactsAdd("ACS_Guards_Tutorial_Shown", 1, -1);
}

function ACS_Guards_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035363);

	Message = GetLocStringById(2117035364);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_TransformationWerewolf_Tutorial() 
{
	if (FactsQuerySum("ACS_Werewolf_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_TransformationWerewolf_Tutorial_Menu();

	FactsAdd("ACS_Werewolf_Tutorial_Shown", 1, -1);
}

function ACS_TransformationWerewolf_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035365);

	Message = GetLocStringById(2117035366);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Glide_Tutorial() 
{
	if (FactsQuerySum("ACS_Glide_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Glide_Tutorial_Menu();

	FactsAdd("ACS_Glide_Tutorial_Shown", 1, -1);
}

function ACS_Glide_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035367);

	Message = GetLocStringById(2117035368);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Bruxa_Dash_Tutorial() 
{
	if (FactsQuerySum("ACS_Bruxa_Dash_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Bruxa_Dash_Tutorial_Menu();

	FactsAdd("ACS_Bruxa_Dash_Tutorial_Shown", 1, -1);
}

function ACS_Bruxa_Dash_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035369);

	Message = GetLocStringById(2117035370);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wraith_Mode_Tutorial() 
{
	if (FactsQuerySum("ACS_Wraith_Mode_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wraith_Mode_Tutorial_Menu();

	FactsAdd("ACS_Wraith_Mode_Tutorial_Shown", 1, -1);
}

function ACS_Wraith_Mode_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035371);

	Message = GetLocStringById(2117035372);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Lights_Tutorial() 
{
	if (FactsQuerySum("ACS_Lights_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Lights_Tutorial_Menu();

	FactsAdd("ACS_Lights_Tutorial_Shown", 1, -1);
}

function ACS_Lights_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035447);

	Message = GetLocStringById(2117035448);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_QuickMeditation_Tutorial() 
{
	if (FactsQuerySum("ACS_QuickMeditation_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_QuickMeditation_Tutorial_Menu();

	FactsAdd("ACS_QuickMeditation_Tutorial_Shown", 1, -1);
}

function ACS_QuickMeditation_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035449);

	Message = GetLocStringById(2117035450);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_PerfectDodgesCounters_Tutorial() 
{
	if (FactsQuerySum("ACS_PerfectDodgesCounters_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_PerfectDodgesCounters_Tutorial_Menu();

	FactsAdd("ACS_PerfectDodgesCounters_Tutorial_Shown", 1, -1);
}

function ACS_PerfectDodgesCounters_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035451);

	Message = GetLocStringById(2117035452);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ArmorSystem_Tutorial() 
{
	if (FactsQuerySum("ACS_ArmorSystem_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ArmorSystem_Tutorial_Menu();

	FactsAdd("ACS_ArmorSystem_Tutorial_Shown", 1, -1);
}

function ACS_ArmorSystem_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035453);

	Message = GetLocStringById(2117035454);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ElementalComboSystem_Tutorial() 
{
	if (FactsQuerySum("ACS_ElementalComboSystem_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ElementalComboSystem_Tutorial_Menu();

	FactsAdd("ACS_ElementalComboSystem_Tutorial_Shown", 1, -1);
}

function ACS_ElementalComboSystem_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035474);

	Message = GetLocStringById(2117035475);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_QuestTrackingSwap_Tutorial() 
{
	if (FactsQuerySum("ACS_QuestTrackingSwap_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_QuestTrackingSwap_Tutorial_Menu();

	FactsAdd("ACS_QuestTrackingSwap_Tutorial_Shown", 1, -1);
}

function ACS_QuestTrackingSwap_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035476);

	Message = GetLocStringById(2117035477);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_CloakWeaponHide_Tutorial() 
{
	if (FactsQuerySum("ACS_CloakWeaponHide_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_CloakWeaponHide_Tutorial_Menu();

	FactsAdd("ACS_CloakWeaponHide_Tutorial_Shown", 1, -1);
}

function ACS_CloakWeaponHide_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035478);

	Message = GetLocStringById(2117035479);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_WitcherSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_WitcherSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_WitcherSchool_Tutorial_Menu();

	FactsAdd("ACS_WitcherSchool_Tutorial_Shown", 1, -1);
}

function ACS_WitcherSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035484);

	Message = GetLocStringById(2117035485);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_WolfSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_WolfSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_WolfSchool_Tutorial_Menu();

	FactsAdd("ACS_WolfSchool_Tutorial_Shown", 1, -1);
}

function ACS_WolfSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035498);

	Message = GetLocStringById(2117035499);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_BearSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_BearSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_BearSchool_Tutorial_Menu();

	FactsAdd("ACS_BearSchool_Tutorial_Shown", 1, -1);
}

function ACS_BearSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035486);

	Message = GetLocStringById(2117035487);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_CatSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_CatSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_CatSchool_Tutorial_Menu();

	FactsAdd("ACS_CatSchool_Tutorial_Shown", 1, -1);
}

function ACS_CatSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035488);

	Message = GetLocStringById(2117035489);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ViperSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_ViperSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ViperSchool_Tutorial_Menu();

	FactsAdd("ACS_ViperSchool_Tutorial_Shown", 1, -1);
}

function ACS_ViperSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035496);

	Message = GetLocStringById(2117035497);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_GriffinSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_GriffinSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_GriffinSchool_Tutorial_Menu();

	FactsAdd("ACS_GriffinSchool_Tutorial_Shown", 1, -1);
}

function ACS_GriffinSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035492);

	Message = GetLocStringById(2117035493);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ManticoreSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_ManticoreSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ManticoreSchool_Tutorial_Menu();

	FactsAdd("ACS_ManticoreSchool_Tutorial_Shown", 1, -1);
}

function ACS_ManticoreSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035494);

	Message = GetLocStringById(2117035495);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ForgottenWolfSchool_Tutorial() 
{
	if (FactsQuerySum("ACS_ForgottenWolfSchool_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ForgottenWolfSchool_Tutorial_Menu();

	FactsAdd("ACS_ForgottenWolfSchool_Tutorial_Shown", 1, -1);
}

function ACS_ForgottenWolfSchool_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035490);

	Message = GetLocStringById(2117035491);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Zireal_Tutorial() 
{
	if (FactsQuerySum("ACS_Zireal_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Zireal_Tutorial_Menu();

	FactsAdd("ACS_Zireal_Tutorial_Shown", 1, -1);
}

function ACS_Zireal_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035500);

	Message = GetLocStringById(2117035501);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Mask_Tutorial() 
{
	if (FactsQuerySum("ACS_Mask_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Mask_Tutorial_Menu();

	FactsAdd("ACS_Mask_Tutorial_Shown", 1, -1);
}

function ACS_Mask_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035508);

	Message = GetLocStringById(2117035509);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Durability_Tutorial() 
{
	if (FactsQuerySum("ACS_Durability_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Durability_Tutorial_Menu();

	FactsAdd("ACS_Durability_Tutorial_Shown", 1, -1);
}

function ACS_Durability_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035511);

	Message = GetLocStringById(2117035512);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Reading_All_Items_Tutorial() 
{
	if (FactsQuerySum("ACS_Reading_All_Items_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Reading_All_Items_Tutorial_Menu();

	FactsAdd("ACS_Reading_All_Items_Tutorial_Shown", 1, -1);
}

function ACS_Reading_All_Items_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035513);

	Message = GetLocStringById(2117035514);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Lightning_Tutorial() 
{
	if (FactsQuerySum("ACS_Lightning_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Lightning_Tutorial_Menu();

	FactsAdd("ACS_Lightning_Tutorial_Shown", 1, -1);
}

function ACS_Lightning_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035515);

	Message = GetLocStringById(2117035516);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_AllBlack_Tutorial() 
{
	if (FactsQuerySum("ACS_AllBlack_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_AllBlack_Tutorial_Menu();

	FactsAdd("ACS_AllBlack_Tutorial_Shown", 1, -1);
}

function ACS_AllBlack_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035520);

	Message = GetLocStringById(2117035521);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Finisher_Tutorial() 
{
	if (FactsQuerySum("ACS_Finisher_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Finisher_Tutorial_Menu();

	FactsAdd("ACS_Finisher_Tutorial_Shown", 1, -1);
}

function ACS_Finisher_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035536);

	Message = GetLocStringById(2117035537);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wisp_Tutorial() 
{
	if (FactsQuerySum("ACS_Wisp_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wisp_Tutorial_Menu();

	FactsAdd("ACS_Wisp_Tutorial_Shown", 1, -1);
}

function ACS_Wisp_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035540);

	Message = GetLocStringById(2117035541);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wisp_Level_05_Tutorial() 
{
	if (FactsQuerySum("ACS_Wisp_Level_05_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wisp_Level_05_Tutorial_Menu();

	FactsAdd("ACS_Wisp_Level_05_Tutorial_Shown", 1, -1);
}

function ACS_Wisp_Level_05_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035551);

	Message = GetLocStringById(2117035552);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wisp_Level_10_Tutorial() 
{
	if (FactsQuerySum("ACS_Wisp_Level_10_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wisp_Level_10_Tutorial_Menu();

	FactsAdd("ACS_Wisp_Level_10_Tutorial_Shown", 1, -1);
}

function ACS_Wisp_Level_10_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035553);

	Message = GetLocStringById(2117035554);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wisp_Level_15_Tutorial() 
{
	if (FactsQuerySum("ACS_Wisp_Level_15_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wisp_Level_15_Tutorial_Menu();

	FactsAdd("ACS_Wisp_Level_15_Tutorial_Shown", 1, -1);
}

function ACS_Wisp_Level_15_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035555);

	Message = GetLocStringById(2117035556);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wisp_Level_20_Tutorial() 
{
	if (FactsQuerySum("ACS_Wisp_Level_20_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wisp_Level_20_Tutorial_Menu();

	FactsAdd("ACS_Wisp_Level_20_Tutorial_Shown", 1, -1);
}

function ACS_Wisp_Level_20_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035557);

	Message = GetLocStringById(2117035558);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wisp_Level_25_Tutorial() 
{
	if (FactsQuerySum("ACS_Wisp_Level_25_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wisp_Level_25_Tutorial_Menu();

	FactsAdd("ACS_Wisp_Level_25_Tutorial_Shown", 1, -1);
}

function ACS_Wisp_Level_25_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035559);

	Message = GetLocStringById(2117035560);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wolf_Heart_Tutorial() 
{
	if (FactsQuerySum("ACS_Wolf_Heart_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wolf_Heart_Tutorial_Menu();

	FactsAdd("ACS_Wolf_Heart_Tutorial_Shown", 1, -1);
}

function ACS_Wolf_Heart_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035568);

	Message = GetLocStringById(2117035569);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Vampire_Necklace_Tutorial() 
{
	if (FactsQuerySum("ACS_Vampire_Necklace_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Vampire_Necklace_Tutorial_Menu();

	FactsAdd("ACS_Vampire_Necklace_Tutorial_Shown", 1, -1);
}

function ACS_Vampire_Necklace_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035661);

	Message = GetLocStringById(2117035662);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Pirate_Amulet_Tutorial() 
{
	if (FactsQuerySum("ACS_Pirate_Amulet_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Pirate_Amulet_Tutorial_Menu();

	FactsAdd("ACS_Pirate_Amulet_Tutorial_Shown", 1, -1);
}

function ACS_Pirate_Amulet_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035663);

	Message = GetLocStringById(2117035664);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Hood_And_Mask_Tutorial() 
{
	if (FactsQuerySum("ACS_Hood_And_Mask_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Hood_And_Mask_Tutorial_Menu();

	FactsAdd("ACS_Hood_And_Mask_Tutorial_Shown", 1, -1);
}

function ACS_Hood_And_Mask_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035705);

	Message = GetLocStringById(2117035706);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Parry_Tutorial() 
{
	if (FactsQuerySum("ACS_Parry_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Parry_Tutorial_Menu();

	FactsAdd("ACS_Parry_Tutorial_Shown", 1, -1);
}

function ACS_Parry_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035746);

	Message = GetLocStringById(2117035747);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Weapon_Arts_Tutorial() 
{
	if (FactsQuerySum("ACS_Weapon_Arts_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Weapon_Arts_Tutorial_Menu();

	FactsAdd("ACS_Weapon_Arts_Tutorial_Shown", 1, -1);
}

function ACS_Weapon_Arts_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035855);

	Message = GetLocStringById(2117035856);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Bruxa_Fang_Tutorial() 
{
	if (FactsQuerySum("ACS_Bruxa_Fang_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Bruxa_Fang_Tutorial_Menu();

	FactsAdd("ACS_Bruxa_Fang_Tutorial_Shown", 1, -1);
}

function ACS_Bruxa_Fang_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035891);

	Message = GetLocStringById(2117035892);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Vampire_Ring_Tutorial() 
{
	if (FactsQuerySum("ACS_Vampire_Ring_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Vampire_Ring_Tutorial_Menu();

	FactsAdd("ACS_Vampire_Ring_Tutorial_Shown", 1, -1);
}

function ACS_Vampire_Ring_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035893);

	Message = GetLocStringById(2117035894);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Sneaking_Tutorial() 
{
	if (FactsQuerySum("ACS_Sneaking_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Sneaking_Tutorial_Menu();

	FactsAdd("ACS_Sneaking_Tutorial_Shown", 1, -1);
}

function ACS_Sneaking_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035926);

	Message = GetLocStringById(2117035927);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Bow_Of_Artemis_Tutorial() 
{
	if (FactsQuerySum("ACS_Bow_Of_Artemis_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Bow_Of_Artemis_Tutorial_Menu();

	FactsAdd("ACS_Bow_Of_Artemis_Tutorial_Shown", 1, -1);
}

function ACS_Bow_Of_Artemis_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449049);

	Message = GetLocStringById(2118449050);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Crossbow_Of_Artemis_Tutorial() 
{
	if (FactsQuerySum("ACS_Crossbow_Of_Artemis_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Crossbow_Of_Artemis_Tutorial_Menu();

	FactsAdd("ACS_Crossbow_Of_Artemis_Tutorial_Shown", 1, -1);
}

function ACS_Crossbow_Of_Artemis_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449051);

	Message = GetLocStringById(2118449052);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Toad_Prince_Venom_Tutorial() 
{
	if (FactsQuerySum("ACS_Toad_Prince_Venom_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Toad_Prince_Venom_Tutorial_Menu();

	FactsAdd("ACS_Toad_Prince_Venom_Tutorial_Shown", 1, -1);
}

function ACS_Toad_Prince_Venom_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449053);

	Message = GetLocStringById(2118449054);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Hold_To_Roll_Tutorial() 
{
	if (FactsQuerySum("ACS_Hold_To_Roll_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Hold_To_Roll_Tutorial_Menu();

	FactsAdd("ACS_Hold_To_Roll_Tutorial_Shown", 1, -1);
}

function ACS_Hold_To_Roll_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449074);

	Message = GetLocStringById(2118449075);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Red_Miasmal_Fragment_Tutorial() 
{
	if (FactsQuerySum("ACS_Red_Miasmal_Fragment_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Red_Miasmal_Fragment_Tutorial_Menu();

	FactsAdd("ACS_Red_Miasmal_Fragment_Tutorial_Shown", 1, -1);
}

function ACS_Red_Miasmal_Fragment_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449104);

	Message = GetLocStringById(2118449105);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Night_Vision_Tutorial() 
{
	if (FactsQuerySum("ACS_Night_Vision_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Night_Vision_Tutorial_Menu();

	FactsAdd("ACS_Night_Vision_Tutorial_Shown", 1, -1);
}

function ACS_Night_Vision_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449126);

	Message = GetLocStringById(2118449127);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}