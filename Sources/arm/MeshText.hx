package arm;

import iron.App;
import haxe.ds.Vector;
import iron.object.MeshObject;
import iron.Scene;
import iron.math.Vec4;
import iron.data.Data;
import iron.data.MaterialData;
import arm.MeshTextAnimation;

class MeshText {
	
	public var text			:String;
	public var material		:String;
	public var mesh_names	:Array<String>				= [];
	public var meshes		:Array<MeshObject>			= [];
	public var position		:Vec4;
	public var width		:Float;
	public var scale		:Float;
	public var animations	:Array<MeshTextAnimation>	= [];
	public var selectable	:Bool						= false;
	public var visible		:Bool						= true;
	public var area_x_l		:Float						= 0.0;
	public var area_x_r		:Float						= 0.0;
	public var area_y_b		:Float						= 0.0;
	public var area_y_t		:Float						= 0.0;
	public var window_w		:Float						= 0.0;
	public var window_h		:Float						= 0.0;		

	public function new(text:String, position:Vec4, scale:Float=1.0, width:Float=0.45, material:String = "", selectable:Bool=false) {
		this.text		= text.toUpperCase();
		this.scale		= scale;
		this.position	= position;
		this.width		= width;
		this.material	= material;
		this.selectable	= selectable;
		window_w = App.w();
		window_h = App.h();
		constructMeshes(material);
	}

	function constructMeshes(material_name:String="") {
		var name:String = "";
		for (i in 0...text.length) {
			var char = text.charAt(i);
			if (char != " ") {
				if (char == "!" ) {
					name = "Text_Exc";
				} else if (char == "?") {
					name = "Text_Que";
				} else if (char == "$") {
					name = "Text_Dol";
				} else if (char == "\"") {
					name = "Text_Dqu";
				} else if (char == ",") {
					name = "Text_Com";
				} else if (char == ".") {
					name = "Text_Fst";
				} else if (char == ";") {
					name = "Text_Sco";
				} else if (char == ":") {
					name = "Text_Col";
				} else {
					name = "Text_" + char;
				}
			} else {
				name = "Text_Emp";
			}
			mesh_names.push(name);
		}

		var pos = position.clone();
		for (mesh_name in mesh_names) {
			if (mesh_name != "Text_Emp") {
				Scene.active.spawnObject(mesh_name, null, function(obj) {
					var msh_obj = cast (obj, MeshObject);
					msh_obj.transform.scale.set(scale, scale, scale);
					msh_obj.transform.loc.setFrom(pos);
					msh_obj.transform.buildMatrix();
					if (material_name != "") {
						var msh_mtr:Vector<MaterialData>;
						Data.getMaterial(Scene.active.raw.name, material_name, function(mat_d:MaterialData){
							msh_mtr = Vector.fromData([mat_d]);
						});
						msh_obj.materials = msh_mtr;
					}
					meshes.push(msh_obj);
				});
			}
			pos.x += width*scale;
		}
		for (a in animations) {
			a.init();
		}
		if (selectable) {
			area_x_l = ((meshes[0].transform.loc.x - meshes[0].transform.dim.x/2 + 3.4 ) / 6.8) * window_w;
			area_x_r = ((meshes[meshes.length-1].transform.loc.x + meshes[meshes.length-1].transform.dim.x/2 + 3.4) / 6.8) * window_w;
			area_y_b = ((-meshes[0].transform.loc.y - meshes[0].transform.dim.y/2 + 2.55) / 5.1) * window_h;
			area_y_t = ((-meshes[0].transform.loc.y + meshes[0].transform.dim.y/2 + 2.55) / 5.1) * window_h;
		}
	}

	public function checkHovered():Bool {
		if (!selectable || !visible)	return false;

		if (PlayerInput.mouse_pointer.x > area_x_l && PlayerInput.mouse_pointer.x < area_x_r &&
			PlayerInput.mouse_pointer.y > area_y_b && PlayerInput.mouse_pointer.y < area_y_t) {
			return true;
		} else {
			return false;
		}
	}

	function destroyMeshes() {
		for (mesh in meshes) {
			mesh.remove();
		}
		meshes.splice(0, meshes.length);
		mesh_names.splice(0, mesh_names.length);
	}

	public function addAnimation(anim_type:AnimationType, loop:Bool = false) {
		animations.push(new MeshTextAnimation(this, anim_type, loop));
	}

	public function resetAnimations() {
		if (animations.length > 0)	{
			for (a in animations) a.reset();
		}
	}

	public function updateAnimations() {
		if (animations.length > 0)	{
			for (a in animations) a.update();
		}
	}

	public function playAnimations() {
		for (a in animations) {
			if (a.state != PLAYING && a.state != FINISHED) {
				a.play();
			}
		}
	}

	public function updateMeshes(text:String, ?position:Vec4, ?scale:Float, ?width:Float, ?material:String) {
		destroyMeshes();
		this.text		= text;
		if (position != null)	this.position	= position;	
		if (scale    != null)	this.scale		= scale;
		if (width    != null)	this.width		= width;	
		if (material != null)	this.material	= material;
		constructMeshes(this.material);
	}

	public function updateTransform(new_position:Vec4, ?new_scale:Float, ?new_width:Float) {
		this.position	= new_position;	
		var pos = position.clone();
		var scale_updated = false;
		if (new_scale != null) {
			this.scale			= new_scale;
			scale_updated  = true;
		}
		if (new_width != null)	this.width = new_width;

		for (m in meshes) {
			if (scale_updated)	m.transform.scale.set(scale, scale, scale);
			m.transform.loc.setFrom(pos);
			m.transform.buildMatrix();
			pos.x += width*scale;
		}

	}

	public function setVisible(visable:Bool) {
		this.visible = visable;
		for (mesh in meshes) {
			mesh.visible = visable;
		}
		for (a in animations) {
			if (a.par_sys != null && a.par_sys.state != STAND_BY) {
				a.par_sys.reset();
			}
		}
	}


}