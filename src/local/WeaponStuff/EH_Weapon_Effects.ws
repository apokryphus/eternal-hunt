
function ACSGetEquippedSword() : CEntity
{
	var blade_temp_ent			: CItemEntity;
		
	GetWitcherPlayer().GetInventory().GetCurrentlyHeldSwordEntity( blade_temp_ent );

	return blade_temp_ent;
}

///////////////////////////////////////////////////////////////////////////////////

function ACS_GetRuneLevel( count : int ) : name
{
	var runeLvl : name;

	switch ( count )
	{	
		case 0:
		{
			runeLvl = 'rune_lvl0';
			break;
		}
		case 1:
		{
			runeLvl = 'rune_lvl1';
			break;
		}
		case 2:
		{
			runeLvl = 'rune_lvl2';
			break;
		}
		case 3:
		{
			runeLvl = 'rune_lvl3';
			break;
	}
	}
	return runeLvl;
}

function ACS_GetRuneFxName( runeName : name ) : name
{
	var runeFx : name;
	
	switch ( runeName )
	{	
		case 'Rune stribog lesser':
		case 'Rune stribog':
		case 'Rune stribog greater':
		{
			runeFx = 'rune_stribog';
			break;
		}
		case 'Rune dazhbog lesser':
		case 'Rune dazhbog':
		case 'Rune dazhbog greater':
		{
			runeFx = 'rune_dazhbog';
			break;
		}
		case 'Rune devana lesser':
		case 'Rune devana':
		case 'Rune devana greater':
		{
			runeFx = 'rune_devana';
			break;
		}
		case 'Rune zoria lesser':
		case 'Rune zoria':
		case 'Rune zoria greater':
		{
			runeFx = 'rune_zoria';
			break;
		}
		case 'Rune morana lesser':
		case 'Rune morana':
		case 'Rune morana greater':
		{
			runeFx = 'rune_morana';
			break;
		}
		case 'Rune triglav lesser':
		case 'Rune triglav':
		case 'Rune triglav greater':
		{
			runeFx = 'rune_triglav';
			break;
		}
		case 'Rune svarog lesser':
		case 'Rune svarog':
		case 'Rune svarog greater':
		{
			runeFx = 'rune_svarog';
			break;
		}
		case 'Rune veles lesser':
		case 'Rune veles':
		case 'Rune veles greater':
		{
			runeFx = 'rune_veles';
			break;
		}
		case 'Rune perun lesser':
		case 'Rune perun':
		case 'Rune perun greater':
		{
			runeFx = 'rune_perun';
			break;
		}
		case 'Rune elemental lesser':
		case 'Rune elemental':
		case 'Rune elemental greater':
		{
			runeFx = 'rune_elemental';
			break;
		}
		case 'Rune pierog lesser':
		case 'Rune pierog':
		case 'Rune pierog greater':
		{
			runeFx = 'rune_pierog';
			break;
		}
		case 'Rune tvarog lesser':
		case 'Rune tvarog':
		case 'Rune tvarog greater':
		{
			runeFx = 'rune_tvarog';
			break;
		}
	}
	return runeFx;
}

function ACS_GetEnchantmentFxName( runeName : name ) : name
{
	var enchantmentFx : name;
	
	switch ( runeName )
	{	
		case 'Runeword 1':
		{
			enchantmentFx = 'runeword_replenishment';
			break;
		}
		case 'Runeword 2':
		{
			enchantmentFx = 'runeword_severance';
			break;
		}
		case 'Runeword 4':
		{
			enchantmentFx = 'runeword_invigoration';
			break;
		}
		case 'Runeword 5':
		{
			enchantmentFx = 'runeword_preservation';
			break;
		}
		case 'Runeword 6':
		{
			enchantmentFx = 'runeword_dumplings';
			break;
		}
		case 'Runeword 7':
		{
			enchantmentFx = 'runeword_exhaustion';
			break;
		}
		case 'Runeword 8':
		{
			enchantmentFx = 'runeword_placation';
			break;
		}
		case 'Runeword 10':
		{
			enchantmentFx = 'runeword_rejuvenation';
			break;
		}
		case 'Runeword 11':
		{
			enchantmentFx = 'runeword_prolongation';
			break;
		}
		case 'Runeword 12':
		{
			enchantmentFx = 'runeword_elation';
			break;
		}
	}
	return enchantmentFx;
}

///////////////////////////////////////////////////////////////////////////////////

function ACSSwordUpdateEnhancements( type : CName )
{
	var steelID, silverID 						: SItemUniqueId;
	var enhancements 							: array<name>;
	var runeCount 								: int;
	var blade_temp_ent							: CEntity;

	if (!ACS_Settings_Main_Bool('acs_player_equipment_visual_settings','acs_permanent_rune_glow', true))
	{
		return;
	}

	switch(type)
	{
		case 'quen_secondary':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_quen_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_4').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_5').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_6').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_quen_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_4').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_5').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_6').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('rune_blast_loop');
		break;

		case 'quen':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_quen_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_quen_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('rune_blast_loop');
		break;

		case 'yrden_secondary':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_yrden_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_4').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_5').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_6').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_yrden_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_4').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_5').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_6').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('rune_blast_loop');
		break;

		case 'yrden':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_yrden_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_4').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_5').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_6').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_7').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_7').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_8').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_8').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_yrden_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_4').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_5').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_6').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_7').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_7').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_8').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_8').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('rune_blast_loop');
		break;

		case 'aard_secondary':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_aard_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_4').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_5').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_6').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_7').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_7').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_8').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_8').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_aard_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_4').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_5').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_6').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_7').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_7').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_8').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_8').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('rune_blast_loop');
		break;

		case 'aard':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_aard_blade_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_4').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_5').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_6').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_7').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_7').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_8').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_8').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_aard_blade_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_4').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_5').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_6').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_6').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_7').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_7').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_8').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_8').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('rune_blast_loop');
			ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('rune_blast_loop');
		break;

		case 'axii_secondary':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_axii_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_axii_secondary_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('rune_blast_loop');
		break;

		case 'axii':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				ACSGetCEntity('acs_axii_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_1').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_2').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_3').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_4').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_5').StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

				ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				ACSGetCEntity('acs_axii_sword_1').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_1').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_2').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_2').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_3').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_3').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_4').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_4').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_5').StopEffect( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_5').StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

				ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
			}

			ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('rune_blast_loop');

			ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('rune_blast_loop');
		break;

		case 'silversword':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);

			enhancements.Clear();
			
			GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

			runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );

			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);

			if (GetWitcherPlayer().GetInventory().IsItemHeld( silverID ))
			{
				blade_temp_ent.DestroyEffect( 'cutscene_fx' );
			}
			else
			{
				if (!blade_temp_ent.IsEffectActive('cutscene_fx', false))
				{
					blade_temp_ent.PlayEffectSingle( 'cutscene_fx' );
				}
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneLevel( runeCount ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				}

				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
				}
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneLevel( runeCount ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				}

				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
				}
			}

			if (!blade_temp_ent.IsEffectActive('rune_blast_loop', false))
			{
				blade_temp_ent.PlayEffectSingle( 'rune_blast_loop' );
			}
		break;

		case 'steelsword':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

			runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );

			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);

			if (GetWitcherPlayer().GetInventory().IsItemHeld( steelID ))
			{
				blade_temp_ent.DestroyEffect( 'cutscene_fx' );
			}
			else
			{
				if (!blade_temp_ent.IsEffectActive('cutscene_fx', false))
				{
					blade_temp_ent.PlayEffectSingle( 'cutscene_fx' );
				}
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneLevel( runeCount ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				}

				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
				}
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneLevel( runeCount ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				}

				if (!blade_temp_ent.IsEffectActive(ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ), false))
				{
					blade_temp_ent.PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
				}
			}

			if (!blade_temp_ent.IsEffectActive('rune_blast_loop', false))
			{
				blade_temp_ent.PlayEffectSingle( 'rune_blast_loop' );
			}
		break;

		case 'default_sword':

			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

			enhancements.Clear();

			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

				runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
			}

			if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
			{
				if (!ACSGetEquippedSword().IsEffectActive(ACS_GetRuneLevel( runeCount ), false))
				{
					ACSGetEquippedSword().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				}

				if (!ACSGetEquippedSword().IsEffectActive(ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ), false))
				{
					ACSGetEquippedSword().PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
				}
			}
			else if ( 3 == runeCount && 1 == enhancements.Size() )
			{
				if (!ACSGetEquippedSword().IsEffectActive(ACS_GetRuneLevel( runeCount ), false))
				{
					ACSGetEquippedSword().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
				}

				if (!ACSGetEquippedSword().IsEffectActive(ACS_GetEnchantmentFxName( enhancements[ 0 ] ), false))
				{
					ACSGetEquippedSword().PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
				}
			}

			if (!ACSGetEquippedSword().IsEffectActive('rune_blast_loop', false))
			{
				ACSGetEquippedSword().PlayEffectSingle( 'rune_blast_loop' );
			}
		break;
	}
}

///////////////////////////////////////////////////////////////////////////////////

function ACSSwordPlayEffects( type : CName )
{
	switch(type)
	{
		case 'quen_secondary':
			ACSGetCEntity('acs_quen_secondary_sword_1').StopAllEffects();
			ACSGetCEntity('acs_quen_secondary_sword_2').StopAllEffects();
			ACSGetCEntity('acs_quen_secondary_sword_3').StopAllEffects();
			ACSGetCEntity('acs_quen_secondary_sword_4').StopAllEffects();
			ACSGetCEntity('acs_quen_secondary_sword_5').StopAllEffects();
			ACSGetCEntity('acs_quen_secondary_sword_6').StopAllEffects();

			ACSSwordUpdateEnhancements('quen_secondary');

			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('q308_hot_tip');
				ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('q308_hot_tip');
				ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('q308_hot_tip');
				ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('q308_hot_tip');
				ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('q308_hot_tip');
				ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('q308_hot_tip');

				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword1_fire_trail');
					
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('ice_sparks_trail');
					
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('aard_power');
					
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{	
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('yrden_power');
					
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('quen_power');
					
					ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'quen':
			ACSGetCEntity('acs_quen_sword_1').StopAllEffects();
			ACSGetCEntity('acs_quen_sword_2').StopAllEffects();
			ACSGetCEntity('acs_quen_sword_3').StopAllEffects();

			ACSSwordUpdateEnhancements('quen');

			if (ACSGetCEntity('acs_quen_sword_1').HasTag('acs_quen_sword_upgraded_2'))
			{
				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack_charged_no_overlay');
				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack_charged_no_overlay');
				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack_charged_no_overlay');
			}

			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword1_fire_trail');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('ice_sparks_trail');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('aard_power');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{
					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('yrden_power');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('quen_power');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'yrden_secondary':
			ACSGetCEntity('acs_yrden_secondary_sword_1').StopAllEffects();
			ACSGetCEntity('acs_yrden_secondary_sword_2').StopAllEffects();
			ACSGetCEntity('acs_yrden_secondary_sword_3').StopAllEffects();
			ACSGetCEntity('acs_yrden_secondary_sword_4').StopAllEffects();
			ACSGetCEntity('acs_yrden_secondary_sword_5').StopAllEffects();
			ACSGetCEntity('acs_yrden_secondary_sword_6').StopAllEffects();

			ACSSwordUpdateEnhancements('yrden_secondary');

			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword1_fire_trail');
					
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('ice_sparks_trail');
					
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('aard_power');
					
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{	
					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('yrden_power');

					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{

					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('quen_power');

					ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'yrden_small':
			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				if ( ACS_GetWeaponMode() == 0 
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2 )
				{
					if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1
					|| ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1
					|| ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1)
					{
						ACSGetCEntity('acs_yrden_sword_1').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_2').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_3').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_4').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_5').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_6').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_7').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_8').StopAllEffects();

						ACSSwordUpdateEnhancements('yrden');
				
						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('absorb_life');

						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('summon_shades');

						GetWitcherPlayer().PlayEffectSingle('heavy_attack_effect_narrow');
						GetWitcherPlayer().StopEffect('heavy_attack_effect_narrow');
					}
				}
				else if (ACS_GetWeaponMode() == 3)
				{
					if (ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel'))
					{
						//ACSGetEquippedSword().StopAllEffects();
							
						ACSGetEquippedSword().StopEffect('summon_shades');
						ACSGetEquippedSword().PlayEffectSingle('summon_shades');

						ACSGetEquippedSword().StopEffect('absorb_life');
						ACSGetEquippedSword().PlayEffectSingle('absorb_life');
						
						GetWitcherPlayer().PlayEffectSingle('heavy_attack_effect_narrow');
						GetWitcherPlayer().StopEffect('heavy_attack_effect_narrow');
					}
				}
			}
		break;

		case 'yrden_big':
			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				if ( ACS_GetWeaponMode() == 0 
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2 )
				{
					if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1
					|| ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1
					|| ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1)
					{
						ACSGetCEntity('acs_yrden_sword_1').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_2').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_3').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_4').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_5').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_6').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_7').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_8').StopAllEffects();

						ACSSwordUpdateEnhancements('yrden');
				
						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('ground_fx');

						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('special_attack_fx');

						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('special_trail');

						if (RandF() < 0.5)
						{
							GetWitcherPlayer().PlayEffectSingle('heavy_attack_effect');
							GetWitcherPlayer().StopEffect('heavy_attack_effect');
						}
						else
						{
							GetWitcherPlayer().PlayEffectSingle('heavy_attack_effect_bigger');
							GetWitcherPlayer().StopEffect('heavy_attack_effect_bigger');
						}
					}
				}
				else if (ACS_GetWeaponMode() == 3)
				{
					if (ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel'))
					{	
						//ACSGetEquippedSword().StopAllEffects();

						ACSGetEquippedSword().StopEffect('ground_fx');
						ACSGetEquippedSword().PlayEffectSingle('ground_fx');
							
						ACSGetEquippedSword().StopEffect('special_attack_fx');
						ACSGetEquippedSword().PlayEffectSingle('special_attack_fx');

						ACSGetEquippedSword().StopEffect('special_trail');
						ACSGetEquippedSword().PlayEffectSingle('special_trail');
						
						if (RandF() < 0.5)
						{
							GetWitcherPlayer().PlayEffectSingle('heavy_attack_effect');
							GetWitcherPlayer().StopEffect('heavy_attack_effect');
						}
						else
						{
							GetWitcherPlayer().PlayEffectSingle('heavy_attack_effect_bigger');
							GetWitcherPlayer().StopEffect('heavy_attack_effect_bigger');
						}
					}
				}
			}
		break;

		case 'yrden_around':
			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				if ( ACS_GetWeaponMode() == 0 
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2 )
				{
					if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1
					|| ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1
					|| ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1)
					{
						ACSGetCEntity('acs_yrden_sword_1').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_2').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_3').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_4').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_5').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_6').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_7').StopAllEffects();
						ACSGetCEntity('acs_yrden_sword_8').StopAllEffects();

						ACSSwordUpdateEnhancements('yrden');

						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('ground_fx');

						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('special_attack_fx');

						ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('special_trail');

						if (RandF() < 0.5)
						{
							GetWitcherPlayer().PlayEffectSingle('around_fx');
							GetWitcherPlayer().StopEffect('around_fx');
						}
					}
				}
				else if (ACS_GetWeaponMode() == 3)
				{
					if (ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel'))
					{
						//ACSGetEquippedSword().StopAllEffects();

						ACSGetEquippedSword().StopEffect('ground_fx');
						ACSGetEquippedSword().PlayEffectSingle('ground_fx');
							
						ACSGetEquippedSword().StopEffect('special_attack_fx');
						ACSGetEquippedSword().PlayEffectSingle('special_attack_fx');

						ACSGetEquippedSword().StopEffect('special_trail');
						ACSGetEquippedSword().PlayEffectSingle('special_trail');

						if (RandF() < 0.5)
						{
							GetWitcherPlayer().PlayEffectSingle('around_fx');
							GetWitcherPlayer().StopEffect('around_fx');
						}
					}
				}
			}
		break;

		case 'yrden':
			ACSGetCEntity('acs_yrden_sword_1').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_2').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_3').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_4').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_5').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_6').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_7').StopAllEffects();
			ACSGetCEntity('acs_yrden_sword_8').StopAllEffects();

			ACSSwordUpdateEnhancements('yrden');

			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword1_fire_trail');
					
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('ice_sparks_trail');
					
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('aard_power');
					
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{	
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('yrden_power');
					
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('quen_power');
					
					ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'aard_secondary':
			ACSGetCEntity('acs_aard_secondary_sword_1').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_2').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_3').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_4').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_5').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_6').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_7').StopAllEffects();
			ACSGetCEntity('acs_aard_secondary_sword_8').StopAllEffects();

			ACSSwordUpdateEnhancements('aard_secondary');

			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword1_fire_trail');
					
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('ice_sparks_trail');
					
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('aard_power');
					
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{	
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('yrden_power');
					
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('quen_power');
					
					ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'aard':
			ACSGetCEntity('acs_aard_blade_1').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_2').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_3').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_4').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_5').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_6').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_7').StopAllEffects();
			ACSGetCEntity('acs_aard_blade_8').StopAllEffects();

			ACSSwordUpdateEnhancements('aard');

			ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('special_trail_fx');
			ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('special_trail_fx');

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('fire_sparks_trail');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('fire_sparks_trail');

				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword1_fire_trail');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword1_fire_trail');
				
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword_igni');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword_igni');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			{
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('ice_sparks_trail');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('ice_sparks_trail');
				
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword_axii');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword_axii');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			{
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('aard_power');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('aard_power');
				
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword_aard');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword_aard');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			{
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('yrden_power');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('yrden_power');
				
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword_yrden');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword_yrden');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			{
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('quen_power');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('quen_power');
				
				ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword_quen');
				ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword_quen');
			}
		break;

		case 'quen_glow':
			if (ACS_GetWeaponMode() == 3)
			{
				if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' ))
				{
					GetWitcherPlayer().DestroyEffect('hand_special_fx');
					GetWitcherPlayer().PlayEffectSingle('hand_special_fx');

					GetWitcherPlayer().SoundEvent('qu_item_olgierd_sabre_pre_attack_fx');
					
					ACSGetEquippedSword().PlayEffectSingle('pre_special_attack_loop');
					ACSGetEquippedSword().StopEffect('pre_special_attack_loop');

					ACSGetEquippedSword().PlayEffectSingle('special_attack_trail');
					ACSGetEquippedSword().StopEffect('special_attack_trail');

					ACSGetEquippedSword().PlayEffectSingle('special_attack');
					ACSGetEquippedSword().StopEffect('special_attack');

					ACSGetEquippedSword().PlayEffectSingle('special_attack_charged');
					ACSGetEquippedSword().StopEffect('special_attack_charged');

					ACSGetEquippedSword().PlayEffectSingle('special_attack_ready');
					ACSGetEquippedSword().StopEffect('special_attack_ready');
				}
			}
			else
			{
				GetWitcherPlayer().DestroyEffect('hand_special_fx');
				GetWitcherPlayer().PlayEffectSingle('hand_special_fx');

				ACSGetCEntity('acs_quen_sword_1').StopEffect('pre_special_attack_loop');
				ACSGetCEntity('acs_quen_sword_2').StopEffect('pre_special_attack_loop');
				ACSGetCEntity('acs_quen_sword_3').StopEffect('pre_special_attack_loop');
				
				ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack_trail');
				ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack_trail');
				ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack_trail');
				
				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('pre_special_attack_loop');
				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('pre_special_attack_loop');
				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('pre_special_attack_loop');
				
				ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack_trail');
				ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack_trail');
				ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack_trail');

				ACSGetCEntity('acs_quen_sword_1').StopEffect('pre_special_attack_loop');
				ACSGetCEntity('acs_quen_sword_2').StopEffect('pre_special_attack_loop');
				ACSGetCEntity('acs_quen_sword_3').StopEffect('pre_special_attack_loop');
				
				ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack_trail');
				ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack_trail');
				ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack_trail');

				if (ACSGetCEntity('acs_quen_sword_1').HasTag('acs_quen_sword_upgraded_1'))
				{
					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack');

					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack_ready');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack_ready');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack_ready');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack_ready');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack_ready');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack_ready');

					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack');

					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack_charged');
				}
				else if (ACSGetCEntity('acs_quen_sword_1').HasTag('acs_quen_sword_upgraded_2'))
				{
					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack');

					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack_charged');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack');

					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack_charged');

					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack');

					ACSGetCEntity('acs_quen_sword_1').StopEffect('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_2').StopEffect('special_attack_charged');
					ACSGetCEntity('acs_quen_sword_3').StopEffect('special_attack_charged');
				}
			}
		break;

		case 'axii_secondary':
			ACSGetCEntity('acs_axii_secondary_sword_1').StopAllEffects();
			ACSGetCEntity('acs_axii_secondary_sword_2').StopAllEffects();
			ACSGetCEntity('acs_axii_secondary_sword_3').StopAllEffects();

			ACSSwordUpdateEnhancements('axii_secondary');

			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');

					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('ice_sparks_trail');

					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('aard_power');

					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{
					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('yrden_power');

					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('quen_power');

					ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'axii':
			ACSGetCEntity('acs_axii_sword_1').StopAllEffects();
			ACSGetCEntity('acs_axii_sword_2').StopAllEffects();
			ACSGetCEntity('acs_axii_sword_3').StopAllEffects();
			ACSGetCEntity('acs_axii_sword_4').StopAllEffects();
			ACSGetCEntity('acs_axii_sword_5').StopAllEffects();

			ACSSwordUpdateEnhancements('axii');
			
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2)
			{
				if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				{
					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('fire_sparks_trail');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('fire_sparks_trail');

					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword1_fire_trail');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword1_fire_trail');

					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword_igni');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword_igni');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
				{
					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('ice_sparks_trail');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('ice_sparks_trail');

					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword_axii');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword_axii');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
				{
					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('aard_power');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('aard_power');

					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword_aard');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword_aard');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
				{
					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('yrden_power');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('yrden_power');

					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword_yrden');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword_yrden');
				}
				else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
				{
					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('quen_power');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('quen_power');

					ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword_quen');
					ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword_quen');
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSSwordPlayEffects('default_sword');
			}
		break;

		case 'default_sword':
			ACSGetEquippedSword().StopEffect('fire_sparks_trail');

			ACSGetEquippedSword().StopEffect('runeword1_fire_trail');

			ACSGetEquippedSword().StopEffect('runeword_igni');

			ACSGetEquippedSword().StopEffect('ice_sparks_trail');

			ACSGetEquippedSword().StopEffect('runeword_axii');

			ACSGetEquippedSword().StopEffect('aard_power');

			ACSGetEquippedSword().StopEffect('runeword_aard');

			ACSGetEquippedSword().StopEffect('yrden_power');

			ACSGetEquippedSword().StopEffect('runeword_yrden');

			ACSGetEquippedSword().StopEffect('quen_power');

			ACSGetEquippedSword().StopEffect('runeword_quen');

			ACSSwordUpdateEnhancements('default_sword');
			
			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				ACSGetEquippedSword().PlayEffectSingle('fire_sparks_trail');

				ACSGetEquippedSword().PlayEffectSingle('runeword1_fire_trail');

				ACSGetEquippedSword().PlayEffectSingle('runeword_igni');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			{
				ACSGetEquippedSword().PlayEffectSingle('ice_sparks_trail');

				ACSGetEquippedSword().PlayEffectSingle('runeword_axii');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			{
				ACSGetEquippedSword().PlayEffectSingle('aard_power');

				ACSGetEquippedSword().PlayEffectSingle('runeword_aard');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			{
				ACSGetEquippedSword().PlayEffectSingle('yrden_power');

				ACSGetEquippedSword().PlayEffectSingle('runeword_yrden');
			}
			else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			{
				ACSGetEquippedSword().PlayEffectSingle('quen_power');

				ACSGetEquippedSword().PlayEffectSingle('runeword_quen');
			}
		break;
	}
}

///////////////////////////////////////////////////////////////////////////////////

function ACSSwordSummonEffect(type : CName)
{
	ACSGetEquippedSword().PlayEffectSingle('fire_sparks_trail');

	ACSGetEquippedSword().PlayEffectSingle('runeword1_fire_trail');

	ACSGetEquippedSword().PlayEffectSingle('fast_attack_buff');

	ACSGetEquippedSword().PlayEffectSingle('fast_attack_buff_hit');

	ACSGetEquippedSword().StopEffect('fast_attack_buff');

	ACSGetEquippedSword().StopEffect('fast_attack_buff_hit');

	ACSGetEquippedSword().StopEffect('fire_sparks_trail');

	ACSGetEquippedSword().StopEffect('runeword1_fire_trail');

	ACSSwordUpdateEnhancements('default_sword');
	
	return;

	/*
	switch(type)
	{
		case 'quen_secondary':
			ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('quen_secondary');
		break;

		case 'quen':
			ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('quen');

			if (ACSGetCEntity('acs_quen_sword_1').HasTag('acs_quen_sword_upgraded_2'))
			{
				if (!ACSGetCEntity('acs_quen_sword_1').IsEffectActive('special_attack_charged_no_overlay', false))
				{
					ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle('special_attack_charged_no_overlay');
				}

				if (!ACSGetCEntity('acs_quen_sword_2').IsEffectActive('special_attack_charged_no_overlay', false))
				{
					ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle('special_attack_charged_no_overlay');
				}

				if (!ACSGetCEntity('acs_quen_sword_3').IsEffectActive('special_attack_charged_no_overlay', false))
				{
					ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle('special_attack_charged_no_overlay');
				}
			}
		break;

		case 'yrden_secondary':
			ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('yrden_secondary');
		break;

		case 'yrden':
			ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('yrden');
		break;

		case 'aard_secondary':
			ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('aard_secondary');
		break;

		case 'aard':
			ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('aard');
		break;

		case 'axii_secondary':
			ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('axii_secondary');
		break;

		case 'axii':
			ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('fire_sparks_trail');
			ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle('runeword1_fire_trail');
			ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('axii');
		break;
		
		case 'igni':
			ACSGetEquippedSword().PlayEffectSingle('fire_sparks_trail');

			ACSGetEquippedSword().PlayEffectSingle('runeword1_fire_trail');

			ACSGetEquippedSword().PlayEffectSingle('fast_attack_buff');

			ACSGetEquippedSword().PlayEffectSingle('fast_attack_buff_hit');

			ACSGetEquippedSword().StopEffect('fast_attack_buff');

			ACSGetEquippedSword().StopEffect('fast_attack_buff_hit');

			ACSGetEquippedSword().StopEffect('fire_sparks_trail');

			ACSGetEquippedSword().StopEffect('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('default_sword');
		break;

		default:
			ACSGetEquippedSword().PlayEffectSingle('fire_sparks_trail');

			ACSGetEquippedSword().PlayEffectSingle('runeword1_fire_trail');

			ACSGetEquippedSword().PlayEffectSingle('fast_attack_buff');

			ACSGetEquippedSword().PlayEffectSingle('fast_attack_buff_hit');

			ACSGetEquippedSword().StopEffect('fast_attack_buff');

			ACSGetEquippedSword().StopEffect('fast_attack_buff_hit');

			ACSGetEquippedSword().StopEffect('fire_sparks_trail');

			ACSGetEquippedSword().StopEffect('runeword1_fire_trail');

			ACSSwordUpdateEnhancements('default_sword');
		break;
	}
	*/
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Attack_Trail(fx_name : CName)
{
	if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
	{
		ACSGetCEntity('acs_axii_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_axii_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_axii_sword_3').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_axii_sword_4').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_axii_sword_5').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_axii_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_axii_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_axii_sword_3').StopEffect(fx_name);
		ACSGetCEntity('acs_axii_sword_4').StopEffect(fx_name);
		ACSGetCEntity('acs_axii_sword_5').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
	{ 
		ACSGetCEntity('acs_axii_secondary_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_axii_secondary_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_axii_secondary_sword_3').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_axii_secondary_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_axii_secondary_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_axii_secondary_sword_3').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
	{
		ACSGetCEntity('acs_quen_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_sword_3').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_quen_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_sword_3').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_3').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_4').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_5').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_6').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_quen_secondary_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_3').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_4').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_5').StopEffect(fx_name);
		ACSGetCEntity('acs_quen_secondary_sword_6').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
	{
		ACSGetCEntity('acs_aard_blade_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_3').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_4').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_5').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_6').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_7').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_blade_8').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_aard_blade_1').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_2').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_3').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_4').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_5').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_6').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_7').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_blade_8').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_3').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_4').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_5').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_6').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_7').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_8').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_aard_secondary_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_3').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_4').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_5').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_6').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_7').StopEffect(fx_name);
		ACSGetCEntity('acs_aard_secondary_sword_8').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
	{
		ACSGetCEntity('acs_yrden_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_3').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_4').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_5').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_6').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_7').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_sword_8').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_yrden_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_3').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_4').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_5').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_6').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_7').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_sword_8').StopEffect(fx_name);
	}
	
	if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
	{
		ACSGetCEntity('acs_yrden_secondary_sword_1').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_2').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_3').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_4').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_5').PlayEffectSingle(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_6').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_yrden_secondary_sword_1').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_2').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_3').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_4').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_5').StopEffect(fx_name);
		ACSGetCEntity('acs_yrden_secondary_sword_6').StopEffect(fx_name);
	}

	if (ACSGetCEntity('acs_dagger_1'))
	{
		if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped') && !GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
		{
			ACSGetCEntity('acs_dagger_1').PlayEffectSingle(fx_name);

			ACSGetCEntity('acs_dagger_1').StopEffect(fx_name);
		}
	}

	if (ACSGetCEntity('ACS_Viper_Dagger_L'))
	{
		ACSGetCEntity('ACS_Viper_Dagger_L').PlayEffectSingle(fx_name);

		ACSGetCEntity('ACS_Viper_Dagger_L').StopEffect(fx_name);
	}

	if (ACSGetCEntity('acs_yrden_sidearm_1'))
	{
		ACSGetCEntity('acs_yrden_sidearm_1').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_yrden_sidearm_1').StopEffect(fx_name);
	}
	
	if (ACSGetCEntity('acs_yrden_sidearm_2'))
	{
		ACSGetCEntity('acs_yrden_sidearm_2').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_yrden_sidearm_2').StopEffect(fx_name);
	}
	
	if (ACSGetCEntity('acs_yrden_sidearm_3'))
	{
		ACSGetCEntity('acs_yrden_sidearm_3').PlayEffectSingle(fx_name);

		ACSGetCEntity('acs_yrden_sidearm_3').StopEffect(fx_name);
	}
}