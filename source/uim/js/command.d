module uim.js.command;

import uim.js;

class DJSCommand : DJSRoot {
	mixin(StringProperty!"command");
		  
	this() {}
	this(string aCommand) { this.command = aCommand; }

	@safe bool opEquals(string value) { return toString() == value; }
	@safe override string toString() {
		return _command;
	}
}
auto JSCommand() { return new DJSCommand(); }
auto JSCommand(string aCommand) { return new DJSCommand(aCommand); }

string jsCommand() { return ""; }
string jsCommand(string aCommand) { return aCommand; }

unittest {
	writeln("Testing ", __MODULE__);

	assert(JSCommand() == jsCommand());
	assert(JSCommand("var x = 'xxx';") == jsCommand("var x = 'xxx';"));
}

