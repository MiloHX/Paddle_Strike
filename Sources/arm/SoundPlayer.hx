package arm;

import iron.data.Data;
import kha.Sound;
import kha.audio1.AudioChannel;
import iron.system.Audio;

@:enum abstract SoundEffect(Int) {
	var MENU_HOVER		= 0;
	var MENU_PUSH		= 1;
	var TITLE_DROP		= 2;
	var BALL_HIT_LEFT	= 3;
	var BALL_HIT_RIGHT	= 4;
	var BALL_HIT_WALL	= 5;
	var SCORE_UPDATE	= 6;
	var RESULT_SHOW		= 7;
	var TITLE_THEME		= 8;
	var KICK_OFF		= 9;
}


class SoundPlayer {

	static public var sound_hover		:Sound			= null;
	static public var sound_push		:Sound			= null;
	static public var sound_hit_left	:Sound			= null;
	static public var sound_hit_right	:Sound			= null;
	static public var sound_wall		:Sound			= null;
	static public var sound_drop		:Sound			= null;
	static public var sound_score		:Sound			= null;
	static public var sound_result		:Sound			= null;
	static public var sound_theme		:Sound			= null;
	static public var sound_kick_off	:Sound			= null;

	static public var audio_channel		:AudioChannel	= null;
	static public var audio_ch_title	:AudioChannel	= null;

	static var init_completed			:Bool 			= false;

	static public function init() {
		if (init_completed)	return;
		// Load sound
		Data.getSound("hover.wav",  function(sound:Sound) {
			sound_hover = sound;
		});
		Data.getSound("push.wav",  function(sound:Sound) {
			sound_push  = sound;
		});
		Data.getSound("hit_left.wav",  function(sound:Sound) {
			sound_hit_left   = sound;
		});
		Data.getSound("hit_right.wav",  function(sound:Sound) {
			sound_hit_right  = sound;
		});
		Data.getSound("wall.wav",  function(sound:Sound) {
			sound_wall   = sound;
		});
		Data.getSound("drop.wav",  function(sound:Sound) {
			sound_drop   = sound;
		});
		Data.getSound("score.wav",  function(sound:Sound) {
			sound_score  = sound;
		});
		Data.getSound("result.wav",  function(sound:Sound) {
			sound_result = sound;
		});
		Data.getSound("theme.wav", function(sound:Sound) {
			sound_theme = sound;
		});
		Data.getSound("kick_off.wav", function(sound:Sound) {
			sound_kick_off = sound;
		});

		init_completed = true;
	}

	static public function play(sound:SoundEffect, ?vol:Float) {
		switch sound {
			case MENU_HOVER:
				audio_channel = Audio.play(sound_hover);
			case MENU_PUSH:
				audio_channel = Audio.play(sound_push);
			case TITLE_DROP:
				audio_channel = Audio.play(sound_drop);
			case BALL_HIT_LEFT:
				audio_channel = Audio.play(sound_hit_left);
			case BALL_HIT_RIGHT:
				audio_channel = Audio.play(sound_hit_right);
			case BALL_HIT_WALL:
				audio_channel = Audio.play(sound_wall);
			case SCORE_UPDATE:
				audio_channel = Audio.play(sound_score);
			case RESULT_SHOW:
				audio_channel = Audio.play(sound_result);
			case TITLE_THEME:
				if (audio_ch_title == null)	{
					audio_ch_title = Audio.play(sound_theme, true);
				} else {
					audio_ch_title.play();
				}
			case KICK_OFF:
				audio_channel = Audio.play(sound_kick_off);
		}
		if (vol != null) {
			audio_channel.volume = vol;
		}
	}

	static public function stopTitleTheme() {
		if (audio_ch_title != null)	audio_ch_title.stop();
	}

}