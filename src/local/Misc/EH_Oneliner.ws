function ACS_Oneliner(text: string, position: Vector, optional tag: string, optional offset: Vector, optional lifetime: float, optional render_distance: float): ACS_Oneliner 
{
  var oneliner: ACS_Oneliner;

  oneliner = new ACS_Oneliner in thePlayer;
  oneliner.text = text;
  oneliner.tag = tag;
  oneliner.offset = offset;
  oneliner.position = position;
  oneliner.lifetime = lifetime;
  oneliner.render_distance = render_distance;
  oneliner.register();

  return oneliner;
}

function ACS_OnelinerScreen(text: string, position: Vector, optional tag: string, optional offset: Vector, optional lifetime: float, optional render_distance: float): ACS_OnelinerScreen 
{
  var oneliner: ACS_OnelinerScreen;

  oneliner = new ACS_OnelinerScreen in thePlayer;
  oneliner.text = text;
  oneliner.tag = tag;
  oneliner.offset = offset;
  oneliner.position = position;
  oneliner.lifetime = lifetime;
  oneliner.render_distance = render_distance;
  oneliner.register();

  return oneliner;
}

function ACS_OnelinerEntity(text: string, entity: CEntity, optional tag: string, optional offset: Vector, optional lifetime: float, optional render_distance: float): ACS_OnelinerEntity 
{
  var oneliner: ACS_OnelinerEntity;

  oneliner = new ACS_OnelinerEntity in thePlayer;
  oneliner.text = text;
  oneliner.entity = entity;
  oneliner.tag = tag;
  oneliner.offset = offset;
  oneliner.lifetime = lifetime;
  oneliner.render_distance = render_distance;
  oneliner.register();

  return oneliner;
}

class ACS_OnelinerEntity extends ACS_Oneliner 
{
  function getPosition(): Vector 
  {
    return this.entity.GetWorldPosition() + this.offset;
  }
}

class ACS_OnelinerScreen extends ACS_Oneliner 
{
  function getScreenPosition(hud: CR4ScriptedHud, out screen_position: Vector): bool 
  {
    var position: Vector;

    position = this.getPosition();
    screen_position = hud.GetScaleformPoint(position.X, position.Y);

    return true;
  }
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

  default lifetime = 0;

  default visible = true;

  function register() 
  {
    var manager: W3ACSStorage;

    manager = GetACSStorage();
    manager.acs_createOneliner(this);

    if (lifetime > 0)
    {
      this.PushState('ACS_Oneliner_Remove');
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

    return VecDistanceSquared2D(player_position, this.getPosition()) <= this.render_distance * this.render_distance;
  }

  function getPosition(): Vector 
  {
    return this.position + this.offset;
  }

  function getScreenPosition(hud: CR4ScriptedHud, out screen_position: Vector): bool 
  {
    var world_position: Vector;
    var result: bool;

    world_position = this.getPosition();

    result = WorldToScreenPosition(hud, world_position, screen_position);

    return result;
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
}

state ACS_Oneliner_Remove in ACS_Oneliner 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);

		this.Remove_Entry();
	}

	entry function Remove_Entry() 
	{
		this.Remove_Latent();
	}

	latent function Remove_Latent() 
	{
		Sleep(parent.lifetime);

    parent.unregister();
	}
}

state ACSStorageOnelinerRender in W3ACSStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);

		this.Render_Entry();
	}

	entry function Render_Entry() 
	{
		if (!thePlayer.IsCiri()) 
		{
			this.Render_Latent();
		}

		parent.GotoState('acsStorageIdle');
	}

	latent function Render_Latent() 
	{
		var sprite: CScriptedFlashSprite;
		var oneliner: ACS_Oneliner;
		var oneliners_count: int;
		var i: int;

		var player_position: Vector;
		var screen_position: Vector;
		screen_position = thePlayer.GetWorldPosition();
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

        if (oneliner.entity.HasTag('ACS_HUD_Marker_Entity'))
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

    hud = (CR4ScriptedHud)theGame.GetHud();	

    if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
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
    else
    {
      marginLeftTop = hud.GetScaleformPoint( screenMarginX, screenMarginY );

      marginRightBottom = hud.GetScaleformPoint( 1 - screenMarginX, 1 - screenMarginZ );
    }

    if (target.HasTag('ACS_Guiding_Light_Marker')
    )
    {
      if ( target && IsMarkerCloseEnough(target, 'quest_tracked'))
      {
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos))
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
          else if ( ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassHybridModeEnabled', true) 
          && ScreenPosTranslate(screenPos, target.GetWorldPosition()) 
          && !VectorIsInsideScreenMargins(screenPos))
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
              if (VectorIsInsideCompassMargins(screenPos))
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

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        else
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
    else if (target.HasTag('ACS_Guiding_Light_Horse_Marker')
    )
    {
      if ( target && IsMarkerCloseEnough(target, 'horse'))
      {
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos))
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
          else if ( ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassHybridModeEnabled', true) 
          && ScreenPosTranslate(screenPos, target.GetWorldPosition()) 
          && !VectorIsInsideScreenMargins(screenPos))
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
              if (VectorIsInsideCompassMargins(screenPos))
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

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        else
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
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos))
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
          else if ( ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassHybridModeEnabled', true) 
          && ScreenPosTranslate(screenPos, target.GetWorldPosition()) 
          && !VectorIsInsideScreenMargins(screenPos))
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
              if (VectorIsInsideCompassMargins(screenPos))
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

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        else
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
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos)
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
          else if ( ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassHybridModeEnabled', true) 
          && ScreenPosTranslate(screenPos, target.GetWorldPosition()) 
          && !VectorIsInsideScreenMargins(screenPos))
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
              if (VectorIsInsideCompassMargins(screenPos))
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

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        else
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
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos)
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
                if (VectorIsInsideCompassMargins(screenPos))
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
        else
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
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) 
          && VectorIsInsideCompassMargins(screenPos)
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
          else if ( ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassHybridModeEnabled', true) 
          && ScreenPosTranslate(screenPos, target.GetWorldPosition()) 
          && !VectorIsInsideScreenMargins(screenPos))
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
              if (VectorIsInsideCompassMargins(screenPos))
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

            mcOneliner.SetPosition( screenPos.X, screenPos.Y );
          }
          else
          {
            mcOneliner.SetVisible( false );
          }
        }
        else
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
      if ( ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true) )
      {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideCompassMargins(screenPos))
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
      else
      {
        mcOneliner.SetVisible( false );
      }
    }
    else if (target.HasTag('ACS_Compass_Bar_Entity')
    )
    {
      if ( ScreenPosTranslate(screenPos, target.GetWorldPosition()) && ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
      {
        if( screenPos.Y < marginLeftTopCompassBar.Y )
        {
          screenPos.Y = marginLeftTopCompassBar.Y;
        }
        else
        {
          screenPos.Y = marginLeftTopCompassBar.Y;
        }

        if (target.HasTag('ACS_Compass_Bar_Entity')
        )
        {
          screenPos.X = 960;
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
        if (ACS_Settings_Main_Bool('EHmodHudSettings','EHmodCompassModeEnabled', true))
        {
          if ( ScreenPosTranslateCompass(screenPos, target.GetWorldPosition()) )
          {
            if (VectorIsInsideCompassMargins(screenPos))
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
        else
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
      case 'horse':
      distance = ACS_Settings_Main_Float('EHmodHudSettings','EHmodHorseMarkerDistanceToDisplay', 500) * ACS_Settings_Main_Float('EHmodHudSettings','EHmodHorseMarkerDistanceToDisplay', 500);
      break;

      case 'enemy':
      distance = ACS_Settings_Main_Float('EHmodHudSettings','EHmodEnemyMarkerDistanceToDisplay', 50) * ACS_Settings_Main_Float('EHmodHudSettings','EHmodEnemyMarkerDistanceToDisplay', 50);
      break;

      case 'poi':
      distance = ACS_Settings_Main_Float('EHmodHudSettings','EHmodPOIMarkerDistanceToDisplay', 5000) * ACS_Settings_Main_Float('EHmodHudSettings','EHmodPOIMarkerDistanceToDisplay', 5000);
      break;

      case 'quest_untracked':
      distance = ACS_Settings_Main_Float('EHmodHudSettings','EHmodUntrackedQuestMarkerDistanceToDisplay', 500) * ACS_Settings_Main_Float('EHmodHudSettings','EHmodUntrackedQuestMarkerDistanceToDisplay', 500);
      break;

      case 'quest_tracked':
      distance = ACS_Settings_Main_Float('EHmodHudSettings','EHmodQuestMarkerDistanceToDisplay', 5000) * ACS_Settings_Main_Float('EHmodHudSettings','EHmodQuestMarkerDistanceToDisplay', 5000);
      break;

      default:
      distance = ACS_Settings_Main_Float('EHmodHudSettings','EHmodQuestMarkerDistanceToDisplay', 5000) * ACS_Settings_Main_Float('EHmodHudSettings','EHmodQuestMarkerDistanceToDisplay', 5000);
      break;	
    }

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= distance;
  }

  /*
  function IsQuestMarkerTrackedCloseEnough( target : CEntity ) : bool
  {
    var VISIBILITY_DISTANCE : float;	

    VISIBILITY_DISTANCE = ACS_Settings_Main_Float('EHmodHudSettings','EHmodQuestMarkerDistanceToDisplay', 5000); 

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
  }

  function IsQuestMarkerUntrackedCloseEnough( target : CEntity ) : bool
  {
    var VISIBILITY_DISTANCE : float;	
    
    VISIBILITY_DISTANCE = ACS_Settings_Main_Float('EHmodHudSettings','EHmodUntrackedQuestMarkerDistanceToDisplay', 500); 

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
  }

  function IsPOIMarkerCloseEnough( target : CEntity ) : bool
  {
    var VISIBILITY_DISTANCE : float;	
    
    VISIBILITY_DISTANCE = ACS_Settings_Main_Float('EHmodHudSettings','EHmodPOIMarkerDistanceToDisplay', 5000); 

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
  }

  function IsEnemyMarkerCloseEnough( target : CEntity ) : bool
  {
    var VISIBILITY_DISTANCE : float;	
    
    VISIBILITY_DISTANCE = ACS_Settings_Main_Float('EHmodHudSettings','EHmodEnemyMarkerDistanceToDisplay', 50); 

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
  }

  function IsHorseMarkerTrackedCloseEnough( target : CEntity ) : bool
  {
    var VISIBILITY_DISTANCE : float;	
    
    VISIBILITY_DISTANCE = ACS_Settings_Main_Float('EHmodHudSettings','EHmodHorseMarkerDistanceToDisplay', 500); 

    return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE * VISIBILITY_DISTANCE;
  }
  */

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

  function VectorIsInsideCompassMargins( screenPos : Vector ) : bool
  {
    var hud									        : CR4ScriptedHud;
    var marginLeftTop						    : Vector;
    var marginRightBottom				  	: Vector;
    var screenMarginX 					  	: float; 
    var screenMarginY 					  	: float = 0.000000000125; 
    var currentWidth, currentHeight : int;
		var ratio                       : float;

    theGame.GetCurrentViewportResolution( currentWidth, currentHeight );

		ratio = ( (float)currentWidth ) / currentHeight;

    if ( AbsF( ratio - 4.0 / 3.0 ) < 0.06 )
		{
			screenMarginX = 0.35; 
		}
		else if ( AbsF( ratio - 21.0 / 9.0 ) < 0.06 )
		{
			screenMarginX = 0.3875; 
		}
		else if ( AbsF( ratio - 43.0 / 18.0 ) < 0.06 )
		{
			screenMarginX = 0.35; 
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
}

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