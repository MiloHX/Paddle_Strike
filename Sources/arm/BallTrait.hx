package arm;

import kha.math.Random;
import iron.Scene;
import iron.math.Vec2;
import iron.math.Math;

class BallTrait extends iron.Trait {

	var system				:SystemTrait;
	var init_speed			:Float			= 0.06;
	var kickoff				:Bool			= false;
	var speedup				:Bool			= false;
	var timer				:Timer;
	var speed_factor		:Float			= 0.3;
	var speed_limit			:Float			= 0.1;

	public var direction	:Vec2 			= new Vec2();
	public var speed		:Float;


	public function new() {
		super();

		notifyOnInit(function() {
			system	= Scene.active.getTrait(SystemTrait);
			system.registerBall(this);
			timer = new Timer(1.0);
			reset();
		});

		notifyOnLateUpdate(function() {
			if (system.game_state == IN_GAME) { 
				if (kickoff) {
					var delta_x =  direction.x * speed;
					var delta_y =  direction.y * speed;
					collisionDetection(new Vec2(delta_x, delta_y));
					object.transform.translate(delta_x, delta_y, 0.0);

					// score
					if (object.transform.worldx() > 3.3) {
						system.socre(0);
						reset();
					} else if (object.transform.worldx() < -3.3) {
						system.socre(1);
						reset();
					}
				} else {
					if(timer.update()) {
						kickoff = true;
					};
				}
			}
		});

	}

	public function reset() {
		var pos = object.transform.loc;
		object.transform.loc.set(0.0, 0.0, pos.z);
		object.transform.buildMatrix();
		speed = init_speed;
		var angle = Random.getFloatIn(-Math.PI_2*0.8, Math.PI_2*0.8);
		if (Random.get() % 2 == 1) angle += Math.PI;
		direction.setFrom(Utilities.rotateVec2(Vec2.xAxis(), angle));
		kickoff = false;
		timer.reset();
		timer.start();
	}

	function collisionDetection(v:Vec2):Bool {
		var result = false;

		var x_pos = object.transform.worldx() + v.x;
		var y_pos = object.transform.worldy() + v.y;

		speedup = false;

		// borders		
		if (y_pos > system.border_h - 0.03) {
			if (v.y > 0) {
				direction.set(direction.x, -direction.y);
				// Add randomness
				if (v.x > 0) {
					direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(0,  Math.PI_4*0.1)));
				} else {
					direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(-Math.PI_4*0.1, 0)));
				}
				result = true;
			}
		} else if (y_pos < -system.border_h + 0.03) {
			if (v.y < 0) {
				direction.set(direction.x, -direction.y);
				// Add randomness
				if (v.x > 0) {
					direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(-Math.PI_4*0.1, 0)));
				} else {
					direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(0,  Math.PI_4*0.1)));
				}
				result = true;
			}
		}
		if (result == true)	return result;
		

		// players
		var x_1 = x_pos - object.transform.dim.x/2;
		var x_2 = x_pos + object.transform.dim.x/2;
		var y_1 = y_pos - object.transform.dim.y/2;
		var y_2 = y_pos + object.transform.dim.y/2;
		for (p in system.players) {
			var p_x_1 = p.hitbox_x1;
			var p_x_2 = p.hitbox_x2;
			var p_y_1 = p.hithox_y1;
			var p_y_2 = p.hitbox_y2;

			var left_x_in	= false;
			var right_x_in	= false;
			var upper_y_in	= false;
			var lower_y_in	= false;

			if (x_1 < p_x_2 && x_1 > p_x_1)		left_x_in	= true;
			if (x_2 < p_x_2 && x_2 > p_x_1)		right_x_in	= true;
			if (y_2 < p_y_2 && y_2 > p_y_1)		upper_y_in	= true;
			if (y_1 < p_y_2 && y_1 > p_y_1)		lower_y_in	= true;


			var y_reflect	= new Vec2(direction.x, -direction.y);
			var y_angle		= Utilities.angleBetweenVec2(direction, y_reflect);
			var x_reflect	= new Vec2(-direction.x, direction.y);
			var x_angle		= Utilities.angleBetweenVec2(direction, x_reflect);
			var o_reflect	= new Vec2(-direction.x, -direction.y);

			// normal cases left
			if (left_x_in && !right_x_in && lower_y_in && upper_y_in) {
				if (v.x < 0) {
					// downwards
					if(v.y < 0) {
						if (system.players[0].speed > 0) {
							direction.setFrom(o_reflect);
						} else {
							direction.setFrom(x_reflect);
						}
					// upwards
					} else {
						if (system.players[0].speed < 0) {
							direction.setFrom(o_reflect);
						} else {
							direction.setFrom(x_reflect);
						}
					}
					// Add randomness
					direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(-Math.PI_4*0.2, Math.PI_4*0.2)));
					if (system.players[1].speed != 0.0) {
						speed = speed > speed_limit ? speed : speed + Math.abs(system.players[1].speed)*speed_factor;
						speedup = true;
					}
					result = true;	
				}
			// normal cases right
			} else if (!left_x_in && right_x_in && lower_y_in && upper_y_in) {
				if (v.x > 0) {
					// downwards
					if(v.y < 0) {
						if (system.players[1].speed > 0) {
							direction.setFrom(o_reflect);
						} else {
							direction.setFrom(x_reflect);
						}
					// upwards
					} else {
						if (system.players[1].speed < 0) {
							direction.setFrom(o_reflect);
						} else {
							direction.setFrom(x_reflect);
						}
					}
					// Add randomness
					direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(-Math.PI_4*0.2, Math.PI_4*0.2)));
					if (system.players[1].speed != 0.0) {
						speed = speed > speed_limit ? speed : speed + Math.abs(system.players[1].speed)*speed_factor;
						speedup = true;
					}				
					result = true;	
				}
			// all inside, abnormal, don't change
			} else if (left_x_in && right_x_in && lower_y_in && upper_y_in) {	
			// ball lower left corner
			} else if (left_x_in && !right_x_in && lower_y_in && !upper_y_in) {
				if (v.x < 0) {
					var x_depth = p_x_2 - x_1;
					var y_depth = p_y_2 - y_1;
					// downwards
					if(v.y < 0) {
						var angle = x_angle * (x_depth/ x_depth + y_depth) + y_angle * (y_depth/ x_depth + y_depth);
						direction.setFrom(Utilities.rotateVec2(direction, angle));
					// upwards
					} else {
						direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));			
					}
					if (system.players[0].speed != 0.0) {
						speed = speed > speed_limit ? speed : speed +  Math.abs(system.players[0].speed)*speed_factor;
						speedup = true;
					}
					result = true;
				}
			// ball upper left corner
			} else if (left_x_in && !right_x_in && !lower_y_in && upper_y_in) {
				if (v.x < 0) {
					var x_depth = p_x_2 - x_1;
					var y_depth = y_2 - p_y_1;
					// downwards
					if(v.y < 0) {
						direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));							
					// upwards
					} else{
						var angle = x_angle * (x_depth/ x_depth + y_depth) + y_angle * (y_depth/ x_depth + y_depth);
						direction.setFrom(Utilities.rotateVec2(direction, angle));
					}
					if (system.players[0].speed != 0.0) {
						speed = speed > speed_limit ? speed : speed + Math.abs(system.players[0].speed)*speed_factor;
						speedup = true;
					}
					result = true;
				}
			// ball lower right corner
			} else if (!left_x_in && right_x_in && lower_y_in && !upper_y_in) {
				if (v.x > 0) {
					var x_depth = x_2 - p_x_1;
					var y_depth = p_y_2 - y_1;
					// downwards
					if(v.y < 0) {
						var angle = x_angle * (x_depth/ x_depth + y_depth) + y_angle * (y_depth/ x_depth + y_depth);
						direction.setFrom(Utilities.rotateVec2(direction, angle));
					// upwards
					} else {
						direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));			
					}
					if (system.players[1].speed != 0.0) {
						speed = speed > speed_limit ? speed : speed + Math.abs(system.players[1].speed)*speed_factor;
						speedup = true;
					}
					result = true;
				}		
			// ball upper right corner
			} else if (!left_x_in && right_x_in && !lower_y_in && upper_y_in) {
				if (v.x > 0) {
					var x_depth = x_2 - p_x_1;
					var y_depth = y_2 - p_y_1;	
					// downwards
					if(v.y < 0) {
						direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));							
					// upwards
					} else{
						var angle = x_angle * (x_depth/ x_depth + y_depth) + y_angle * (y_depth/ x_depth + y_depth);
						direction.setFrom(Utilities.rotateVec2(direction, angle));
					}
					if (system.players[1].speed != 0.0) {
						speed = speed > speed_limit ? speed : speed + Math.abs(system.players[1].speed)*speed_factor;
						speedup = true;
					}
					result = true;
				}		
			}
			if (result == true && speedup != true) {									
				speed = speed < init_speed + 0.005 ? init_speed : speed - 0.005; // decrease speed
				return result;
			}
		}

		if (result == false && v.length() > 0.03) {
			var new_length = v.length() - 0.01;
			var new_v = v.normalize().mult(new_length);
			result = collisionDetection(new_v);
		}

		return result;
	}
}
