package arm;

import iron.system.Input;

class PlayerInput {
	
	static public var key_up_1			:Bool;
	static public var key_down_1		:Bool;
	static public var key_up_2			:Bool;
	static public var key_down_2		:Bool;
	static public var confirm			:Bool;
	static public var menu				:Bool;
	static public var up				:Bool;
	static public var down				:Bool;

	static var keyboard					:Keyboard;				// keybord reference	
	static var init_completed			:Bool		= false;	// init completed?
	static var timer_escape				:Timer;
	static var timer_confirm			:Timer;
	static var timer_direction			:Timer;

	/**
	* Input initialization
	*/
	static function init() {
		if (keyboard == null)	keyboard	= Input.getKeyboard();
		timer_escape    = new Timer(0.2);
		timer_confirm   = new Timer(0.2);
		timer_direction = new Timer(0.15);

		init_completed = true;
	}

	static public function update() {
		if (!init_completed) init();

		timer_escape.update();
		timer_confirm.update();
		timer_direction.update();

		key_up_1		= keyboard.down("w");
		key_down_1		= keyboard.down("s"); 
		key_up_2		= keyboard.down("up");
		key_down_2		= keyboard.down("down"); 

		if (!timer_direction.isRunning()) {
			up   = key_up_1   || key_up_2  ;
			down = key_down_1 || key_down_2;
			if (up || down) {
				timer_direction.reset();
				timer_direction.start();
			}
		} else {
			up   = false;
			down = false;
		}		

		var enter		= keyboard.down("enter");
		if (!timer_confirm.isRunning()) {
			confirm = enter;
			if (confirm) {
				timer_confirm.reset();
				timer_confirm.start();
			}
		} else {
			confirm = false;
		}

		var escape 		= keyboard.down("escape");
		if (!timer_escape.isRunning()) {
			menu = escape;
			if (menu) {
				timer_escape.reset();
				timer_escape.start();
			}
		} else {
			menu = false;
		}

	}

}