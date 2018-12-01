package arm;

import iron.system.Input;

class PlayerInput {
	
	static public var key_up_1			:Bool;
	static public var key_down_1		:Bool;
	static public var key_up_2			:Bool;
	static public var key_down_2		:Bool;
	static public var menu				:Bool;

	static var keyboard					:Keyboard;				// keybord reference	
	static var init_completed			:Bool		= false;	// init completed?
	static var timer					:Timer;

	/**
	* Input initialization
	*/
	static function init() {
		if (keyboard == null)	keyboard	= Input.getKeyboard();
		timer = new Timer(0.3);
		init_completed = true;
	}

	static public function update() {
		if (!init_completed) init();

		timer.update();

		key_up_1		= keyboard.down("w");
		key_down_1		= keyboard.down("s"); 
		key_up_2		= keyboard.down("up");
		key_down_2		= keyboard.down("down"); 

		var escape 		= keyboard.down("escape");
		if (!timer.isRunning()) {
			menu = escape;
			if (menu) {
				timer.reset();
				timer.start();
			}
		} else {
			menu = false;
		}

	}

}