package ;
import elements.Animation;
import elements.Frame;
import elements.Key;
import elements.Sprite;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import openfl.Assets;
import tjson.TJSON;
/**
 * ...
 * @author cdizzle
 */
class Character extends FlxObject
{
	public static var img:BitmapData;
	
	public static var sprite:Sprite;
	public static var animations:Array<Animation>;
	public var scale:Int;
	public static var frameData:Array<BitmapData>;
	private static var highlight:FlxSprite;
	private static var heldKey:Key;
	//public var properties:Array<>;
	
	public function new(filename:String = "assets/test.png", sizeX:Int = 22, sizeY:Int = 18, ?preData) 
	{
		//test JSON data
		var testData = Assets.getText("assets/testData.txt");
		var charObj:CharData = TJSON.parse((preData == null?testData:preData), "assets/testData.txt");
		
		
		
		FlxG.state.add(this); 
		
		sprite = new Sprite(filename, sizeX, sizeY);
		animations = new Array<Animation>();
		frameData = new Array<BitmapData>();
		
		scale = Math.floor((FlxG.width / width) / 5);
		
		img = Assets.getBitmapData(filename);
		var isVertical:Bool = img.height > img.width;
		var count:Int = Std.int((isVertical ? (img.height / sizeY) : (img.width / sizeX)));
		if (charObj == null)
		{
			for (i in 0...count)
			{
				frameData[i] = new BitmapData(sizeX, sizeY,true,0x00000000);
				frameData[i].copyPixels(img, new Rectangle(i * (!isVertical?sizeX:0), i * (isVertical?sizeY:0), sizeX, sizeY), new Point(0, 0), null, null, true);
				animations[i] = new Animation("", [new Key(i, 1, [])], 8);
				animations[i].keys[0].parent = animations[i];
			}
		}
		else
		{
			for (i in 0...count)
			{
				frameData[i] = new BitmapData(sizeX, sizeY,true,0x00000000);
				frameData[i].copyPixels(img, new Rectangle(i * (!isVertical?sizeX:0), i * (isVertical?sizeY:0), sizeX, sizeY), new Point(0, 0), null, null, true);
			}
			
			var _keys:Array<Key> = new Array<Key>();
			for (a in charObj.Animations)
			{
				_keys = [];
				for (k in a.Keys)
				{
					_keys.push(new Key(k.Frame, k.Length, k.Scripts));
				}
				//a contains: Name + keys
				animations.push(new Animation(a.Name, _keys, 8));
			}
		}
		spaceAnimations();
		highlight = new FlxSprite();
		highlight.makeGraphic(sprite.sizeX, sprite.sizeY, 0x88FFFFFF);
		highlight.visible = false;
		FlxG.state.add(highlight);
		super();
	}
	
	public static function spaceAnimations():Void
	{
		var sortGroup = new Array<FlxSprite>();
		for (i in 0...animations.length)
		{
			//First we space the first Key of each animation along the X axis
			sortGroup[i] = (animations[i].keys[0].frame);
			FlxSpriteUtil.space(sortGroup, 3, 0, sprite.sizeX + 5, 0);
			//Then we call the animation's space function to manage its other keys
			animations[i].spaceKeys();
		}		
	}
	
	override public function update():Void 
	{
		if (heldKey == null)
		{
			highlight.visible = false;
		}
		else
		{
			if (FlxG.mouse.justReleased)
			{
				var a:Animation = getHoveredAnimation();
				if (a == null)
				{
					a = new Animation("", [heldKey], 8);
					animations.push(a);
				}
				heldKey.setParent(a);
				spaceAnimations();
				heldKey = null;
				AdapterState.freeMouse();
			}
			else
			{
				heldKey.frame.x = AdapterState.mouse.x;
				heldKey.frame.y = AdapterState.mouse.y;
			}
		}
		super.update();
	}
	
	private function getHoveredAnimation():Animation
	{
		for (a in animations)
		{
			if (a.keys[0].frame.overlapsPoint(new FlxPoint(AdapterState.mouse.x, a.keys[0].frame.y+1)))
			{
				return a;
			}
		}
		
		return null;
	}
	
	public static function attachSpriteToMouse(frame:Frame):Void
	{
		AdapterState.reserveMouse();
		heldKey = frame.parent;
	}
	
	public static function showHover(frame:FlxSprite):Void
	{
		highlight.visible = true;
		highlight.x = frame.x;
		highlight.y = frame.y;
	}
	
	public static function removeAnimation(anim:Animation):Bool
	{
		return animations.remove(anim);
	}
	
	

	
	
	//public static function addAnimation(anim:Animation):Void
	//{
	//	animations.push(anim);
	//}
}

	typedef CharData = {
		Sprite:Dynamic,
		Animations:Array<AnimData>,
		Properties:Dynamic
	}
	
	typedef AnimData = {
		Name: String,
		Keys:Array<KeyData>
	}
	
	typedef KeyData = {
		Frame: Int,
		Length: Int,
		Scripts: Array<String>
	}