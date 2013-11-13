package elements;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author cdizzle
 */
class Frame extends FlxSprite
{
	public var index:Int;
	public var parent:Key;
	
	public function new(_index:Int, _parent:Key) 
	{
		index = _index;
		var img = Character.frameData[index];
		super(0, 0, img);
		FlxG.state.add(this);
		parent = _parent;
	}
	
	override public function update():Void 
	{
		if (onScreen() && overlapsPoint(AdapterState.mouse) && !AdapterState.isMouseReserved)
		{
			if (FlxG.mouse.justPressed)
			{
				Character.attachSpriteToMouse(this);
			}
			else
			{
				Character.showHover(this);
			}
		}
		super.update();
	}
	
}