module uim.javascript;

// Libraries
public import uim.core;
public import uim.oop;

// Modules
public import uim.javascript.base;
public import uim.javascript.helper;
public import uim.javascript.array;
public import uim.javascript.js;
public import uim.javascript.command;
public import uim.javascript.obj;
public import uim.javascript.module_;

class DJSRoot {
	this() {}

	override string toString() { return ""; }
}

string jsArray() { return "[]"; }
string jsArray(string[] values) { return "["~values.join(",")~"]"; }
unittest {
	assert(jsArray() == "[]");
	assert(jsArray(["a", "b"]) == "[a,b]");
}

string jsObject(string[string] values, bool sorted = true) {
	string[] props;
	foreach(k; values.keys.sort.array) props ~= k~":"~values[k];
	return "{"~props.join(",")~"}"; }
unittest {
	assert(jsObject(["a":"1", "b":"2"]) == "{a:1,b:2}");
}

string jsBlock(DJS content) { return jsBlock(content.toString); }
string jsBlock() { return "{}"; }
string jsBlock(string content) { return "{"~content~"}"; }
unittest {
	assert(jsBlock() == "{}");
	assert(jsBlock("return;") == "{return;}");
}

string jsFCall(string name = "") { return "%s()".format(name); } 
string jsFCall(string name, string[] parameters) { return "%s(%s)".format(name, parameters.join(",")); } 
unittest {
	assert(jsFCall("fn") == "fn()");
	assert(jsFCall("fn", ["a", "b"]) == "fn(a,b)");
}

string jsOCall(string name = "") { return ".%s()".format(name); } 
string jsOCall(string name, string[] parameters) { return ".%s(%s)".format(name, parameters.join(",")); } 
unittest {
	assert(jsOCall("fn") == ".fn()");
	assert(jsOCall("fn", ["a", "b"]) == ".fn(a,b)");
}

string jsFunc(DJS content) { return jsFunc(content.toString); } 
string jsFunc(string[] parameters, DJS content) { return jsFunc(parameters, content.toString);  } 
string jsFunc(string name, string[] parameters, DJS content) { return jsFunc(name, parameters, content.toString);  } 
string jsFunc(string content = "") { return "function()%s".format(jsBlock(content)); } 
string jsFunc(string[] parameters, string content = "") { return "function(%s)%s".format(parameters.join(","), jsBlock(content)); } 
string jsFunc(string name, string[] parameters, string content = "") { return "function %s(%s)%s".format(name, parameters.join(","), jsBlock(content)); } 
unittest {
	assert(jsFunc("return;") == "function(){return;}");
	assert(jsFunc(["a", "b", "c"], "return;") == "function(a,b,c){return;}");
	assert(jsFunc("fn", ["a", "b", "c"], "return;") == "function fn(a,b,c){return;}");
}

unittest {
	auto js = JS.If("x > 0", "do something;");
	assert(JS.Func() == "function(){}");

	assert(JS.Switch("value", ["1": "do something;"]) == "switch(value){case 1: do something; break;}"); 
	assert(JS.Switch("value", ["1": "do something;"], "do the rest;") == "switch(value){case 1: do something; break;default: do the rest;}"); 
		
	assert(JS.Constructor("variable", "content") == "constructor(variable){content}");
	assert(JS.Get("name", "content") == "get name(){content}");
	assert(JS.Set("name", ["A", "B"], "content") == "set name(A, B){content}");
}

auto jsIf(string condition, string content) { return "if (%s) { %s }".format(condition, content); }
auto jsElse(string content) { return "else { %s }".format(content); }
auto jsIfElse(string condition, string ifContent, string elseContent) { 
	return jsIf(condition, ifContent)~jsElse(elseContent); }

auto jsThen(string code) { return ".then(function (response) { %s })".format(code); }
auto jsCatch(string code) { return ".catch(function (error) { %s })".format(code); }

auto jsImports(string[string] imports) {
	string result;
	foreach(k,v; imports) if (v) result~=`import %s from "%s";`.format(v, k); else `import "%s";`.format(k);
	return result;
} 

auto jsForIn(string item, string items, string content) { return "for(let %s in %s) { %s }".format(item, items, content); }
auto jsForOf(string item, string items, string content) { return "for(let %s ofs %s) { %s }".format(item, items, content); }