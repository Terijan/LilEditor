package elements;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author cdizzle
 */
class Animation
{
	public var name:String;
	public var keys:Array<Key>;
	public var speed:Int;
	public function new(_name: String, _keys:Array<Key>, _spd:Int) 
	{
		name = _name;
		keys = _keys;
		speed = _spd;
		
		for (k in _keys)
		{
			k.parent = this;
		}
	}
	
	public function spaceKeys():Void
	{
		if (keys.length == 1)
			return;
			
		var sortGroup = new Array<FlxSprite>();
		
		for (i in 0...keys.length)
		{
			sortGroup[i] = keys[i].frame;
		}
		
		FlxSpriteUtil.space(sortGroup, Std.int(keys[0].frame.x), Std.int(keys[0].frame.y), 0, Character.sprite.sizeY + 3);
	}
	
}