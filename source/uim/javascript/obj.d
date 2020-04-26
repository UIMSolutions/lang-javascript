module uim.javascript.obj;

import uim.javascript;

class DJSObj : DJSRoot {
	this() { }
	this(string aName) { this(); _name = aName; }

	string _name;
	@property O name(this O)(string newName) { _name = newName; return cast(O)this; } 
	@property auto name() { return _name; }
	unittest {
		assert(JSObj.name("name") == "var name={}"); 
	} 

	string[string] _values;
	@property O values(this O)(string[string] newValues) { _values = newValues; return cast(O)this; } 
	@property auto values() { return _values; } 
	unittest {
		assert(JSObj.values(["name":"value"]) == "{name:value}"); 
	} 

	string[string] _getters;
	@property O getters(this O)(string[string] newValues) { _getters = newValues; return cast(O)this; } 
	@property auto getters() { return _getters; } 

	string[string] _setters;
	@property O setters(this O)(string[string] newValues) { _setters = newValues; return cast(O)this; } 
	@property auto setters() { return _setters; } 

	bool opEquals(string value) {
		return toString() == value; }
	override string toString() { 
		string result;
		if (_name) result = "var "~_name~"=";
		result ~= "{";
		string[] inner;
		foreach(k; _values.toKeys.sort) inner ~= k~":"~_values[k];
		foreach(k; _getters.toKeys.sort) inner ~= "get "~k~"()"~jsBlock(_getters[k]);
		foreach(k; _setters.toKeys.sort) inner ~= "get "~k~jsBlock(_setters[k]);
		result ~= inner.join(",")~"}";
		return result; }
}
auto JSObj() { return new DJSObj(); }
auto JSObj(string aName) { return new DJSObj(aName); }
unittest {
	assert((new DJSObj).toString == JSObj.toString);
	assert((new DJSObj("name")).toString == JSObj("name").toString);
}


string jsObj(string[string] values = null) {
	if (values) {
		string[] kvs;
		foreach(k, v; values) kvs ~= k~":"~v;
		return "{"~kvs.join(",")~"}";
	}
	return "{}";
} 
