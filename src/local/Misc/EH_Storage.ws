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

	/*
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
	*/

	public function acs_GetKillCountString(kill_count_type : name) : string
	{
		var killcount_type_to_return : string;

		switch(kill_count_type)
		{
			case 'other':
				killcount_type_to_return = IntToString(other_killcount);
			break;

			case 'vampire':
				killcount_type_to_return = IntToString(vampires_killcount);
			break;

			case 'spectre':
				killcount_type_to_return = IntToString(specters_killcount);
			break;

			case 'relict':
				killcount_type_to_return = IntToString(relicts_killcount);
			break;

			case 'ogroid':
				killcount_type_to_return = IntToString(ogroids_killcount);
			break;

			case 'necrophage':
				killcount_type_to_return = IntToString(necrophages_killcount);
			break;

			case 'insectoid':
				killcount_type_to_return = IntToString(insectoids_killcount);
			break;

			case 'hybrid':
				killcount_type_to_return = IntToString(hybrids_killcount);
			break;

			case 'elemental':
				killcount_type_to_return = IntToString(elementa_killcount);
			break;

			case 'draconid':
				killcount_type_to_return = IntToString(draconids_killcount);
			break;

			case 'cursed_one':
				killcount_type_to_return = IntToString(cursed_ones_killcount);
			break;

			case 'beast':
				killcount_type_to_return = IntToString(beast_killcount);
			break;

			case 'human':
				killcount_type_to_return = IntToString(human_killcount);
			break;

			case 'total':
				killcount_type_to_return = IntToString(killcount);
			break;

			default:
				killcount_type_to_return = IntToString(killcount);
			break;
		}

		return killcount_type_to_return;
	}

	public function acs_Killcount_Increment(kill_count_type : name)
	{
		switch(kill_count_type)
		{
			case 'other':
				other_killcount += 1;
			break;

			case 'vampire':
				vampires_killcount += 1;
			break;

			case 'spectre':
				specters_killcount += 1;
			break;

			case 'relict':
				relicts_killcount += 1;
			break;

			case 'ogroid':
				ogroids_killcount += 1;
			break;

			case 'necrophage':
				necrophages_killcount += 1;
			break;

			case 'insectoid':
				insectoids_killcount += 1;
			break;

			case 'hybrid':
				hybrids_killcount += 1;
			break;

			case 'elementa':
				elementa_killcount += 1;
			break;

			case 'draconid':
				draconids_killcount += 1;
			break;

			case 'cursed_one':
				cursed_ones_killcount += 1;
			break;

			case 'beast':
				beast_killcount += 1;
			break;

			case 'human':
				human_killcount += 1;
			break;

			case 'total':
				killcount += 1;
			break;

			default:
				killcount += 1;
			break;
		}
	}

	public function acs_Number_Of_Unseen_Blade_Slain_Manage(reset : bool)
	{
		if (reset)
		{
			number_of_bruxae_slain -= number_of_bruxae_slain;
		}
		else
		{
			number_of_bruxae_slain += 1;
		}
	}

	public function acs_Number_Of_Bruxae_Slain_Manage(reset : bool)
	{
		if (reset)
		{
			unseen_blade_death_count -= unseen_blade_death_count;
		}
		else
		{
			unseen_blade_death_count += 1;
		}
	}

	private var oneliner_counter: int;
	default oneliner_counter = 2117035;

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

	function ResetOnelinerIDs()
	{
		oneliner_counter -= oneliner_counter;

		oneliner_counter = 7035;
	}

	/*
	private function acs_onelinerGetNewId(): int 
	{
		var id: int;

		//id = Max(this.oneliner_counter, (int)theGame.GetLocalTimeAsMilliseconds());

		//this.oneliner_counter = id + 1;

		//return id;

		id = oneliner_counter;

		oneliner_counter += 1;

		return id;
	}
	*/

	/*
	public function acs_clearOneliners() 
	{
		var i: int;

		for (i = 0; i < this.oneliners.Size(); i += 1) 
		{
			this.fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(oneliners[i].id));
		}

		oneliner_counter = 2117035;

		this.oneliners.Clear();
	}
	*/

	public function acs_getOnelinerID(oneliner: ACS_Oneliner): int 
	{
		var id: int;

		id = oneliner.id;

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

		oneliner.id = oneliner_counter;

		oneliner_counter += 1;

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

		output.Clear();

		for (i = 0; i < this.oneliners.Size(); i += 1) 
		{
			if (this.oneliners[i].tag == tag) 
			{
				output.PushBack(this.oneliners[i]);
			}
		}

		return output;
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public function acs_setPositionForOnelinerByTag(tag: string, x, y, z : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetX(x);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetY(y);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetZ(z);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public function acs_setAlphaForOnelinerByTag(tag: string, alpha : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetAlpha(alpha);
		}
	}

	public function acs_setAlphaForOnelinerByID(id: int, alpha : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByID(id);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetAlpha(alpha);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public function acs_setRotationForOnelinerByTag(tag: string, rot : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetRotation(rot);
		}
	}

	public function acs_setRotationForOnelinerByID(id: int, rot : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByID(id);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetRotation(rot);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public function acs_setScaleForOnelinerByTag(tag: string, scaleX, scaleY, scaleZ : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByTag(tag);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetXScale(scaleX);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetYScale(scaleY);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetZScale(scaleZ);
		}
	}

	public function acs_setScaleForOnelinerByID(id: int, scaleX, scaleY, scaleZ : float)
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

		output = acs_findOnelinerByID(id);

		for (i = 0; i < output.Size(); i += 1) 
		{
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetXScale(scaleX);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetYScale(scaleY);
			module_flash.GetChildFlashSprite( "mcOneliner" + output[i].id ).SetZScale(scaleZ);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public function acs_findOnelinerByTagPrefix(tag: string): array<ACS_Oneliner> 
	{
		var output: array<ACS_Oneliner>;
		var i: int;

		output.Clear();

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

		output.Clear();

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

		output.Clear();

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

		output.Clear();

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

		output.Clear();

		output = this.acs_findOnelinerByID(id);

		for (i = 0; i < output.Size(); i += 1) 
		{
			this.acs_deleteOneliner(output[i]);
		}

		return output;
	}


	public var book_items_to_be_read      : array< SItemUniqueId >;	

	function GetBookItemsToBeRead( book : SItemUniqueId)
	{
		book_items_to_be_read.PushBack(book);
	}

	timer function AutoReadDelay( delta : float , id : int )
	{
		var i : int;
		var itemId : SItemUniqueId;
		var itemCategory : name;
		var isItemShematic : bool;
		var m_bookPopupData : BookPopupFeedback;

		for(i=0; i<book_items_to_be_read.Size(); i+=1)
		{
			itemId = book_items_to_be_read[i];

			itemCategory = thePlayer.inv.GetItemCategory( itemId );

			isItemShematic = itemCategory == 'alchemy_recipe' ||  itemCategory == 'crafting_schematic';

			if( !isItemShematic 
			&& ( thePlayer.GetInventory().ItemHasTag( itemId, 'ReadableItem' ) ) 
			&& !thePlayer.GetInventory().ItemHasTag( itemId, 'NoShow' ) 
			&& !thePlayer.GetInventory().IsBookRead ( itemId )
			)
			{
				m_bookPopupData = new BookPopupFeedback in this;
				m_bookPopupData.SetMessageTitle( GetLocStringByKeyExt(thePlayer.GetInventory().GetItemLocalizedNameByUniqueID(itemId)) );
				m_bookPopupData.SetMessageText( thePlayer.GetInventory().GetBookText(itemId) );
				m_bookPopupData.curInventory = thePlayer.GetInventory();
				m_bookPopupData.BlurBackground = true;
				m_bookPopupData.PauseGame = true;
				m_bookPopupData.singleBookMode = false;
				m_bookPopupData.bookItemId = itemId;
				
				theGame.RequestMenu('PopupMenu', m_bookPopupData);
			}
		}

		RemoveTimer('AutoReadClear');

		AddTimer('AutoReadClear', 0.125f / theGame.GetTimeScale(), false );
	} 

	timer function AutoReadClear( delta : float , id : int )
	{
		var i : int;
		var itemId : SItemUniqueId;
		var itemCategory : name;
		var isItemShematic : bool;

		for(i=0; i<book_items_to_be_read.Size(); i+=1)
		{
			itemId = book_items_to_be_read[i];

			itemCategory = thePlayer.inv.GetItemCategory( itemId );

			isItemShematic = itemCategory == 'alchemy_recipe' ||  itemCategory == 'crafting_schematic';

			if( !isItemShematic && ( thePlayer.GetInventory().ItemHasTag( itemId, 'ReadableItem' ) 
			|| thePlayer.GetInventory().ItemHasTag( itemId, 'Painting' ) ) && !thePlayer.GetInventory().ItemHasTag( itemId, 'NoNotification' ) )
			{
				thePlayer.GetInventory().ReadSchematicsAndRecipes(itemId);
			}
		}
		
		book_items_to_be_read.Clear();
	}

}

state acsStorageIdle in W3ACSStorage 
{
  	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
  	}
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