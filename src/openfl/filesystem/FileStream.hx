package openfl.filesystem;

#if air
	typedef FileStream = flash.filesystem.FileStream;
#elseif electron
	typedef FileStream = openfl.filesystem.electron.FileStream;
#end