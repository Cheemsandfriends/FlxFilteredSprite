package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));
		addChild(new FPS(10, 10, 0x7D7D7D));
		addChild(new MemCounter(10, 20, 0x7D7D7D));
	}
}
