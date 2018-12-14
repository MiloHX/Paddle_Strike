package arm;

import kha.math.Random;
import iron.Trait;

@:enum abstract GameState(Int) {
	var TITLE		= 0;
	var MENU 		= 1;
	var IN_GAME 	= 2;
	var RESULT		= 3;
	var OPTIONS		= 4;
}

@:enum abstract GameType(Int) {
	var ONE_PLAYER	= 0;
	var TWO_PLAYER	= 1;
	var CPU_VS_CPU  = 2;
}


class SystemTrait extends Trait {

	public var border_h 	:Float				= 2.35;
	public var players		:Array<PlayerTrait>	= [];
	public var ball			:BallTrait;
	public var game_state	:GameState			= TITLE;
	public var scores		:Array<Int>			= [];
	public var game_type	:GameType			= ONE_PLAYER;
	public var score_to_win	:Int				= 10;
	public var difficulty	:Float				= 0.15;
	public var winner_ID	:Int;
	public var game_ongoing	:Bool				= false;

	public function new() {
		super();

		notifyOnInit(function() {
			Random.init(Std.random(10000));
		});

		notifyOnUpdate(function() {
			PlayerInput.update();
			ComputerAIP1.update();
			ComputerAIP2.update();
			UserInterface.update();
		});
	}

	public function reset() {
		for (i in 0...scores.length)	scores[i] = 0;
		for (p in players)				p.reset();
		ball.reset();
		game_ongoing = false;
		winner_ID = -1;
	}

	public function start_game() {
		for (p in players)		p.start();
		game_ongoing = true;
	}

	public function socre(playerID:Int) {
		scores[playerID]++;
		if (scores[playerID] >= score_to_win) {
			winner_ID = playerID;
			game_ongoing = false;
		}
	}


	public function registerPlayer(p:PlayerTrait):Int {
		scores.push(0);
		return players.push(p) - 1;
	}

	public function registerBall(b:BallTrait) {
		ball = b;
	}

}