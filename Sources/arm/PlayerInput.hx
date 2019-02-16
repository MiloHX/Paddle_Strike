package arm;

import iron.math.Vec2;
import iron.system.Input;

class PlayerInput {
    
    static public var key_up_1			:Bool;
    static public var key_down_1		:Bool;
    static public var key_up_2			:Bool;
    static public var key_down_2		:Bool;

    static public var key_left_1		:Bool;
    static public var key_right_1		:Bool;
    static public var key_left_2		:Bool;
    static public var key_right_2		:Bool;
    
    static public var confirm			:Bool;
    static public var menu				:Bool;
    static public var up				:Bool;
    static public var down				:Bool;
    static public var left				:Bool;
    static public var right				:Bool;

    static public var mouse_left		:Bool;
    static public var mouse_right		:Bool;
    static public var mouse_middle		:Bool;
    static public var mouse_pointer		:Vec2;
    static public var mouse_moved		:Bool;
    static public var mouse_y_speed		:Float;

    static var keyboard					:Keyboard;				// keybord reference
    static var mouse					:Mouse;	
    static var init_completed			:Bool		= false;	// init completed?
    static var timer_escape				:Timer;
    static var timer_confirm			:Timer;
    static var timer_direction			:Timer;

    /**
    * Input initialization
    */
    static function init() {
        if (keyboard == null)	keyboard	= Input.getKeyboard();
        if (mouse == null)		mouse		= Input.getMouse();
        mouse_pointer	= new Vec2();
        timer_escape    = new Timer(0.2);
        timer_confirm   = new Timer(0.2);
        timer_direction = new Timer(0.15);

        init_completed = true;
    }


    static public function update() {
        if (!init_completed) init();

        timer_escape   .update();
        timer_confirm  .update();
        timer_direction.update();

        mouse_pointer.x	= mouse.x;
        mouse_pointer.y	= mouse.y;
        mouse_moved = mouse.moved;
        mouse_y_speed = -mouse.movementY / 150;
        if (mouse.started("left"  ))	mouse_left   = true;
        else							mouse_left   = false;
        if (mouse.started("right" ))	mouse_right  = true;
        else							mouse_right  = false;
        if (mouse.started("middle"))	mouse_middle = true;
        else							mouse_middle = false;	
        

        key_up_1		= keyboard.down("w");
        key_down_1		= keyboard.down("s"); 
        key_up_2		= keyboard.down("up");
        key_down_2		= keyboard.down("down"); 

        key_left_1		= keyboard.down("a");
        key_right_1		= keyboard.down("d");
        key_left_2		= keyboard.down("left");
        key_right_2		= keyboard.down("right");

        if (!timer_direction.isRunning()) {
            up   = key_up_1   || key_up_2  ;
            down = key_down_1 || key_down_2;
            left = key_left_1 || key_left_2;
            right= key_right_1|| key_right_2;
            if (up || down || left || right) {
                timer_direction.reset();
                timer_direction.start();
            }
        } else {
            up   = false;
            down = false;
            left = false;
            right= false;
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