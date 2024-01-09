abstract class ACSStorageData
{
    public var id: CName;
    public var containerId: CName;
}

statemachine abstract class W3ACSStorage extends CPeristentEntity
{
	private saved var data										: array<ACSStorageData>;

	public saved var killcount 									: int;

	public saved var human_killcount 							: int;

	public saved var beast_killcount 							: int;

	public saved var cursed_ones_killcount 						: int;

	public saved var draconids_killcount 						: int;

	public saved var elementa_killcount 						: int;

	public saved var hybrids_killcount 							: int;

	public saved var insectoids_killcount 						: int;

	public saved var necrophages_killcount 						: int;

	public saved var ogroids_killcount 							: int;

	public saved var relicts_killcount 							: int;

	public saved var specters_killcount 						: int;

	public saved var vampires_killcount 						: int;

	public saved var other_killcount 							: int;

	public saved var number_of_bruxae_slain						: int;

	public saved var unseen_blade_death_count					: int;

	public function listContainerIds(id: CName): array<CName> 
	{
        var null: ACSStorageData;
        var containers: int = data.Size();
        var i: int;
        var result: array<CName>;

        for (i = 0; i < containers; i += 1) 
		{
            if (data[i].id == id) {
                result.PushBack(data[i].containerId);
            }
        }

        return result;
    }

    public function load(id: CName, optional containerid: CName) : ACSStorageData 
	{
        var null: ACSStorageData;
        var containers: int = data.Size();
        var i: int;

        for (i = 0; i < containers; i += 1) 
		{
            if (data[i].id == id && data[i].containerId == containerid) {
                return data[i];
            }
        }

        return null;
    }

    public function save(savedata: ACSStorageData) : bool 
	{
        var containers: int = data.Size();
        var i: int;

        if (savedata.id != '') {

            for (i = 0; i < containers; i += 1) 
			{
                if (data[i].id == savedata.id && data[i].containerId == savedata.containerId) 
				{
                    // replace
                    data[i] = savedata;
                    return true;
                }
            }

            data.PushBack(savedata);
            return true;
        }
        return false;
    }

    public function remove(id: CName, optional containerid: CName) : bool 
	{
        var containers: int = data.Size();
        var i: int;

        for (i = 0; i < containers; i += 1) 
		{
            if (data[i].id == id && data[i].containerId == containerid) 
			{
                data.Erase(i);
                return true;
            }
        }

        return false;
    }







	public function KillCount_Reset()
	{
		killcount -= killcount;		

		human_killcount -= human_killcount;						

		beast_killcount -= beast_killcount;						

		cursed_ones_killcount -= cursed_ones_killcount;					

		draconids_killcount -= draconids_killcount;					

		elementa_killcount -= elementa_killcount;					

		hybrids_killcount -= hybrids_killcount; 					

		insectoids_killcount -= insectoids_killcount;					

		necrophages_killcount -= necrophages_killcount;				

		ogroids_killcount -= ogroids_killcount;				

		relicts_killcount -= relicts_killcount;		

		specters_killcount -= specters_killcount;				

		vampires_killcount -= vampires_killcount;					

		other_killcount -= other_killcount;				
	}

	public function GetKillCount() : int
	{
		return killcount;
	}

	public function GetKillCountString() : string
	{
		return IntToString(killcount);
	}

	public function Killcount_Increment()
	{
		killcount += 1;
	}


	public function GetHumanKillCount() : int
	{
		return human_killcount;
	}

	public function GetHumanKillCountString() : string
	{
		return IntToString(human_killcount);
	}

	public function HumanKillcount_Increment()
	{
		human_killcount += 1;
	}


	public function GetBeastKillCount() : int
	{
		return beast_killcount;
	}

	public function GetBeastKillCountString() : string
	{
		return IntToString(beast_killcount);
	}

	public function BeastKillcount_Increment()
	{
		beast_killcount += 1;
	}


	public function GetCursedOnesKillCount() : int
	{
		return cursed_ones_killcount;
	}

	public function GetCursedOnesKillCountString() : string
	{
		return IntToString(cursed_ones_killcount);
	}

	public function CursedOnesKillcount_Increment()
	{
		cursed_ones_killcount += 1;
	}

	public function GetDraconidsKillCount() : int
	{
		return draconids_killcount;
	}

	public function GetDraconidsKillCountString() : string
	{
		return IntToString(draconids_killcount);
	}

	public function DraconidsKillcount_Increment()
	{
		draconids_killcount += 1;
	}

	public function GetElementaKillCount() : int
	{
		return elementa_killcount;
	}

	public function GetElementaKillCountString() : string
	{
		return IntToString(elementa_killcount);
	}

	public function ElementaKillcount_Increment()
	{
		elementa_killcount += 1;
	}

	public function GetHybridsKillCount() : int
	{
		return hybrids_killcount;
	}

	public function GetHybridsKillCountString() : string
	{
		return IntToString(hybrids_killcount);
	}

	public function HybridsKillcount_Increment()
	{
		hybrids_killcount += 1;
	}


	public function GetInsectoidsKillCount() : int
	{
		return insectoids_killcount;
	}

	public function GetInsectoidsKillCountString() : string
	{
		return IntToString(insectoids_killcount);
	}

	public function InsectoidsKillcount_Increment()
	{
		insectoids_killcount += 1;
	}


	public function GetNecrophagesKillCount() : int
	{
		return necrophages_killcount;
	}

	public function GetNecrophagesKillCountString() : string
	{
		return IntToString(necrophages_killcount);
	}

	public function NecrophagesKillcount_Increment()
	{
		necrophages_killcount += 1;
	}

	public function GetOgroidsKillCount() : int
	{
		return ogroids_killcount;
	}

	public function GetOgroidsKillCountString() : string
	{
		return IntToString(ogroids_killcount);
	}

	public function OgroidsKillcount_Increment()
	{
		ogroids_killcount += 1;
	}

	public function GetRelictsKillCount() : int
	{
		return relicts_killcount;
	}

	public function GetRelictsKillCountString() : string
	{
		return IntToString(relicts_killcount);
	}

	public function RelictsKillcount_Increment()
	{
		relicts_killcount += 1;
	}


	public function GetSpectersKillCount() : int
	{
		return specters_killcount;
	}

	public function GetSpectersKillCountString() : string
	{
		return IntToString(specters_killcount);
	}

	public function SpectersKillcount_Increment()
	{
		specters_killcount += 1;
	}

	public function GetVampiresKillCount() : int
	{
		return vampires_killcount;
	}

	public function GetVampiresKillCountString() : string
	{
		return IntToString(vampires_killcount);
	}

	public function VampiresKillcount_Increment()
	{
		vampires_killcount += 1;
	}

	public function GetOtherKillCount() : int
	{
		return other_killcount;
	}

	public function GetOtherKillCountString() : string
	{
		return IntToString(other_killcount);
	}

	public function OtherKillcount_Increment()
	{
		other_killcount += 1;
	}



















	public function Number_Of_Bruxae_Slain() : int
	{
		return number_of_bruxae_slain;
	}

	public function Number_Of_Bruxae_Slain_Increment()
	{
		number_of_bruxae_slain += 1;
	}

	public function Number_Of_Bruxae_Slain_Reset()
	{
		number_of_bruxae_slain -= number_of_bruxae_slain;
	}

	public function Unseen_Blade_Death_Count() : int
	{
		return unseen_blade_death_count;
	}

	public function Unseen_Blade_Death_Count_Increment()
	{
		unseen_blade_death_count += 1;
	}

	public function Unseen_Blade_Death_Count_Reset()
	{
		unseen_blade_death_count -= unseen_blade_death_count;
	}
}

function GetACSStorage() : W3ACSStorage 
{
    var storage: W3ACSStorage;
    var template : CEntityTemplate;
    var tags: array<CName>;

    storage = (W3ACSStorage)theGame.GetEntityByTag('acsstorage');

    if (!storage) 
	{
        template = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\ACS_Orodruin.w2ent", true);

        tags.PushBack('acsstorage');

        storage = (W3ACSStorage) theGame.CreateEntity( template, thePlayer.GetWorldPosition(), , , , , PM_Persist, tags);
    }

    return storage;
}

exec function acskillcount()
{
	GetWitcherPlayer().DisplayHudMessage( IntToString(FactsQuerySum("ACS_Persistent_Kill_Count")));
}

function ACS_Kill_Count_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035570) + ACS_Region_Name_Switch();

	Message = GetLocStringById(2117035594) + GetACSStorage().GetKillCountString() 
	
	+ "<br/> <br/>" 
	
	+ GetLocStringById(2117035581) + GetACSStorage().GetHumanKillCountString() 
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035582) + GetACSStorage().GetBeastKillCountString() 
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035583) + GetACSStorage().GetCursedOnesKillCountString()
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035584) + GetACSStorage().GetDraconidsKillCountString()
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035585) + GetACSStorage().GetElementaKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035586) + GetACSStorage().GetHybridsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035587) + GetACSStorage().GetInsectoidsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035588) + GetACSStorage().GetNecrophagesKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035589) + GetACSStorage().GetOgroidsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035590) + GetACSStorage().GetRelictsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035591) + GetACSStorage().GetSpectersKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035592) + GetACSStorage().GetVampiresKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035593) + GetACSStorage().GetOtherKillCountString()
	
	;

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

function ACS_Region_Name_Switch() : string
{
	var location_name : string;

	if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
	{
		location_name = GetLocStringById(2117035572);
	}
	else if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"
	)
	{
		location_name = GetLocStringById(2117035575);
	}
	else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"
	)
	{
		location_name = GetLocStringById(2117035576);
	}
	else if (theGame.GetWorld().GetDepotPath() == "levels\the_spiral\spiral.w2w"
	)
	{
		location_name = GetLocStringById(2117035577);
	}
	else if (theGame.GetWorld().GetDepotPath() == "levels\island_of_mist\island_of_mist.w2w"
	)
	{
		location_name = GetLocStringById(2117035578);
	}
	else if (theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"
	)
	{
		location_name = GetLocStringById(2117035571);
	}
	else if ( theGame.GetWorld().GetDepotPath() == "levels\wyzima_castle\wyzima_castle.w2w"
	)
	{
		location_name = GetLocStringById(2117035579);
	}
	else if (theGame.GetWorld().GetDepotPath() == "levels\prolog_village_winter\prolog_village.w2w"
	)
	{
		location_name = GetLocStringById(2117035574);
	}
	else if (theGame.GetWorld().GetDepotPath() == "levels\prolog_village\prolog_village.w2w"
	)
	{
		location_name = GetLocStringById(2117035573);
	}
	else
	{
		location_name = GetLocStringById(2117035580);
	}

	return location_name;
}