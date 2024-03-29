// Bestiary

function ACSEnhancedEnemiesBestiaryGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodEnhancedEnemiesBestiary', nam);

	return value;
}

function ACSAdditionalRandomEncountersBestiaryGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodAdditionalRandomEncountersBestiary', nam);

	return value;
}

function ACSAdditionalWorldEncountersBestiaryGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodAdditionalWorldEncountersBestiary', nam);

	return value;
}

function ACSSpecialEncountersBestiaryGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('EHmodSpecialEncountersBestiary', nam);

	return value;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACSAlexanderBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodAlexanderBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBerstukBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodBerstukBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBladeOfTheUnseenBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialEncountersBestiaryGetConfigValue('EHmodBladeOfTheUnseenBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBruxaeBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodBruxaeBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSDrownersBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodDrownersBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFireWyrmBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodFireWyrmBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSForestGodShadowsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalRandomEncountersBestiaryGetConfigValue('EHmodForestGodShadowsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGhoulsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodGhoulsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSwordsmanBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodSwordsmanBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSIceTitanBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodIceTitanBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKhagmarBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialEncountersBestiaryGetConfigValue('EHmodKhagmarBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKnightmareBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodKnightmareBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLoviatarBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodLoviatarBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNekkerGuardianBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodNekkerGuardianBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPixieGuardianBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodPixieGuardianBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNightHunterBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalRandomEncountersBestiaryGetConfigValue('EHmodNightHunterBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNovigradVampiresBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodNovigradVampiresBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSRogueMagesBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodRogueMagesBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVolosBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialEncountersBestiaryGetConfigValue('EHmodVolosBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWerewolvesBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodWerewolvesBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWildHuntHoundsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodWildHuntHoundsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVampiresLifestealBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodVampiresLifestealBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWildHuntWarriorsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalRandomEncountersBestiaryGetConfigValue('EHmodWildHuntWarriorsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSXenoSwarmSoldierBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodXenoSwarmSoldierBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSXenoSwarmTyrantBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodXenoSwarmTyrantBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSXenoSwarmWorkerBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodXenoSwarmWorkerBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFireGargoyleBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodFireGargoyleBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLynxAssassinBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodLynxAssassinBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFluffyBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodHellhoundBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFogAssassinBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodFogAssassinBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCultOfMelusineBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodCultOfMelusineBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSMelusineBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialEncountersBestiaryGetConfigValue('EHmodMelusineBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSRioghanBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodRioghanBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDuskwraithBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodDuskwraithBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSvalblodBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodSvalblodBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVildkaarlBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodVildkaarlBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSIncubusBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodIncubusBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDraugBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodDraugBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDraugirBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodDraugirBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSMegaWraithBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodMegaWraithBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFireGryphonBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodFireGryphonBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSMulaBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodMulaBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBloodHymBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodBloodHymBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBumbakvetchBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodBumbakvetchBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSElderbloodAssassinBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalRandomEncountersBestiaryGetConfigValue('EHmodElderbloodAssassinBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFrostBoarBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodFrostBoarBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNimeanPantherBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodNimeanPantherBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDemonicConstructBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodDemonicConstructBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSViyBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodViyBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPhoocaBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodPhoocaBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPlumardBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodPlumardBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSElementalTitansBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodElementalTitansBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSTheBeastBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodTheBeastBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGiantTrollsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodGiantTrollsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDarkKnightBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodDarkKnightBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVorefBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodVorefBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSMaerolornBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodMaerolornBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSIfritBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodIfritBestiaryEnabled');
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

function ACSEnhancedEnemiesOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSEnhancedEnemiesBestiaryGetConfigValue('EHmodEnhancedEnemiesOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACS_Enhanced_Enemies_Overview() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035768);

	Message = GetLocStringById(2117035769);

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

function ACSAdditionalRandomEncountersOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalRandomEncountersBestiaryGetConfigValue('EHmodAdditionalRandomEncounterssOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACS_Additional_Random_Encounters_Overview() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035770);

	Message = GetLocStringById(2117035771);

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

function ACSAdditionalWorldEncountersOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSAdditionalWorldEncountersBestiaryGetConfigValue('EHmodAdditionalWorldEncounterssOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACS_Additional_World_Encounters_Overview() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035772);

	Message = GetLocStringById(2117035773);

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

function ACSSpecialEncountersOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSpecialEncountersBestiaryGetConfigValue('EHmodSpecialEncounterssOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACS_Additional_Special_Encounters_Overview() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035774);

	Message = GetLocStringById(2117035775);

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Alexander_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035342);

	Message = GetLocStringById(2117035416);

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

function ACS_Berstuk_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035316);

	Message = GetLocStringById(2117035424);

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

function ACS_BladeOfTheUnseenn_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035319);

	Message = GetLocStringById(2117035425);

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

function ACS_Bruxae_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035417);

	Message = GetLocStringById(2117035426);

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

function ACS_Drowners_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035418);

	Message = GetLocStringById(2117035427);

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

function ACS_FireWyrm_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035337);

	Message = GetLocStringById(2117035428);

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

function ACS_ForestGodShadows_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035317);

	Message = GetLocStringById(2117035429);

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

function ACS_Ghouls_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035419);

	Message = GetLocStringById(2117035430);

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

function ACS_Swordsman_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035482);

	Message = GetLocStringById(2117035483);

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

function ACS_IceTitan_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035420);

	Message = GetLocStringById(2117035431);

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

function ACS_Khagmar_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035335);

	Message = GetLocStringById(2117035432);

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

function ACS_Knightmare_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035324);

	Message = GetLocStringById(2117035433);

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

function ACS_Loviatar_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035334);

	Message = GetLocStringById(2117035434);

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

function ACS_NekkerGuardian_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035318);

	Message = GetLocStringById(2117035435);

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

function ACS_NightHunter_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035353);

	Message = GetLocStringById(2117035436);

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

function ACS_NovigradVampires_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035421);

	Message = GetLocStringById(2117035437);

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

function ACS_RogueMages_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035343);

	Message = GetLocStringById(2117035438);

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

function ACS_Volos_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035320);

	Message = GetLocStringById(2117035439);

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

function ACS_Werewolves_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035445);

	Message = GetLocStringById(2117035446);

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

function ACS_WildHuntHounds_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035422);

	Message = GetLocStringById(2117035440);

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

function ACS_VampiresLifesteal_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449111);

	Message = GetLocStringById(2118449112);

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

function ACS_WildHuntWarriors_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035423);

	Message = GetLocStringById(2117035441);

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

function ACS_XenoSwarmSoldiers_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035357);

	Message = GetLocStringById(2117035442);

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

function ACS_XenoSwarmTyrant_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035356);

	Message = GetLocStringById(2117035443);

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

function ACS_XenoSwarmWorkers_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035358);

	Message = GetLocStringById(2117035444);

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

function ACS_FireGargoyle_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035517);

	Message = GetLocStringById(2117035522);

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

function ACS_LynxAssassin_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035523);

	Message = GetLocStringById(2117035524);

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

function ACS_Fluffy_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035561);

	Message = GetLocStringById(2117035562);

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

function ACS_Fog_Assassin_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035563);

	Message = GetLocStringById(2117035564);

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

function ACS_Cult_Of_Melusine_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035657);

	Message = GetLocStringById(2117035658);

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

function ACS_Melusine_Of_The_Storm_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035625);

	Message = GetLocStringById(2117035659);

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

function ACS_Rioghan_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035651);

	Message = GetLocStringById(2117035660);

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

function ACS_Duskwraith_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035700);

	Message = GetLocStringById(2117035704);

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

function ACS_Svalblod_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035694);

	Message = GetLocStringById(2117035702);

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

function ACS_Vildkaarl_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035701);

	Message = GetLocStringById(2117035703);

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

function ACS_Incubus_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035707);

	Message = GetLocStringById(2117035708);

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

function ACS_Draug_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035709);

	Message = GetLocStringById(2117035712);

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

function ACS_Draugir_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035710);

	Message = GetLocStringById(2117035713);

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

function ACS_MegaWraith_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035711);

	Message = GetLocStringById(2117035714);

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

function ACS_FireGryphon_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035715);

	Message = GetLocStringById(2117035716);

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

function ACS_Mula_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035717);

	Message = GetLocStringById(2117035718);

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

function ACS_Blood_Hym_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035776);

	Message = GetLocStringById(2117035777);

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

function ACS_Bumbakvetch_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449039);

	Message = GetLocStringById(2118449040);

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

function ACS_Elderblood_Assassin_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449001);

	Message = GetLocStringById(2118449042);

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

function ACS_Frost_Boar_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449003);

	Message = GetLocStringById(2118449043);

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

function ACS_Nimean_Panther_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449044);

	Message = GetLocStringById(2118449045);

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

function ACS_Pixie_Guardian_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449067);

	Message = GetLocStringById(2118449069);

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

function ACS_Demonic_Construct_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449068);

	Message = GetLocStringById(2118449070);

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

function ACS_Viy_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449077);

	Message = GetLocStringById(2118449078);

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

function ACS_Phooca_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449080);

	Message = GetLocStringById(2118449081);

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

function ACS_Plumard_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449084);

	Message = GetLocStringById(2118449085);

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

function ACS_ElementalTitans_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449096);

	Message = GetLocStringById(2118449097);

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

function ACS_GiantTrolls_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449087);

	Message = GetLocStringById(2118449088);

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

function ACS_TheBeast_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449093);

	Message = GetLocStringById(2118449094);

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

function ACS_DarkKnight_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449106);

	Message = GetLocStringById(2118449107);

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

function ACS_Voref_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449113);

	Message = GetLocStringById(2118449114);

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

function ACS_Maerolorn_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449120);

	Message = GetLocStringById(2118449121);

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

function ACS_Ifrit_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2118449123);

	Message = GetLocStringById(2118449124);

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