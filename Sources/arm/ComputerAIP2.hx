package arm;

import kha.FastFloat;
import kha.math.Random;
import iron.Scene;

class ComputerAIP2 {

    static public var up			:Bool;
    static public var down			:Bool;

    static var system				:SystemTrait;
    static var ball					:BallTrait;
    static var player_1				:PlayerTrait;
    static var player_2				:PlayerTrait;
    static var init_completed		:Bool			= false;	// init completed?
    static var timer				:Timer;
    static var action_time			:FastFloat		= 0.1;

    static function init() {
        system  	= Scene.active.getTrait(SystemTrait);
        ball		= system.ball;
        player_1	= system.players[0];
        player_2	= system.players[1];
        timer		= new Timer(action_time);
    }

    static public function update() {
        if (!init_completed) {
            init();
            init_completed = true;
        }
        timer.update();

        if (system.game_type == TWO_PLAYER)		return;

        var ball_h     = ball.object.transform.worldy();
        var ball_d     = player_2.object.transform.worldx() - ball.object.transform.worldx();
        var ball_dir   = ball.direction.x > 0;
        var player_2_h = player_2.object.transform.worldy();

        if (!timer.isRunning()) {
            up   = false;
            down = false;
            var action_flag:Bool = false;
            if (ball_dir) {
                if (Random.getFloatIn(0.0, 6.0)  > ball_d)	action_flag = true;
            } else {
                if (Random.getFloatIn(0.0, 48.0) < ball_d)	action_flag = true;
            }

            if (action_flag) {
                // follow ball
                if (ball_h > player_2_h + 0.2) {
                    if (ball_h - player_2_h > 0.2) {
                        move(1);
                    } else {
                        if (Random.getFloatIn(0.0, 0.2) < (ball_h - player_2_h)) {
                            move(1);
                        }
                    }
                } else if (ball_h < player_2_h - 0.2) {
                    if (player_2_h - ball_h > 0.2) {
                        move(-1);
                    } else {
                        if (Random.getFloatIn(0.0, 0.2) < (player_2_h - ball_h)) {
                            move(-1);
                        }
                    }
                } 
            }
        } else if(timer.time_remain < action_time * Random.getFloatIn(0.0, 0.5)) {
            up   = false;
            down = false;
        }
    }

    static function move(dir:Int) {

        var mistake_flag = false;
        var reverse_flag = false;
        if (Random.getFloatIn(0.0, 1.0) < system.difficulty)	mistake_flag = true;
        if (mistake_flag == true) {
            if (Random.getFloatIn(0.0, 1.0) < 0.5) reverse_flag = true;
        }

        if (dir > 0) {
            if (!mistake_flag) {
                up   = true;
            } else if (reverse_flag) {
                down = true;
            }				
            timer.reset();
            timer.start();
        } else if (dir < 0) {
            if (!mistake_flag) {
                down = true;
            } else if (reverse_flag) {
                up   = true;
            }	
            timer.reset();
            timer.start();			
        }
    }

}