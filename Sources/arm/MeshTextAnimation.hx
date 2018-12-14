package arm;

import iron.Scene;
import iron.object.CameraObject;
import kha.math.Random;
import iron.math.Quat;
import iron.math.Vec4;

@:enum abstract AnimationType(Int) {
	var DROP_IN			= 0;
	var ROLLING			= 1;
	var VIBERATING		= 2;
	var SCALING_DOWN	= 3;
}

@:enum abstract AnimationState(Int) {
	var STAND_BY	= 0;
	var PLAYING		= 1;
	var FINISHED	= 2;
}

class MeshTextAnimation {

	public var mesh_text		:MeshText;

	public var type				:AnimationType;
	public var state			:AnimationState = STAND_BY;
	public var loop				:Bool			= false;
	public var phase			:Int			= 0;
	public var init_height		:Float			= 0.0;
	public var speed_factor		:Float;
	public var par_sys			:ParticleSystem;
	public var x_leftmost		:Float;
	public var x_rightmost		:Float;
	public var y_bottom			:Float;
	public var z_level			:Float;
	public var shake			:Float;
	public var rolling_interval	:Float			= 3.0;
	public var rolling_speed	:Float			= Math.PI/5;
	public var rolling_delay	:Int			= 3;

	var system					:SystemTrait;
	var camera					:CameraObject;
	var camera_orig_loc			:Vec4;
	var mesh_orig_loc			:Array<Vec4>	= [];
	var mesh_orig_rot			:Array<Quat>	= [];
	var mesh_orig_scl			:Array<Vec4>	= [];

	var timer					:Timer;
	var total_angles			:Array<Float>	= [];
	var rolling_delay_frames	:Array<Int>		= [];

	public var vib_hori			:Bool			= true;
	public var vib_vert			:Bool			= false;
	public var vib_rate			:Float			= 0.2;
	public var amplitude		:Float			= 0.06;
	var cur_amp					:Float;

	public var init_scale		:Float			= 2.0;
	public var scaling_rate		:Float			= 0.1;
	var cur_scale				:Float;



	public function new(mesh_text:MeshText, anim_type:AnimationType, loop:Bool = false) {
		this.mesh_text	= mesh_text;
		this.type		= anim_type;
		this.loop		= loop;

		camera			= Scene.active.camera;
		camera_orig_loc = camera.transform.loc.clone();

		init();
	}

	public function init() {

		// save original loc/rot/scale
		updateMeshText(mesh_text);

		switch type {
			case DROP_IN:
				var offset = 0.0;
				speed_factor  = 0.15;
				for (m in mesh_text.meshes) {
					offset = m.transform.dim.y/2 > offset ? m.transform.dim.y/2 : offset;
				}
				init_height = 2.7 + offset;
				var floor:Float = -10.0;
				if (par_sys != null) {
					floor = par_sys.floor;
					par_sys.destroyParticles();
				}
				par_sys = new ParticleSystem("particle", SPLASH_HORI, 200, x_leftmost, x_rightmost, y_bottom, y_bottom, z_level);
				if (floor > -10)	par_sys.floor = floor;
				par_sys.init();
			case ROLLING:
				if (timer == null) {
					timer = new Timer(rolling_interval, true);
				}
			case VIBERATING:
			case SCALING_DOWN:

		}
		reset();
	}

	public function reset() {
		switch type {
			case DROP_IN:
				for (m in mesh_text.meshes) {
					m.transform.loc.y = init_height;
					m.transform.buildMatrix();
				}
				phase = 0;
				shake = 0.1;
				camera.transform.loc.setFrom(camera_orig_loc);
				camera.transform.buildMatrix();
			case ROLLING:
				timer.reset();
				for (i in 0...mesh_text.meshes.length) {
					mesh_text.meshes[i].transform.rot.setFrom(mesh_orig_rot[i]);
					mesh_text.meshes[i].transform.buildMatrix();
					total_angles[i] = 0.0;
					rolling_delay_frames[i] = i*rolling_delay;
				}
			case VIBERATING:
				cur_amp   = amplitude;
			case SCALING_DOWN:
				cur_scale = init_scale;

		}
		state = STAND_BY;

	}

	public function update() {
		if (state == PLAYING) {
			switch type {
				case DROP_IN:

					switch phase {
						case 0:
							if (par_sys != null) {
								if (par_sys.state != STAND_BY) {
									par_sys.reset();
								}
							}
							// droping
							for (i in 0...mesh_text.meshes.length) {
								var cur_height = mesh_text.meshes[i].transform.loc.y;
								var tgt_height = mesh_orig_loc[i].y;
								var speed = Math.sqrt((init_height - cur_height) / (init_height - tgt_height)) * speed_factor;
								speed = speed > 0.0 ? speed : 0.05;
								var nxt_height = cur_height - speed;
								if (nxt_height < tgt_height) {
									nxt_height = tgt_height;
									phase = 1;
								} else {
									phase = 0;
								}
								mesh_text.meshes[i].transform.loc.y = nxt_height;
								mesh_text.meshes[i].transform.buildMatrix();
							}
						case 1:
							// particle effect
							var par_sys_ongoing:Bool = false;
							if (par_sys != null) {
								par_sys_ongoing = true;
								if (par_sys.state == STAND_BY) {
									par_sys.play();
								} else if (par_sys.state == ONGOING) {
									par_sys.update();
								} else if (par_sys.state == FINISHED) {
									par_sys_ongoing = false;
								}
							} else {
								par_sys_ongoing = false;
							}
							// camera shake
							var shake_ongoing:Bool = false;
							if (shake > 0.0) {
								shake_ongoing = true;
								camera.transform.loc.set(camera_orig_loc.x+Random.getFloatIn(-shake, shake),
														camera_orig_loc.y+Random.getFloatIn(-shake, shake),
														camera.transform.loc.z);
								camera.transform.buildMatrix();
								shake -= 0.005;								
							} else {
								camera.transform.loc.setFrom(camera_orig_loc);
								camera.transform.buildMatrix();
								shake_ongoing = false;
							}
							
							if (!par_sys_ongoing && !shake_ongoing) {
								state = FINISHED;
							}
					}

				case ROLLING:
					if (timer.update()) {
						state = FINISHED;
					}
					for (i in 0...mesh_text.meshes.length) {
						if (total_angles[i] < Math.PI *2) {
							if (rolling_delay_frames[i] == 0) {
								var m     = mesh_text.meshes[i];
								var speed = rolling_speed;
								total_angles[i] += speed;
								if (total_angles[i] >= Math.PI *2) {
									m.transform.rot.setFrom(mesh_orig_rot[i]);
									m.transform.buildMatrix();
								} else {
									m.transform.rotate(Vec4.yAxis(), speed);
								}
							} else {
								rolling_delay_frames[i]--;
							}
						}
					}
				case VIBERATING:
					if (cur_amp > 0.001) {
						for (i in 0...mesh_text.meshes.length) {
							if (vib_hori) {
								mesh_text.meshes[i].transform.loc.x = mesh_orig_loc[i].x + cur_amp * Math.sin(20 * UserInterface.t);
							}
							if (vib_vert) {
								mesh_text.meshes[i].transform.loc.y = mesh_orig_loc[i].y + cur_amp * Math.sin(31 * UserInterface.t);
							}
							mesh_text.meshes[i].transform.buildMatrix();
						}
						cur_amp = Utilities.lerpFloat(cur_amp, 0.0, vib_rate);			
					} else {
						cur_amp = 0.0;
						for (i in 0...mesh_text.meshes.length) {
							mesh_text.meshes[i].transform.loc.setFrom(mesh_orig_loc[i]);
							mesh_text.meshes[i].transform.buildMatrix();
						}
						state = FINISHED;
					}
				case SCALING_DOWN:
					if (cur_scale > 1.01) {
						for (i in 0...mesh_text.meshes.length) {
							mesh_text.meshes[i].transform.scale.x = mesh_orig_scl[i].x * cur_scale;
							mesh_text.meshes[i].transform.scale.y = mesh_orig_scl[i].y * cur_scale;
							mesh_text.meshes[i].transform.loc.x	  = mesh_orig_loc[i].x + 
																	i * mesh_text.width  * (cur_scale - 1.0);
							mesh_text.meshes[i].transform.buildMatrix();
						}
						cur_scale = Utilities.lerpFloat(cur_scale, 1.0, scaling_rate);
					} else {
						cur_scale = 1.0;
						for (i in 0...mesh_text.meshes.length) {
							mesh_text.meshes[i].transform.scale.setFrom(mesh_orig_scl[i]);
							mesh_text.meshes[i].transform.buildMatrix();
							mesh_text.meshes[i].transform.loc.x	= mesh_orig_loc[i].x;
						}
						state = FINISHED;				
					}


					
			}
		} else if (state == FINISHED) {
			if (loop) {
				reset();
				play();
			}
		}
	}

	public function play() {
		state = PLAYING;
		switch type {
			case DROP_IN:
			case ROLLING:
				timer.start();
			case VIBERATING:
			case SCALING_DOWN:
		}
	}

	public function stop() {
		for (i in 0...mesh_text.meshes.length) {
			mesh_text.meshes[i].transform.loc  .setFrom(mesh_orig_loc[i]);
			mesh_text.meshes[i].transform.rot  .setFrom(mesh_orig_rot[i]);
			mesh_text.meshes[i].transform.scale.setFrom(mesh_orig_scl[i]);
			mesh_text.meshes[i].transform.buildMatrix();
		}
		state = FINISHED;
	}

	public function updateMeshText(?new_mesh_text:MeshText) {
		if (new_mesh_text != null)	mesh_text = new_mesh_text;

		mesh_orig_loc.splice(0, mesh_orig_loc.length);
		mesh_orig_rot.splice(0, mesh_orig_rot.length);
		mesh_orig_scl.splice(0, mesh_orig_scl.length);

		for (i in 0...mesh_text.meshes.length) {
			var m = mesh_text.meshes[i];

			if (i == 0) {
				x_leftmost = m.transform.worldx() - m.transform.dim.x/2;
				y_bottom   = m.transform.worldy() - m.transform.dim.y/2;
				z_level    = m.transform.worldz();
			} 
			if (i == mesh_text.meshes.length - 1) {
				x_rightmost = m.transform.worldx() + m.transform.dim.x/2;
			}

			mesh_orig_loc.push(m.transform.loc.clone());
			mesh_orig_rot.push(new Quat().setFrom(m.transform.rot));
			mesh_orig_scl.push(m.transform.scale.clone());
		}

		switch type {
			case DROP_IN:
			case ROLLING:
				total_angles.splice(0, total_angles.length);
				rolling_delay_frames.splice(0, rolling_delay_frames.length);
				for (i in 0...mesh_text.meshes.length) {
					total_angles.push(0.0);
				}
				for (i in 0...mesh_text.meshes.length) {
					rolling_delay_frames.push(i*rolling_delay);
				}
			case VIBERATING:
			case SCALING_DOWN:
		}
	}
}