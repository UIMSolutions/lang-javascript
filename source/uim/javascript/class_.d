module uim.javascript.class_;

import uim.javascript;

class DJSClass : DJSRoot {
	this(string aClassName, string superClassName) { super(); _name = aClassName; _extends = superClassName; }


	string _name;
	string _extends;

	string _constructor;
	@property O constructor(this O)(string newValue) { _constructor = newValue; } 
	@property auto constructor() { return _constructor; } 
	unittest {
	} 

	string[] _constructorParameters;
	@property O constructorParameters(this O)(string[] newParameters) { _constructorParameters = newParameters; } 
	@property auto constructorParameters() { return _constructorParameters; } 
	unittest {
	} 

	string[string] _getters;
	@property O getters(this O)(string[string] newValues) { _getters = newValues; } 
	@property auto getters() { return _getters; } 

	string[string] _setters;
	@property O setters(this O)(string[string] newValues) { _setters = newValues; } 
	@property auto setters() { return _setters; } 

	bool opEquals(string value) {
		return toString() == value; }
	override string toString() { 
		string result = "class %s extends %s".format(_name, _extends);
		result ~= "{";
		if (_constructor) {
			if (_constructorParameters) result ~= "constructor(%s)%s".format(_constructorParameters.join(","), jsBlock(_constructor));
		}
		string[] inner;
		foreach(k; _getters.keys.sort) inner ~= "get "~k~"()"~jsBlock(_getters[k]);
		foreach(k; _setters.keys.sort) inner ~= "get "~k~jsBlock(_setters[k]);
		result ~= inner.join(",")~"}";
		return result; }
}
auto JSClass(string aName, string superClassName) { return new DJSClass(aName, superClassName); }
unittest {
	assert((new DJSClass("name", "super")).toString == JSClass("name", "super").toString);
}