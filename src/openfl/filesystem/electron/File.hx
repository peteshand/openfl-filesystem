package openfl.filesystem.electron;

import js.node.Fs;
import js.node.Os;
import js.node.Path;
import js.node.Require;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import openfl.utils.ByteArray;

class File extends FileReference
{
	@:isVar static var temporaryDirectory(get, null):File;
	@:isVar public static var applicationDirectory(get, null):File;
	//@:isVar public static var applicationStorageDirectory(get, null):File;
	//@:isVar public static var cacheDirectory(get, null):File;
	@:isVar public static var desktopDirectory(get, null):File;
	@:isVar public static var documentsDirectory(get, null):File;
	//public static var lineEnding:String;
	//public static var permissionStatus:String;
	public static var separator(get, null):String;
	//public static var systemCharset(get, null):String;
	@:isVar public static var userDirectory(get, null):File;

	// property missing from FileReference
	public var extension(get, null):String;
	
	static function get_userDirectory():File 
	{
		if (userDirectory == null) userDirectory = new File(Os.homedir());
		return userDirectory;
	}
	
	static function get_documentsDirectory():File 
	{
		if (documentsDirectory == null) documentsDirectory = new File(userDirectory.nativePath + Path.sep + 'Documents');
		return documentsDirectory;
	}
	
	static function get_desktopDirectory():File 
	{
		if (desktopDirectory == null) desktopDirectory = new File(userDirectory.nativePath + Path.sep + 'Desktop');
		return desktopDirectory;
	}
	
	static function get_applicationDirectory():File 
	{
		if (applicationDirectory == null) applicationDirectory = new File(Path.dirname(Require.main.filename));
		return applicationDirectory;
	}

	static function get_temporaryDirectory():File 
	{
		if (temporaryDirectory == null) {
			temporaryDirectory = new File(userDirectory.nativePath + Path.sep + '.temp');
			if (!temporaryDirectory.exists) temporaryDirectory.createDirectory();
		}
		return temporaryDirectory;
	}

	
	
	private var path:String;
	
	//public var downloaded:Bool;
	public var exists(get, null):Bool;
	//public var icon(get, null):Icon;
	public var isDirectory(get, never):Bool;
	//public var isHidden(get, never):Bool;
	//public var isPackage(get, never):Bool;
	//public var isSymbolicLink(get, never):Bool;
	public var nativePath(get, never):String;
	//public var parent(get, null):File;
	//public var preventBackup:Bool;
	//public var spaceAvailable(get, null):Float;
	
	public var url(get, null):String;
	
	
	public function new(path:String="") 
	{
		this.path = path;
		super();
		
		if (exists){
			var birthtime = Fs.statSync(path).birthtime;
			creationDate = new Date(birthtime.getFullYear(), birthtime.getMonth(), birthtime.getDate(), birthtime.getHours(), birthtime.getMinutes(), birthtime.getSeconds());

			// The issue with setting modificationDate here is that it won't update after the File object is created
			var mtime = Fs.statSync(path).mtime;
			modificationDate = new Date(mtime.getFullYear(), mtime.getMonth(), mtime.getDate(), mtime.getHours(), mtime.getMinutes(), mtime.getSeconds());

			var stats = Fs.statSync(path);
			this.size = Math.floor(stats.size);
		}
		

		//name = Path.basename(path);
	}

	private function get_nativePath():String 
	{
		return path;
	}
	
	private function get_url():String 
	{
		return path;
	}

	private function get_exists():Bool 
	{
		var flag = true;
		try{
			Fs.accessSync(path, Fs.F_OK);
		}catch(e:Dynamic){
			flag = false;
		}
		return flag;
	}

	

	

	

	

	
	function get_isDirectory():Bool 
	{
		if (!this.exists) return false;
		return Fs.lstatSync(path).isDirectory();
	}

	/*override function get_modificationDate():Date
	{
		var jsDate = Fs.statSync(path).mtime;
		return new Date(jsDate.getFullYear(), jsDate.getMonth(), jsDate.getDate(), jsDate.getHours(), jsDate.getMinutes(), jsDate.getSeconds());
	}*/

	static function get_separator():String
	{
		return Path.sep;
	}

	//#if (lime <= "7.1.0") override #end
	function get_size():Float
	{
		var stats = Fs.statSync(path);
		return stats.size;
	}

	//#if (lime <= "7.1.0") override #end
	function get_name():String
	{
		return Path.basename(path);
	}






    public function browseForDirectory(title:String):Void
	{
		throw "browseForDirectory is yet to be implemented, please help add this feature";
	}
 	 	
    public function browseForOpen(title:String, typeFilter:Array<FileFilter> = null):Void
	{
		throw "browseForOpen is yet to be implemented, please help add this feature";
	}
 	 	
    public function browseForOpenMultiple(title:String, typeFilter:Array<FileFilter> = null):Void
	{
		throw "browseForOpenMultiple is yet to be implemented, please help add this feature";
	}
 	 	
    public function browseForSave(title:String):Void
	{
		throw "browseForSave is yet to be implemented, please help add this feature";
	}
 	 	
    override public function cancel():Void
	{
		throw "cancel is yet to be implemented, please help add this feature";
	}
 	 	
    public function canonicalize():Void
	{
		throw "canonicalize is yet to be implemented, please help add this feature";
	}
 	 	
    public function clone():File
	{
		throw "clone is yet to be implemented, please help add this feature";
		return null;
	}
 	 	
    public function copyTo(newLocation:File, overwrite:Bool = false):Void
	{
		if (newLocation.isDirectory){
			copyFolderRecursiveSync(this, newLocation);
		} else {
			copyFileSync(this, newLocation);
		}
	}

	function copyFileSync( source:File, target:File )
	{
		var targetFile:File = target;

		if ( target.exists ) {
			if ( target.isDirectory ) {
				targetFile = target.resolvePath(source.name);
			}
		}

		var fileStream1:FileStream = new FileStream();
		fileStream1.open(source, FileMode.READ);
		var value:String = fileStream1.readUTFBytes(Math.floor(source.size));
		fileStream1.close();

		var fileStream:FileStream = new FileStream();
		fileStream.open(targetFile, FileMode.WRITE);
		fileStream.writeUTFBytes(value);
		fileStream.close();
	}

	function copyFolderRecursiveSync( source:File, target:File )
	{
		var files:Array<File> = [];

		if ( !target.exists ) {
			target.createDirectory();
		}
		
		if ( source.isDirectory ) {
			files = source.getDirectoryListing();
			for (file in files) {
				if ( file.isDirectory ) {
					copyFolderRecursiveSync( file, target );
				} else {
					copyFileSync( file, target );
				}
			}
		}
	}
 	 	
    public function copyToAsync(newLocation:FileReference, overwrite:Bool = false):Void
	{
		throw "copyToAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function createDirectory():Void
	{
		Fs.mkdirSync(path);
	}
 	 	
    public static function createTempDirectory():File
	{
		//throw "createTempDirectory is yet to be implemented, please help add this feature";
		var name:String = StringTools.hex(Math.floor(Math.random() * 100000000000000000));
		return temporaryDirectory.resolvePath(name);
	}
 	 	
    public static function createTempFile():File
	{
		//throw "createTempFile is yet to be implemented, please help add this feature";
		var name:String = StringTools.hex(Math.floor(Math.random() * 100000000000000000)) + ".tmp";
		return temporaryDirectory.resolvePath(name);
	}
 	 	
    public function deleteDirectory(deleteDirectoryContents:Bool = false):Void
	{
		var files:Array<File> = this.getDirectoryListing();
		if (deleteDirectoryContents){
			for (i in 0...files.length){
				if (files[i].isDirectory) files[i].deleteDirectory(true);
				else files[i].deleteFile();
			}
			Fs.rmdirSync(path);
		} else {
			if (files.length == 0) Fs.rmdirSync(path);
		}
	}
 	 	
    public function deleteDirectoryAsync(deleteDirectoryContents:Bool = false):Void
	{
		throw "deleteDirectoryAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function deleteFile()
	{
		Fs.unlinkSync(path);
	}
 	 	
    public function deleteFileAsync():Void
	{
		throw "deleteFileAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function getDirectoryListing():Array<File>
	{
		if (isDirectory){
			var fileStrs:Array<String> = Fs.readdirSync(path);
			var files:Array<File> = [];
			for (i in 0...fileStrs.length) {
				files.push(new File(path + separator + fileStrs[i]));
			}
			return files;
		}
		else {
			return [];
		}
	}
	/*
	override function get_name():String
	{
		return Path.basename(nativePath);
	}*/

	//#if (lime <= "7.1.0") override #end
	function get_extension():String
	{
		return Path.extname(nativePath);
	}
 	

    public function getDirectoryListingAsync():Void
	{
		throw "getDirectoryListingAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function getRelativePath(ref:FileReference, useDotDot:Bool = false):String
	{
		throw "getRelativePath is yet to be implemented, please help add this feature";
	}
 	 	
    public static function getRootDirectories():Array<File>
	{
		throw "getRootDirectories is yet to be implemented, please help add this feature";
	}
 	 	
    public function moveTo(newLocation:FileReference, overwrite:Bool = false):Void
	{
		//throw "moveTo is yet to be implemented, please help add this feature";
		var file:File = cast(newLocation);
		if (file == null) {
			throw 'new location needs to be a file';
		}
		Fs.renameSync(nativePath, file.nativePath);
    }
 	 	
    public function moveToAsync(newLocation:FileReference, overwrite:Bool = false):Void
	{
		throw "moveToAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function moveToTrash():Void
	{
		throw "moveToTrash is yet to be implemented, please help add this feature";
	}
 	 	
    public function moveToTrashAsync():Void
	{
		throw "moveToTrashAsync is yet to be implemented, please help add this feature";
	}
 	 	
    public function openWithDefaultApplication():Void
	{
		throw "openWithDefaultApplication is yet to be implemented, please help add this feature";
	}
 	
	// function missing from openfl FileReference
	//#if (lime <= "7.1.0") override #end
    public function requestPermission():Void
	{
		throw "requestPermission is yet to be implemented, please help add this feature";
	}
 	 	
    public function resolvePath(path:String):File
	{
		return new File(this.path + "/" + path);
	}

	
}