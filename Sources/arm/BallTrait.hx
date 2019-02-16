package arm;

import kha.math.Random;
import iron.Scene;
import iron.math.Vec2;
import iron.math.Math;

class BallTrait extends iron.Trait {

    public var init_speed	:Float			= 0.05;
    public var speed_factor	:Float			= 0.20;
    public var speed_limit	:Float			= 0.075;
    public var kickoff		:Bool			= false;
    public var par_sys		:ParticleSystem;
    public var trail		:ParticleSystem;

    var system				:SystemTrait;
    var speedup				:Bool			= false;
    var timer				:Timer;
    var start_scale			:Float			= 4.0;
    var cool_down_timer		:Timer;
    var cool_down_time 		:Float			= 0.2;

    public var hit_player	:Int			= -1;
    public var hit_wall		:Bool			= false;

    public var direction	:Vec2 			= new Vec2();
    public var speed		:Float;


    public function new() {
        super();

        notifyOnInit(function() {
            system	= Scene.active.getTrait(SystemTrait);
            system.registerBall(this);
            timer = new Timer(1.5);
            cool_down_timer = new Timer(cool_down_time);
            par_sys = new ParticleSystem("particle", SPLASH_VERT, 20, -object.transform.dim.x/2, 
                                                                       object.transform.dim.x/2, 
                                                                      -object.transform.dim.y/2, 
                                                                       object.transform.dim.y/2,
                                                                       object.transform.loc.z);
            par_sys.floor   = -2.7;
            par_sys.gravity = 0.002;
            par_sys.init();

            trail = new ParticleSystem("trail", TRAIL, 8,  -object.transform.dim.x/2, 
                                                            object.transform.dim.x/2, 
                                                           -object.transform.dim.y/2, 
                                                            object.transform.dim.y/2,
                                                            object.transform.loc.z);
            trail.init();

            reset();
        });

        notifyOnLateUpdate(function() {
            if (system.game_state == IN_GAME) {
                if (kickoff) {
                    cool_down_timer.update();
                    var delta_x =  direction.x * speed;
                    var delta_y =  direction.y * speed;
                    collisionDetection(new Vec2(delta_x, delta_y));
                    object.transform.translate(delta_x, delta_y, 0.0);

                    // score
                    if (object.transform.worldx() > 3.3) {
                        system.socre(0);
                        reset(true);
                    } else if (object.transform.worldx() < -3.3) {
                        system.socre(1);
                        reset(true);
                    }
                } else {
                    if(timer.update()) {
                        kickoff = true;
                        SoundPlayer.play(KICK_OFF);
                    } else {
                        var new_scale = 1 + (start_scale - 1) * (timer.time_remain / timer.time_duration);
                        object.transform.scale.set(new_scale, new_scale, new_scale);
                        object.transform.buildMatrix();
                    }
                }
                playHitEffect();
                playTrailEffect();
            }
        });

    }

    public function setVisible(vis:Bool) {
        object.visible = vis;
        par_sys.setVisible(vis);
        trail.setVisible(vis);
    }

    public function reset(score:Bool = false) {
        var pos = object.transform.loc;
        object.transform.loc.set(0.0, 0.0, pos.z);
        object.transform.scale.set(start_scale, start_scale, start_scale);
        object.transform.buildMatrix();
        speed = init_speed;
        var angle = Random.getFloatIn(-Math.PI_2*0.8, Math.PI_2*0.8);
        if (Random.get() % 2 == 1) angle += Math.PI;
        direction.setFrom(Utilities.rotateVec2(Vec2.xAxis(), angle));
        kickoff = false;
        timer.reset();
        timer.start();
        cool_down_timer.reset();
        if (!score) par_sys.reset();
        hit_player = -1;
        hit_wall   = false;
    }

    function collisionDetection(v:Vec2):Bool {
        var result = false;
        var no_speedup_case = false;

        var x_pos = object.transform.worldx() + v.x;
        var y_pos = object.transform.worldy() + v.y;

        speedup = false;
        hit_player = -1;
        hit_wall   = false;

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
                hit_wall = true;
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
                hit_wall = true;
            }
        }
        if (result == true)	return result;
        

        // players

        if (cool_down_timer.isRunning()) {
            return false;
        }

        var x_1 = x_pos - object.transform.dim.x/2;
        var x_2 = x_pos + object.transform.dim.x/2;
        var y_1 = y_pos - object.transform.dim.y/2;
        var y_2 = y_pos + object.transform.dim.y/2;
        for (i in 0...system.players.length) {
            var p = system.players[i];
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
                        if (system.players[i].speed > 0) {
                            direction.setFrom(o_reflect);
                        } else {
                            direction.setFrom(x_reflect);
                        }
                    // upwards
                    } else {
                        if (system.players[i].speed < 0) {
                            direction.setFrom(o_reflect);
                        } else {
                            direction.setFrom(x_reflect);
                        }
                    }
                    addRandomness();
                    if (!no_speedup_case)	increaseSpeed(i);
                    result = true;	
                } else if (p.player_ID == 1) {
                    direction.setFrom(x_reflect);
                    addRandomness();
                    increaseSpeed(i);
                    result = true;	
                }
            // normal cases right
            } else if (!left_x_in && right_x_in && lower_y_in && upper_y_in) {
                if (v.x > 0) {
                    // downwards
                    if(v.y < 0) {
                        if (system.players[i].speed > 0) {
                            direction.setFrom(o_reflect);
                        } else {
                            direction.setFrom(x_reflect);
                        }
                    // upwards
                    } else {
                        if (system.players[i].speed < 0) {
                            direction.setFrom(o_reflect);
                        } else {
                            direction.setFrom(x_reflect);
                        }
                    }
                    addRandomness();
                    if (!no_speedup_case)	increaseSpeed(i);			
                    result = true;	
                } else if (p.player_ID == 0) {
                    direction.setFrom(x_reflect);
                    addRandomness();
                    increaseSpeed(i);
                    result = true;	
                }
            // normal cases up
            } else if (left_x_in && right_x_in && lower_y_in && !upper_y_in) {
                if (v.y < 0) {
                    // downwards
                    direction.setFrom(y_reflect);
                    if (system.players[i].speed < 0)	no_speedup_case = true;
                } else {
                    // upwards
                    direction.setFrom(x_reflect);
                    if (system.players[i].speed > 0) 	no_speedup_case = true;
                }
                addRandomness();
                if (!no_speedup_case)	increaseSpeed(i);
                result = true;	
            // normal cases down
            } else if (left_x_in && right_x_in && !lower_y_in && upper_y_in) {
                if (v.y < 0) {
                    // downwards
                    direction.setFrom(x_reflect);
                    if (system.players[i].speed < 0)	no_speedup_case = true;
                } else {
                    // upwards
                    direction.setFrom(y_reflect);
                    if (system.players[i].speed > 0) 	no_speedup_case = true;
                }
                addRandomness();
                if (!no_speedup_case)	increaseSpeed(i);
                result = true;					
            // all inside, refelect
            } else if (left_x_in && right_x_in && lower_y_in && upper_y_in) {
                direction.setFrom(x_reflect);
                result = true;	
            // ball lower left corner
            } else if (left_x_in && !right_x_in && lower_y_in && !upper_y_in) {
                var x_depth = p_x_2 - x_1;
                var y_depth = p_y_2 - y_1;
                if (v.x < 0) {
                    // downwards
                    if(v.y < 0) {
                        var angle = x_angle * (x_depth/(x_depth + y_depth)) + y_angle * (y_depth/ (x_depth + y_depth));
                        direction.setFrom(Utilities.rotateVec2(direction, angle));
                        if (system.players[i].speed < 0) {
                            no_speedup_case = true;
                        }
                    // upwards
                    } else {
                        direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));
                        no_speedup_case = true;			
                    }
                } else {
                    // downwards
                    if(v.y < 0) {
                        direction.setFrom(Utilities.rotateVec2(direction, y_angle * (y_depth / object.transform.dim.y)));
                        no_speedup_case = true;
                    // upwards
                    } else {
                        direction.setFrom(x_reflect);
                        if (system.players[i].speed < 0) {
                            no_speedup_case = true;
                        }							
                    }				
                }
                    
                if (!no_speedup_case)	increaseSpeed(i);
                result = true;
    
            // ball upper left corner
            } else if (left_x_in && !right_x_in && !lower_y_in && upper_y_in) {
                var x_depth = p_x_2 - x_1;
                var y_depth = y_2 - p_y_1;
                if (v.x < 0) {
                    // downwards
                    if(v.y < 0) {
                        direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));
                        no_speedup_case = true;							
                    // upwards
                    } else{
                        var angle = x_angle * (x_depth/(x_depth + y_depth)) + y_angle * (y_depth/(x_depth + y_depth));
                        direction.setFrom(Utilities.rotateVec2(direction, angle));
                        if (system.players[i].speed > 0) {
                            no_speedup_case = true;
                        }
                    }
                } else {
                    // downwards
                    if(v.y < 0) {
                        direction.setFrom(x_reflect);
                        if (system.players[i].speed > 0) {
                            no_speedup_case = true;
                        }
                    // upwards
                    } else {
                        direction.setFrom(Utilities.rotateVec2(direction, y_angle * (y_depth / object.transform.dim.y)));
                        no_speedup_case = true;									
                    }						
                }

                if (!no_speedup_case)	increaseSpeed(i);
                result = true;

            // ball lower right corner
            } else if (!left_x_in && right_x_in && lower_y_in && !upper_y_in) {
                var x_depth = x_2 - p_x_1;
                var y_depth = p_y_2 - y_1;
                if (v.x > 0) {
                    // downwards
                    if(v.y < 0) {
                        var angle = x_angle * (x_depth/(x_depth + y_depth)) + y_angle * (y_depth/(x_depth + y_depth));
                        direction.setFrom(Utilities.rotateVec2(direction, angle));
                        if (system.players[i].speed < 0) {
                            no_speedup_case = true;
                        }
                    // upwards
                    } else {
                        direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));
                        no_speedup_case = true;			
                    }
                } else {
                    // downwards
                    if(v.y < 0) {
                        direction.setFrom(Utilities.rotateVec2(direction, y_angle * (y_depth / object.transform.dim.y)));
                        no_speedup_case = true;	
                    // upwards
                    } else {
                        direction.setFrom(x_reflect);
                        if (system.players[i].speed < 0) {
                            no_speedup_case = true;
                        }	
                    }					
                }
                if (!no_speedup_case)	increaseSpeed(i);
                result = true;	
            // ball upper right corner
            } else if (!left_x_in && right_x_in && !lower_y_in && upper_y_in) {
                var x_depth = x_2 - p_x_1;
                var y_depth = y_2 - p_y_1;
                if (v.x > 0) {
                    // downwards
                    if(v.y < 0) {
                        direction.setFrom(Utilities.rotateVec2(direction, x_angle * (x_depth / object.transform.dim.x)));
                        no_speedup_case = true;							
                    // upwards
                    } else{
                        var angle = x_angle * (x_depth/ (x_depth + y_depth)) + y_angle * (y_depth/(x_depth + y_depth));
                        direction.setFrom(Utilities.rotateVec2(direction, angle));
                        if (system.players[i].speed > 0) {
                            no_speedup_case = true;
                        }	
                    }
                } else {
                    // downwards
                    if(v.y < 0) {
                        direction.setFrom(x_reflect);
                        if (system.players[i].speed > 0) {
                            no_speedup_case = true;
                        }								
                    // upwards
                    } else{
                        direction.setFrom(Utilities.rotateVec2(direction, y_angle * (y_depth / object.transform.dim.y)));
                        no_speedup_case = true;		
                    }
                }
                if (!no_speedup_case)	increaseSpeed(i);
                result = true;
            }

            if (result == true) {
                hit_player = i;
                system.players[i].playHitAnimation(speed);
                if ( speedup != true) {									
                    speed = speed < init_speed + 0.005 ? init_speed : speed - 0.005; // decrease speed
                }
                cool_down_timer.reset();
                cool_down_timer.start();
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

    function addRandomness() {
        direction.setFrom(Utilities.rotateVec2(direction, Random.getFloatIn(-Math.PI_4*0.2, Math.PI_4*0.2)));
    }

    function increaseSpeed(i) {
        if (system.players[i].speed != 0.0) {
            speed = speed > speed_limit ? speed : speed + Math.abs(system.players[i].speed)*speed_factor;
            speedup = true;
        }
    }

    public function playHitEffect() {
        var factor = Math.pow(speed * 7, 2);
        if (hit_player != -1) {
            par_sys.reset();
            if (hit_player == 0)	par_sys.direction = true;
            else 					par_sys.direction = false;
            par_sys.offset.setFrom(object.transform.loc);
            par_sys.speed_factor = factor;
            par_sys.play();
            if (hit_player == 0) {
                SoundPlayer.play(BALL_HIT_LEFT, Math.max(factor, 0.5));
            } else if (hit_player == 1) {
                SoundPlayer.play(BALL_HIT_RIGHT,  Math.max(factor, 0.5));				
            }
        } 

        if (hit_wall) {
            SoundPlayer.play(BALL_HIT_WALL,  Math.max(factor, 0.5));
        }
        par_sys.update();
        if (par_sys.state == FINISHED) {
            par_sys.reset();
        }
    }

    public function playTrailEffect() {
        if (trail.state != ONGOING) {
            trail.reset();
            trail.play();
        } 
        trail.trail_dir.setFrom(direction);
        trail.trail_loc.set(object.transform.loc.x, object.transform.loc.y, -2.0);
        trail.update();
    }
}
