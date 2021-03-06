package openfl.filesystem.electron;

import openfl.utils.ByteArray;
import openfl.filesystem.File;
import openfl.events.EventDispatcher;

import js.node.Fs;
import js.node.fs.ReadStream;
import js.node.fs.WriteStream;
import js.node.Buffer;

class FileStream extends EventDispatcher
{
	var openFile:File;
	var fileMode:FileMode;
	var writeStream:WriteStream;
	var readStream:ReadStream;
	
	public function new()
	{
		super();
	}
	
	public function open(openFile:File, fileMode:FileMode) 
	{
		this.openFile = openFile;
		this.fileMode = fileMode;

		if (fileMode == FileMode.WRITE) writeStream = Fs.createWriteStream(openFile.nativePath);
		else if (fileMode == FileMode.READ) readStream = Fs.createReadStream(openFile.nativePath);
	}

	public function openAsync(openFile:File, fileMode:FileMode) 
	{
		open(openFile, fileMode);
	}
	

	public function readUTF():String
	{
		if (openFile == null) return null;
		return Fs.readFileSync(openFile.nativePath, 'utf8');
	}

	public function readUTFBytes(size:UInt):String
	{
		if (openFile == null) return null;
		var buffer = Fs.readFileSync(openFile.nativePath, { flag:FsOpenFlag.ReadSync } );
		return buffer.toString('utf8', 0, size);
	}

	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		if (openFile == null) return;
		var buffer:Buffer = Fs.readFileSync(openFile.nativePath, { flag:FsOpenFlag.ReadSync } );
		var hxBytes = buffer.hxToBytes();
		bytes.writeBytes(hxBytes, offset, length);
	}
	
	public function writeUTFBytes(value:String):String
	{
		if (openFile == null) return null;
		
		writeStream.once('open', function(fd) {
			writeStream.write(value);
			writeStream.end();
		});

		return value;
	}

	public function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		if (openFile == null) {
			trace(openFile == null);
			return;
		}
		
		writeStream.once('open', function(fd) {
			writeStream.write(Buffer.from(bytes));
			writeStream.end();
		});
	}
	
	public function close() 
	{
		openFile = null;
	}
}