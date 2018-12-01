package arm;

import kha.math.Random;
import iron.Trait;

@:enum abstract PongGameState(Int) {
	var MENU 		= 0;
	var IN_GAME 	= 1;
}

class SystemTrait extends Trait {

	public var border_h 	:Float				= 2.35;
	public var players		:Array<PlayerTrait>	= [];
	public var ball			:BallTrait;
	public var game_state	:PongGameState		= IN_GAME;
	public var scores		:Array<Int>			= [];

	public function new() {
		super();

		notifyOnInit(function() {
			Random.init(Std.random(10000));
		});

		notifyOnUpdate(function() {
			PlayerInput.update();
			if (PlayerInput.menu) {
				switch game_state {
					case MENU:
						game_state = IN_GAME;
					case IN_GAME:
						game_state = MENU;
					default:
				}
			}

			// Show menu
			if (game_state == MENU) {

			}
			UserInterface.update();

		});
	}

	public function reset() {
		for (s in scores)	s = 0;
		for (p in players)	p.reset();
		ball.reset();
	}

	public function socre(playerID:Int) {
		scores[playerID]++;
	}


	public function registerPlayer(p:PlayerTrait):Int {
		scores.push(0);
		return players.push(p) - 1;
	}

	public function registerBall(b:BallTrait) {
		ball = b;
	}

}