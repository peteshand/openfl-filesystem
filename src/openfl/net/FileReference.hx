package openfl.net;

#if (air||flash)
	typedef FileReference = flash.net.FileReference;	
#elseif electron
	typedef FileReference = openfl.net.electron.FileReference;
#end