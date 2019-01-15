/**
* Name:			Timer.hx                       
* Description:	Count down timer for Armory 
* Author:		Milo Hao XU / MiloGameWorks (milo.h.xu@gmail.com)
* Date:			20Jan2018                                                        
* Version:		0.4 (13Jun2018)
*/
package arm;

import kha.FastFloat;
import iron.system.Time;

class Timer {

	public  var time_duration	:FastFloat;	
	public  var time_remain		:FastFloat;
	public  var time_ratio		:FastFloat;

	private var loop			:Bool;
	private var stopped			:Bool;
	private var paused			:Bool;

	/**
	* Constructor
	* @param duration how long the timer will run
	* @param repeat	repeat the timer after complete
	*/
  	public function new(duration:FastFloat, repeat:Bool=false) {
		time_duration	= duration;
		time_remain		= duration;
		time_ratio		= 0.0;
		loop 			= repeat;
		stopped			= true;
		paused			= false;
	} 

	/**
	* Set duration & repeat, and reset the status
	* @param duration how long the timer will run
	* @param repeat	repeat the timer after complete
	*/
  	public inline function set(duration:FastFloat, repeat:Bool=false) {
		time_duration	= duration;
		time_remain		= duration;
		time_ratio		= 0.0;
		loop 			= repeat;
		stopped			= true;
		paused			= false;
	} 

	/**
	* Run timer (call this in the update function)
	* @return true when timer count down complete
	*/
	public function update():Bool {
		var alarm = false;
		if (!stopped && !paused) {
			time_remain -= Time.delta;
			time_ratio	= (time_duration - time_remain) / time_duration;
			if (time_remain <= 0.0) {
				if(loop) {
					reset();
					start();
					alarm 		= true;
				} else {	
					time_remain = 0.0;
					time_ratio	= 1.0;
					stopped 	= true;
					paused		= false;
					alarm 		= true;
				}
			}
		}
		return alarm;
	}

	/**
	* Start timer count down
	*/
	public inline function start() {
		stopped	= false;
		paused	= false;
	}

	/**
	* Reset timer (the timer will be at "stopped" status after reset)
	*/
	public inline function reset() {
		time_remain = time_duration;
		time_ratio	= 0.0;
		stopped 	= true;
		paused		= false;
	}

	/**
	* Jump to end (but not reset)
	*/
	public inline function jumpToEnd() {
		time_remain = 0.0;
		time_ratio	= 1.0;
		stopped 	= true;
		paused		= false;
	}

	/**
	* Pause timer
	*/
	public inline function pause() {
		paused = true;
	}

	/**
	* Resume timer
	*/
	public inline function resume() {
		paused = false;
	}

	/**
	* is the timer still Running? (Note that "paused" state is counted as running)
	* @return is running
	*/
	public inline function isRunning():Bool {
		return !stopped;
	}
}
