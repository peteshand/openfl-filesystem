package openfl.filesystem;

#if air
	typedef File = flash.filesystem.File;
#elseif electron
	typedef File = openfl.filesystem.electron.File;
#end