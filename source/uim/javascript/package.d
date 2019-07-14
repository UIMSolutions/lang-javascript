module uim.javascript;

// Libraries
public import uim.core;
public import uim.oop;

// Modules
public import uim.javascript.js;
public import uim.javascript.obj;
public import uim.javascript.command;

@safe class DJSRoot {
	@safe this() {}

	@safe override string toString() { return ""; }
}



string jsFunc(string content) { return "function(){ %s }".format(content); } 
string jsFunc(string[] parameters, string content) { return "function(%s){ %s }".format(parameters.join(", "), content); } 

unittest {
	writeln("Testing ", __MODULE__);

	auto js = JS.If("x > 0", "do something;");
	assert(JS.Func() == "function(){}");
	writeln(JS.Func().Func("return 1;"));
	writeln(JS.Func().Func(js));
	writeln(JS.Func().Func(JS.If("x > 0", "do something;")));

	assert(JS.Switch("value", ["1": "do something;"]) == "switch(value){case 1: do something; break;}"); 
	assert(JS.Switch("value", ["1": "do something;"], "do the rest;") == "switch(value){case 1: do something; break;default: do the rest;}"); 
		
	writeln(JS.Object(["name":"wert"]));
		
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