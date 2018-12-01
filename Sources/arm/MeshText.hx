package arm;

import iron.object.Object;
import iron.Scene;
import iron.math.Vec4;

class MeshText {
	
	public var text			:String;
	public var mesh_names	:Array<String>		= [];
	public var meshes		:Array<Object>		= [];
	public var position		:Vec4;
	public var width		:Float;
	public var scale		:Float;

	public function new(text:String, position:Vec4, scale:Float=1.0, width:Float=0.45) {
		this.text		= text;
		this.scale		= scale;
		this.position	= position;
		this.width		= width;

		constructMeshes();
	}

	function constructMeshes() {
		var name:String = "";
		for (i in 0...text.length) {
			if (text.charAt(i) != " ") {
				name = "Text_" + text.charAt(i);
			} else {
				name = "Text_Emp";
			}
			mesh_names.push(name);
		}

		var pos = position.clone();
		for (mesh_name in mesh_names) {
			if (mesh_name != "Text_Emp") {
				Scene.active.spawnObject(mesh_name, null, function(obj) {
					obj.transform.scale.set(scale, scale, scale);
					obj.transform.loc.setFrom(pos);
					obj.transform.buildMatrix();
					meshes.push(obj);
				});
			}
			pos.x += width*scale;
		}
	}

	public function updateMeshes(text:String, ?position:Vec4, ?scale:Float, ?width) {
		destroyMeshes();
		this.text		= text;
		if (position != null)	this.position	= position;	
		if (scale    != null)	this.scale		= scale;
		if (width    != null)	this.width		= width;	
		constructMeshes();
	}

	public function setVisible(visable:Bool) {
		for (mesh in meshes) {
			mesh.visible = visable;
		}
	}

	function destroyMeshes() {
		for (mesh in meshes) {
			mesh.remove();
		}
		meshes.splice(0, meshes.length);
		mesh_names.splice(0, mesh_names.length);
	}

}