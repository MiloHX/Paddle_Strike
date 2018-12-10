package arm;

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

	public function new(text:String, position:Vec4, scale:Float=1.0, width:Float=0.45, material:String = "") {
		this.text		= text.toUpperCase();
		this.scale		= scale;
		this.position	= position;
		this.width		= width;
		this.material	= material;
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

	public function setVisible(visable:Bool) {
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