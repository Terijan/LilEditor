package;

import flash.external.ExternalInterface;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.input.mouse.FlxMouse;
import flixel.system.input.mouse.FlxMouseButton;
import flixel.system.replay.MouseRecord;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class AdapterState extends FlxState
{
	public var character:Character;
	public var cameraTarget:FlxSprite;
	private static var lastMouse:FlxPoint;
	public static var mouse:FlxPoint;
	public static var isMouseReserved:Bool;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		mouse = new FlxPoint(0, 0);
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		FlxG.camera.zoom = 8;
		cameraTarget = new FlxSprite(0, 0);
		add(cameraTarget);
		FlxG.camera.focusOn(cameraTarget.getMidpoint());
		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON, null);
		lastMouse = new FlxPoint();
		
		
		//FlxG.camera.focusOn(cameraTarget.getMidpoint());
		cameraTarget.visible = false;
		trace("test");
		if (ExternalInterface.available)
		{
			ExternalInterface.addCallback("loadData", this.loadData);
			ExternalInterface.call("Initialize");
		}
		else
		{
			character = new Character();
			add(character);
		}
		FlxG.autoPause = false;
		super.create();
	}
	
	public function loadData(data:String):String {
		character = new Character("assets/test.png", 22, 18, data);		
		add(character);
		data = data.split("%").join("%25")
           .split("\\").join("%5c")
           .split("\"").join("%22")
           .split("&").join("%26");
		trace(data);
		
		return data;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		mouse.x = FlxG.mouse.x + 260;
		mouse.y = FlxG.mouse.y + 208;
		super.update();
		if (!isMouseReserved && lastMouse != null && FlxG.mouse.pressed)
		{
			cameraTarget.x += Math.floor(getMouseDiffX());
			cameraTarget.y += Math.floor(getMouseDiffY());
		}
		lastMouse.x = FlxG.mouse.screenX;
		lastMouse.y = FlxG.mouse.screenY;
	}
	
	public static function reserveMouse():Void
	{
		isMouseReserved = true;
	}
	
	public static function freeMouse():Void
	{
		isMouseReserved = false;
	}
	
	public static function getMouseDiffX():Float
	{
		return lastMouse.x - FlxG.mouse.screenX;
	}
	
	public static function getMouseDiffY():Float
	{
		return lastMouse.y - FlxG.mouse.screenY;
	}
}