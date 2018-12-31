package openfl.filesystem;

#if air
	typedef FileStream = flash.filesystem.FileStream;
#elseif electron
	typedef FileStream = flash.filesystem.electron.FileStream;
#end