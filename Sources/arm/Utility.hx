package arm;

import kha.FastFloat;
import iron.math.Math;
import iron.math.Vec2;

class Utility {

	static public inline function rotateVec2(vec:Vec2, angle:Float):Vec2 {
		var sin = Math.sin(angle);
		var cos = Math.cos(angle);

		var result = new Vec2();
		result.x = vec.x * cos - vec.y * sin;
		result.y = vec.x * sin + vec.y * cos;

		return result;
	}

	/**
	* angle from vec2 v1 to vec2 v2 (normalize them first)
	* @param v1 vec2 1
	* @param v2 vec2 2
	* @return   result
	*/
	public static inline function angleBetweenVec2(v1:Vec2, v2:Vec2):FastFloat {
		return Math.atan2(v1.x*v2.y - v1.y*v2.x, v1.x*v2.x + v1.y*v2.y);
	}

}