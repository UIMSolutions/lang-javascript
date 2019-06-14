module uim.javascript.obj;

import uim.javascript;

class DJSObj : DJSRoot {
	this() { }
	this(string[string] newValues) { this(); _values = newValues; }

@safe:
	string[string] _values;
	@property void values(string[string] newValues) { _values = newValues; } 
	@property auto values() { return _values; } 

	@safe bool opEquals(string value) {
		return toString() == value;
	}
}
auto JSObj() { return new DJSObj(); }

@safe {
	string jsObj(string[string] values = null) {
		if (values) {
			string[] kvs;
			foreach(k, v; values) kvs ~= k~":"~v;
			return "{"~kvs.join(",")~"}";
		}
		return "{}";
	} 
}
unittest {
	writeln("Testing ", __MODULE__);
}