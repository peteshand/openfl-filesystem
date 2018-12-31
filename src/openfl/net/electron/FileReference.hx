package mantle.net;

import js.node.Fs;
import openfl.utils.ByteArray;
import openfl.net.URLRequest;

class FileReference
{
	public var creationDate(get, null):Date;
	public var creator(get, null):String;
	public var data(get, null):ByteArray;
	public var extension(get, null):String;
	public var modificationDate(get, null):Date;
	public var name(get, null):String;
	public static var permissionStatus(get, null):String;
	public var size(get, null):Float;
	public var type(get, null):String;
	
	public function new() 
	{
		
	}

	function get_creationDate():Date
	{
		throw "Need to implement";
		return null;
	}

	function get_creator():String
	{
		throw "Need to implement";
		return null;
	}
	
	function get_data():ByteArray
	{
		throw "Need to implement";
		return null;
	}
	
	function get_extension():String
	{
		throw "Need to implement";
		return null;
	}
	
	function get_modificationDate():Date
	{
		throw "Need to implement";
		return null;
	}
	
	function get_name():String
	{
		throw "Need to implement";
		return null;
	}
	
	static function get_permissionStatus():String
	{
		throw "Need to implement";
		return null;
	}
	
	function get_size():Float
	{
		throw "Need to implement";
		return 0;
	}
	
	function get_type():String
	{
		throw "Need to implement";
		return null;
	}

	public function browse(typeFilter:Array<String> = null):Bool
	{
		throw "Need to implement";
		return false;
	}

	public function cancel():Void
	{
		throw "Need to implement";
	}
		
	public function download(request:URLRequest, defaultFileName:String = null):Void
	{
		throw "Need to implement";
	}
			
	public function load():Void
	{
		throw "Need to implement";
	}
			
	public function requestPermission():Void
	{
		throw "Need to implement";
	}
			
	public function save(data:Dynamic, defaultFileName:String = null):Void
	{
		throw "Need to implement";
	}
			
	public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Bool = false):Void
	{
		throw "Need to implement";
	}
			
	public function uploadUnencoded(request:URLRequest):Void
	{
		throw "Need to implement";
	}
}