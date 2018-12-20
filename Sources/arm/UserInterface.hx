package arm;

import kha.System;
import iron.object.MeshObject;
import iron.math.Vec4;
import iron.Scene;
import iron.object.Uniforms;
import iron.object.Object;
import iron.data.MaterialData;
import iron.system.Time;

class UserInterface {

	static public var t 			:Float;

	static var system				:SystemTrait;
	static var score_1				:Int		= 0;
	static var score_2				:Int		= 0;
	static var score_1_updated		:Bool		= false;
	static var score_2_updated		:Bool		= false;
	static var score_1_updating		:Bool		= false;
	static var score_2_updating		:Bool		= false;
	static var score_1_color		:Vec4;
	static var score_2_color		:Vec4;
	static var default_score_color	:Vec4;
	static var highlight_score_color:Vec4;
	static var result_score_color	:Vec4;

	static var par_fadeout_color	:Vec4;
	static var par_start_color		:Vec4;
	static var par_start_color_bl	:Vec4;
	static var par_color			:Vec4;
	static var par_color_updating	:Bool		= false;
	static var par_fadeout_speed	:Float		= 0.00005;

	static var game_meshes_score_1	:MeshText;
	static var game_meshes_score_2	:MeshText;
	static var title_meshes_title	:MeshText;
	static var title_meshes_1_player:MeshText;
	static var title_meshes_2_player:MeshText;
	static var title_meshes_cpuvscpu:MeshText;
	static var title_meshes_exit	:MeshText;
	static var menu_meshes_title	:MeshText;
	static var menu_meshes_resume	:MeshText;
	static var menu_meshes_restart	:MeshText;
	static var menu_meshes_exit		:MeshText;
	static var result_meshes_result	:MeshText;
	static var result_meshes_enter	:MeshText;
	static var options_meshes_title	:MeshText;
	static var options_meshes_stw	:MeshText;
	static var options_meshes_stw_v	:MeshText;
	static var options_meshes_diff	:MeshText;
	static var options_meshes_diff_v:MeshText;
	static var options_meshes_start	:MeshText;
	static var options_meshes_cancel:MeshText;
	static var disclaimer_1			:MeshText;
	static var disclaimer_2			:MeshText;
	static var disclaimer_3			:MeshText;
	static var disclaimer_4			:MeshText;

	static var cursor				:MeshObject;

	static var border_up			:MeshObject;
	static var border_down			:MeshObject;
	static var separator			:MeshObject;
	static var colon				:MeshObject;

	static var title_cursor_pos		:Int;
	static var menu_cursor_pos		:Int;
	static var options_cursor_pos	:Int;
	static var menu_itm_count		:Int		= 3;
	static var option_itm_count		:Int		= 4;

	static var init_completed		:Bool		= false;	// init completed?

	static var timer				:Timer;
	static var timer_disc			:Timer;

	static var title_sound_played	:Bool;
	static var result_sound_played	:Bool;


	static function init() {
		system  = Scene.active.getTrait(SystemTrait);
		timer	= new Timer(1.0);
		timer_disc = new Timer(5.0);
		highlight_score_color	= new Vec4(1.0, 1.0, 0.0);
		result_score_color		= new Vec4(1.0, 1.0, 1.0);
		default_score_color		= new Vec4(0.4, 0.4, 0.4);
		score_1_color			= new Vec4(0.4, 0.4, 0.4);
		score_2_color			= new Vec4(0.4, 0.4, 0.4);

		par_start_color			= new Vec4(1.0, 1.0, 1.0);
		par_start_color_bl		= new Vec4(0.5, 0.5, 0.5);
		par_fadeout_color		= new Vec4(0.0, 0.0, 0.0);
		par_color				= new Vec4(1.0, 1.0, 1.0);

		game_meshes_score_1 	= new MeshText(Std.string(score_1), new Vec4(-0.7, 1.8, -1.0), 1.0, 0.45, "MTR_score_1");
		game_meshes_score_2 	= new MeshText(Std.string(score_2), new Vec4( 0.7, 1.8, -1.0), 1.0, 0.45, "MTR_score_2");
		title_meshes_title		= new MeshText("PADDLE STRIKE", new Vec4(-2.35,  1.0, 1.0), 0.8, 0.5, "MTR_title"  );
		title_meshes_1_player	= new MeshText("1 PLAYER" ,     new Vec4(-0.70,  0.0, 1.0), 0.4, 0.5, "MTR_option" );
		title_meshes_2_player	= new MeshText("2 PLAYERS",     new Vec4(-0.70, -0.4, 1.0), 0.4, 0.5, "MTR_option" );
		title_meshes_cpuvscpu	= new MeshText("CPU v CPU",     new Vec4(-0.70, -0.8, 1.0), 0.4, 0.5, "MTR_option" );
		title_meshes_exit		= new MeshText("EXIT",          new Vec4(-0.70, -1.4, 1.0), 0.4, 0.5, "MTR_option" );
		menu_meshes_title		= new MeshText("PAUSED",        new Vec4(-0.70,  1.0, 1.0), 0.6, 0.5, "MTR_title"  );
		menu_meshes_resume		= new MeshText("RESUME",        new Vec4(-0.50,  0.0, 1.0), 0.4, 0.5, "MTR_option" );
		menu_meshes_restart		= new MeshText("RESTART",       new Vec4(-0.50, -0.4, 1.0), 0.4, 0.5, "MTR_option" );
		menu_meshes_exit		= new MeshText("QUIT",          new Vec4(-0.50, -1.0, 1.0), 0.4, 0.5, "MTR_option" );
		result_meshes_result	= new MeshText("RESULT",        new Vec4(-2.00,  1.0, 1.0), 0.8, 0.5, "MTR_title"  );
		result_meshes_enter		= new MeshText("PRESS ENTER",	new Vec4(-1.00, -0.8, 1.0), 0.4, 0.5, "MTR_tips"   );
		options_meshes_title	= new MeshText("OPTIONS",       new Vec4(-0.90,  1.0, 1.0), 0.6, 0.5, "MTR_title"  );
		options_meshes_stw		= new MeshText("SCORE TO WIN:", new Vec4(-1.50,  0.0, 1.0), 0.4, 0.5, "MTR_option" );
		options_meshes_stw_v	= new MeshText("10",            new Vec4( 1.20,  0.0, 1.0), 0.4, 0.5, "MTR_setting");
		options_meshes_diff		= new MeshText("DIFFICULTY:",   new Vec4(-1.50, -0.4, 1.0), 0.4, 0.5, "MTR_option" );
		options_meshes_diff_v	= new MeshText("NORMAL",        new Vec4( 1.20, -0.4, 1.0), 0.4, 0.5, "MTR_setting");
		options_meshes_start  	= new MeshText("START",         new Vec4(-1.50, -1.0, 1.0), 0.4, 0.5, "MTR_option" );
		options_meshes_cancel  	= new MeshText("CANCEL",        new Vec4(-1.50, -1.4, 1.0), 0.4, 0.5, "MTR_option" );

		disclaimer_1			= new MeshText("THIS GAME IS CREATED FOR LEARNING AND",        
												new Vec4(-2.60,  1.0, 1.0), 0.3, 0.5, "MTR_tips" );
		disclaimer_2			= new MeshText("TESTING PURPOSE. IT IS NOT INTENDED ",        
												new Vec4(-2.60,  0.4, 1.0), 0.3, 0.5, "MTR_tips" );
		disclaimer_3			= new MeshText("TO BE USED COMERCIALLY.",        
												new Vec4(-2.60, -0.2, 1.0), 0.3, 0.5, "MTR_tips" );
		disclaimer_4			= new MeshText("2018, MILO H XU",        
												new Vec4( 0.60, -0.8, 1.0), 0.3, 0.5, "MTR_tips" );
		cursor					= Scene.active.getMesh("cursor");
		border_up				= Scene.active.getMesh("border_up");
		border_down				= Scene.active.getMesh("border_down");
		separator				= Scene.active.getMesh("separator");
		colon					= Scene.active.getMesh("colon");

		game_meshes_score_1  .addAnimation(VIBERATING);
		game_meshes_score_1.animations[0].vib_vert  = true;
		game_meshes_score_1.animations[0].vib_rate  = 0.1;
		game_meshes_score_1.animations[0].amplitude = 0.1;
		game_meshes_score_1  .addAnimation(SCALING_DOWN);
		game_meshes_score_2  .addAnimation(VIBERATING);
		game_meshes_score_2.animations[0].vib_vert  = true;
		game_meshes_score_2.animations[0].vib_rate  = 0.1;
		game_meshes_score_2.animations[0].amplitude = 0.1;
		game_meshes_score_2  .addAnimation(SCALING_DOWN);

		title_meshes_title   .addAnimation(DROP_IN);
		title_meshes_1_player.addAnimation(ROLLING, true);
		title_meshes_1_player.addAnimation(VIBERATING);
		title_meshes_2_player.addAnimation(ROLLING, true);
		title_meshes_2_player.addAnimation(VIBERATING);
		title_meshes_cpuvscpu.addAnimation(ROLLING, true);
		title_meshes_cpuvscpu.addAnimation(VIBERATING);
		title_meshes_exit    .addAnimation(ROLLING, true);
		title_meshes_exit    .addAnimation(VIBERATING);

		menu_meshes_resume   .addAnimation(ROLLING, true);
		menu_meshes_resume   .addAnimation(VIBERATING);
		menu_meshes_restart  .addAnimation(ROLLING, true);
		menu_meshes_restart  .addAnimation(VIBERATING);
		menu_meshes_exit     .addAnimation(ROLLING, true);
		menu_meshes_exit     .addAnimation(VIBERATING);

		options_meshes_stw   .addAnimation(ROLLING, true);
		options_meshes_stw   .addAnimation(VIBERATING);
		options_meshes_stw_v .addAnimation(VIBERATING);
		options_meshes_diff  .addAnimation(ROLLING, true);
		options_meshes_diff  .addAnimation(VIBERATING);
		options_meshes_diff_v.addAnimation(VIBERATING);
		options_meshes_start .addAnimation(ROLLING, true);
		options_meshes_start .addAnimation(VIBERATING);
		options_meshes_cancel.addAnimation(ROLLING, true);
		options_meshes_cancel.addAnimation(VIBERATING);

		result_meshes_result .addAnimation(DROP_IN);
		result_meshes_result.animations[0].par_sys.floor = -0.1;
		result_meshes_enter  .addAnimation(ROLLING, true);

		title_cursor_pos		= 0;
		menu_cursor_pos			= 0;
		options_cursor_pos		= 0;

		Uniforms.externalVec3Links.push(colorShifting);

		title_sound_played = false;
		result_sound_played = false;
		setGameObjectsVisibility(false);
		setTitleObjectsVisibility(false);
		setMenuObjectsVisibility(false);
		setOptionsObjectsVisibility(false);
		setResultObjectsVisibility(false);
		timer_disc.start();
	}

	static public function update() {
		if (!init_completed) {
			init();
			init_completed = true;
		}

		t = Time.time();
		cursorRotation();

		var menu_pushed    = PlayerInput.menu;
		var confirm_pushed = PlayerInput.confirm;

		if (system.game_state == DISCLAIMER) {
			if (timer_disc.update() || confirm_pushed) {
				if (confirm_pushed) {
					confirm_pushed = false;
					SoundPlayer.play(MENU_PUSH);
				}
				disclaimer_1.setVisible(false);
				disclaimer_2.setVisible(false);
				disclaimer_3.setVisible(false);
				disclaimer_4.setVisible(false);
				switchToTitle();
			} 

		} else if (system.game_state == IN_GAME) {

			if (score_1_updated)	game_meshes_score_1  .playAnimations();
			if (score_2_updated)	game_meshes_score_2  .playAnimations();
			game_meshes_score_1  .updateAnimations();
			game_meshes_score_2  .updateAnimations();

			if (system.winner_ID == -1) {
				if (menu_pushed) {
					SoundPlayer.play(MENU_PUSH);
					par_color_updating = false;
					switchToMenu();
					menu_pushed = false;
				} else {
					updateScores();
				}
			} else {
				if (!timer.isRunning()) {
					system.ball.setVisible(false);
					timer.start();
				} else if (timer.update()) {
					timer.reset();
					UserInterface.switchToResult();
				} else {
					updateScores();
				}
			}

		} else if (system.game_state == TITLE) {
			title_meshes_title   .playAnimations();
			title_meshes_title   .updateAnimations();
			if (!title_sound_played && title_meshes_title.animations[0].phase == 1) {
				SoundPlayer.play(TITLE_DROP);
				SoundPlayer.play(TITLE_THEME);
				title_sound_played = true;
			}

			title_meshes_1_player.updateAnimations();
			title_meshes_2_player.updateAnimations();
			title_meshes_cpuvscpu.updateAnimations();
			title_meshes_exit    .updateAnimations();

			var cursor_moved = false;

			if (PlayerInput.down) {
				if (title_cursor_pos < 3) {
					title_cursor_pos++;
				} else {
					title_cursor_pos = 0;
				}
				cursor_moved = true;
			}
			if (PlayerInput.up) {
				if (title_cursor_pos > 0) {
					title_cursor_pos--;
				} else {
					title_cursor_pos = 3;
				}
				cursor_moved = true;
			}
			if (cursor_moved) {
				SoundPlayer.play(MENU_HOVER);
			}

			switch title_cursor_pos {
				case 0:	setCursor(true, new Vec4(-1.1,  0.0, 1.0));
						if (cursor_moved) {
							title_meshes_1_player.playAnimations ();
							title_meshes_2_player.resetAnimations();
							title_meshes_exit    .resetAnimations();
						}
				case 1: setCursor(true, new Vec4(-1.1, -0.4, 1.0));
						if (cursor_moved) {
							title_meshes_2_player.playAnimations ();
							title_meshes_1_player.resetAnimations();
							title_meshes_cpuvscpu.resetAnimations();
						}
				case 2: setCursor(true, new Vec4(-1.1, -0.8, 1.0));
						if (cursor_moved) {
							title_meshes_cpuvscpu.playAnimations ();
							title_meshes_2_player.resetAnimations();
							title_meshes_exit    .resetAnimations();
						}
				case 3: setCursor(true, new Vec4(-1.1, -1.4, 1.0));
						if (cursor_moved) {
							title_meshes_exit    .playAnimations ();
							title_meshes_1_player.resetAnimations();
							title_meshes_cpuvscpu.resetAnimations();
						}

			}
			
			if (confirm_pushed) {
				SoundPlayer.play(MENU_PUSH);
				confirm_pushed = false;
				switch title_cursor_pos {
					case 0:	system.game_type = ONE_PLAYER;
							switchToOption();
					case 1: system.game_type = TWO_PLAYER;
							switchToOption();
					case 2: system.game_type = CPU_VS_CPU;
							switchToOption();
					case 3: System.stop();
				}
				title_cursor_pos = 0;
				title_meshes_title   .resetAnimations();
				title_meshes_1_player.resetAnimations();
				title_meshes_2_player.resetAnimations();
				title_meshes_cpuvscpu.resetAnimations();
				title_meshes_exit    .resetAnimations();
				par_color_updating = false;
			}
		} else if (system.game_state == MENU) {
			menu_meshes_resume .updateAnimations();
			menu_meshes_restart.updateAnimations();
			menu_meshes_exit   .updateAnimations();
			game_meshes_score_1.updateAnimations();
			game_meshes_score_2.updateAnimations();

			if (menu_pushed) {
				switchToInGame();
				menu_pushed = false;
			} else {
				var cursor_moved = false;
				if (PlayerInput.down) {
					if (menu_cursor_pos < menu_itm_count - 1) {
						menu_cursor_pos++;
					} else {
						menu_cursor_pos = 0;
					}
					cursor_moved = true;
				}
				if (PlayerInput.up) {
					if (menu_cursor_pos > 0) {
						menu_cursor_pos--;
					} else {
						menu_cursor_pos = menu_itm_count - 1;
					}
					cursor_moved = true;
				}
				if (cursor_moved) {
					SoundPlayer.play(MENU_HOVER);
				}

				switch menu_cursor_pos {
					case 0:		setCursor(true, new Vec4(-0.9,  0.0, 1.0));
								if (system.game_ongoing) {
									if (cursor_moved) {
										menu_meshes_resume .playAnimations  ();
										menu_meshes_restart.resetAnimations();
										menu_meshes_exit   .resetAnimations();
									}
								} else {
									if (cursor_moved) {
										menu_meshes_restart.playAnimations ();
										menu_meshes_exit   .resetAnimations();
									}							
								}			
					case 1: 	if (system.game_ongoing) {
									setCursor(true, new Vec4(-0.9, -0.4, 1.0));
									if (cursor_moved) {
										menu_meshes_restart.playAnimations ();
										menu_meshes_resume .resetAnimations();
										menu_meshes_exit   .resetAnimations();
									}								
								} else {
									setCursor(true, new Vec4(-0.9, -0.6, 1.0));
									if (cursor_moved) {
										menu_meshes_exit   .playAnimations ();
										menu_meshes_restart.resetAnimations();
									}
								}
					case 2: 	setCursor(true, new Vec4(-0.9, -1.0, 1.0));
								if (cursor_moved) {
									menu_meshes_exit   .playAnimations ();	
									menu_meshes_resume .resetAnimations();
									menu_meshes_restart.resetAnimations();
								}
														

				}
				
				if (confirm_pushed) {
					SoundPlayer.play(MENU_PUSH);
					confirm_pushed = false;
					if (system.game_ongoing) {
						switch menu_cursor_pos {
							case 0:	switchToInGame();
							case 1: system.reset();
									system.start_game();
									switchToInGame();
							case 2: system.reset();
									switchToTitle();
						}
						menu_cursor_pos = 0;
					} else {
						switch menu_cursor_pos {
							case 0: system.reset();
									system.start_game();
									switchToInGame();
							case 1: system.reset();
									switchToTitle();
						}
						menu_cursor_pos = 0;					
					}
					menu_meshes_resume .resetAnimations();
					menu_meshes_restart.resetAnimations();
					menu_meshes_exit   .resetAnimations();
				}

			}
		} else if (system.game_state == RESULT) {
			result_meshes_result.playAnimations();
			result_meshes_result.updateAnimations();
			if (!result_sound_played && result_meshes_result.animations[0].phase == 1) {
				SoundPlayer.play(TITLE_DROP);
				result_sound_played = true;
			}
			updateScores();
			if (score_1_updated)	game_meshes_score_1  .playAnimations();
			if (score_2_updated)	game_meshes_score_2  .playAnimations();
			game_meshes_score_1 .updateAnimations();
			game_meshes_score_2 .updateAnimations();

			if (result_meshes_result.animations[0].state == FINISHED) {
				result_meshes_enter.setVisible(true);
				result_meshes_enter.playAnimations();
				result_meshes_enter.updateAnimations();

				if (confirm_pushed) {
					SoundPlayer.play(MENU_PUSH);
					confirm_pushed = false;
					system.reset();
					switchToMenu();
					result_meshes_result.resetAnimations();
					result_meshes_enter.resetAnimations();
					par_color_updating = false;
				}
			}
		} else if (system.game_state == OPTIONS) {
			options_meshes_stw   .updateAnimations();
			options_meshes_stw_v .updateAnimations();
			options_meshes_diff  .updateAnimations();
			options_meshes_diff_v.updateAnimations();
			options_meshes_start .updateAnimations();
			options_meshes_cancel.updateAnimations();

			if (menu_pushed) {
				menu_pushed    = false;
				switchToTitle();
			} else {
				var cursor_moved = false;
				if (PlayerInput.down) {
					if (options_cursor_pos < option_itm_count - 1) {
						options_cursor_pos++;
					} else {
						options_cursor_pos = 0;
					}
					cursor_moved = true;
				}
				if (PlayerInput.up) {
					if (options_cursor_pos > 0) {
						options_cursor_pos--;
					} else {
						options_cursor_pos = option_itm_count - 1;
					}
					cursor_moved = true;
				}
				if (cursor_moved) {
					SoundPlayer.play(MENU_HOVER);
				}

				switch options_cursor_pos {
					case 0:		setCursor(true, new Vec4(-1.9,  0.0, 1.0));
								if (system.game_type != TWO_PLAYER) {
									if (cursor_moved) {
										options_meshes_stw   .playAnimations ();
										options_meshes_diff  .resetAnimations();
										options_meshes_cancel.resetAnimations();
									}
								} else {
									if (cursor_moved) {
										options_meshes_stw   .playAnimations ();
										options_meshes_cancel.resetAnimations();
										options_meshes_start .resetAnimations();
									}									
								}
					case 1: 	if (system.game_type != TWO_PLAYER) {
									setCursor(true, new Vec4(-1.9, -0.4, 1.0));
									if (cursor_moved) {
										options_meshes_diff .playAnimations ();
										options_meshes_stw  .resetAnimations();
										options_meshes_start.resetAnimations();	
									}
								} else {
									setCursor(true, new Vec4(-1.9, -0.6, 1.0));
									if (cursor_moved) {
										options_meshes_start .playAnimations ();
										options_meshes_stw   .resetAnimations();
										options_meshes_cancel.resetAnimations();	
									}
								}			
					case 2: 	if (system.game_type != TWO_PLAYER) {
									setCursor(true, new Vec4(-1.9, -1.0, 1.0));
									if (cursor_moved) {
										options_meshes_start .playAnimations ();
										options_meshes_diff  .resetAnimations();
										options_meshes_cancel.resetAnimations();
									}
								} else {
									setCursor(true, new Vec4(-1.9, -1.0, 1.0));
									if (cursor_moved) {
										options_meshes_cancel.playAnimations ();
										options_meshes_stw   .resetAnimations();
										options_meshes_start .resetAnimations();
									}
								}
					case 3: 	if (system.game_type != TWO_PLAYER) {
									setCursor(true, new Vec4(-1.9, -1.4, 1.0));
									if (cursor_moved) {
										options_meshes_cancel.playAnimations ();
										options_meshes_start .resetAnimations();
										options_meshes_stw   .resetAnimations();
									}	
								}			
				}

				if (PlayerInput.left) {
					SoundPlayer.play(MENU_PUSH);
					if (options_cursor_pos == 0) {
						if (system.score_to_win == 10) {
							system.score_to_win = 5;
							options_meshes_stw_v.updateMeshes("5");
						} else if (system.score_to_win == 5 ) {
							system.score_to_win = 30;
							options_meshes_stw_v.updateMeshes("30");
						} else if (system.score_to_win == 30 ) {
							system.score_to_win = 25;
							options_meshes_stw_v.updateMeshes("25");
						} else if (system.score_to_win == 25 ) {
							system.score_to_win = 20;
							options_meshes_stw_v.updateMeshes("20");
						} else if (system.score_to_win == 20 ) {
							system.score_to_win = 15;
							options_meshes_stw_v.updateMeshes("15");
						} else if (system.score_to_win == 15 ) {
							system.score_to_win = 10;
							options_meshes_stw_v.updateMeshes("10");
						}
						options_meshes_stw_v.playAnimations();
					} else if (options_cursor_pos == 1 && system.game_type != TWO_PLAYER) {
						if        (system.difficulty == 0.15) {
							system.difficulty        = 0.20;
							system.ball.init_speed   = 0.045;
							system.ball.speed_limit  = 0.060;
							system.ball.speed_factor = 0.15;
							options_meshes_diff_v.updateMeshes("EASY");
						} else if (system.difficulty == 0.20) {
							system.difficulty        = 0.00;
							system.ball.init_speed   = 0.06;
							system.ball.speed_limit  = 0.10;
							system.ball.speed_factor = 0.30;
							options_meshes_diff_v.updateMeshes("EXPERT");
						} else if (system.difficulty == 0.00) {
							system.difficulty        = 0.08;
							system.ball.init_speed   = 0.055;
							system.ball.speed_limit  = 0.085;
							system.ball.speed_factor = 0.25;
							options_meshes_diff_v.updateMeshes("HARD");
						} else if (system.difficulty == 0.08) {
							system.difficulty        = 0.15;
							system.ball.init_speed   = 0.05;
							system.ball.speed_limit  = 0.075;
							system.ball.speed_factor = 0.20;
							options_meshes_diff_v.updateMeshes("NORMAL");
						}
						options_meshes_diff_v.playAnimations();
					}
				}

				if (PlayerInput.right || confirm_pushed) {
					SoundPlayer.play(MENU_PUSH);
					if (options_cursor_pos == 0) {
						if (confirm_pushed)	confirm_pushed = false;
						if        (system.score_to_win == 10) {
							system.score_to_win = 15;
							options_meshes_stw_v.updateMeshes("15");
						} else if (system.score_to_win == 15) {
							system.score_to_win = 20;
							options_meshes_stw_v.updateMeshes("20");
						} else if (system.score_to_win == 20) {
							system.score_to_win = 25;
							options_meshes_stw_v.updateMeshes("25");
						} else if (system.score_to_win == 25) {
							system.score_to_win = 30;
							options_meshes_stw_v.updateMeshes("30");
						} else if (system.score_to_win == 30) {
							system.score_to_win = 5;
							options_meshes_stw_v.updateMeshes("5");
						} else if (system.score_to_win == 5 ) {
							system.score_to_win = 10;
							options_meshes_stw_v.updateMeshes("10");
						}
						options_meshes_stw_v.playAnimations();
					} else if (options_cursor_pos == 1 && system.game_type != TWO_PLAYER) {
						if (confirm_pushed)		confirm_pushed = false;
						if        (system.difficulty == 0.15) {
							system.difficulty        = 0.08;
							system.ball.init_speed   = 0.055;
							system.ball.speed_limit  = 0.085;
							system.ball.speed_factor = 0.25;
							options_meshes_diff_v.updateMeshes("HARD");
						} else if (system.difficulty == 0.08) {
							system.difficulty        = 0.00;
							system.ball.init_speed   = 0.06;
							system.ball.speed_limit  = 0.10;
							system.ball.speed_factor = 0.30;
							options_meshes_diff_v.updateMeshes("EXPERT");
						} else if (system.difficulty == 0.00) {
							system.difficulty        = 0.20;
							system.ball.init_speed   = 0.045;
							system.ball.speed_limit  = 0.060;
							system.ball.speed_factor = 0.15;
							options_meshes_diff_v.updateMeshes("EASY");
						} else if (system.difficulty == 0.20) {
							system.difficulty        = 0.15;
							system.ball.init_speed   = 0.05;
							system.ball.speed_limit  = 0.075;
							system.ball.speed_factor = 0.20;
							options_meshes_diff_v.updateMeshes("NORMAL");
						}
						options_meshes_diff_v.playAnimations();
					}
				}

				if (confirm_pushed) {
					SoundPlayer.play(MENU_PUSH);
					confirm_pushed  	= false;
					var no_reset:Bool = false;
					switch options_cursor_pos {
						case 0: no_reset = true;
						case 1:	if (system.game_type != TWO_PLAYER) {
									no_reset = true;
								} else {
									system.reset();
									system.start_game();
									SoundPlayer.stopTitleTheme();
									switchToInGame();
									options_cursor_pos = 0;									
								}
						case 2: if (system.game_type != TWO_PLAYER) {
									system.reset();
									system.start_game();
									SoundPlayer.stopTitleTheme();
									switchToInGame();
									options_cursor_pos = 0;
								} else {
									switchToTitle();
									options_cursor_pos = 0;									
								}
						case 3: if (system.game_type != TWO_PLAYER) {
									switchToTitle();
									options_cursor_pos = 0;
								} 
					}
					options_meshes_stw   .resetAnimations();
					options_meshes_stw_v .resetAnimations();
					options_meshes_diff  .resetAnimations();
					options_meshes_diff_v.resetAnimations();
					options_meshes_cancel.resetAnimations();
					options_meshes_start .resetAnimations();
				}
			}

		}

	}

	static function updateScores() {
		score_1_updated = false;
		score_2_updated = false;
		if (score_1 != system.scores[0]) {
			score_1 = system.scores[0];
			game_meshes_score_1.updateMeshes(Std.string(score_1));
			game_meshes_score_1.updateMeshes(Std.string(score_1), 
				new Vec4(-(game_meshes_score_1.width * (Utilities.checkDigits(score_1) - 1) + 0.7), 1.8, -1.0));
			score_1_updated = true;
		}

		if (score_2 != system.scores[1]) {
			score_2 = system.scores[1];
			game_meshes_score_2.updateMeshes(Std.string(score_2));
			score_2_updated = true;
		}
		if (score_1 == 0 && score_2 == 0) {
			score_1_updated = false;
			score_2_updated = false;
		}
		if (score_1_updated || score_2_updated) {
			SoundPlayer.play(SCORE_UPDATE);
		}
	}

	static function switchToInGame() {
		system.game_state = IN_GAME;
		setTitleObjectsVisibility(false);
		setMenuObjectsVisibility(false);
		setGameObjectsVisibility(true);
		setResultObjectsVisibility(false);
		setOptionsObjectsVisibility(false);
		setCursor(false);
	}

	static function switchToMenu() {
		system.game_state = MENU;
		if (system.game_ongoing) {
			menu_meshes_title  .updateMeshes("PAUSED",  new Vec4(-0.70,  1.0, 1.0));
			menu_meshes_restart.updateMeshes("RESTART", new Vec4(-0.50, -0.4, 1.0));
			menu_meshes_exit   .updateMeshes("QUIT",    new Vec4(-0.50, -1.0, 1.0));
			menu_itm_count = 3;
		} else {
			menu_meshes_title  .updateMeshes("NEXT",    new Vec4(-0.50,  1.0, 1.0));
			menu_meshes_restart.updateMeshes("RESTART", new Vec4(-0.50,  0.0, 1.0));
			menu_meshes_exit   .updateMeshes("QUIT",    new Vec4(-0.50, -0.6, 1.0));
			menu_itm_count = 2;
		}
		setTitleObjectsVisibility(false);
		setMenuObjectsVisibility(true);
		setResultObjectsVisibility(false);
		setOptionsObjectsVisibility(false);
		game_meshes_score_1.setVisible(true);
		game_meshes_score_2.setVisible(true);
		colon.visible = true;
		border_up.visible	= true;
		border_down.visible	= true;
		separator.visible	= false;
		for (p in system.players)	p.setVisible(false);
		system.ball.setVisible(false);
		setCursor(true);
	}

	static function switchToTitle() {
		system.game_state = TITLE;
		setTitleObjectsVisibility(true);
		setMenuObjectsVisibility(false);
		setGameObjectsVisibility(false);
		setResultObjectsVisibility(false);
		setOptionsObjectsVisibility(false);
		setCursor(true);
		title_sound_played = false;
	}

	static public function switchToResult() {
		system.game_state = RESULT;
		if (system.game_type == ONE_PLAYER) {
			if (system.winner_ID == 0) {
				result_meshes_result.updateMeshes("YOU WIN!",  new Vec4(-1.30,  0.2, 1.0), 0.8, 0.5, "MTR_title");
			} else {
				result_meshes_result.updateMeshes("YOU LOSE!", new Vec4(-1.50,  0.2, 1.0), 0.8, 0.5, "MTR_lose" );
			}
		} else if (system.game_type == TWO_PLAYER) {
			if (system.winner_ID == 0) {
				result_meshes_result.updateMeshes("PLAYER 1 WIN!", new Vec4(-2.30,  0.2, 1.0), 0.8, 0.5, "MTR_title");
			} else {
				result_meshes_result.updateMeshes("PLAYER 2 WIN!", new Vec4(-2.30,  0.2, 1.0), 0.8, 0.5, "MTR_title");
			}			
		} else {
			if (system.winner_ID == 0) {
				result_meshes_result.updateMeshes("CPU 1 WIN!", new Vec4(-1.70,  0.2, 1.0), 0.8, 0.5, "MTR_title");
			} else {
				result_meshes_result.updateMeshes("CPU 2 WIN!", new Vec4(-1.70,  0.2, 1.0), 0.8, 0.5, "MTR_title");
			}			
		}
		setTitleObjectsVisibility(false);
		setMenuObjectsVisibility(false);
		setResultObjectsVisibility(true);
		setOptionsObjectsVisibility(false);
		game_meshes_score_1.setVisible(true);
		game_meshes_score_2.setVisible(true);
		border_up.visible	= true;
		border_down.visible	= true;
		separator.visible	= false;
		for (p in system.players)	p.setVisible(false);
		system.ball.setVisible(false);
		setCursor(false);
		result_sound_played = false;
		SoundPlayer.play(RESULT_SHOW);
	}

	static function switchToOption() {
		system.game_state = OPTIONS;
		if (system.game_type != TWO_PLAYER) {
			options_meshes_start .updateMeshes("START",   new Vec4(-1.50, -1.0, 1.0));
			options_meshes_cancel.updateMeshes("CANCEL",  new Vec4(-1.50, -1.4, 1.0));
			option_itm_count = 4;
			options_cursor_pos = 2;
		} else {
			options_meshes_start .updateMeshes("START",   new Vec4(-1.50, -0.6, 1.0));
			options_meshes_cancel.updateMeshes("CANCEL",  new Vec4(-1.50, -1.0, 1.0));
			option_itm_count = 3;
			options_cursor_pos = 1;
		}
		
		setTitleObjectsVisibility(false);
		setMenuObjectsVisibility(false);
		setGameObjectsVisibility(false);
		setResultObjectsVisibility(false);
		setOptionsObjectsVisibility(true);
	}

	static function setGameObjectsVisibility(vis:Bool) {
		game_meshes_score_1.setVisible(vis);
		game_meshes_score_2.setVisible(vis);
		border_up.visible	= vis;
		border_down.visible	= vis;
		separator.visible	= vis;
		for (p in system.players)	p.setVisible(vis);
		system.ball.setVisible(vis);
	}

	static function setTitleObjectsVisibility(vis:Bool) {
		title_meshes_title   .setVisible(vis);
		title_meshes_1_player.setVisible(vis);
		title_meshes_2_player.setVisible(vis);
		title_meshes_cpuvscpu.setVisible(vis);
		title_meshes_exit    .setVisible(vis);
	}

	static function setMenuObjectsVisibility(vis:Bool) {
		menu_meshes_title.setVisible(vis);
		if (system.game_ongoing) {
			menu_meshes_resume.setVisible(vis);
		} else {
			menu_meshes_resume.setVisible(false);
		}
		menu_meshes_restart.setVisible(vis);
		menu_meshes_exit   .setVisible(vis);
	}

	static function setResultObjectsVisibility(vis:Bool) {
		colon.visible = vis;
		result_meshes_result.setVisible(vis);
		if (vis == false) {
			result_meshes_enter.setVisible(vis);
		}
	}

	static function setOptionsObjectsVisibility(vis:Bool) {
		options_meshes_title .setVisible(vis);
		options_meshes_stw   .setVisible(vis);
		options_meshes_stw_v .setVisible(vis);
		if (system.game_type != TWO_PLAYER) {
			options_meshes_diff  .setVisible(vis);
			options_meshes_diff_v.setVisible(vis);
		} else {
			options_meshes_diff  .setVisible(false);
			options_meshes_diff_v.setVisible(false);			
		}
		options_meshes_start .setVisible(vis);
		options_meshes_cancel.setVisible(vis);
	}

	static function setCursor(vis:Bool, ?pos:Vec4) {
		cursor.visible = vis;
		if (pos != null) {
			cursor.transform.loc.setFrom(pos);
			cursor.transform.buildMatrix();
		}
	}

	static function cursorRotation() {
		cursor.transform.rotate(Vec4.xAxis(), Math.PI/45);
	}

	static function colorShifting(object:Object, mat:MaterialData, link:String):iron.math.Vec4 {
		if (link == "title_color") {
			var color = new Vec4(Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8, 0.0);
			return color;

		} else if (link == "lose_color") {
			var color = new Vec4(Math.sin(4*t) * 0.2 + 0.4, Math.sin(4*t) * 0.4 + 0.2, 1.0);
			return color;

		} else if (link == "option_color") {
			var color = new Vec4(0.3, 0.3, 0.3);
			if (system.game_state == TITLE) {
				if (title_cursor_pos == 0 && object.transform.worldy() ==  0.0 ||
					title_cursor_pos == 1 && object.transform.worldy() == -0.4 ||
					title_cursor_pos == 2 && object.transform.worldy() == -0.8 ||
					title_cursor_pos == 3 && object.transform.worldy() == -1.4  ) {
					color.set(Math.sin(4*t) * 0.2 + 0.7, Math.sin(4*t) * 0.2 + 0.7, 1.0);
				}
			} else if (system.game_state == MENU) {
				if (menu_cursor_pos == 0 && object.transform.worldy() ==  0.0 ||
					menu_cursor_pos == 1 && object.transform.worldy() == -0.4 ||
					menu_cursor_pos == 1 && object.transform.worldy() == -0.6 ||
					menu_cursor_pos == 2 && object.transform.worldy() == -1.0   ) {
					color.set(Math.sin(4*t) * 0.2 + 0.7, Math.sin(4*t) * 0.2 + 0.7, 1.0);
				}
			} else if (system.game_state == OPTIONS) {
				if (options_cursor_pos == 0 && object.transform.worldy() ==  0.0 ||
					options_cursor_pos == 1 && object.transform.worldy() == -0.4 ||
					options_cursor_pos == 1 && object.transform.worldy() == -0.6 ||
					options_cursor_pos == 2 && object.transform.worldy() == -1.0 ||
					options_cursor_pos == 3 && object.transform.worldy() == -1.4   ) {
					color.set(Math.sin(4*t) * 0.2 + 0.7, Math.sin(4*t) * 0.2 + 0.7, 1.0);
				}
			}
			return color;

		} else if (link == "setting_color") {
			var color = new Vec4(0.6, 0.6, 0.6);
			if (options_cursor_pos == 0 && object.transform.worldy() ==  0.0 ||
				options_cursor_pos == 1 && object.transform.worldy() == -0.4  ) {
				color.set(Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8);
			}
			return color;

		} else if (link == "score_1_color") {
			if (score_1_updated) {
				score_1_color.setFrom(highlight_score_color);
				score_1_updating = true;
			} 
			if (system.game_state == RESULT) {
				score_1_updating = false;
				score_1_color.setFrom(result_score_color);
			} else {
				if (score_1_updating) {
					score_1_color.lerp(score_1_color, default_score_color, 0.02);
					if (Utilities.compareMarginVec4(default_score_color, score_1_color, 0.01)) {
						score_1_updating = false;
					}
				} else {
					score_1_color.setFrom(default_score_color);
				}
			}
			return score_1_color.clone();

		} else if (link == "score_2_color") {
			if (score_2_updated) {
				score_2_color.setFrom(highlight_score_color);
				score_2_updating = true;
			} 
			if (system.game_state == RESULT) {
				score_2_updating = false;
				score_2_color.setFrom(result_score_color);
			} else {
				if (score_2_updating) {
					score_2_color.lerp(score_2_color, default_score_color, 0.02);
					if (Utilities.compareMarginVec4(default_score_color, score_2_color, 0.01)) {
						score_2_updating = false;
					}
				} else {
					score_2_color.setFrom(default_score_color);
				}
			}
			return score_2_color.clone();

		} else if (link == "particle_color") {
			if (system.game_state == TITLE) {
				if (par_color_updating) {
					par_color.lerp(par_color, par_fadeout_color, par_fadeout_speed);
					if (title_meshes_title.animations[0].state != PLAYING &&
						Utilities.compareMarginVec4(par_color, par_fadeout_color, 0.01)) {
						par_color_updating = false;
					}
				} else {
					par_color.setFrom(par_fadeout_color);
				}
				if (title_meshes_title.animations[0].state == PLAYING  &&
					title_meshes_title.animations[0].phase == 1        &&
					!par_color_updating) {
					par_color.setFrom(par_start_color);
					par_color_updating = true;
				} 
			} else if (system.game_state == RESULT) {
				if (par_color_updating) {
					par_color.lerp(par_color, par_fadeout_color, par_fadeout_speed);
					if (result_meshes_result.animations[0].state == FINISHED &&
						Utilities.compareMarginVec4(par_color, par_fadeout_color, 0.01)) {
						par_color_updating = false;
					}
				} else {
					par_color.setFrom(par_fadeout_color);
				}
				if (result_meshes_result.animations[0].state != FINISHED &&
					result_meshes_result.animations[0].phase == 1        &&
					!par_color_updating) {
					par_color.setFrom(par_start_color);
					par_color_updating = true;
				} 			
			} else if (system.game_state == IN_GAME) {
				par_color.setFrom(par_start_color_bl);
			} else {
				par_color.setFrom(par_start_color);
			}
			return par_color.clone();
		} else if (link == "colon_color") {
			var color :Vec4 = null;
			if (system.game_state == RESULT) {
				color = new Vec4(1.0, 1.0, 1.0);
			} else if (system.game_state == MENU) {
				color = new Vec4(0.4, 0.4, 0.4);
			}
			return color;
		} else if (link == "colon_color") {
			var color :Vec4 = null;
			if (system.game_state == RESULT) {
				color = new Vec4(1.0, 1.0, 1.0);
			} else if (system.game_state == MENU) {
				color = new Vec4(0.4, 0.4, 0.4);
			}
			return color;
		} else if (link == "indicator_color") {
			var color = new Vec4(Math.sin(16*t) * 0.2 + 0.8, Math.sin(16*t) * 0.2 + 0.8, 0.0);
			return color;			
		} else if (link == "tips_color") {
			var color = new Vec4(Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8);
			return color;			
		} else if (link == "trail_color") {
			return new Vec4(0.2, 0.2, 0.2);
		}
		return null;
	}
}