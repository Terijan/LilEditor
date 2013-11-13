package elements;
import flixel.FlxSprite;

/**
 * ...
 * @author cdizzle
 */
class Key
{
	public var frame:FlxSprite;
	public var index:Int;
	public var length:Int;
	public var scripts:Array<String>;
	public var parent:Animation;
	
	public function new(_index:Int, _length:Int, _scripts:Array<String>) 
	{
		frame = new Frame(_index, this);
		index = _index;
		length = _length;
		scripts = _scripts;
	}
	
	public function setParent(_parent:Animation):Void
	{
		//First clear out our original parent and clean up after him
		if (parent.keys.length == 1)
		{
			var removeSuccessful:Bool;
			removeSuccessful = Character.removeAnimation(parent);
			if (!removeSuccessful)
				trace("Warning: animation removal was requested but Character.hx couldn't find it");
		}
		parent.keys.remove(this);
		
		//Now, accept new parent.  ACCEPTTTT
		parent = _parent;
		
		//inform parent of their new bundle of responsibility
		parent.keys.push(this);
	}
	
}