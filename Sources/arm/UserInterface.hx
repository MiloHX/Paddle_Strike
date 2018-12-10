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

	static var game_meshes_score_1	:MeshText;
	static var game_meshes_score_2	:MeshText;
	static var title_meshes_title	:MeshText;
	static var title_meshes_1_player:MeshText;
	static var title_meshes_2_player:MeshText;
	static var title_meshes_exit	:MeshText;
	static var menu_meshes_title	:MeshText;
	static var menu_meshes_resume	:MeshText;
	static var menu_meshes_restart	:MeshText;
	static var menu_meshes_exit		:MeshText;
	static var result_meshes_result	:MeshText;
	static var options_meshes_title	:MeshText;
	static var options_meshes_stw	:MeshText;
	static var options_meshes_stw_v	:MeshText;
	static var options_meshes_diff	:MeshText;
	static var options_meshes_diff_v:MeshText;
	static var options_meshes_start	:MeshText;
	static var options_meshes_cancel:MeshText;

	static var cursor				:MeshObject;

	static var border_up			:MeshObject;
	static var border_down			:MeshObject;
	static var separator			:MeshObject;

	static var title_cursor_pos		:Int;
	static var menu_cursor_pos		:Int;
	static var options_cursor_pos	:Int;
	static var menu_itm_count		:Int		= 3;

	static var init_completed		:Bool		= false;	// init completed?


	static function init() {
		system  = Scene.active.getTrait(SystemTrait);
		game_meshes_score_1 	= new MeshText(Std.string(score_1), new Vec4(-0.7, 1.8, -1.0), 1.0, 0.45);
		game_meshes_score_2 	= new MeshText(Std.string(score_2), new Vec4( 0.7, 1.8, -1.0), 1.0, 0.45);
		title_meshes_title		= new MeshText("ARMORY PONG",   new Vec4(-2.00,  1.0, 1.0), 0.8, 0.5, "MTR_title"  );
		title_meshes_1_player	= new MeshText("1 PLAYER" ,     new Vec4(-0.70,  0.0, 1.0), 0.4, 0.5, "MTR_option" );
		title_meshes_2_player	= new MeshText("2 PLAYERS",     new Vec4(-0.70, -0.4, 1.0), 0.4, 0.5, "MTR_option" );
		title_meshes_exit		= new MeshText("EXIT",          new Vec4(-0.70, -1.0, 1.0), 0.4, 0.5, "MTR_option" );
		menu_meshes_title		= new MeshText("PAUSED",        new Vec4(-0.70,  1.0, 1.0), 0.6, 0.5, "MTR_title"  );
		menu_meshes_resume		= new MeshText("RESUME",        new Vec4(-0.50,  0.0, 1.0), 0.4, 0.5, "MTR_option" );
		menu_meshes_restart		= new MeshText("RESTART",       new Vec4(-0.50, -0.4, 1.0), 0.4, 0.5, "MTR_option" );
		menu_meshes_exit		= new MeshText("QUIT",          new Vec4(-0.50, -1.0, 1.0), 0.4, 0.5, "MTR_option" );
		result_meshes_result	= new MeshText("RESULT",        new Vec4(-2.00,  1.0, 1.0), 0.8, 0.5, "MTR_title"  );
		options_meshes_title	= new MeshText("OPTIONS",       new Vec4(-0.90,  1.0, 1.0), 0.6, 0.5, "MTR_title"  );
		options_meshes_stw		= new MeshText("SCORE TO WIN:", new Vec4(-1.50,  0.0, 1.0), 0.4, 0.5, "MTR_option" );
		options_meshes_stw_v	= new MeshText("10",            new Vec4( 1.20,  0.0, 1.0), 0.4, 0.5, "MTR_setting");
		options_meshes_diff		= new MeshText("DIFFICULTY:",   new Vec4(-1.50, -0.4, 1.0), 0.4, 0.5, "MTR_option" );
		options_meshes_diff_v	= new MeshText("NORMAL",        new Vec4( 1.20, -0.4, 1.0), 0.4, 0.5, "MTR_setting");
		options_meshes_start  	= new MeshText("START",         new Vec4(-1.50, -1.0, 1.0), 0.4, 0.5, "MTR_option" );
		options_meshes_cancel  	= new MeshText("CANCEL",        new Vec4(-1.50, -1.4, 1.0), 0.4, 0.5, "MTR_option" );
		cursor					= Scene.active.getMesh("cursor");
		border_up				= Scene.active.getMesh("border_up");
		border_down				= Scene.active.getMesh("border_down");
		separator				= Scene.active.getMesh("separator");

		title_meshes_title   .addAnimation(DROP_IN);
		title_meshes_1_player.addAnimation(ROLLING, true);
		title_meshes_1_player.addAnimation(VIBERATING);
		title_meshes_2_player.addAnimation(ROLLING, true);
		title_meshes_2_player.addAnimation(VIBERATING);
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
		options_meshes_diff  .addAnimation(ROLLING, true);
		options_meshes_diff  .addAnimation(VIBERATING);
		options_meshes_start .addAnimation(ROLLING, true);
		options_meshes_start .addAnimation(VIBERATING);
		options_meshes_cancel.addAnimation(ROLLING, true);
		options_meshes_cancel.addAnimation(VIBERATING);

		result_meshes_result .addAnimation(DROP_IN);
		result_meshes_result.animations[0].par_sys.floor = -0.1;

		title_cursor_pos		= 0;
		menu_cursor_pos			= 0;
		options_cursor_pos		= 0;

		Uniforms.externalVec3Links.push(colorShifting);
	}

	static public function update() {
		if (!init_completed) {
			init();
			switchToTitle();
			init_completed = true;
		}

		t = Time.time();
		cursorRotation();



		var menu_pushed    = PlayerInput.menu;
		var confirm_pushed = PlayerInput.confirm;
		if (system.game_state == IN_GAME) {
			if (menu_pushed) {
				switchToMenu();
				menu_pushed = false;
			} else {
				updateScores();
			}
		}
		
		if (system.game_state == TITLE) {
			title_meshes_title   .playAnimations();
			title_meshes_title   .updateAnimations();

			title_meshes_1_player.updateAnimations();
			title_meshes_2_player.updateAnimations();
			title_meshes_exit    .updateAnimations();

			var cursor_moved = false;

			if (PlayerInput.down) {
				if (title_cursor_pos < 2) {
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
					title_cursor_pos = 2;
				}
				cursor_moved = true;
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
							title_meshes_exit    .resetAnimations();
						}
				case 2: setCursor(true, new Vec4(-1.1, -1.0, 1.0));
						if (cursor_moved) {
							title_meshes_exit    .playAnimations ();
							title_meshes_1_player.resetAnimations();
							title_meshes_2_player.resetAnimations();
						}

			}
			
			if (confirm_pushed) {
				confirm_pushed = false;
				switch title_cursor_pos {
					case 0:	system.game_type = ONE_PLAYER;
							switchToOption();
					case 1: system.game_type = TWO_PLAYER;
							system.start_game();
							switchToInGame();
					case 2: System.stop();
				}
				title_cursor_pos = 0;
				title_meshes_title   .resetAnimations();
				title_meshes_1_player.resetAnimations();
				title_meshes_2_player.resetAnimations();
				title_meshes_exit    .resetAnimations();
			}
		}

		if (system.game_state == MENU) {
			menu_meshes_resume .updateAnimations();
			menu_meshes_restart.updateAnimations();
			menu_meshes_exit   .updateAnimations();

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
		}

		if (system.game_state == RESULT) {
			result_meshes_result.playAnimations();
			result_meshes_result.updateAnimations();

			updateScores();
			if (menu_pushed || confirm_pushed) {
				menu_pushed    = false;
				confirm_pushed = false;
				system.reset();
				switchToMenu();
				result_meshes_result.resetAnimations();
			}
		}

		if (system.game_state == OPTIONS) {
			options_meshes_stw   .updateAnimations();
			options_meshes_diff  .updateAnimations();
			options_meshes_start .updateAnimations();
			options_meshes_cancel.updateAnimations();

			if (menu_pushed) {
				menu_pushed    = false;
				switchToTitle();
			} else {
				var cursor_moved = false;
				if (PlayerInput.down) {
					if (options_cursor_pos < 3) {
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
						options_cursor_pos = 3;
					}
					cursor_moved = true;
				}

				switch options_cursor_pos {
					case 0:		setCursor(true, new Vec4(-1.9,  0.0, 1.0));
								if (cursor_moved) {
									options_meshes_stw   .playAnimations();
									options_meshes_diff  .resetAnimations();
									options_meshes_cancel.resetAnimations();
								}
					case 1: 	setCursor(true, new Vec4(-1.9, -0.4, 1.0));
								if (cursor_moved) {
									options_meshes_diff .playAnimations();
									options_meshes_stw  .resetAnimations();
									options_meshes_start.resetAnimations();	
								}							
					case 2: 	setCursor(true, new Vec4(-1.9, -1.0, 1.0));
								if (cursor_moved) {
									options_meshes_start .playAnimations ();
									options_meshes_diff  .resetAnimations();
									options_meshes_cancel.resetAnimations();
								}
					case 3: 	setCursor(true, new Vec4(-1.9, -1.4, 1.0));
								if (cursor_moved) {
									options_meshes_cancel.playAnimations ();
									options_meshes_start .resetAnimations();
									options_meshes_stw   .resetAnimations();
								}				
				}

				if (confirm_pushed) {
					confirm_pushed  	= false;
					var reset_animation	= false;
					switch options_cursor_pos {
						case 0: if        (system.score_to_win == 10) {
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
						case 1:	if        (system.difficulty == 0.15) {
									system.difficulty = 0.08;
									options_meshes_diff_v.updateMeshes("HARD");
								} else if (system.difficulty == 0.08) {
									system.difficulty = 0.00;
									options_meshes_diff_v.updateMeshes("EXPERT");
								} else if (system.difficulty == 0.00) {
									system.difficulty = 0.20;
									options_meshes_diff_v.updateMeshes("EASY");
								} else if (system.difficulty == 0.20) {
									system.difficulty = 0.15;
									options_meshes_diff_v.updateMeshes("NORMAL");
								} 
						case 2: system.start_game();
								switchToInGame();
								options_cursor_pos = 0;
								reset_animation = true;
						case 3: switchToTitle();
								reset_animation = true;
								options_cursor_pos = 0;
					}
					if (reset_animation) {
						options_meshes_stw   .resetAnimations();
						options_meshes_diff  .resetAnimations();
						options_meshes_cancel.resetAnimations();
						options_meshes_start .resetAnimations();
					}
				}
			}

		}

	}

	static function updateScores() {
		if (score_1 != system.scores[0]) {
			score_1 = system.scores[0];
			game_meshes_score_1.updateMeshes(Std.string(score_1));
			game_meshes_score_1.updateMeshes(Std.string(score_1), 
				new Vec4(-(game_meshes_score_1.width * (Utilities.checkDigits(score_1) - 1) + 0.7), 1.8, -1.0));
		}

		if (score_2 != system.scores[1]) {
			score_2 = system.scores[1];
			game_meshes_score_2.updateMeshes(Std.string(score_2));
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
		border_up.visible	= true;
		border_down.visible	= true;
		separator.visible	= false;
		for (p in system.players)	p.object.visible = false;
		system.ball.object.visible = false;
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
		for (p in system.players)	p.object.visible = false;
		system.ball.object.visible = false;
		setCursor(false);		
	}

	static function switchToOption() {
		system.game_state = OPTIONS;
		options_cursor_pos = 2;
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
		for (p in system.players)	p.object.visible = vis;
		system.ball.object.visible = vis;
	}

	static function setTitleObjectsVisibility(vis:Bool) {
		title_meshes_title   .setVisible(vis);
		title_meshes_1_player.setVisible(vis);
		title_meshes_2_player.setVisible(vis);
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
		result_meshes_result.setVisible(vis);
	}

	static function setOptionsObjectsVisibility(vis:Bool) {
		options_meshes_title .setVisible(vis);
		options_meshes_stw   .setVisible(vis);
		options_meshes_stw_v .setVisible(vis);
		options_meshes_diff  .setVisible(vis);
		options_meshes_diff_v.setVisible(vis);
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
		}
		if (link == "lose_color") {
			var color = new Vec4(Math.sin(4*t) * 0.2 + 0.4, Math.sin(4*t) * 0.4 + 0.2, 1.0);
			return color;
		}
		if (link == "option_color") {
			var color = new Vec4(0.3, 0.3, 0.3);
			if (system.game_state == TITLE) {
				if (title_cursor_pos == 0 && object.transform.worldy() ==  0.0 ||
					title_cursor_pos == 1 && object.transform.worldy() == -0.4 ||
					title_cursor_pos == 2 && object.transform.worldy() == -1.0  ) {
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
					options_cursor_pos == 2 && object.transform.worldy() == -1.0 ||
					options_cursor_pos == 3 && object.transform.worldy() == -1.4   ) {
					color.set(Math.sin(4*t) * 0.2 + 0.7, Math.sin(4*t) * 0.2 + 0.7, 1.0);
				}
			}
			return color;
		}
		if (link == "setting_color") {
			var color = new Vec4(0.6, 0.6, 0.6);
			if (options_cursor_pos == 0 && object.transform.worldy() ==  0.0 ||
				options_cursor_pos == 1 && object.transform.worldy() == -0.4  ) {
				color.set(Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8, Math.sin(4*t) * 0.2 + 0.8);
			}
			return color;
		}
		return null;
	}
}