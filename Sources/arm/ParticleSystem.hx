package arm;

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
}

class ParticleSystem {

	public var state	:ParticleSystemState	= STAND_BY;
	public var visible	:Bool					= true;
	public var floor	:Float					= 0.7;

	var emit_x_l		:Float;
	var emit_x_r		:Float;
	var emit_y_b		:Float;
	var emit_y_t		:Float;
	var emit_z			:Float;
	var emit_dim_x		:Float;
	var emit_dim_y		:Float;

	var par_name		:String;
	var type			:ParticleType;
	var amount			:Int;

	var base_speed		:Float			= 0.05;
	var gravity			:Float			= 0.005;
	var frame_count		:Int			= 0;

	var particles		:Array<Object>	= [];
	var locations		:Array<Vec4>	= [];
	var speeds			:Array<Float>	= [];
	var angles			:Array<Float>	= [];
	var movement		:Array<Bool>	= [];

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
				var x = Random.getFloatIn(emit_x_l, emit_x_r);
				var y = Random.getFloatIn(emit_y_b, emit_y_t);
				locations.push(new Vec4(x, y, emit_z));
				switch type {
					case SPLASH_HORI:
						speeds.push(base_speed + Random.getFloatIn(-base_speed/2, base_speed));
						angles.push(((x - emit_x_l)/emit_dim_x) * 0.2 * Math.PI - 0.1 * Math.PI); 
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
			particles[i].transform.loc.setFrom(locations[i]);
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
	}

	public function update() {
		if (state == ONGOING) {
			state = FINISHED;
			for (i in 0...particles.length) {
				var p   = particles[i];
				// stop movement 
				if (p.transform.loc.y < floor) {
				 	movement[i] = false;
				} else {
					state = ONGOING;
				}
				if (movement[i] == true) {
					var ang = angles[i];
					var spd = speeds[i];
					// splash
					p.transform.loc.x += spd * Math.sin(ang);
					p.transform.loc.y += spd * Math.cos(ang);
					// gravity
					p.transform.loc.y -= gravity * frame_count;
					p.transform.buildMatrix();
				}

			}
			frame_count++;
		}
	}
}