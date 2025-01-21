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

	public function acs_listContainerIds(id: CName): array<CName> 
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

    public function acs_load(id: CName, optional containerid: CName) : ACSStorageData 
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

    public function acs_save(savedata: ACSStorageData) : bool 
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

    public function acs_remove(id: CName, optional containerid: CName) : bool 
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

	public function acs_KillCount_Reset()
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

	public function acs_GetKillCount() : int
	{
		return killcount;
	}

	public function acs_GetKillCountString() : string
	{
		return IntToString(killcount);
	}

	public function acs_Killcount_Increment()
	{
		killcount += 1;
	}

	public function acs_GetHumanKillCount() : int
	{
		return human_killcount;
	}

	public function acs_GetHumanKillCountString() : string
	{
		return IntToString(human_killcount);
	}

	public function acs_HumanKillcount_Increment()
	{
		human_killcount += 1;
	}

	public function acs_GetBeastKillCount() : int
	{
		return beast_killcount;
	}

	public function acs_GetBeastKillCountString() : string
	{
		return IntToString(beast_killcount);
	}

	public function acs_BeastKillcount_Increment()
	{
		beast_killcount += 1;
	}

	public function acs_GetCursedOnesKillCount() : int
	{
		return cursed_ones_killcount;
	}

	public function acs_GetCursedOnesKillCountString() : string
	{
		return IntToString(cursed_ones_killcount);
	}

	public function acs_CursedOnesKillcount_Increment()
	{
		cursed_ones_killcount += 1;
	}

	public function acs_GetDraconidsKillCount() : int
	{
		return draconids_killcount;
	}

	public function acs_GetDraconidsKillCountString() : string
	{
		return IntToString(draconids_killcount);
	}

	public function acs_DraconidsKillcount_Increment()
	{
		draconids_killcount += 1;
	}

	public function acs_GetElementaKillCount() : int
	{
		return elementa_killcount;
	}

	public function acs_GetElementaKillCountString() : string
	{
		return IntToString(elementa_killcount);
	}

	public function acs_ElementaKillcount_Increment()
	{
		elementa_killcount += 1;
	}

	public function acs_GetHybridsKillCount() : int
	{
		return hybrids_killcount;
	}

	public function acs_GetHybridsKillCountString() : string
	{
		return IntToString(hybrids_killcount);
	}

	public function acs_HybridsKillcount_Increment()
	{
		hybrids_killcount += 1;
	}


	public function acs_GetInsectoidsKillCount() : int
	{
		return insectoids_killcount;
	}

	public function acs_GetInsectoidsKillCountString() : string
	{
		return IntToString(insectoids_killcount);
	}

	public function acs_InsectoidsKillcount_Increment()
	{
		insectoids_killcount += 1;
	}


	public function acs_GetNecrophagesKillCount() : int
	{
		return necrophages_killcount;
	}

	public function acs_GetNecrophagesKillCountString() : string
	{
		return IntToString(necrophages_killcount);
	}

	public function acs_NecrophagesKillcount_Increment()
	{
		necrophages_killcount += 1;
	}

	public function acs_GetOgroidsKillCount() : int
	{
		return ogroids_killcount;
	}

	public function acs_GetOgroidsKillCountString() : string
	{
		return IntToString(ogroids_killcount);
	}

	public function acs_OgroidsKillcount_Increment()
	{
		ogroids_killcount += 1;
	}

	public function acs_GetRelictsKillCount() : int
	{
		return relicts_killcount;
	}

	public function acs_GetRelictsKillCountString() : string
	{
		return IntToString(relicts_killcount);
	}

	public function acs_RelictsKillcount_Increment()
	{
		relicts_killcount += 1;
	}


	public function acs_GetSpectersKillCount() : int
	{
		return specters_killcount;
	}

	public function acs_GetSpectersKillCountString() : string
	{
		return IntToString(specters_killcount);
	}

	public function acs_SpectersKillcount_Increment()
	{
		specters_killcount += 1;
	}

	public function acs_GetVampiresKillCount() : int
	{
		return vampires_killcount;
	}

	public function acs_GetVampiresKillCountString() : string
	{
		return IntToString(vampires_killcount);
	}

	public function acs_VampiresKillcount_Increment()
	{
		vampires_killcount += 1;
	}

	public function acs_GetOtherKillCount() : int
	{
		return other_killcount;
	}

	public function acs_GetOtherKillCountString() : string
	{
		return IntToString(other_killcount);
	}

	public function acs_OtherKillcount_Increment()
	{
		other_killcount += 1;
	}

	public function acs_Number_Of_Bruxae_Slain() : int
	{
		return number_of_bruxae_slain;
	}

	public function acs_Number_Of_Bruxae_Slain_Increment()
	{
		number_of_bruxae_slain += 1;
	}

	public function acs_Number_Of_Bruxae_Slain_Reset()
	{
		number_of_bruxae_slain -= number_of_bruxae_slain;
	}

	public function acs_Unseen_Blade_Death_Count() : int
	{
		return unseen_blade_death_count;
	}

	public function acs_Unseen_Blade_Death_Count_Increment()
	{
		unseen_blade_death_count += 1;
	}

	public function acs_Unseen_Blade_Death_Count_Reset()
	{
		unseen_blade_death_count -= unseen_blade_death_count;
	}

	private var oneliner_counter: int;

	protected var oneliners: array<ACS_Oneliner>;

	protected var module_oneliners: CR4HudModuleOneliners;

	protected var module_flash: CScriptedFlashSprite;

	protected var module_hud: CR4ScriptedHud;

	private var fxCreateOnelinerSFF: CScriptedFlashFunction;

	private var fxRemoveOnelinerSFF: CScriptedFlashFunction;

	private function acs_onelinerInitialize() 
	{
		this.module_hud = (CR4ScriptedHud)theGame.GetHud();

		this.module_oneliners = (CR4HudModuleOneliners)(this.module_hud.GetHudModule( "OnelinersModule" ));

		this.module_flash = this.module_oneliners.GetModuleFlash();

		this.fxCreateOnelinerSFF 	= this.module_flash.GetMemberFlashFunction( "CreateOneliner" );

		this.fxRemoveOnelinerSFF 	= this.module_flash.GetMemberFlashFunction( "RemoveOneliner" );
	}

	private function acs_onelinerGetNewId(): int 
	{
		var id: int = Max(this.oneliner_counter, (int)theGame.GetLocalTimeAsMilliseconds());

		this.oneliner_counter = id + 1;

		return id;
	}

	public function acs_createOneliner(oneliner: ACS_Oneliner) 
	{
		var should_initialize_and_render: bool;

		should_initialize_and_render = this.GetCurrentStateName() != 'ACSStorageOnelinerRender';

		if (should_initialize_and_render) 
		{
			this.acs_onelinerInitialize();
		}

		oneliner.id = this.acs_onelinerGetNewId();

		this.acs_updateOneliner(oneliner);

		this.oneliners.PushBack(oneliner);

		if (should_initialize_and_render) 
		{
			this.GotoState('ACSStorageOnelinerRender');
		}
	}

	public function acs_updateOneliner(oneliner: ACS_Oneliner) 
	{
		this.fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(oneliner.id));

		this.fxCreateOnelinerSFF.InvokeSelfTwoArgs(
		FlashArgInt(oneliner.id),
		FlashArgString(oneliner.text)
		);
	}

	public function acs_deleteOneliner(oneliner: ACS_Oneliner) 
	{
		this.oneliners.Remove(oneliner);
		this.fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(oneliner.id));
	}

	public function acs_findOnelinerByTag(tag: string): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		for (i = 0; i < this.oneliners.Size(); i += 1) 
		{
			if (this.oneliners[i].tag == tag) 
			{
				output.PushBack(this.oneliners[i]);
			}
		}

		return output;
	}

	public function acs_setPositionForOnelinerByTag(tag: string, x, y, z : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetX(x);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetY(y);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetZ(z);
		}
	}

	public function acs_setAlphaForOnelinerByTag(tag: string, alpha : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetAlpha(alpha);
		}
	}

	public function acs_setScaleForOnelinerByTag(tag: string, scaleX, scaleY, scaleZ : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetXScale(scaleX);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetYScale(scaleY);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetZScale(scaleZ);
		}
	}

	public function acs_findOnelinerByTagPrefix(tag: string): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		for (i = 0; i < this.oneliners.Size(); i += 1) 
		{
			if (StrStartsWith(this.oneliners[i].tag, tag)) 
			{
				output.PushBack(this.oneliners[i]);
			}
		}

		return output;
	}

	public function acs_deleteOnelinerByTag(tag: string): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output = this.acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			this.acs_deleteOneliner(output[i]);
		}

		return output;
	}

	public function acs_deleteOnelinerByTagPrefix(tag: string): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output = this.acs_findOnelinerByTagPrefix(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			this.acs_deleteOneliner(output[i]);
		}

		return output;
	}

	public function acs_findOnelinerByID(id: int): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		for (i = 0; i < this.oneliners.Size(); i += 1) 
		{
			if (this.oneliners[i].id == id) 
			{
				output.PushBack(this.oneliners[i]);
			}
		}

		return output;
	}

	public function acs_deleteOnelinerByID(id: int): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output = this.acs_findOnelinerByID(id);

		for (i = 0; i < output.Size(); i += 1) 
		{
			this.acs_deleteOneliner(output[i]);
		}

		return output;
	}

	var leviathanPosition : Vector;

	public function acs_recordLeviathanPosition(pos: Vector)
	{
		leviathanPosition = pos;
	}

	public function acs_getLeviathanPosition() : Vector
	{
		return leviathanPosition;
	}
	
}

state acsStorageIdle in W3ACSStorage 
{
  	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
  	}
}

function ACS_Kill_Count_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035570) + ACS_Region_Name_Switch();

	Message = GetLocStringById(2117035594) + GetACSStorage().acs_GetKillCountString() 
	
	+ "<br/> <br/>" 
	
	+ GetLocStringById(2117035581) + GetACSStorage().acs_GetHumanKillCountString() 
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035582) + GetACSStorage().acs_GetBeastKillCountString() 
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035583) + GetACSStorage().acs_GetCursedOnesKillCountString()
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035584) + GetACSStorage().acs_GetDraconidsKillCountString()
	
	+ "<br/>" 
	
	+ GetLocStringById(2117035585) + GetACSStorage().acs_GetElementaKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035586) + GetACSStorage().acs_GetHybridsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035587) + GetACSStorage().acs_GetInsectoidsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035588) + GetACSStorage().acs_GetNecrophagesKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035589) + GetACSStorage().acs_GetOgroidsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035590) + GetACSStorage().acs_GetRelictsKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035591) + GetACSStorage().acs_GetSpectersKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035592) + GetACSStorage().acs_GetVampiresKillCountString()

	+ "<br/>" 
	
	+ GetLocStringById(2117035593) + GetACSStorage().acs_GetOtherKillCountString()
	
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