package;

import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class MemCounter extends TextField
{
	private var memPeak:Float = 0;

	static final BYTES_PER_MEG:Float = 1024 * 1024;
	static final ROUND_TO:Float = 1 / 100;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;
		this.width = 500;
		this.selectable = false;
		this.mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "RAM: ";

		#if flash
		addEventListener(flash.events.Event.ENTER_FRAME, function(e)
		{
			var time = flash.Lib.getTimer();
			__enterFrame(time);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		var mem:Float = Math.round(System.totalMemory / BYTES_PER_MEG / ROUND_TO) * ROUND_TO;

		if (mem > memPeak)
			memPeak = mem;
		text = 'RAM: ${mem}mb / ${memPeak}mb';
	}
}
