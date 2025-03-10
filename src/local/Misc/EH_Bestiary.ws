// Bestiary

function ACSEnhancedEnemyBestiaryEnabled( bestiaryEntry : name ): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodEnhancedEnemiesBestiary',bestiaryEntry);
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACSAdditionalRandomEncountersBestiaryEnabled( bestiaryEntry : name ): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalRandomEncountersBestiary',bestiaryEntry);
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACSAdditionalWorldEncountersBestiaryEnabled( bestiaryEntry : name ): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodAdditionalWorldEncountersBestiary',bestiaryEntry);
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}

	else return (bool)configValueString;
}

function ACSSpecialEncountersBestiaryEnabled( bestiaryEntry : name ): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('EHmodSpecialEncountersBestiary',bestiaryEntry);
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