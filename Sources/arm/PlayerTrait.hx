package arm;

import iron.Scene;
import kha.FastFloat;

import iron.Trait;

class PlayerTrait extends Trait {

	@prop public var player_ID		:Int			= 1;	

	var system	:SystemTrait;
	var playerID:Int;

	public var hitbox_x1:FastFloat;
	public var hitbox_x2:FastFloat;
	public var hithox_y1:FastFloat;
	public var hitbox_y2:FastFloat;
	public var speed:FastFloat = 0.0;

	public function new() {
		super();

		notifyOnInit(function() {
			system = Scene.active.getTrait(SystemTrait);
			playerID = system.registerPlayer(this);
			reset();
		});

		notifyOnUpdate(function() {
			if (system.game_state == IN_GAME) {
				updateHitbox();
				getPlayerSpeed();
				if (speed != 0.0) movePlayer();
			}
		});
	}

	public function reset() {
		speed = 0.0;
		var pos = object.transform.loc;
		object.transform.loc.set(pos.x, 0.0, pos.y);
		object.transform.buildMatrix();
	}

	function updateHitbox() {
		hitbox_x1 = object.transform.worldx() - object.transform.dim.x/2;
		hitbox_x2 = object.transform.worldx() + object.transform.dim.x/2;
		hithox_y1 = object.transform.worldy() - object.transform.dim.y/2 - 0.05;
		hitbox_y2 = object.transform.worldy() + object.transform.dim.y/2 + 0.05;
	}

	function getPlayerSpeed() {
		var key_pressed:Bool = false;
		switch player_ID {
			case 1:	
				if (PlayerInput.key_up_1)	{
					if (speed < 0.0) {
						speed = 0.0;
					} else {
						speed = speed > 0.1 ? speed : speed += 0.025;
					}
					key_pressed = true;
				}
				if (PlayerInput.key_down_1)	{
					if (speed > 0.0) {
						speed = 0.0;
					} else {
						speed = speed < -0.1 ? speed : speed -= 0.025;
					}
					key_pressed = true;
				}
			case 2:	
				if (system.game_type == TWO_PLAYER) {
					if (PlayerInput.key_up_2)	{
						if (speed < 0.0) {
							speed = 0.0;
						} else {
							speed = speed > 0.1 ? speed : speed += 0.025;
						}
						key_pressed = true;
					}
					if (PlayerInput.key_down_2)	{
						if (speed > 0.0) {
							speed = 0.0;
						} else {
							speed = speed < -0.1 ? speed : speed -= 0.025;
						}
						key_pressed = true;
					}
				} else {
					if (ComputerAI.up)	{
						if (speed < 0.0) {
							speed = 0.0;
						} else {
							speed = speed > 0.1 ? speed : speed += 0.025;
						}
						key_pressed = true;
					}
					if (ComputerAI.down)	{
						if (speed > 0.0) {
							speed = 0.0;
						} else {
							speed = speed < -0.1 ? speed : speed -= 0.025;
						}
						key_pressed = true;
					}					
				}
			default:
		}
		if (!key_pressed) {
			if (speed > 0.0) {
				var temp_speed = speed -= 0.025;
				speed = temp_speed <= 0.0 ? 0.0 : temp_speed; 
			} else {
				var temp_speed = speed += 0.025;
				speed = temp_speed >= 0.0 ? 0.0 : temp_speed; 						
			}
		}
	}

	public function movePlayer() {
		var y_position		:FastFloat = object.transform.worldy();
		var new_y_pos		:FastFloat = y_position + speed;
		var upper_limit		:FastFloat = system.border_h - object.transform.dim.y/2;
		var lower_limit		:FastFloat = -system.border_h + object.transform.dim.y/2;

		var pos = object.transform.loc;
		if (y_position > upper_limit || new_y_pos > upper_limit) {
			pos.set(pos.x, upper_limit, pos.z);
			object.transform.buildMatrix();
			speed = 0.0;
		} else if (y_position < lower_limit || new_y_pos < lower_limit) {
			pos.set(pos.x, lower_limit, pos.z);
			object.transform.buildMatrix();
			speed = 0.0;
		} else {
			object.transform.translate(0.0, speed, 0.0);
		} 
	}
}
