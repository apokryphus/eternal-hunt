// Bestiary

function ACSAlexanderBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodAlexanderBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodBerstukBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodSpecialEncountersBestiary','EHmodBladeOfTheUnseenBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodBruxaeBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodDrownersBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodFireWyrmBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalRandomEncountersBestiary','EHmodForestGodShadowsBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodGhoulsBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodSwordsmanBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodIceTitanBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodSpecialEncountersBestiary','EHmodKhagmarBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodKnightmareBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodLoviatarBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodNekkerGuardianBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodPixieGuardianBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalRandomEncountersBestiary','EHmodNightHunterBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodNovigradVampiresBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodRogueMagesBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodSpecialEncountersBestiary','EHmodVolosBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodWerewolvesBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodWildHuntHoundsBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodVampiresLifestealBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalRandomEncountersBestiary','EHmodWildHuntWarriorsBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodXenoSwarmSoldierBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodXenoSwarmTyrantBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodXenoSwarmWorkerBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodFireGargoyleBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodLynxAssassinBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodHellhoundBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodFogAssassinBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodCultOfMelusineBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodSpecialEncountersBestiary','EHmodMelusineBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodRioghanBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDuskwraithBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodSvalblodBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodVildkaarlBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodIncubusBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDraugBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDraugirBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodMegaWraithBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodFireGryphonBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodMulaBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodBloodHymBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodBumbakvetchBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalRandomEncountersBestiary','EHmodElderbloodAssassinBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodFrostBoarBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodNimeanPantherBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDemonicConstructBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodViyBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodPhoocaBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodPlumardBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodElementalTitansBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodTheBeastBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodGiantTrollsBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDarkKnightBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodVorefBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodMaerolornBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodIfritBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSIridescentSharleyBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodIridescentSharleyBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSChironexBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodChironexBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDaoBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDaoBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKnockerBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodKnockerBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNekuratBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodNekuratBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVendigoBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodVendigoBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSwarmMotherBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodSwarmMotherBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSUngoliantBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodUngoliantBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDullahanBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodDullahanBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSManticoreBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodManticoreBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKnightmareLesserBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodKnightmareLesserBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVigilosaurBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodVigilosaurBestiaryEnabled');
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
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary','EHmodEnhancedEnemiesOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSAdditionalRandomEncountersOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalRandomEncountersBestiary','EHmodAdditionalRandomEncounterssOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSAdditionalWorldEncountersOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary','EHmodAdditionalWorldEncounterssOverviewEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSSpecialEncountersOverviewEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodSpecialEncountersBestiary','EHmodSpecialEncounterssOverviewEnabled');
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