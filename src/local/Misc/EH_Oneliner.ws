function ACS_Oneliner(text: string, optional entity: CEntity, optional tag: string, optional offset: Vector, optional lifetime: float, optional render_distance: float, optional starting_alpha: float, optional starting_size_x, starting_size_y, starting_size_z : float, optional use_screen_pos : bool, optional screen_pos : Vector): ACS_Oneliner 
{
  var oneliner: ACS_Oneliner;

  oneliner = new ACS_Oneliner in theGame;
  oneliner.text = text;
  oneliner.entity = entity;
  oneliner.tag = tag;
  oneliner.offset = offset;
  oneliner.lifetime = lifetime;
  oneliner.render_distance = render_distance;
  oneliner.onelinerAlpha = starting_alpha;
  oneliner.onelinerScaleX = starting_size_x;
  oneliner.onelinerScaleY = starting_size_y;
  oneliner.onelinerScaleZ = starting_size_z;
  oneliner.use_screen_pos = use_screen_pos;
  oneliner.screen_pos = screen_pos;
  oneliner.register();

  return oneliner;
}

statemachine class ACS_Oneliner
{
  var tag: string;
  var id: int;
  var text: string;
  var visible: bool;
  var position: Vector;
  var offset: Vector;
  var entity: CEntity;
  var render_distance: float;
  var lifetime : float;
  var duration   : float;
	var directionX : float;
	var directionY : float;
	var riseSpeed  : float;
  var onelinerAlpha  : float;
  var onelinerScaleX  : float;
  var onelinerScaleY  : float;
  var onelinerScaleZ  : float;

  var npc_for_posture  : CNewNPC;

  var screen_pos: Vector;

  var use_screen_pos: bool;

  default lifetime = 0;

  default visible = true;

  default onelinerAlpha  = 0;

  default onelinerScaleX  = 100;
  default onelinerScaleY  = 100;
  default onelinerScaleZ  = 100;
	
	default duration  = 7.5f;
	default riseSpeed = 0.00001f;

  function register() 
  {
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;

    manager = GetACSStorage();
    manager.acs_createOneliner(this);

    onelinerID = manager.acs_getOnelinerID(this);

    manager.acs_setRotationForOnelinerByID(onelinerID, 0);

    visible = true;

    //onelinerAlpha  = 0;

    if (lifetime > 0)
    {
      GotoState('acs_oneliner_remove');
    }
  }

  function unregister() 
  {
    var manager: W3ACSStorage;

    manager = GetACSStorage();
    manager.acs_deleteOneliner(this);
  }

  function update() 
  {
    var manager: W3ACSStorage;

    manager = GetACSStorage();
    manager.acs_updateOneliner(this);
    
  }

  //////////////////////////////////////////////////////////////////////////////

  public function setRenderDistance(value: float): ACS_Oneliner 
  {
    this.render_distance = value;

    return this;
  }

  //////////////////////////////////////////////////////////////////////////////

  function getVisible(player_position: Vector): bool 
  {
    if (this.render_distance <= 0) 
	  {
      return this.visible;
    }

    return VecDistanceSquared2D(player_position, this.getEntityPosition()) <= this.render_distance * this.render_distance;
  }

  function getPosition(): Vector 
  {
    return this.position + this.offset;
  }

  function getScreenPosition(hud: CR4ScriptedHud, out screen_position: Vector): bool 
  {
    var world_position: Vector;
    var result: bool;

    if (use_screen_pos)
    {
      screen_position = hud.GetScaleformPoint(screen_pos.X, screen_pos.Y);

      return true;
    }

    world_position = this.getEntityPosition();

    result = WorldToScreenPosition(hud, world_position, screen_position);

    return result;
  }

  function SetPosition(value: Vector)
	{
		this.position = value;
	}
	

  function WorldToScreenPosition(hud: CR4ScriptedHud, world_position: Vector, out screen_position: Vector): bool 
  {
    if (!theCamera.WorldVectorToViewRatio(world_position, screen_position.X, screen_position.Y)) 
    {
      return false;
    }

    screen_position.X = (screen_position.X + 1) / 2;
    screen_position.Y = (screen_position.Y + 1) / 2;
    screen_position = hud.GetScaleformPoint(screen_position.X, screen_position.Y);

    return true;
  }

  var max_indicator : bool;

  var oneliner_indicator_name : name;

  var focus_bar_indicator_33, focus_bar_indicator_66, focus_bar_indicator_99 : bool;

  var medallion_back_glow, medallion_eyes_glow : bool;

  var player_sign_indicator_dimmed, player_sign_indicator_available, player_sign_indicator_activated : bool;

  var popup_static : bool;

  var background_bar : bool;

  var detected_enemy : CActor;

  var arrow_detection_type : bool;

  function run_enemy_detection(entity: CActor, detection_type : bool)
  {
    detected_enemy = entity;

    arrow_detection_type = detection_type;

    this.GotoState('acs_enemy_detection_indicator_running');
  }

  function run_indicator( indicator_name : name, optional npc : CNewNPC ) 
  {
    visible = true;

    oneliner_indicator_name = indicator_name;

    switch (indicator_name)
    {
      case 'compass_bar':
        this.GotoState('acs_oneliner_compass_bar_running');
      break;

      case 'popup_static':
        onelinerScaleX  = 0;
        onelinerScaleY  = 0;
        onelinerScaleZ  = 0;

        onelinerAlpha  = 100;

        popup_static = true;

        this.GotoState('acs_oneliner_popup_running');
      break;

      case 'popup':
        onelinerScaleX  = 0;
        onelinerScaleY  = 0;
        onelinerScaleZ  = 0;

        onelinerAlpha  = 100;

        this.GotoState('acs_oneliner_popup_running');
      break;

      case 'clue_icon':
        //this.GotoState('acs_focus_bar_indicator_99_running');
        this.GotoState('acs_clue_icon_running');
      break;

      case 'player_focus_bar_99_max_indicator':
        max_indicator = true;
        focus_bar_indicator_99 = true;
        background_bar = false;
        //this.GotoState('acs_focus_bar_indicator_99_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_66_max_indicator':
        max_indicator = true;
        focus_bar_indicator_66 = true;
        background_bar = false;
        //this.GotoState('acs_focus_bar_indicator_66_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_33_max_indicator':
        max_indicator = true;
        focus_bar_indicator_33 = true;
        background_bar = false;
        //this.GotoState('acs_focus_bar_indicator_33_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_99':
        max_indicator = false;
        focus_bar_indicator_99 = true;
        background_bar = false;
       // this.GotoState('acs_focus_bar_indicator_99_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_66':
        max_indicator = false;
        focus_bar_indicator_66 = true;
        background_bar = false;
        //this.GotoState('acs_focus_bar_indicator_66_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_33':
        max_indicator = false;
        focus_bar_indicator_33 = true;
        background_bar = false;
        //this.GotoState('acs_focus_bar_indicator_33_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;


      case 'player_focus_bar_99_background':
        max_indicator = false;
        focus_bar_indicator_99 = true;
        background_bar = true;
       // this.GotoState('acs_focus_bar_indicator_99_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_66_background':
        max_indicator = false;
        focus_bar_indicator_66 = true;
        background_bar = true;
        //this.GotoState('acs_focus_bar_indicator_66_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;

      case 'player_focus_bar_33_background':
        max_indicator = false;
        focus_bar_indicator_33 = true;
        background_bar = true;
        //this.GotoState('acs_focus_bar_indicator_33_running');
        this.GotoState('acs_focus_bar_indicator_running');
      break;



      case 'player_sign_indicator_dimmed':
        player_sign_indicator_dimmed = true;
        this.GotoState('acs_player_sign_indicator_running');
      break;

      case 'player_sign_indicator_available':
        player_sign_indicator_available = true;
        this.GotoState('acs_player_sign_indicator_running');
      break;

      case 'player_sign_indicator_activated':
        player_sign_indicator_activated = true;
        this.GotoState('acs_player_sign_indicator_running');
      break;

      case 'grey_health_bar_vanilla_indicator':
        max_indicator = false;
        this.GotoState('acs_grey_health_bar_vanilla_indicator_running');
      break;

      case 'player_posture_bar_vanilla_max_indicator':
        max_indicator = true;
        this.GotoState('acs_player_posture_bar_vanilla_indicator_running');
      break;

      case 'player_posture_bar_vanilla_indicator':
        this.GotoState('acs_player_posture_bar_vanilla_indicator_running');
      break;

      case 'wolf_head_indicator':
        medallion_back_glow = false;
        medallion_eyes_glow = false;
        this.GotoState('acs_wolf_head_indicator_running');
      break;

      case 'wolf_head_back_glow_indicator':
        medallion_back_glow = true;
        this.GotoState('acs_wolf_head_indicator_running');
      break;

      case 'wolf_head_eyes_glow_indicator':
        medallion_eyes_glow = true;
        this.GotoState('acs_wolf_head_indicator_running');
      break;

      /*
      case 'player_posture_bar_max_indicator':
        max_indicator = true;
        this.GotoState('acs_player_posture_bar_indicator_running');
      break;

      case 'player_posture_bar':
        max_indicator = false;
        this.GotoState('acs_player_posture_bar_indicator_running');
      break;
      */

      case 'enemy_posture_bar_background_indicator':
        max_indicator = true;
        npc_for_posture = npc;
        background_bar = true;
        this.GotoState('acs_enemy_posture_bar_indicator_running');
      break;

      case 'enemy_posture_bar_max_indicator':
        max_indicator = true;
        npc_for_posture = npc;
        background_bar = false;
        this.GotoState('acs_enemy_posture_bar_indicator_running');
      break;

      case 'enemy_posture_bar':
        max_indicator = false;
        npc_for_posture = npc;
        background_bar = false;
        this.GotoState('acs_enemy_posture_bar_indicator_running');
      break;

      case 'toxicity_bar':
        background_bar = false;
        this.GotoState('acs_toxicity_bar_indicator_running');
      break;

      case 'toxicity_bar_background':
        background_bar = true;
        this.GotoState('acs_toxicity_bar_indicator_running');
      break;

      case 'stamina_bar':
        background_bar = false;
        this.GotoState('acs_stamina_bar_indicator_running');
      break;

      case 'stamina_bar_background':
        background_bar = true;
        this.GotoState('acs_stamina_bar_indicator_running');
      break;

      case 'grey_health_bar':
        this.GotoState('acs_grey_health_bar_indicator_running');
      break;

      case 'health_bar':
        background_bar = false;
        this.GotoState('acs_health_bar_indicator_running');
      break;

      case 'health_bar_background':
        background_bar = true;
        this.GotoState('acs_health_bar_indicator_running');
      break;

      default:

      break;
    }
  }

  function getEntityPosition(): Vector 
  {
    return this.entity.GetWorldPosition() + this.offset;
  }
}

//////////////////////////////////////////////////////////////////////////////

state acs_oneliner_compass_bar_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_oneliner_compass_bar_running_entry();
  }

  entry function acs_oneliner_compass_bar_running_entry()
	{
    var manager                      							  : W3ACSStorage;
    var onelinerID                   							  : int;
    var newOnelinerAlpha              						  : float;
    var newOnelinerScaleX            							  : float;
    var newOnelinerScaleY            							  : float;
    var newOnelinerScaleZ             							: float;
    var hud									        								: CR4ScriptedHud;
    var screenMarginX 					  									: float; 
    var screenMarginY 					  									: float = 0.000000000125; 
    var currentWidth, currentHeight 								: int;
    var ratio                      									: float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setAlphaForOnelinerByID(onelinerID, 75);

		while(true)
		{
      theGame.GetCurrentViewportResolution( currentWidth, currentHeight );

      ratio = ( (float)currentWidth ) / currentHeight;

      if (ACS_Settings_Main_Int('acs_hud_settings_markers','acs_compass_bar_size', 0) == 1)
      {

        if ( AbsF( ratio - 21.0 / 9.0 ) < 0.06 )
        {
          newOnelinerScaleX = 200; 
        }
        else
        {
          newOnelinerScaleX = 150; 
        }
      }
      else
      {
        if ( AbsF( ratio - 21.0 / 9.0 ) < 0.06 )
        {
          newOnelinerScaleX = 125; 
        }
        else
        {
          newOnelinerScaleX = 100; 
        }
      }

      newOnelinerScaleY = 75;

      newOnelinerScaleZ = 100;

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      if(GetACSWatcher().RadialMenuCheck()
      || GetACSWatcher().HudExceptionCheck() 
      || ACS_GetNearbyEnemyLocation() != Vector(0,0,-200)
      || ACS_MapPinsCheck()
      || thePlayer.IsAnyWeaponHeld()
      )
      {
        manager.acs_setAlphaForOnelinerByID(onelinerID, 75);
      }

			SleepOneFrame();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_enemy_detection_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_enemy_detection_indicator_running_entry();
  }

  entry function acs_enemy_detection_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var detected_enemy                : CActor;
    var alpha                         : float;
    var targetDistance 								: float;
    var o                             : float;
    var npcStorage 										: CBaseAICombatStorage;
    var alpha_check                   : bool;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    detected_enemy = parent.detected_enemy;

    npcStorage = (CBaseAICombatStorage)detected_enemy.GetScriptStorageObject('CombatData');

    if (parent.arrow_detection_type)
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 0);
    }
    else
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 100);
    }
    
    manager.acs_setScaleForOnelinerByID(onelinerID, 50, 50, 50);

		while(true)
		{
      if(!detected_enemy.IsAlive() 
      || detected_enemy.IsKnockedUnconscious()
      || !detected_enemy
      //|| detected_enemy.GetTarget() != thePlayer
      || GetAttitudeBetween( thePlayer, detected_enemy ) != AIA_Hostile
      )
      {
        break;
      }

      if (thePlayer.IsThreatened()
      || thePlayer.IsInCombat()
      )
      {
        if (detected_enemy.GetTarget() == thePlayer)
        {
          if ( !thePlayer.WasVisibleInScaledFrame( detected_enemy, 1, 1 ) )
          {
            if (parent.arrow_detection_type)
            {
              if (detected_enemy.ACS_attack_duration_active
              || detected_enemy.HasTag('ACS_Ghoul_Firing_Projectile')
              || detected_enemy.HasTag('ACS_Bomber')
              || detected_enemy.HasTag('ACS_In_Rage')
              || detected_enemy.HasTag('ACS_Pre_Rage')
              //|| npcStorage.GetIsInImportantAnim()
              || npcStorage.GetIsAttacking()
              || npcStorage.GetIsCharging()
              //|| npcStorage.GetIsTaunting()
              || npcStorage.GetIsShooting()
              || npcStorage.GetIsAiming()
              )
              {
                if (alpha >= 100)
                {
                  alpha_check = true;
                }
                else if (alpha <= 0)
                {
                  alpha_check = false;
                }

                if (!alpha_check)
                {
                  alpha += 1;
                }
                else
                {
                  alpha -= 1;
                }

                newOnelinerScaleX += 1;

                newOnelinerScaleY += 1;

                newOnelinerScaleZ += 1;

                if (newOnelinerScaleX >= 37)
                {
                  newOnelinerScaleX = 37;
                }
              }
              else
              {
                alpha_check = false;

                alpha -= 0.5;

                if (alpha <= 0)
                {
                  alpha = 0;
                }

                newOnelinerScaleX -= 0.5;

                newOnelinerScaleY -= 0.5;

                newOnelinerScaleZ -= 0.5;

                if (newOnelinerScaleX <= 33)
                {
                  newOnelinerScaleX = 33;
                }
              }
            }
            else
            {
              alpha_check = false;

              alpha += 1;

              if (alpha >= 100)
              {
                alpha = 100;
              }

              newOnelinerScaleX += 1;

              newOnelinerScaleY += 1;

              newOnelinerScaleZ += 1;

              if (newOnelinerScaleX >= 33)
              {
                newOnelinerScaleX = 40;
              }
            }
          }
          else
          {
            if (parent.arrow_detection_type)
            {
              if ( npcStorage.GetIsShooting()
              || npcStorage.GetIsAiming()
              )
              {
                if (alpha >= 100)
                {
                  alpha_check = true;
                }
                else if (alpha <= 0)
                {
                  alpha_check = false;
                }

                if (!alpha_check)
                {
                  alpha += 1;
                }
                else
                {
                  alpha -= 1;
                }

                newOnelinerScaleX += 1;

                newOnelinerScaleY += 1;

                newOnelinerScaleZ += 1;

                if (newOnelinerScaleX >= 37)
                {
                  newOnelinerScaleX = 50;
                }
              }
              else
              {
                alpha_check = false;

                alpha -= 0.5;

                if (alpha <= 0)
                {
                  alpha = 0;
                }

                newOnelinerScaleX -= 0.5;

                newOnelinerScaleY -= 0.5;

                newOnelinerScaleZ -= 0.5;

                if (newOnelinerScaleX <= 0)
                {
                  newOnelinerScaleX = 0;
                }
              }
            }
            else
            {
              alpha_check = false;

              if ( npcStorage.GetIsShooting()
              || npcStorage.GetIsAiming()
              )
              {
                alpha += 1;

                if (alpha >= 100)
                {
                  alpha = 100;
                }

                newOnelinerScaleX += 1;

                newOnelinerScaleY += 1;

                newOnelinerScaleZ += 1;

                if (newOnelinerScaleX >= 33)
                {
                  newOnelinerScaleX = 33;
                }
              }
              else
              {
                alpha -= 0.5;

                if (alpha <= 0)
                {
                  alpha = 0;
                }

                newOnelinerScaleX -= 0.5;

                newOnelinerScaleY -= 0.5;

                newOnelinerScaleZ -= 0.5;

                if (newOnelinerScaleX <= 0)
                {
                  newOnelinerScaleX = 0;
                }
              }
            }
          }
        }
        else
        {
          alpha_check = false;

          alpha -= 0.5;

          if (alpha <= 0)
          {
            alpha = 0;
          }

          newOnelinerScaleX -= 0.5;

          newOnelinerScaleY -= 0.5;

          newOnelinerScaleZ -= 0.5;

          if (newOnelinerScaleX <= 0)
          {
            newOnelinerScaleX = 0;
          }
        }
      }
      else
      {
        alpha_check = false;
         
        if (parent.arrow_detection_type)
        {
          alpha -= 0.5;

          if (alpha <= 0)
          {
            alpha = 0;
          }

          newOnelinerScaleX -= 0.5;

          newOnelinerScaleY -= 0.5;

          newOnelinerScaleZ -= 0.5;

          if (newOnelinerScaleX <= 0)
          {
            newOnelinerScaleX = 0;
          }
        }
        else
        {
          if(theGame.IsFocusModeActive())
          {
            alpha += 1;

            if (alpha >= 100)
            {
              alpha = 100;
            }

            newOnelinerScaleX += 1;

            newOnelinerScaleY += 1;

            newOnelinerScaleZ += 1;

            if (newOnelinerScaleX >= 33)
            {
              newOnelinerScaleX = 33;
            }
          }
          else
          {
            alpha -= 0.5;

            if (alpha <= 0)
            {
              alpha = 0;
            }

            newOnelinerScaleX -= 0.5;

            newOnelinerScaleY -= 0.5;

            newOnelinerScaleZ -= 0.5;

            if (newOnelinerScaleX <= 0)
            {
              newOnelinerScaleX = 0;
            }
          }
        }
      }

      o = 0 - (Pi() + Deg2Rad(VecHeading( thePlayer.GetBoneWorldPosition('neck') - (detected_enemy.GetWorldPosition() + Vector(0,0,1.5)) ) - theCamera.GetCameraHeading() ));

      manager.acs_setRotationForOnelinerByID(onelinerID, Rad2Deg(o));

      manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, 33, 50);

			SleepOneFrame();
		}

    detected_enemy.RemoveTag('ACS_Enemy_Detected_Tag');

    manager.acs_setAlphaForOnelinerByID(onelinerID, 0);

    manager.acs_setScaleForOnelinerByID(onelinerID, 0, 0, 0);
		
		parent.visible = false;
		parent.unregister();
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_oneliner_idle in ACS_Oneliner 
{
  
}

//////////////////////////////////////////////////////////////////////////////

state acs_clue_icon_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_clue_icon_running_entry();
  }

  entry function acs_clue_icon_running_entry()
	{
    var manager                                                                 : W3ACSStorage;
    var onelinerID                                                              : int;
    var newOnelinerAlpha                                                        : float;
    var newOnelinerScaleX                                                       : float;
    var newOnelinerScaleY                                                       : float;
    var newOnelinerScaleZ                                                       : float;
    var rotation_switch                                                         : bool;
    var rotation, rotation_limit, vibrate_intensity, rotation_intensity         : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setScaleForOnelinerByID(onelinerID, 0, 0, 0);

    manager.acs_setAlphaForOnelinerByID(onelinerID, 0);

		while(true)
		{
      if((theGame.GetFocusModeController().CanUseFocusMode()
      && theGame.IsFocusModeActive())
      || thePlayer.IsAnyWeaponHeld()
      )
      {
        if (newOnelinerScaleX >= 33)
        {
          newOnelinerScaleX = 33;
        }
        else
        {
          newOnelinerScaleX += 0.5;
        }

        if (newOnelinerScaleY >= 33)
        {
          newOnelinerScaleY = 33;
        }
        else
        {
          newOnelinerScaleY += 0.5;
        }

        if (newOnelinerScaleZ >= 33)
        {
          newOnelinerScaleZ = 33;
        }
        else
        {
          newOnelinerScaleZ += 0.5;
        }

        if (newOnelinerAlpha >= 50)
        {
          newOnelinerAlpha = 50;
        }
        else
        {
          newOnelinerAlpha += 0.5;
        }

        rotation_intensity = 0.5;

        rotation_limit = 5;

        if (rotation >= rotation_limit && !rotation_switch)
        {
          rotation_switch = true;
        }
        else if (rotation <= -rotation_limit && rotation_switch)
        {
          rotation_switch = false;
        }

        if (!rotation_switch)
        {
          rotation += rotation_intensity;
        }
        else if (rotation_switch)
        {
          rotation -= rotation_intensity;
        }
      }
      else
      {
        if (newOnelinerScaleX <= 0)
        {
          newOnelinerScaleX = 0;
        }
        else
        {
          newOnelinerScaleX -= 0.025;
        }

        if (newOnelinerScaleY <= 0)
        {
          newOnelinerScaleY = 0;
        }
        else
        {
          newOnelinerScaleY -= 0.025;
        }

        if (newOnelinerScaleZ <= 0)
        {
          newOnelinerScaleZ = 0;
        }
        else
        {
          newOnelinerScaleZ -= 0.025;
        }

        if (newOnelinerAlpha <= 0)
        {
          newOnelinerAlpha = 0;
        }
        else
        {
          newOnelinerAlpha -= 0.025;
        }

        if (rotation > 0)
        {
          rotation -= 0.125;
        }
        else if (rotation < 0)
        {
          rotation += 0.125;
        }
        else
        {
          rotation = 0;
        }
      }

      manager.acs_setRotationForOnelinerByID(onelinerID, rotation);

      manager.acs_setAlphaForOnelinerByID(onelinerID, newOnelinerAlpha);

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      if(!theGame.GetFocusModeController().CanUseFocusMode()
      || !theGame.IsFocusModeActive()
      )
      {
        if (newOnelinerAlpha == 0
        && newOnelinerScaleX == 0
        && newOnelinerScaleY == 0
        && newOnelinerScaleZ == 0
        )
        {
          break;
        }
      }

			SleepOneFrame();
		}

    manager.acs_setAlphaForOnelinerByID(onelinerID, 0);

    manager.acs_setScaleForOnelinerByID(onelinerID, 0, 0, 0);
		
		parent.visible = false;
		parent.unregister();
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_focus_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_focus_bar_indicator_running_entry();
  }

  entry function acs_focus_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_focus, max_focus 		    : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    if (parent.focus_bar_indicator_33)
    {
      manager.acs_setRotationForOnelinerByID(onelinerID, -25);
    }
    else if (parent.focus_bar_indicator_66)
    {
      manager.acs_setRotationForOnelinerByID(onelinerID, -40);
    }
    else if (parent.focus_bar_indicator_99)
    {
      manager.acs_setRotationForOnelinerByID(onelinerID, -55);
    }

		while(true)
		{
      if (parent.focus_bar_indicator_33)
      {
        curr_focus = thePlayer.GetStat(BCS_Focus);

        max_focus = thePlayer.GetStatMax(BCS_Focus) * 0.33;

        if (parent.background_bar)
        {
          if ( GetACSWatcher().RadialMenuCheck()
          || thePlayer.HasTag('ACS_Drawn_Weapon')
          || theInput.GetActionValue('Focus') > 0.1f
          )
          {
            newOnelinerAlpha += 1.5;

            if (newOnelinerAlpha >= 75)
            {
              newOnelinerAlpha = 75;
            }
          }
          else
          {
            if (curr_focus == 0)
            {
              newOnelinerAlpha -= 1.5;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }
            else
            {
              newOnelinerAlpha += 1.5;

              if (newOnelinerAlpha >= 75)
              {
                newOnelinerAlpha = 75;
              }
            }
          }

          newOnelinerScaleX = 30;

          newOnelinerScaleY = 50;

          newOnelinerScaleZ = 50;
        }
        else
        {
          if (parent.max_indicator)
          {
            if ((curr_focus / max_focus) >= 1)
            {
              newOnelinerAlpha += 1;

              if (newOnelinerAlpha >= 75)
              {
                newOnelinerAlpha = 75;
              }
            }
            else
            {
              newOnelinerAlpha -= 1;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }

            newOnelinerScaleX = 30;
          }
          else
          {
            if ((curr_focus / max_focus) >= 1)
            {
              newOnelinerScaleX = 10;
            }
            else
            {
              newOnelinerScaleX = (curr_focus / max_focus) * 30;
            }
          }
        }
      }
      else if (parent.focus_bar_indicator_66)
      {
        curr_focus = (thePlayer.GetStat(BCS_Focus) - thePlayer.GetStatMax(BCS_Focus) * 0.33);

        max_focus = (thePlayer.GetStatMax(BCS_Focus) * 0.66 - thePlayer.GetStatMax(BCS_Focus) * 0.33);

        if (parent.background_bar)
        {
          if ( GetACSWatcher().RadialMenuCheck()
          || thePlayer.HasTag('ACS_Drawn_Weapon')
          || theInput.GetActionValue('Focus') > 0.1f
          )
          {
            newOnelinerAlpha += 1.5;

            if (newOnelinerAlpha >= 75)
            {
              newOnelinerAlpha = 75;
            }
          }
          else
          {
            if ((curr_focus / max_focus) <= 0)
            {
              newOnelinerAlpha -= 1.5;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }
            else
            {
              newOnelinerAlpha += 1.5;

              if (newOnelinerAlpha >= 75)
              {
                newOnelinerAlpha = 75;
              }
            }
          }

          newOnelinerScaleX = 40;

          newOnelinerScaleY = 50;

          newOnelinerScaleZ = 50;
        }
        else
        {
          if (parent.max_indicator)
          {
            if ((curr_focus / max_focus) >= 1)
            {
              newOnelinerAlpha += 1;

              if (newOnelinerAlpha >= 75)
              {
                newOnelinerAlpha = 75;
              }
            }
            else
            {
              newOnelinerAlpha -= 1;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }

            newOnelinerScaleX = 40;
          }
          else
          {
            if ((curr_focus / max_focus) >= 1)
            {
              newOnelinerScaleX = 20;
            }
            else if ((curr_focus / max_focus) <= 0)
            {
              newOnelinerScaleX = 0;
            }
            else
            {
              newOnelinerScaleX = (curr_focus / max_focus) * 40;
            }
          }
        }
      }
      else if (parent.focus_bar_indicator_99)
      {
        curr_focus = (thePlayer.GetStat(BCS_Focus) - thePlayer.GetStatMax(BCS_Focus) * 0.66);

        max_focus = (thePlayer.GetStatMax(BCS_Focus) * 0.99 - thePlayer.GetStatMax(BCS_Focus) * 0.66);

        if (parent.background_bar)
        {
          if ( GetACSWatcher().RadialMenuCheck()
          || thePlayer.HasTag('ACS_Drawn_Weapon')
          || theInput.GetActionValue('Focus') > 0.1f
          )
          {
            newOnelinerAlpha += 1.5;

            if (newOnelinerAlpha >= 75)
            {
              newOnelinerAlpha = 75;
            }
          }
          else
          {
            if ((curr_focus / max_focus) <= 0)
            {
              newOnelinerAlpha -= 1.5;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }
            else
            {
              newOnelinerAlpha += 1.5;;

              if (newOnelinerAlpha >= 75)
              {
                newOnelinerAlpha = 75;
              }
            }
          }

          newOnelinerScaleX = 50;

          newOnelinerScaleY = 50;

          newOnelinerScaleZ = 50;
        }
        else
        {
          if (parent.max_indicator)
          {
            if ((curr_focus / max_focus) >= 1)
            {
              newOnelinerAlpha += 1;

              if (newOnelinerAlpha >= 75)
              {
                newOnelinerAlpha = 75;
              }
            }
            else
            {
              newOnelinerAlpha -= 1;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }

            newOnelinerScaleX = 50;
          }
          else
          {
            if ((curr_focus / max_focus) >= 1)
            {
              newOnelinerScaleX = 30;
            }
            else if ((curr_focus / max_focus) <= 0)
            {
              newOnelinerScaleX = 0;
            }
            else
            {
              newOnelinerScaleX = (curr_focus / max_focus) * 50;
            }
          }
        }
      }

      if (!parent.background_bar
      )
      {
        if (newOnelinerScaleX < 3)
        {
          newOnelinerScaleY = 0;
        }
        else
        {
          newOnelinerScaleY = 50;
        }
      }

      newOnelinerScaleZ = 50;

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      if (parent.background_bar
      || parent.max_indicator
      )
      {
        manager.acs_setAlphaForOnelinerByID(onelinerID, newOnelinerAlpha);
      }
      else
      {
        manager.acs_setAlphaForOnelinerByID(onelinerID, 75);
      }

			SleepOneFrame();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_player_sign_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_player_sign_indicator_running_entry();
  }

  var vibrate_cooldown			: float;

  entry function acs_player_sign_indicator_running_entry()
	{
    var manager                                                                 : W3ACSStorage;
    var onelinerID                                                              : int;
    var m_EnoughStaminaForSign 																		            	: bool;
		var m_CurrentSelectedSign							                                    	: ESignType;
    var rotation                                                                : float;
    var alpha                                                                   : float;
    var scale                                                                   : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    rotation = 0;

    manager.acs_setRotationForOnelinerByID(onelinerID, rotation);

    if (parent.player_sign_indicator_dimmed)
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 100);
    }
    else if (parent.player_sign_indicator_available)
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 0);
    }
    else if (parent.player_sign_indicator_activated)
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 0);
    }

		while(true)
		{
      m_CurrentSelectedSign = thePlayer.GetEquippedSign();

      if (ACS_Is_DLC_Installed('dlc_spectre'))
      {
        m_EnoughStaminaForSign = (thePlayer.CanUseSkill(SignEnumToSkillEnum( m_CurrentSelectedSign )) && thePlayer.HasStaminaToUseSkill( SignEnumToSkillEnum( m_CurrentSelectedSign ) ) && GetACSWatcher().Spectre_Can_Use_Sign(m_CurrentSelectedSign));
      }
      else
      {
        m_EnoughStaminaForSign = (thePlayer.CanUseSkill(SignEnumToSkillEnum( m_CurrentSelectedSign )) && thePlayer.HasStaminaToUseSkill( SignEnumToSkillEnum( m_CurrentSelectedSign ) ));
      }

      if (GetWitcherPlayer().IsCastingSign()
      || GetACSWatcher().ACS_Cast_Sign_Process
      )
      {

        if (parent.player_sign_indicator_activated)
        {
          alpha += 1.5;

          if (alpha >= 100)
          {
            alpha = 100;
          }
        }
        else
        {
          alpha -= 1.5;

          if (alpha <= 0)
          {
            alpha = 0;
          }
        }
      }
      else
      {
        if (parent.player_sign_indicator_activated)
        {
          alpha -= 1.5;

          if (alpha <= 0)
          {
            alpha = 0;
          }
        }
        else
        {
          if (m_EnoughStaminaForSign)
          {
            if (parent.player_sign_indicator_dimmed)
            {
              alpha -= 1.5;

              if (alpha <= 0)
              {
                alpha = 0;
              }
            }
            else if (parent.player_sign_indicator_available)
            {
              alpha += 1.5;

              if (alpha >= 100)
              {
                alpha = 100;
              }
            }
          }
          else
          {
            if (parent.player_sign_indicator_dimmed)
            {
              alpha += 1.5;

              if (alpha >= 100)
              {
                alpha = 100;
              }
            }
            else if (parent.player_sign_indicator_available)
            {
              alpha -= 1.5;

              if (alpha <= 0)
              {
                alpha = 0;
              }
            }
          }
        }
      }

      manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);

      if (GetWitcherPlayer().IsCastingSign()
      || GetACSWatcher().ACS_Cast_Sign_Process
      || thePlayer.IsInCombat()
      || thePlayer.IsThreatened()
      || GetACSWatcher().RadialMenuCheck()
      || thePlayer.HasTag('ACS_Drawn_Weapon')
      || theInput.GetActionValue('Focus') > 0.1f
      )
      {
        scale += 0.5;

        if (scale >= 62.5)
        {
          scale = 62.5;
        }
      }
      else
      {
        scale -= 0.5;

        if (scale <= 50)
        {
          scale = 50;
        }
      }

      manager.acs_setScaleForOnelinerByID(onelinerID, scale, scale, scale);

			SleepOneFrame();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_wolf_head_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_wolf_head_indicator_running_entry();
  }

  var vibrate_cooldown			: float;

  entry function acs_wolf_head_indicator_running_entry()
	{
    var manager                                                                                   : W3ACSStorage;
    var onelinerID                                                                                : int;
    var original_screen_pos, screen_pos 		                                                      : Vector;
    var screen_pos_vibrate, rotation_switch, is_using_horse                                       : bool;
    var rotation, rotation_limit, vibrate_intensity, rotation_intensity, alpha, velocity          : float;

    original_screen_pos = parent.screen_pos;

    screen_pos = parent.screen_pos;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    rotation = 0;

    if (parent.medallion_back_glow
    )
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 5);
    }
    else if (parent.medallion_eyes_glow
    )
    {
      manager.acs_setAlphaForOnelinerByID(onelinerID, 0);
    }

		while(true)
		{
      if( 
      FactsQuerySum("q001_nightmare_ended") <= 0
      )
      {
        if (thePlayer.playerMoveType != PMT_Idle
        || theGame.IsFocusModeActive()
        //|| ACS_MapPinsCheck()
        || thePlayer.HasTag('ACS_Player_Is_Attacking')
        || thePlayer.HasTag('ACS_Is_Sneaking')
        || thePlayer.IsCurrentlyDodging()
        || thePlayer.HasTag('ACS_Is_Currently_Dodging')
        || thePlayer.HasTag('ACS_IsPerformingFinisher')
        || thePlayer.HasTag('ACS_IsPerformingCounterWound')
        || thePlayer.substateManager.GetStateCur() == 'Jump'
        || thePlayer.substateManager.GetStateCur() == 'Interaction'
        || thePlayer.substateManager.GetStateCur() == 'Climb'
        || thePlayer.IsThrowingItem()
        || thePlayer.IsThrowingItemWithAim()
        || thePlayer.IsThrowHold()
        || thePlayer.rangedWeapon.IsWeaponBeingUsed() 
        )
        {
          if (theGame.IsFocusModeActive()
          )
          {
            if (parent.medallion_back_glow
            )
            {
              alpha -= 0.25;

              if (alpha <= 5)
              {
                alpha = 5;
              }
            }
            else if (parent.medallion_eyes_glow)
            {
              alpha += 0.5;

              if (alpha >= 100)
              {
                alpha = 100;
              }
            }

            vibrate_intensity = 0.0009375;

            rotation_intensity = 0.0625;
            rotation_limit = 1.25;
          }
          else
          {
            if (parent.medallion_back_glow
            )
            {
              alpha -= 0.25;

              if (alpha <= 5)
              {
                alpha = 5;
              }
            }
            else if (parent.medallion_eyes_glow
            )
            {
              alpha -= 0.25;

              if (alpha <= 0)
              {
                alpha = 0;
              }
            }
            
            switch(GetACSWatcher().currspeed)
            {
              case 4:
                rotation_intensity = 0.0625;
                rotation_limit = 1.25;
                vibrate_intensity = 0.0009375;
              break;

              case 3:
                rotation_intensity = 0.03125;
                rotation_limit = 0.625;
                vibrate_intensity = 0.000625;
              break;

              case 2:
                rotation_intensity = 0.03125;
                rotation_limit = 0.625;
                vibrate_intensity = 0.00046875;
              break;

              case 1:
                rotation_intensity = 0.015625;
                rotation_limit = 0.3125;
                vibrate_intensity = 0.0003125;
              break;

              case 0:
                rotation_intensity = 0.015625;
                rotation_limit = 0.3125;
                vibrate_intensity = 0.000234375;
              break;

              default:
                rotation_intensity = 0.015625;
                rotation_limit = 0.3125;
                vibrate_intensity = 0.000234375;
              break;
            }
          }

          if (theGame.GetEngineTimeAsSeconds() - vibrate_cooldown > 0.1
          )
          {
            vibrate_cooldown = theGame.GetEngineTimeAsSeconds();

            screen_pos = original_screen_pos;

            if (!screen_pos_vibrate)
            {
              screen_pos.X -= vibrate_intensity;

              screen_pos.Y += vibrate_intensity;

              screen_pos_vibrate = true;
            }
            else
            {
              screen_pos.X += vibrate_intensity;

              screen_pos.Y -= vibrate_intensity;

              screen_pos_vibrate = false;
            }

            parent.screen_pos = screen_pos;
          }

          if (rotation >= rotation_limit && !rotation_switch)
          {
            rotation_switch = true;
          }
          else if (rotation <= -rotation_limit && rotation_switch)
          {
            rotation_switch = false;
          }

          if (!rotation_switch)
          {
            rotation += rotation_intensity;
          }
          else if (rotation_switch)
          {
            rotation -= rotation_intensity;
          }
        }
        else
        {
          if (parent.medallion_back_glow
          )
          {
            alpha -= 0.25;

            if (alpha <= 5)
            {
              alpha = 5;
            }
          }
          else if (parent.medallion_eyes_glow
          )
          {
            alpha -= 0.25;

            if (alpha <= 0)
            {
              alpha = 0;
            }
          }

          parent.screen_pos = original_screen_pos;

          if (rotation > 0)
          {
            rotation -= 0.125;
          }
          else if (rotation < 0)
          {
            rotation += 0.125;
          }
          else
          {
            rotation = 0;
          }
        }
      }
      else
      {
        if (
        (thePlayer.IsCastingSign()
        || GetACSWatcher().ACS_Cast_Sign_Process
        || GetWitcherPlayer().IsCurrentSignChanneled()
        || thePlayer.HasTag('ACS_In_Combat_Art')
        || ACS_NPCInYrden(GetWitcherPlayer().GetWorldPosition())
        || ACSGetCActor('ACS_Enemy_Attacking_From_Behind')
        || GetACSWatcher().ACS_Rage_Process == true
        || ACS_MagicDetected()
        || ACS_PlaceOfPowerDetected()
        || (thePlayer.GetTarget() && GetAttitudeBetween( thePlayer, (thePlayer.GetTarget()) ) == AIA_Hostile && (thePlayer.GetTarget()).UsesEssence() )
        )
        && !thePlayer.ACS_IsInDimeritiumCloud()
        && !thePlayer.IsSkillBlocked(SkillNameToEnum('magic_s5'))
        )
        { 
          if (
          ACSGetCActor('ACS_Enemy_Attacking_From_Behind')
          || GetACSWatcher().ACS_Rage_Process == true
          )
          {
            vibrate_intensity = 0.0025;

            rotation_intensity = 0.25;

            rotation_limit = 5;
          }
          else if (
          thePlayer.IsCastingSign()
          || GetACSWatcher().ACS_Cast_Sign_Process
          || GetWitcherPlayer().IsCurrentSignChanneled()
          || thePlayer.HasTag('ACS_In_Combat_Art')
          || ACS_NPCInYrden(GetWitcherPlayer().GetWorldPosition())
          )
          {
            vibrate_intensity = 0.00125;

            rotation_intensity = 0.125;

            rotation_limit = 2.5;
          }
          else
          {
            vibrate_intensity = 0.0009375;

            rotation_intensity = 0.09375;

            rotation_limit = 1.875;
          }

          if (theGame.GetEngineTimeAsSeconds() - vibrate_cooldown > 0.075f
          )
          {
            vibrate_cooldown = theGame.GetEngineTimeAsSeconds();

            screen_pos = original_screen_pos;

            if (!screen_pos_vibrate)
            {
              screen_pos.X += vibrate_intensity;

              screen_pos.Y -= vibrate_intensity;

              screen_pos_vibrate = true;
            }
            else
            {
              screen_pos.X -= vibrate_intensity;

              screen_pos.Y += vibrate_intensity;

              screen_pos_vibrate = false;
            }

            parent.screen_pos = screen_pos;
          }

          if (rotation >= rotation_limit && !rotation_switch)
          {
            rotation_switch = true;
          }
          else if (rotation <= -rotation_limit && rotation_switch)
          {
            rotation_switch = false;
          }

          if (!rotation_switch)
          {
            rotation += rotation_intensity;
          }
          else if (rotation_switch)
          {
            rotation -= rotation_intensity;
          }

          if (parent.medallion_back_glow)
          {
            alpha += 0.25;

            if (alpha >= 50)
            {
              alpha = 50;
            }
          }
          else if (parent.medallion_eyes_glow)
          {
            alpha += 0.5;

            if (alpha >= 100)
            {
              alpha = 100;
            }
          }
        }
        else
        {
          if (thePlayer.IsUsingHorse())
          {
            is_using_horse = true;
            velocity = (thePlayer.GetHorseCurrentlyMounted().GetHorseComponent()).GetHorseVelocitySpeed();
          }
          else
          {
            is_using_horse = false;
          }
          

          if (thePlayer.playerMoveType != PMT_Idle
          || (is_using_horse && velocity >= 1)
          || theGame.IsFocusModeActive()
          || ACS_MapPinsCheck()
          || thePlayer.HasTag('ACS_Player_Is_Attacking')
          || thePlayer.HasTag('ACS_Is_Sneaking')
          || thePlayer.IsCurrentlyDodging()
          || thePlayer.HasTag('ACS_Is_Currently_Dodging')
          || thePlayer.HasTag('ACS_IsPerformingFinisher')
          || thePlayer.HasTag('ACS_IsPerformingCounterWound')
          || thePlayer.substateManager.GetStateCur() == 'Jump'
          || thePlayer.substateManager.GetStateCur() == 'Interaction'
          || thePlayer.substateManager.GetStateCur() == 'Climb'
          || thePlayer.IsThrowingItem()
          || thePlayer.IsThrowingItemWithAim()
          || thePlayer.IsThrowHold()
          || thePlayer.rangedWeapon.IsWeaponBeingUsed() 
          )
          {
            if (theGame.IsFocusModeActive()
            || thePlayer.HasTag('ACS_Is_Sneaking')
            || thePlayer.HasTag('ACS_IsPerformingFinisher')
            || thePlayer.HasTag('ACS_IsPerformingCounterWound')
            )
            {
              if (parent.medallion_back_glow
              )
              {
                alpha -= 0.25;

                if (alpha <= 5)
                {
                  alpha = 5;
                }
              }
              else if (parent.medallion_eyes_glow)
              {
                alpha += 0.5;

                if (alpha >= 100)
                {
                  alpha = 100;
                }
              }

              vibrate_intensity = 0.0009375;

              rotation_intensity = 0.0625;
              rotation_limit = 1.25;
            }
            else
            {
              if (parent.medallion_back_glow
              )
              {
                alpha -= 0.25;

                if (alpha <= 5)
                {
                  alpha = 5;
                }
              }
              else if (parent.medallion_eyes_glow
              )
              {
                alpha -= 0.25;

                if (alpha <= 0)
                {
                  alpha = 0;
                }
              }

              if (is_using_horse)
              {
                if (velocity <= 5)
                {
                  rotation_intensity = 0.015625;
                  rotation_limit = 0.3125;
                  vibrate_intensity = 0.0003125;
                }
                else if (velocity > 5 && velocity <= 8)
                {
                  rotation_intensity = 0.03125;
                  rotation_limit = 0.625;
                  vibrate_intensity = 0.00046875;
                }
                else if (velocity > 8 && velocity <= 13)
                {
                  rotation_intensity = 0.03125;
                  rotation_limit = 0.625;
                  vibrate_intensity = 0.000625;
                }
                else if (velocity > 13)
                {
                  rotation_intensity = 0.0625;
                  rotation_limit = 1.25;
                  vibrate_intensity = 0.0009375;
                }
              }
              else
              {
                switch(GetACSWatcher().currspeed)
                {
                  case 4:
                    rotation_intensity = 0.0625;
                    rotation_limit = 1.25;
                    vibrate_intensity = 0.0009375;
                  break;

                  case 3:
                    rotation_intensity = 0.03125;
                    rotation_limit = 0.625;
                    vibrate_intensity = 0.000625;
                  break;

                  case 2:
                    rotation_intensity = 0.03125;
                    rotation_limit = 0.625;
                    vibrate_intensity = 0.00046875;
                  break;

                  case 1:
                    rotation_intensity = 0.015625;
                    rotation_limit = 0.3125;
                    vibrate_intensity = 0.0003125;
                  break;

                  case 0:
                    rotation_intensity = 0.015625;
                    rotation_limit = 0.3125;
                    vibrate_intensity = 0.000234375;
                  break;

                  default:
                    rotation_intensity = 0.015625;
                    rotation_limit = 0.3125;
                    vibrate_intensity = 0.000234375;
                  break;
                }
              }
            }

            if (theGame.GetEngineTimeAsSeconds() - vibrate_cooldown > 0.1
            )
            {
              vibrate_cooldown = theGame.GetEngineTimeAsSeconds();

              screen_pos = original_screen_pos;

              if (!screen_pos_vibrate)
              {
                screen_pos.X -= vibrate_intensity;

                screen_pos.Y += vibrate_intensity;

                screen_pos_vibrate = true;
              }
              else
              {
                screen_pos.X += vibrate_intensity;

                screen_pos.Y -= vibrate_intensity;

                screen_pos_vibrate = false;
              }

              parent.screen_pos = screen_pos;
            }

            if (rotation >= rotation_limit && !rotation_switch)
            {
              rotation_switch = true;
            }
            else if (rotation <= -rotation_limit && rotation_switch)
            {
              rotation_switch = false;
            }

            if (!rotation_switch)
            {
              rotation += rotation_intensity;
            }
            else if (rotation_switch)
            {
              rotation -= rotation_intensity;
            }
          }
          else
          {
            if (parent.medallion_back_glow
            )
            {
              alpha -= 0.25;

              if (alpha <= 5)
              {
                alpha = 5;
              }
            }
            else if (parent.medallion_eyes_glow
            )
            {
              alpha -= 0.25;

              if (alpha <= 0)
              {
                alpha = 0;
              }
            }

            parent.screen_pos = original_screen_pos;

            if (rotation > 0)
            {
              rotation -= 0.125;
            }
            else if (rotation < 0)
            {
              rotation += 0.125;
            }
            else
            {
              rotation = 0;
            }
          }
        }
      }

      if (parent.medallion_back_glow
      || parent.medallion_eyes_glow
      )
      {
        manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);
      }

      manager.acs_setRotationForOnelinerByID(onelinerID, rotation);

			SleepOneFrame();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_health_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_health_bar_indicator_running_entry();
  }

  entry function acs_health_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_health, max_health 		  : float;
    var alpha                         : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 30);

		while(true)
		{
      curr_health = thePlayer.GetStat(BCS_Vitality);

      max_health = thePlayer.GetStatMax(BCS_Vitality);

      if ( GetACSWatcher().RadialMenuCheck()
      || thePlayer.HasTag('ACS_Drawn_Weapon')
      || theInput.GetActionValue('Focus') > 0.1f
      )
      {
        alpha += 1.5;

        if (alpha >= 75)
        {
          alpha = 75;
        }
      }
      else
      {
        if (curr_health == max_health)
        {
          alpha = 0;
        }
        else
        {
          alpha += 1.5;

          if (alpha >= 75)
          {
            alpha = 75;
          }
        }
      }

      if(parent.background_bar)
      {
        newOnelinerScaleX = 75;

        newOnelinerScaleY = 50;

        newOnelinerScaleZ = 50;
      }
      else
      {
        newOnelinerScaleX = (curr_health / max_health) * 75;

        if (newOnelinerScaleX < 3)
        {
          newOnelinerScaleY = 0;
        }
        else
        {
          newOnelinerScaleY = 50;
        }
        newOnelinerScaleZ = 50;
      }

      

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);

			SleepOneFrame();
		}
	}
}

state acs_grey_health_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_grey_health_bar_indicator_running_entry();
  }

  entry function acs_grey_health_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_health, max_health 		  : float;
    var alpha                         : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 30);

		while(true)
		{
      if (thePlayer.GetStat(BCS_Vitality) == thePlayer.GetStatMax(BCS_Vitality))
      {
        alpha = 0;
      }
      else
      {
        alpha += 1.5;

        if (alpha >= 75)
        {
          alpha = 75;
        }
      }
      
      curr_health = thePlayer.GetStat(BCS_Vitality) + thePlayer.acs_grey_health_current;

      if (curr_health > thePlayer.GetStatMax(BCS_Vitality))
      {
        //curr_health = thePlayer.GetStatMax(BCS_Vitality);
      }

      max_health = thePlayer.GetStatMax(BCS_Vitality);

      newOnelinerScaleX = (curr_health / max_health) * 75;

      if (newOnelinerScaleX < 3)
      {
        newOnelinerScaleY = 0;
      }
      else
      {
        newOnelinerScaleY = 50;
      }
      newOnelinerScaleZ = 50;


      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);

			SleepOneFrame();
		}
	}
}

state acs_stamina_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_stamina_bar_indicator_running_entry();
  }

  entry function acs_stamina_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_stamina, max_stamina 		: float;
    var alpha                         : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 28);

		while(true)
		{
      
      curr_stamina = thePlayer.GetStat(BCS_Stamina);

      max_stamina = thePlayer.GetStatMax(BCS_Stamina);

      if ( GetACSWatcher().RadialMenuCheck()
      || thePlayer.HasTag('ACS_Drawn_Weapon')
      || theInput.GetActionValue('Focus') > 0.1f
      )
      {
        alpha += 1.5;

        if (alpha >= 75)
        {
          alpha = 75;
        }
      }
      else
      {
        if (curr_stamina == max_stamina)
        {
          alpha = 0;
        }
        else
        {
          alpha += 1.5;

          if (alpha >= 75)
          {
            alpha = 75;
          }
        }
      }

      if (parent.background_bar)
      {
        newOnelinerScaleX = 70;

        newOnelinerScaleY = 50;

        newOnelinerScaleZ = 50;
      }
      else
      {
        newOnelinerScaleX = (curr_stamina / max_stamina) * 70;

        if (newOnelinerScaleX < 3)
        {
          newOnelinerScaleY = 0;
        }
        else
        {
          newOnelinerScaleY = 50;
        }
        newOnelinerScaleZ = 50;
      }

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);

			SleepOneFrame();
		}
	}
}

state acs_toxicity_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_toxicity_bar_indicator_running_entry();
  }

  entry function acs_toxicity_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_toxicity, max_toxicity 	: float;
    var alpha                         : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 26);

		while(true)
		{
      curr_toxicity = thePlayer.GetStat(BCS_Toxicity);

      max_toxicity = thePlayer.GetStatMax(BCS_Toxicity);

      if ( GetACSWatcher().RadialMenuCheck()
      || thePlayer.HasTag('ACS_Drawn_Weapon')
      || theInput.GetActionValue('Focus') > 0.1f
      )
      {
        alpha += 1.5;

        if (alpha >= 75)
        {
          alpha = 75;
        }
      }
      else
      {
        if (curr_toxicity == 0)
        {
          alpha = 0;
        }
        else
        {
          alpha += 1.5;

          if (alpha >= 75)
          {
            alpha = 75;
          }
        }
      }

      if (parent.background_bar)
      {
        newOnelinerScaleX = 65;

        newOnelinerScaleY = 50;

        newOnelinerScaleZ = 50;
      }
      else
      {
        newOnelinerScaleX = (curr_toxicity / max_toxicity) * 65;
        
        if (newOnelinerScaleX < 3)
        {
          newOnelinerScaleY = 0;
        }
        else
        {
          newOnelinerScaleY = 50;
        }

        newOnelinerScaleZ = 50;
      }

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

      manager.acs_setAlphaForOnelinerByID(onelinerID, alpha);

			SleepOneFrame();
		}
	}
}

/*
state acs_player_posture_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_player_posture_bar_indicator_running_entry();
  }

  entry function acs_player_posture_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_posture, max_posture     : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 22);

		while(true)
		{
      curr_posture = thePlayer.acs_player_posture;
      
      max_posture = thePlayer.acs_max_player_posture;

      if (parent.max_indicator)
      {
        if (curr_posture == max_posture)
        {
          newOnelinerAlpha += 1;

          if (newOnelinerAlpha >= 75)
          {
            newOnelinerAlpha = 75;
          }
        }
        else
        {
          newOnelinerAlpha -= 1;

          if (newOnelinerAlpha <= 0)
          {
            newOnelinerAlpha = 0;
          }
        }

        newOnelinerScaleX = (curr_posture / max_posture) * 110;
      }
      else
      {
        if (curr_posture == max_posture)
        {
          newOnelinerScaleX = 85;
        }
        else
        {
          newOnelinerScaleX = (curr_posture / max_posture) * 110;
        }
      }

      if (newOnelinerScaleX < 3)
      {
        newOnelinerScaleY = 0;
      }
      else
      {
        newOnelinerScaleY = 75;
      }
      newOnelinerScaleZ = 50;

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      if (parent.max_indicator)
      {
        manager.acs_setAlphaForOnelinerByID(onelinerID, newOnelinerAlpha);
      }
      
      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

			SleepOneFrame();
		}
	}
}
*/

//////////////////////////////////////////////////////////////////////////////

state acs_player_posture_bar_vanilla_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_player_posture_bar_vanilla_indicator_running_entry();
  }

  entry function acs_player_posture_bar_vanilla_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_posture, max_posture     : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 0);

		while(true)
		{
      curr_posture = thePlayer.acs_player_posture;
      
      max_posture = thePlayer.acs_max_player_posture;

      if (parent.max_indicator)
      {
        if (curr_posture == max_posture)
        {
          newOnelinerScaleX = 300;

          newOnelinerScaleY = 75;
        }
        else
        {
          newOnelinerScaleX = 0;

          newOnelinerScaleY = 0;
        }
      }
      else
      {
        if (curr_posture == max_posture)
        {
          newOnelinerScaleX = 250;
        }
        else
        {
          newOnelinerScaleX = (curr_posture / max_posture) * 300;
        }

        if (newOnelinerScaleX < 3)
        {
          newOnelinerScaleY = 0;
        }
        else
        {
          newOnelinerScaleY = 75;
        }
      }

      newOnelinerScaleZ = 50;

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);
      
      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

			SleepOneFrame();
		}
	}
}

state acs_grey_health_bar_vanilla_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_grey_health_bar_vanilla_indicator_running_entry();
  }

  entry function acs_grey_health_bar_vanilla_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_health, max_health 		  : float;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setRotationForOnelinerByID(onelinerID, 26);

		while(true)
		{
      curr_health = thePlayer.acs_grey_health_current;

      max_health = thePlayer.GetStatMax(BCS_Vitality);

      newOnelinerScaleX = (curr_health / max_health) * 250;
      if (newOnelinerScaleX < 3)
      {
        newOnelinerScaleY = 0;
      }
      else
      {
        newOnelinerScaleY = 75;
      }
      newOnelinerScaleZ = 50;

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

			SleepOneFrame();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_enemy_posture_bar_indicator_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_enemy_posture_bar_indicator_running_entry();
  }

  entry function acs_enemy_posture_bar_indicator_running_entry()
	{
    var manager                       : W3ACSStorage;
    var onelinerID                    : int;
    var newOnelinerAlpha              : float;
    var newOnelinerScaleX             : float;
    var newOnelinerScaleY             : float;
    var newOnelinerScaleZ             : float;
    var curr_posture, max_posture     : float;
    var npc                           : CNewNPC;

    manager = GetACSStorage();

    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setAlphaForOnelinerByID(onelinerID, 100);

		while(true)
		{
      npc = parent.npc_for_posture;

      if (npc.IsAlive())
      {
        curr_posture = npc.acs_posture;
      }
      else
      {
        curr_posture = 0;
      }
      
      max_posture = npc.acs_max_posture;

      if (!thePlayer.GetDisplayTarget()
      || !thePlayer.IsInCombat()
      || !npc.GetGameplayVisibility()
      || !npc.IsAlive()
      )
      {
        newOnelinerAlpha -= 0.5;

        if (newOnelinerAlpha <= 0)
        {
          newOnelinerAlpha = 0;
        }
      }
      else
      {
        if (parent.background_bar)
        {
          newOnelinerScaleX = 125;

          newOnelinerScaleY = 60;

          newOnelinerScaleZ = 50;

          newOnelinerAlpha = 75;
        }
        else
        {
          if (parent.max_indicator)
          {
            if (curr_posture == max_posture)
            {
              newOnelinerAlpha = 75;
            }
            else
            {
              newOnelinerAlpha -= 0.5;

              if (newOnelinerAlpha <= 0)
              {
                newOnelinerAlpha = 0;
              }
            }

            newOnelinerScaleX = (curr_posture / max_posture) * 125;
          }
          else
          {
            if (curr_posture == max_posture)
            {
              newOnelinerScaleX = 100;
            }
            else
            {
              newOnelinerScaleX = (curr_posture / max_posture) * 125;
            }

            newOnelinerAlpha = 75;
          }
        }
      }

      if (newOnelinerScaleX < 3)
      {
        newOnelinerScaleY = 0;
      }
      else
      {
        newOnelinerScaleY = 60;
      }

      newOnelinerScaleZ = 50;

      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);

      manager.acs_setAlphaForOnelinerByID(onelinerID, newOnelinerAlpha);

      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

			SleepOneFrame();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////

state acs_oneliner_popup_running in ACS_Oneliner 
{
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
    acs_oneliner_popup_running_entry();
  }

  entry function acs_oneliner_popup_running_entry()
	{
		var startTime             : float;
		var elapsed               : float;
		var progress              : float;
		var newOffset             : Vector;
		var deltaTime             : float;
		var lastTime              : float;
    var manager               : W3ACSStorage;
    var onelinerID            : int;
    var newOnelinerAlpha      : float;
    var newOnelinerScaleX     : float;
    var newOnelinerScaleY     : float;
    var newOnelinerScaleZ     : float;
    var newRiseSpeed          : float;

    manager = GetACSStorage();
    onelinerID = manager.acs_getOnelinerID(parent);

    manager.acs_setAlphaForOnelinerByID(onelinerID, 100);

    manager.acs_setScaleForOnelinerByID(onelinerID, 0, 0, 0);
		
		startTime = theGame.GetEngineTimeAsSeconds();
		lastTime = startTime;

		while(true)
		{
			elapsed = theGame.GetEngineTimeAsSeconds() - startTime;
			if(elapsed >= parent.duration)
				break;
			
			deltaTime = theGame.GetEngineTimeAsSeconds() - lastTime;
			lastTime = theGame.GetEngineTimeAsSeconds();
			
			progress = elapsed / parent.duration;
			
      if (!parent.popup_static)
      {
        newOffset = parent.offset;
        newRiseSpeed = parent.riseSpeed;

        newRiseSpeed *= 1.125;

        if (newRiseSpeed >= 0.75)
        {
          newRiseSpeed = 0.75;
        }

        newOffset.X += parent.directionX * deltaTime * (1.0f - progress);
        newOffset.Y += parent.directionY * deltaTime * (1.0f - progress);
        newOffset.Z += newRiseSpeed * deltaTime * (1.0f - progress );
        parent.offset = newOffset;
        parent.riseSpeed = newRiseSpeed;
      }
			
      newOnelinerAlpha = parent.onelinerAlpha;
      newOnelinerAlpha -= 0.1875;
      if (newOnelinerAlpha <= 0)
      {
        newOnelinerAlpha = 0;
      }
      manager.acs_setAlphaForOnelinerByID(onelinerID, newOnelinerAlpha);
      parent.onelinerAlpha = newOnelinerAlpha;


      newOnelinerScaleX = parent.onelinerScaleX;
      newOnelinerScaleY = parent.onelinerScaleY;
      newOnelinerScaleZ = parent.onelinerScaleZ;

      if (newOnelinerScaleX <= 50)
      {
        newOnelinerScaleX += 1.875;
      }
      else
      {
        newOnelinerScaleX += 0.9375;
      }

      if (newOnelinerScaleY <= 50)
      {
        newOnelinerScaleY += 1.875;
      }
      else
      {
        newOnelinerScaleY += 0.9375;
      }

      if (newOnelinerScaleZ <= 50)
      {
        newOnelinerScaleZ += 1.875;
      }
      else
      {
        newOnelinerScaleZ += 0.9375;
      }

      if (newOnelinerScaleX >= 100)
      {
        newOnelinerScaleX = 100;
      }

      if (newOnelinerScaleY >= 100)
      {
        newOnelinerScaleY = 100;
      }

      if (newOnelinerScaleZ >= 100)
      {
        newOnelinerScaleZ = 100;
      }
      manager.acs_setScaleForOnelinerByID(onelinerID, newOnelinerScaleX, newOnelinerScaleY, newOnelinerScaleZ);
      parent.onelinerScaleX = newOnelinerScaleX;
      parent.onelinerScaleY = newOnelinerScaleY;
      parent.onelinerScaleZ = newOnelinerScaleZ;

			SleepOneFrame();
		}

    manager.acs_setAlphaForOnelinerByID(onelinerID, 0);

    manager.acs_setScaleForOnelinerByID(onelinerID, 100, 100, 100);
		
		parent.visible = false;
		parent.unregister();
	}
}

state acs_oneliner_remove in ACS_Oneliner 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		acs_oneliner_remove_Entry();
	}
  
	entry function acs_oneliner_remove_Entry() 
	{
		Sleep(parent.lifetime);

    parent.unregister();
	}
}

//////////////////////////////////////////////////////////////////////////////

state ACSStorageOnelinerRender in W3ACSStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);

		this.Render_Entry();
	}

	entry function Render_Entry() 
	{
		this.Render_Latent();

		parent.GotoState('acsStorageIdle');
	}

	latent function Render_Latent() 
	{
		var sprite                                                : CScriptedFlashSprite;
		var oneliner                                              : ACS_Oneliner;
		var oneliners_count                                       : int;
		var i                                                     : int;

		var player_position                                       : Vector;
		var screen_position                                       : Vector;

		screen_position = thePlayer.GetWorldPosition();
    //screen_position = theCamera.GetCameraPosition();
		player_position = thePlayer.GetWorldPosition();

		while (true) 
		{
			oneliners_count = parent.oneliners.Size();

			if (oneliners_count <= 0) 
			{
				break;
			}

			player_position = thePlayer.GetWorldPosition();

			for (i = 0; i < oneliners_count; i += 1) 
			{
				oneliner = parent.oneliners[i];
				sprite = parent.module_flash.GetChildFlashSprite("mcOneliner" + oneliner.id);

				if (!oneliner.getVisible(player_position)) 
        {
					sprite.SetVisible(false);
					continue;	
				}

        if (oneliner.entity.HasTag('ACS_HUD_Marker_Entity')
        )
        {
          HUD_Marker_Manager(oneliner.entity, sprite);
        }
        else
        {
          if (oneliner.getScreenPosition(parent.module_hud, screen_position)) 
          {
            sprite.SetPosition(screen_position.X, screen_position.Y);
            sprite.SetVisible(true);
          } 
          else 
          {
            sprite.SetVisible(false);
          }
        }
				
			}

			SleepOneFrame();
		}
	}

  latent function HUD_Marker_Manager( target : CEntity, mcOneliner : CScriptedFlashSprite)
  {
    var screenPos							                                : Vector;
    var hud									                                  : CR4ScriptedHud;
    var marginLeftTop, marginLeftTopSecondary						      : Vector;
    var marginLeftTopCompassBar			                        	: Vector;
    var marginRightBottom, marginRightBottomSecondary				  : Vector;
    var screenMarginX 					    	                      	: float = 0.025; 
    var screenMarginY 					    	                      	: float = 0.09; 
    var screenMarginZ 					    	                      	: float = 0.025; 
    var screenMarginYCompass 			                         		: float = 0.11; 
    var screenMarginYCompassBar 			                      	: float = 0.14; 
    var oxygenModule                                          : CR4HudModuleOxygenBar;
    var bossBarModule                                         : CR4HudModuleBossFocus;
    var marginLeftTopCompassBarAdjusted      						      : Vector;
    var marginRightBottomCompassBarAdjusted				  	        : Vector;

    hud = (CR4ScriptedHud)theGame.GetHud();	

    if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
    {
      if( hud )
      {
        oxygenModule = (CR4HudModuleOxygenBar)hud.GetHudModule("OxygenBarModule");

        bossBarModule = (CR4HudModuleBossFocus)hud.GetHudModule("BossFocusModule");
      }

      if (bossBarModule.GetModuleFlash().GetVisible()
      || oxygenModule.GetModuleFlash().GetVisible()
      )
		  {
        if (oxygenModule.GetModuleFlash().GetVisible()
        )
        {
          screenMarginYCompass = 0.19;

          screenMarginYCompassBar = 0.22;
        }
        else
        {
          screenMarginYCompass = 0.17;

          screenMarginYCompassBar = 0.20;
        }
      }
      else
      {
        screenMarginYCompass = 0.11;

        screenMarginYCompassBar = 0.14;
      }

      marginLeftTop = hud.GetScaleformPoint( screenMarginX, screenMarginYCompass );

      marginLeftTopCompassBar = hud.GetScaleformPoint( screenMarginX, screenMarginYCompassBar );

      marginLeftTopSecondary = hud.GetScaleformPoint( screenMarginX, screenMarginY );

      marginRightBottomSecondary = hud.GetScaleformPoint( 1 - screenMarginX, 1 - screenMarginZ );
    }
    else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
    {
      marginLeftTop = hud.GetScaleformPoint( screenMarginX, screenMarginY );

      marginRightBottom = hud.GetScaleformPoint( 1 - screenMarginX, 1 - screenMarginZ );
    }

    if (target.HasTag('ACS_Guiding_Light_Marker')
    )
    {
      if ( target && IsMarkerCloseEnough(target, 'quest_tracked'))
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Guiding_Light_Horse_Marker'))
    {
      if ( target && IsMarkerCloseEnough(target, 'horse'))
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_All_Tracked_Quest_Entity')
    || target.HasTag('ACS_Guiding_Light_Available_Quest_Marker'))
    {
      if ( target && IsMarkerCloseEnough(target, 'quest_untracked'))
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Guiding_Light_POI_Marker'))
    {
      if ( target && IsMarkerCloseEnough(target, 'poi'))
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Guiding_Light_Enemy_Marker'))
    {
      if ( target && IsMarkerCloseEnough(target, 'enemy'))
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        
        /*
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted)
          )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTopSecondary.X;

                mcOneliner.SetVisible( true );
              }
              else if( screenPos.X > marginRightBottomSecondary.X )
              {
                screenPos.X = marginRightBottomSecondary.X;

                mcOneliner.SetVisible( true );
              }
              else if( screenPos.Y < marginLeftTopSecondary.Y )
              {
                if (VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
                {
                  mcOneliner.SetVisible( false );
                }
                else
                {
                  screenPos.Y = marginLeftTopSecondary.Y;

                  mcOneliner.SetVisible( true );
                }
              }
              else
              {
                screenPos.Y = marginRightBottomSecondary.Y;

                mcOneliner.SetVisible( true );
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        */
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Guiding_Light_Merchant_Marker'))
    {
      if ( target && IsMarkerCloseEnough(target, 'merchant'))
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Guiding_Light_User_Pin_Marker'))
    {
      if ( target )
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X + 37.5)
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X - 37.5)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Compass_Bar_Cardinal_North_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_South_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_East_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_West_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_NorthEast_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_NorthWest_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_SouthEast_Entity')
    || target.HasTag('ACS_Compass_Bar_Cardinal_SouthWest_Entity')
    )
    {
      if ( ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0 )
      {
        if ( ScreenPosTranslateCompassMarkers(screenPos, target.GetWorldPosition()))
        {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

          if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
          {
            if( screenPos.X <= marginLeftTopCompassBarAdjusted.X )
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X;
            }
            else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X;
            }
          }

          mcOneliner.SetPosition( screenPos.X, screenPos.Y );

          mcOneliner.SetVisible( true );
        }
        else
        {
            mcOneliner.SetVisible( false );
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Compass_Bar_Entity')
    )
    {
      if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) && ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
      {
        screenPos.Y = (marginLeftTopCompassBar.Y - 17.25);

        screenPos.X = 960;
        
        mcOneliner.SetPosition( screenPos.X, screenPos.Y );

        mcOneliner.SetVisible( true );
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Health_Stat_Indicator')
    || target.HasTag('ACS_Stamina_Stat_Indicator')
    || target.HasTag('ACS_Toxicity_Stat_Indicator')
    || target.HasTag('ACS_Posture_Stat_Indicator')
    || target.HasTag('ACS_Current_Sign_Indicator')
    || target.HasTag('ACS_Adrenaline_Indicator')
    )
    {
      marginLeftTop = hud.GetScaleformPoint( screenMarginX, screenMarginY );

      marginRightBottom = hud.GetScaleformPoint( 1 - screenMarginX, 1 - screenMarginZ );

      if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
      {
        if (!VectorIsInsideScreenMargins(screenPos))
        {
          if( screenPos.X < marginLeftTop.X )
          {
            screenPos.X = marginLeftTop.X;
          }
          else if( screenPos.X > marginRightBottom.X )
          {
            screenPos.X = marginRightBottom.X;
          }
          else if( screenPos.Y < marginLeftTop.Y )
          {
            screenPos.Y = marginLeftTop.Y;
          }
          else
          {
            screenPos.Y = marginRightBottom.Y;
          }
        }

        mcOneliner.SetPosition( screenPos.X, screenPos.Y );

        mcOneliner.SetVisible( true );
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else
    {
      if ( target )
      {
        if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 0)
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()))
          {
             if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginLeftTop.Y;
              }

            if (!VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted))
            {
              if( screenPos.X <= marginLeftTopCompassBarAdjusted.X )
              {
                screenPos.X = marginLeftTopCompassBarAdjusted.X;
              }
              else if(screenPos.X >= marginRightBottomCompassBarAdjusted.X)
              {
                screenPos.X = marginRightBottomCompassBarAdjusted.X;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else if (ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if( screenPos.Y < marginLeftTop.Y )
            {
              screenPos.Y = marginLeftTop.Y;
            }
            else
            {
              screenPos.Y = marginLeftTop.Y;
            }

            VectorIsInsideCompassMargins(screenPos, marginLeftTopCompassBarAdjusted, marginRightBottomCompassBarAdjusted);

            if( screenPos.X >= marginLeftTopCompassBarAdjusted.X + 37.5)
            {
              screenPos.X = marginRightBottomCompassBarAdjusted.X - 37.5;
            }
            else if(screenPos.X <= marginRightBottomCompassBarAdjusted.X - 37.5)
            {
              screenPos.X = marginLeftTopCompassBarAdjusted.X + 37.5;
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
             mcOneliner.SetVisible( false );
          }
        }
        else if (ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1)
        {
          if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideScreenMargins(screenPos))
            {
              screenPos.Y -= 45;
            }
            else
            {
              if( screenPos.X < marginLeftTop.X )
              {
                screenPos.X = marginLeftTop.X;
              }
              else if( screenPos.X > marginRightBottom.X )
              {
                screenPos.X = marginRightBottom.X;
              }
              else if( screenPos.Y < marginLeftTop.Y )
              {
                screenPos.Y = marginLeftTop.Y;
              }
              else
              {
                screenPos.Y = marginRightBottom.Y;
              }
            }

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );

            mcOneliner.SetVisible( true );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
      }
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
  }

  function IsMarkerCloseEnough( target : CEntity, marker_name : name ) : bool
  {
    var distance : float;

    switch (marker_name) 
		{
      case 'merchant':
        distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_merchant_marker_distance_to_display', 50) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_merchant_marker_distance_to_display', 50);
      break;

      case 'horse':
        distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_horse_marker_distance_to_display', 500) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_horse_marker_distance_to_display', 500);
      break;

      case 'enemy':
        distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50);
      break;

      case 'poi':
        distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_poi_marker_distance_to_display', 5000) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_poi_marker_distance_to_display', 5000);
      break;

      case 'quest_untracked':
        distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_untracked_quest_marker_distance_to_display', 500) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_untracked_quest_marker_distance_to_display', 500);
      break;

      case 'quest_tracked':
        distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_quest_marker_distance_to_display', 5000) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_quest_marker_distance_to_display', 5000);
      break;

      default:
       distance = ACS_Settings_Main_Float('acs_hud_settings_markers','acs_quest_marker_distance_to_display', 5000) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_quest_marker_distance_to_display', 5000);
      break;	
    }

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= distance;
  }

  function VectorIsInsideScreenMargins( screenPos : Vector ) : bool
  {
    var hud								    	: CR4ScriptedHud;
    var marginLeftTop						: Vector;
    var marginRightBottom				: Vector;
    var screenMargin 						: float = 0.0125; 

    hud = (CR4ScriptedHud)theGame.GetHud();	

    marginLeftTop = hud.GetScaleformPoint( screenMargin, screenMargin );

    marginRightBottom = hud.GetScaleformPoint( 1 - screenMargin, 1 - screenMargin );

    if( screenPos.X <= marginLeftTop.X 
    || screenPos.X >= marginRightBottom.X 
    ||screenPos.Y <= marginLeftTop.Y 
    || screenPos.Y >= marginRightBottom.Y )
    {
      return false;
    }

    return true;
  }

  function VectorIsInsideCompassMargins( screenPos : Vector, out marginLeftTop, marginRightBottom : Vector ) : bool
  {
    var hud									        : CR4ScriptedHud;
    var screenMarginX 					  	: float; 
    var screenMarginY 					  	: float = 0.000000000125; 
    var currentWidth, currentHeight : int;
		var ratio                       : float;

    theGame.GetCurrentViewportResolution( currentWidth, currentHeight );

		ratio = ( (float)currentWidth ) / currentHeight;

    if (ACS_Settings_Main_Int('acs_hud_settings_markers','acs_compass_bar_size', 0) == 1)
    {
      screenMarginX = 0.2625; 
    }
    else
    {
      screenMarginX = 0.35; 
    }

    hud = (CR4ScriptedHud)theGame.GetHud();	

    marginLeftTop = hud.GetScaleformPoint( screenMarginX, screenMarginY );

    marginRightBottom = hud.GetScaleformPoint( 1 - screenMarginX, 1 - screenMarginY );

    if( screenPos.X <= marginLeftTop.X 
    || screenPos.X >= marginRightBottom.X)
    {
      return false;
    }

    return true;
  }

  function ScreenPosTranslate( out newScreenPos : Vector, screenPos : Vector ) : bool
  {
    var hud									: CR4ScriptedHud;

    if( !theCamera.WorldVectorToViewRatio( screenPos, newScreenPos.X, newScreenPos.Y ) )
    {
      GetOppositeCameraScreenPos( screenPos, newScreenPos.X, newScreenPos.Y );
    }

    newScreenPos.X = ( newScreenPos.X + 1 ) / 2;
    newScreenPos.Y = ( newScreenPos.Y + 1 ) / 2;

    hud = (CR4ScriptedHud)theGame.GetHud();	

    newScreenPos = hud.GetScaleformPoint( newScreenPos.X, newScreenPos.Y );

    return true;
  }

  function ScreenPosTranslateCompass( out newScreenPos : Vector, screenPos : Vector ) : bool
  {
    var hud									: CR4ScriptedHud;

    if( theCamera.WorldVectorToViewRatio( screenPos, newScreenPos.X, newScreenPos.Y ) )
    {
      newScreenPos.X = ( newScreenPos.X + 1 ) / 2;
      newScreenPos.Y = ( newScreenPos.Y + 1 ) / 2;

      hud = (CR4ScriptedHud)theGame.GetHud();	

      newScreenPos = hud.GetScaleformPoint( newScreenPos.X, newScreenPos.Y );

      return true;
    }

    return false;
  }

  function ScreenPosTranslateCompassMarkers( out newScreenPos : Vector, screenPos : Vector ) : bool
  {
    var hud									: CR4ScriptedHud;

    if( theCamera.WorldVectorToViewRatio( screenPos, newScreenPos.X, newScreenPos.Y ) )
    {
      if (ACS_Settings_Main_Int('acs_hud_settings_markers','acs_compass_bar_size', 0) == 1)
      {
        newScreenPos.X = ( newScreenPos.X + 2 ) / 4;
        newScreenPos.Y = ( newScreenPos.Y + 2 ) / 4;
      }
      else
      {
        newScreenPos.X = ( newScreenPos.X + 4 ) / 8;
        newScreenPos.Y = ( newScreenPos.Y + 4 ) / 8;
      }

      hud = (CR4ScriptedHud)theGame.GetHud();	

      newScreenPos = hud.GetScaleformPoint( newScreenPos.X, newScreenPos.Y );

      return true;
    }

    return false;
  }
}

//////////////////////////////////////////////////////////////////////////////

class ACS_Oneliner_TagBuilder 
{
  private var buffer: string;

  private var self_closing: bool;
  default self_closing = true;

  private var _tag: string;

  public function tag(value: string): ACS_Oneliner_TagBuilder 
  {
    this._tag = value;
    this.buffer = "<" + value;

    return this;
  }

  public function attr(key: string, value: string): ACS_Oneliner_TagBuilder 
  {
    this.buffer += " ";
    this.buffer += key;
    this.buffer += "=\"";
    this.buffer += value;
    this.buffer +="\"";

    return this;
  }

  public function text(value: string): string 
  {
    this.buffer += ">" + value;

    return this.buffer + "</" + this._tag + ">";
  }

  public function close(): string 
  {
    return this.buffer + " />";
  }
}