package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.filters.ShaderFilter;

class PlayState extends FlxState
{
	/**
	 * the sprite with Flash filtering support.
	 */
	var filteredSprite:FlxFilteredSprite;

	var exampleShader = new ExampleShader();

	/**
	 * A specified amount of filters to apply to `filteredSprite`.
	 */
	var filters:Array<BitmapFilter> = [new DropShadowFilter(4, 45, 0xFF0000)];

	var filterVisible:FlxText;

	override public function create()
	{
		// Changes the scale mode to fill everything. More of a personal preference, since it doesnt display what the "juice" of FlxFilteredSprite can do.
		// @:privateAccess
		// cast(FlxG.scaleMode, flixel.system.scaleModes.RatioScaleMode).fillScreen = true;
		exampleShader.effectType = WAVY;
		exampleShader.waveAmplitude = 0.5;
		exampleShader.waveFrequency = 7;
		exampleShader.waveSpeed = 1;
		filters.unshift(new ShaderFilter(exampleShader.shader));
		super.create();
		// Loads the BG, could be anything really.
		var bg = new FlxSprite();
		bg.makeGraphic(1, 1);
		bg.setGraphicSize(FlxG.game.stage.stageWidth, FlxG.game.stage.stageHeight);
		bg.updateHitbox();
		add(bg);
		filteredSprite = new FlxFilteredSprite();

		var filtersText = new FlxText("Filters:", 37);
		filtersText.color = 0;
		#if !web
		filtersText.text += "\n[";

		for (filter in filters)
		{
			filtersText.text += '\n${filter}';
		}

		filtersText.text += "\n]";
		#else
		filtersText.text += " CANNOT SHOW ARRAY";
		#end

		filterVisible = new FlxText(0, filtersText.height, 0, "Visible: true", filtersText.size);

		filterVisible.color = 0;

		add(filterVisible);
		add(filtersText);

		// This is where you can switch between loading an image or loading frames, your choice.
		// It's loading frames by default due to me thinking it's way cooler than a simple image.

		loadGraphic();
		// loadFrames();

		// Loads the filters from the array above the create function, and positions it while finally adding it to the members list.
		filteredSprite.filters = filters;
		filteredSprite.antialiasing = true;
		filteredSprite.screenCenter();
		add(filteredSprite);
	}

	override public function update(elapsed:Float)
	{
		filteredSprite.filterDirty = true; // setting this to true so that it can render every frame of a custom shader.
		exampleShader.update(elapsed);
		if (FlxG.keys.justPressed.F && (filters != null || filters.length > 0))
		{
			filteredSprite.filters = (filteredSprite.filters != null) ? null : filters;

			if (filterVisible != null)
			{
				if (filteredSprite.filters == null)
				{
					filterVisible.text = "Visible: false";
					filterVisible.color = 0xFF0000;
				}
				else
				{
					filterVisible.text = "Visible: true";
					filterVisible.color = 0;
				}
			}
		}
		super.update(elapsed);
	}

	/**
	 * Loads a simple graphic and showcases it.
	 */
	function loadGraphic()
	{
		filteredSprite.loadGraphic(AssetPaths.me_dumb__png);
	}

	/**
	 * Loads an animation and plays it.
	 */
	function loadFrames()
	{
		filteredSprite.frames = FlxAtlasFrames.fromSparrow("assets/images/nagatoro assets.png", "assets/images/nagatoro assets.xml");
		filteredSprite.animation.addByPrefix("d", "naga ora", 24, true);
		filteredSprite.animation.play("d");
	}
}
