package arm;

import arm.SystemTrait.PongGameState;
import iron.math.Vec4;
import iron.Scene;

class UserInterface {

	static var system				:SystemTrait;
	static var score_1				:Int		= 0;
	static var score_2				:Int		= 0;
	static var score_meshes_1		:MeshText;
	static var score_meshes_2		:MeshText;

	static var menu_meshes_title	:MeshText;

	static var init_completed	:Bool		= false;	// init completed?
	static var last_game_state	:PongGameState	= MENU;


	static public function init() {
		system  = Scene.active.getTrait(SystemTrait);
		score_meshes_1 		= new MeshText(Std.string(score_1), new Vec4(-0.7, 1.8, -1.0), 1.0, 0.45);
		score_meshes_2 		= new MeshText(Std.string(score_2), new Vec4( 0.7, 1.8, -1.0), 1.0, 0.45);
		menu_meshes_title	= new MeshText("ARMORY PONG", new Vec4(-2.0, 1.0, 1.0), 0.8, 0.5);
	}


	static public function update() {
		if (!init_completed) {
			init();
			init_completed = true;
		}

		if (system.game_state == IN_GAME) {
			if (system.game_state != last_game_state) {
				menu_meshes_title.setVisible(false);
				score_meshes_1.setVisible(true);
				score_meshes_2.setVisible(true);
			}
			if (score_1 != system.scores[0]) {
				score_1 = system.scores[0];
				score_meshes_1.updateMeshes(Std.string(score_1));
				score_meshes_1.updateMeshes(Std.string(score_1), 
					new Vec4(-(score_meshes_1.width * (checkDigits(score_1) - 1) + 0.7), 1.8, -1.0));
			}

			if (score_2 != system.scores[1]) {
				score_2 = system.scores[1];
				score_meshes_2.updateMeshes(Std.string(score_2));
			}
		}
		
		if (system.game_state == MENU) {
			if (system.game_state != last_game_state) {
				menu_meshes_title.setVisible(true);
				score_meshes_1.setVisible(false);
				score_meshes_2.setVisible(false);
			}

		}

		last_game_state = system.game_state;
	}

	static function checkDigits(number:Int):Int {
		if (number < 100000) {
			if (number < 100) {
				if (number < 10) {
					return 1;
				} else {
					return 2;
				}
			} else {
				if (number < 1000) {
					return 3;
				} else {
					if (number < 10000) {
						return 4;
					} else {
						return 5;
					}
				}
			}
		} else {
			if (number < 10000000) {
				if (number < 1000000) {
					return 6;
				} else {
					return 7;
				}
			} else {
				if (number < 100000000) {
					return 8;
				} else {
					if (number < 1000000000) {
						return 9;
					} else {
						return 10;
					}
				}
			}
		}
	}
}