package ;
import elements.Animation;
import flash.display.BitmapData;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import openfl.Assets;
import tjson.TJSON;

/**
 * ...
 * @author cdizzle
 */
class Unit extends FlxSprite
{
	public var Animations:Array<Animation>;
	public var fSprites:FlxTypedGroup<FlxTypedGroup<FlxSprite>>;
	public static var heldSprite:FlxSprite;
	private var originalPos:FlxPoint;
	private var highlight:FlxSprite;
	public function new() 
	{
		super();
		fSprites = new FlxTypedGroup<FlxTypedGroup<FlxSprite>>();
		originalPos = new FlxPoint();
		loadGraphic("assets/test.png", true, true, 22, 18);
		scale.x = Math.floor((FlxG.width / width) / 5);
		scale.y = Math.floor((FlxG.width / width) / 5);
		x = 100;
		highlight = new FlxSprite();
		highlight.makeGraphic(Std.int(width), Std.int(height), 0x88FFFFFF);
		highlight.visible = false;
		highlight.scale = scale;
		
		visible = false;
		
		FlxSpriteUtil.screenCenter(this, false, true);
		for (i in 0...frames)
		{
			set_frame(i);
			fSprites.add(new FlxTypedGroup<FlxSprite>());
			fSprites.members[i].add(new FlxSprite(0, 0, getFlxFrameBitmapData()));
		}
		FlxSpriteUtil.space(getFirstSprites().members, Math.floor(x), Math.floor(y), Std.int(1 + (width * scale.x)), 0);
		fSprites.setAll("scale", scale);
		FlxG.state.add(getFirstSprites());
		FlxG.state.add(highlight);
	}
	
	override public function update():Void 
	{
		highlight.visible = false;
		if (heldSprite == null)
		{
			for (fG in fSprites.members)
			{
				for (f in fG.members)
				{
					if (f.overlapsPoint(FlxG.mouse.getWorldPosition()))
					{
						frameOverlap(FlxG.mouse.getWorldPosition(), f);
						break;
					}
				}
			}
		}
		else
		{
			for (fG in fSprites.members)
			{
				for (f in fG.members)
				{
					if (f == heldSprite)
						continue;
					if (f.overlapsPoint(new FlxPoint(FlxG.mouse.x, f.getMidpoint().y)))
					{
						highlight.x = f.x;
						highlight.y = f.y;
						highlight.visible = true;
						break;
					}
				}
			}
			if (FlxG.mouse.pressed)
			{
				heldSprite.x -= AdapterState.getMouseDiffX();
				heldSprite.y -= AdapterState.getMouseDiffY();
			}
			if (FlxG.mouse.justReleased)
			{
				if (highlight.visible)//note, this is assuming that the visibility of highlight is set prior
				{
					for (fG in fSprites.members)
					{
						for (f in fG.members)
						{
							if (f == heldSprite)
							{
								fG.remove(heldSprite);
								if (fG.length == 0)
									fG.remove(f);
							}
						}
					}
					heldSprite = null;
				}
				else
				{
				heldSprite.x = originalPos.x;
				heldSprite.y = originalPos.y;
				heldSprite = null;
				}
			}
		}
		super.update();
	}
	
	public function frameOverlap(m:FlxPoint, s:FlxObject):Void
	{
		if (heldSprite != null && s != heldSprite)
			return;
		
		if (FlxG.mouse.justPressed)
		{
			heldSprite = cast(s, FlxSprite);
			originalPos.x = heldSprite.x;
			originalPos.y = heldSprite.y;
			heldSprite.x = m.x - (heldSprite.width) / 2;
			heldSprite.y = m.y - (heldSprite.height) / 2;
		}
		else
		{
			highlight.visible = true;
			highlight.x = s.x;
			highlight.y = s.y;
		}
		
		
	}
	
	public inline function getFirstSprites():FlxTypedGroup<FlxSprite>
	{
		var firstGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
		for (i in 0...fSprites.length)
		{
			firstGroup.add(fSprites.members[i].members[0]);
		}
		return firstGroup;
	}
	
}