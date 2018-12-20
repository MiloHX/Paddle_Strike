package arm;

import iron.math.Vec4;
import iron.object.Object;
import iron.Scene;
import kha.FastFloat;

import iron.Trait;

class PlayerTrait extends Trait {

	var system				:SystemTrait;

	public var player_ID	:Int;
	public var visual		:Object;
	public var hitbox_x1	:FastFloat;
	public var hitbox_x2	:FastFloat;
	public var hithox_y1	:FastFloat;
	public var hitbox_y2	:FastFloat;
	public var speed		:FastFloat = 0.0;

	public var indicator	:MeshText;
	var timer				:Timer;

	public var amplitude	:Float			= 0.04;
	var cur_amp				:Float;
	var vib_prog			:Float			= 0.2;
	var ani_playing			:Bool			= false;

	public function new() {
		super();

		notifyOnInit(function() {
			system = Scene.active.getTrait(SystemTrait);
			if (object.transform.worldx() < 0) {
				system.registerPlayer(this, 0);
				player_ID = 0;
			} else {
				system.registerPlayer(this, 1);
				player_ID = 1;				
			}
			visual = Scene.active.getMesh("player_visual_" + player_ID);
			if (player_ID == 0) {
				indicator = new MeshText("...PLAYER 1", 
										visual.transform.loc.clone().add(new Vec4(0.1, 0.24, 0)), 
										0.2, 0.5, "MTR_indicator");
			} else if (player_ID == 1) {
				indicator = new MeshText("PLAYER 2...", 
										visual.transform.loc.clone().add(new Vec4(-1.1, 0.24, 0)),  
										0.2, 0.5, "MTR_indicator");
			}

			if (indicator != null) {
				indicator.addAnimation(ROLLING, true);
			}
			timer  = new Timer(2.0);

			reset();
		});

		notifyOnUpdate(function() {
			if (system.game_state == IN_GAME) {
				timer.update();
				updateHitbox();
				updateVisual();
				updateHitAnimation();
				updateIndicator();
				getPlayerSpeed();
				if (speed != 0.0) movePlayer();
			}
		});
	}

	public function setVisible(vis:Bool) {
		visual.visible	= vis;
		if (player_ID == 1 && system.game_type != TWO_PLAYER) {
			indicator.setVisible(false);
		} else if (player_ID == 0 && system.game_type == CPU_VS_CPU) {
			indicator.setVisible(false);
		} else {
			indicator.setVisible(vis);
		}
	}

	public function reset() {
		speed = 0.0;
		var pos = object.transform.loc;
		object.transform.loc.set(pos.x, 0.0, pos.y);
		object.transform.buildMatrix();
		cur_amp = amplitude;
		ani_playing = false;
		indicator.resetAnimations();
		if (player_ID == 1 && system.game_type != TWO_PLAYER) {
			indicator.setVisible(false);
		} else if (player_ID == 0 && system.game_type == CPU_VS_CPU) {
			indicator.setVisible(false);
		} else {
			indicator.setVisible(true);
		}
		timer.reset();
	}

	public function start() {
		timer.start();
		if (indicator != null)	indicator.playAnimations();
	}

	function updateVisual() {
		if (!ani_playing) {
			visual.transform.loc.setFrom(object.transform.loc);
			visual.transform.buildMatrix();
		}
	}

	function updateHitbox() {
		hitbox_x1 = object.transform.worldx() - object.transform.dim.x/2 - 0.02;
		hitbox_x2 = object.transform.worldx() + object.transform.dim.x/2 + 0.02;
		hithox_y1 = object.transform.worldy() - object.transform.dim.y/2 - 0.1;
		hitbox_y2 = object.transform.worldy() + object.transform.dim.y/2 + 0.1;
	}

	function updateIndicator() {
		if (player_ID == 1 && system.game_type != TWO_PLAYER) {
			
		} else if (player_ID == 0 && system.game_type == CPU_VS_CPU) {

		} else {
			if (timer.isRunning()) {
				if (player_ID == 0) {
					indicator.updateTransform(visual.transform.loc.clone().add(new Vec4( 0.1, 0.24, 0)));
				} else {
					indicator.updateTransform(visual.transform.loc.clone().add(new Vec4(-1.1, 0.24, 0)));
				}
				indicator.updateAnimations();
			} else {
				indicator.setVisible(false);
			}
		}
	}

	function getPlayerSpeed() {
		var key_pressed:Bool = false;
		if (system.winner_ID != -1)	{
			speed = 0.0;
			return;
		}
		switch player_ID {
			case 0:	
				if (system.game_type == TWO_PLAYER) {
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
				} else if (system.game_type == ONE_PLAYER) {
					if (PlayerInput.key_up_1 || PlayerInput.key_up_2)	{
						if (speed < 0.0) {
							speed = 0.0;
						} else {
							speed = speed > 0.1 ? speed : speed += 0.025;
						}
						key_pressed = true;
					}
					if (PlayerInput.key_down_1 || PlayerInput.key_down_2)	{
						if (speed > 0.0) {
							speed = 0.0;
						} else {
							speed = speed < -0.1 ? speed : speed -= 0.025;
						}
						key_pressed = true;
					}					
				} else if (system.game_type == CPU_VS_CPU) {
					if (ComputerAIP1.up)	{
						if (speed < 0.0) {
							speed = 0.0;
						} else {
							speed = speed > 0.1 ? speed : speed += 0.025;
						}
						key_pressed = true;
					}
					if (ComputerAIP1.down)	{
						if (speed > 0.0) {
							speed = 0.0;
						} else {
							speed = speed < -0.1 ? speed : speed -= 0.025;
						}
						key_pressed = true;
					}						
				}
			case 1:	
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
				} else if (system.game_type == ONE_PLAYER || system.game_type == CPU_VS_CPU)  {
					if (ComputerAIP2.up)	{
						if (speed < 0.0) {
							speed = 0.0;
						} else {
							speed = speed > 0.1 ? speed : speed += 0.025;
						}
						key_pressed = true;
					}
					if (ComputerAIP2.down)	{
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

	public function updateHitAnimation() {
		if (ani_playing) {
			if (cur_amp > 0.001) {
				visual.transform.loc.x = object.transform.loc.x + cur_amp * Math.sin(50 * UserInterface.t);
				visual.transform.loc.y = object.transform.loc.y + cur_amp * Math.sin(20 * UserInterface.t);
				visual.transform.buildMatrix();
				cur_amp = Utilities.lerpFloat(cur_amp, 0.0, vib_prog);
			} else {
				ani_playing = false;
			}
		}
	}

	public function playHitAnimation(speed:Float) {
		cur_amp = amplitude * speed * 10;
		ani_playing = true;
	}
}
