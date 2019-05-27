module uim.js;

// Libraries
public import uim.core;
public import uim.oop;

// Modules
public import uim.js.obj;
public import uim.js.command;

@safe class DJSRoot {
	@safe this() {}

	@safe override string toString() { return ""; }
}

@safe class DJS {
	@safe this() {}

	@safe string[] _jsCode;

	@safe O opCall(this O)(string value) { _jsCode ~= value; return cast(O)this; }
	@safe O opCall(this O)(DJS value) { _jsCode ~= value.toString; return cast(O)this; }

	@safe bool opEquals(string value) {
		return toString() == value;
	}

	@safe 	string obj(string[string] values) {
		string[] entries;
		foreach(k, v; values) {
			entries ~= "%s:%k".format(k,v);
		}
		return "{ %s }".format(entries.join(" "));
	}

	@safe O Func(this O)() { _jsCode ~= "function(){}"; return cast(O)this; } 
	@safe O Func(this O)(string content) { _jsCode ~= "function(){ %s }".format(content); return cast(O)this; } 
	@safe O Func(this O)(DJS content) { _jsCode ~= "function(){ %s }".format(content); return cast(O)this; } 
	@safe O Func(this O)(string name, string content) { _jsCode ~= "function %s(){ %s }".format(name, content); return cast(O)this; } 
	@safe O Func(this O)(string name, DJS content) { _jsCode ~= "function %s(){ %s }".format(name, content); return cast(O)this; } 
	@safe O Func(this O)(string[] parameters, string content) { _jsCode ~= "function(%s){ %s }".format(parameters.join(", "), content); return cast(O)this; } 
	@safe O Func(this O)(string name, string[] parameters, string content) { _jsCode ~= "function %s(%s){ %s }".format(name, parameters.join(", "), content); return cast(O)this; }
	@safe O Func(this O)(string name, string[] parameters, DJS content) { _jsCode ~= "function %s(%s){ %s }".format(name, parameters.join(", "), content); return cast(O)this; }

	@safe O Switch(this O)(string expression, string[string] cases, string defaultCase = null) {
		string result = "switch(%s){".format(expression);
		foreach(k, v; cases) result ~= "case %s: %s break;".format(k, v);
		if (defaultCase) result ~= "default: %s".format(defaultCase);
		_jsCode ~= result ~ "}"; 
		return cast(O)this; }

	@safe O If(this O)(string condition, string content) { 
		_jsCode ~= "if (%s) { %s }".format(condition, content); 
		return cast(O)this; }
	@safe O Else(this O)(string content) { 
		_jsCode ~= "else { %s }".format(content); 
		return cast(O)this; }
	@safe O IfElse(this O)(string condition, string ifContent, string elseContent) { 
		_jsCode ~= JS.If(condition, ifContent).toString~" "~JS.Else(elseContent).toString; 
		return cast(O)this; }
	@safe O IfsElse(this O)(string[] conditions, string[] ifContents, string elseContent = null) { 
		string result = JS.If(conditions[0], ifContents[0]).toString;
		if (conditions.length > 1) for(size_t i = 1; i < conditions.length; i++) result ~= " else "~JS.If(conditions[i], ifContents[i]).toString;
		if (elseContent) result ~= " "~JS.Else(elseContent).toString; 
		_jsCode ~= result;
		return cast(O)this; }

	@safe O Object(this O)(string[string] values) {
		string[] result;
		foreach(k, v; values) result ~= "%s:%s".format(k, v);
		_jsCode ~= "{ %s }".format(result.join(","));
		return cast(O)this;	} 

	@safe O ForOf(this O)(string variable, string source, string statement) {
		_jsCode ~= "for (let %s of %s) { %s }".format(variable, source, statement);
		return cast(O)this;
	}
	@safe O ForIn(this O)(string variable, string source, string statement) {
		_jsCode ~= "for (let %s in %s) { %s }".format(variable, source, statement);
		return cast(O)this;	}

	@safe O ForEach(this O)(string variable, string content, bool withIndex = true) {
		_jsCode ~= "%s.forEach(function (element %s) { %s });".format(variable, (withIndex) ? ", index" : "", content);
		return cast(O)this;	}

	@safe O Try(this O)(string content) { 
		_jsCode ~= "try { %s }".format(content); 
		return cast(O)this; }
	@safe O Catch(this O)(string content, string errorName = "e") { 
		_jsCode ~= "catch (%s) { %s }".format(errorName, content); 
		return cast(O)this; }
	@safe O CatchIf(this O)(string errorType, string content, string errorName = "e") { 
		_jsCode ~= "catch (%s if %s instanceof %s) { %s }".format(errorName, errorName, errorType, content); 
		return cast(O)this;	}
	@safe O Finally(this O)(string content) { 
		_jsCode ~= "finally { %s }".format(content); 
		return cast(O)this; }

	@safe O Constructor(this O)(string variable, string content) {
		_jsCode ~= "constructor(%s) { %s }".format(variable, content);
		return cast(O)this;	}
	@safe O Get(this O)(string name, string content) {
		_jsCode ~= "get %s() { %s }".format(name, content);
		return cast(O)this;	}
	@safe O Set(this O)(string name, string[] parameters, string content) {
		_jsCode ~= "set %s(%s) { %s }".format(name, parameters.join(", "), content);
		return cast(O)this;	}
	@safe O Array(this O)(string[] items) { 
		_jsCode ~= "["~items.join(",")~"]"; 
		return cast(O)this; }

	override string toString() { return _jsCode.join(" "); }	
}
auto JS() { return new DJS(); }

string jsFunc(string content) { return "function(){ %s }".format(content); } 
string jsFunc(string[] parameters, string content) { return "function(%s){ %s }".format(parameters.join(", "), content); } 

unittest {
	writeln("Testing ", __MODULE__);

	auto js = JS.If("x > 0", "do something;");
	assert(JS.Func() == "function(){}");
	writeln(JS.Func().Func("return 1;"));
	writeln(JS.Func().Func(js));
	writeln(JS.Func().Func(JS.If("x > 0", "do something;")));
	assert(JS
		.Func()
		.Func("return 1;") == "function(){} function(){ return 1; }");
	assert(JS.Func("test", "return 1;") == "function test(){ return 1; }");
	assert(JS.Func(["a", "b"], "return 1;") == "function(a, b){ return 1; }");
	assert(JS.Func("test", ["a", "b"], "return 1;") == "function test(a, b){ return 1; }");

	assert(JS.Switch("value", ["1": "do something;"]) == "switch(value){case 1: do something; break;}"); 
	assert(JS.Switch("value", ["1": "do something;"], "do the rest;") == "switch(value){case 1: do something; break;default: do the rest;}"); 
	
	assert(JS.If("A>B", "do something;") == "if (A>B) { do something; }");
	assert(JS.IfElse("A>B", "do something;", "do something else;") == "if (A>B) { do something; } else { do something else; }");
	assert(JS.IfsElse(["A>B"], ["do something;"], "do something else;") == "if (A>B) { do something; } else { do something else; }");
	assert(JS.IfsElse(["A>B", "C>D"], ["do something;","or do this;"]) == "if (A>B) { do something; } else if (C>D) { or do this; }");
	assert(JS.IfsElse(["A>B", "C>D"], ["do something;","or do this;"], "do something else;") == "if (A>B) { do something; } else if (C>D) { or do this; } else { do something else; }");
	
	writeln(JS.Object(["name":"wert"]));
	
	assert(JS.Try("content") == "try { content }");
	assert(JS.Catch("content", "error") == "catch (error) { content }");
	assert(JS.CatchIf("errorType", "content") == "catch (e if e instanceof errorType) { content }");
	assert(JS.CatchIf("errorType", "content", "errorName") == "catch (errorName if errorName instanceof errorType) { content }");
	assert(JS.Finally("content") == "finally { content }");
	
	assert(JS.Constructor("variable", "content") == "constructor(variable) { content }");
	assert(JS.Get("name", "content") == "get name() { content }");
	assert(JS.Set("name", ["A", "B"], "content") == "set name(A, B) { content }");
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