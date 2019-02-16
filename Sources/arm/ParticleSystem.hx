package arm;

import iron.math.Vec2;
import iron.math.Vec4;
import kha.math.Random;
import iron.object.Object;
import iron.Scene;


@:enum abstract ParticleSystemState(Int) {
    var STAND_BY		= 0;
    var ONGOING			= 1;
    var FINISHED		= 2;
}

@:enum abstract ParticleType(Int) {
    var SPLASH_HORI		= 0;
    var SPLASH_VERT		= 1;
    var TRAIL			= 2;
}

class ParticleSystem {

    public var state		:ParticleSystemState	= STAND_BY;
    public var visible		:Bool					= true;
    public var floor		:Float					= 0.7;
    public var direction	:Bool					= false;
    public var trail_dir	:Vec2					= new Vec2();
    public var trail_stop	:Bool					= false;
    public var trail_loc	:Vec4					= new Vec4();
    public var speed_factor	:Float					= 1.0;
    public var offset		:Vec4					= new Vec4();
    public var gravity		:Float					= 0.005;

    var emit_x_l			:Float;
    var emit_x_r			:Float;
    var emit_y_b			:Float;
    var emit_y_t			:Float;
    var emit_z				:Float;
    var emit_dim_x			:Float;
    var emit_dim_y			:Float;

    var par_name			:String;
    var type				:ParticleType;
    var amount				:Int;

    var base_speed			:Float			= 0.05;

    var frame_count			:Int			= 0;

    var particles			:Array<Object>	= [];
    var locations			:Array<Vec4>	= [];
    var speeds				:Array<Float>	= [];
    var angles				:Array<Float>	= [];
    var movement			:Array<Bool>	= [];

    var trail_pointer		:Float;

    var init_completed	:Bool			= false;


    public function new(par_name:String, type:ParticleType, amount:Int, 
                        x_left:Float, x_right:Float, y_bot:Float, y_top:Float, z:Float) {
        emit_x_l	= x_left;
        emit_x_r	= x_right;
        emit_y_b	= y_bot;
        emit_y_t	= y_top;
        emit_z		= z;
        emit_dim_x	= emit_x_r - emit_x_l;
        emit_dim_y	= emit_y_t - emit_y_b;

        this.par_name	= par_name;
        this.type		= type;
        this.amount		= amount;
    }

    public function init() {
        if (init_completed)	return;

        for (i in 0...amount) {
            Scene.active.spawnObject(par_name, null, function(obj) {
                obj.transform.loc.set(0.0, -99999.0, 0.0);
                obj.transform.buildMatrix();
                var x:Float;
                var y:Float;
                if (type == SPLASH_HORI || type == SPLASH_VERT) {
                    x = Random.getFloatIn(emit_x_l, emit_x_r);
                    y = Random.getFloatIn(emit_y_b, emit_y_t);
                } else {
                    x = (emit_x_l + emit_x_r) * 0.5;
                    y = (emit_y_b + emit_y_t) * 0.5;
                }
                locations.push(new Vec4(x, y, emit_z));
                switch type {
                    case SPLASH_HORI:
                        speeds.push(base_speed + Random.getFloatIn(-base_speed/2, base_speed));
                        angles.push(((x - emit_x_l)/emit_dim_x) * 0.2 * Math.PI - 0.1 * Math.PI); 
                    case SPLASH_VERT:
                        speeds.push(base_speed + Random.getFloatIn(-base_speed/2, base_speed));
                        angles.push(((y - emit_y_b)/emit_dim_y) * 0.6 * Math.PI - 0.3 * Math.PI);
                    case TRAIL:
                }

                particles.push(obj);
            });
        }
        reset();
        state = STAND_BY;
        frame_count = 0;
        init_completed = true;
    }

    public function destroyParticles() {
        for (p in particles) {
            p.remove();
        }
        particles.splice(0, particles.length);
        locations.splice(0, locations.length);
        speeds   .splice(0, speeds   .length);
        angles   .splice(0, angles   .length);
    }

    public function play() {
        for (i in 0...amount) {
            particles[i].transform.loc.set(locations[i].x + offset.x, locations[i].y + offset.y, locations[i].z + offset.z);
            particles[i].transform.buildMatrix();
        }
        state = ONGOING;
    }

    public function setVisible(vis:Bool) {
        for (p in particles) {
            p.visible = vis;
        }
        visible = vis;
    }

    public function reset() {
        for (i in 0...amount) {
            particles[i].transform.loc.set(0.0, -99999.0, 0.0);
            particles[i].transform.buildMatrix();
            movement[i] = true;
        }
        frame_count = 0;
        state = STAND_BY;
        direction = false;
        offset.set(0.0, 0.0, 0.0);
        speed_factor = 1.0;
        trail_dir.set(0.0, 0.0);
        trail_stop = false;
        trail_pointer = 0;
        trail_loc.set(0.0, 0.0, 0.0);
    }

    public function update() {
        if (state == ONGOING) {
            state = FINISHED;
            for (i in 0...particles.length) {
                var p   = particles[i];
                if (type == SPLASH_HORI || type == SPLASH_VERT) {
                    // stop movement 
                    if (p.transform.loc.y < floor) {
                        movement[i] = false;
                    } else {
                        state = ONGOING;
                    }
                } else if (type == TRAIL) {
                    if (!trail_stop)	state = ONGOING;
                }
                if (movement[i] == true) {
                    var ang = angles[i];
                    var spd = speeds[i];
                    // splash
                    switch type {
                        case SPLASH_HORI:
                            p.transform.loc.x += spd * speed_factor * Math.sin(ang);
                            p.transform.loc.y += spd * speed_factor * Math.cos(ang);
                        case SPLASH_VERT:
                            p.transform.loc.y += spd * speed_factor * Math.sin(ang);
                            if (direction)	p.transform.loc.x += spd * speed_factor * Math.cos(ang);
                            else 			p.transform.loc.x += spd * speed_factor * -Math.cos(ang);
                        case TRAIL:
                            if (i == trail_pointer) {
                                p.transform.loc.setFrom(trail_loc);
                                p.transform.scale.set(1.0, 1.0, 1.0);
                            } else {
                                p.transform.scale.mult(0.91);
                            }
                    }
                    // gravity
                    if (type != TRAIL) {
                        p.transform.loc.y -= gravity * frame_count;
                    }
                    p.transform.buildMatrix();
                }

            }
            frame_count++;
            if (trail_pointer + 0.5 > amount - 0.5) {
                trail_pointer = 0.0;
            } else {
                trail_pointer += 0.5;
            }
        }
    }
}