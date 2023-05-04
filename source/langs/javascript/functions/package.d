module langs.javascript.functions;

@safe:
import langs.javascript;

public import langs.javascript.functions.elements;
public import langs.javascript.functions.create_element;

string jsOr(string[] conditions...) { return jsOr(conditions); }
string jsOr(string[] conditions) {
    if (conditions.length == 0) return "";
    string[] cs; 
    foreach(condition; conditions) if (condition.length > 0) cs~= (condition.indexOf("(") == 0 ? condition : "("~condition~")"); 
    if (conditions.length == 1) return cs[0]; 
    return "("~cs.join("||")~")"; } 

string jsAnd(string[] conditions...) { return jsAnd(conditions); }
string jsAnd(string[] conditions) {
    if (conditions.length == 0) return "";
    string[] cs; 
    foreach(condition; conditions) if (condition.length > 0) cs~= (condition.indexOf("(") == 0 ? condition : "("~condition~")"); 
    if (conditions.length == 1) return cs[0]; 
    return "("~cs.join("&&")~")"; } 
version(test_uim_javascript) { unittest {
    assert(jsAnd("a>b") == "(a>b)");
    assert(jsAnd("(a>b)") == "(a>b)");
    assert(jsAnd("a>b", "c===d") == "((a>b)&&(c===d))");
    assert(jsAnd("(a>b)", "c===d") == "((a>b)&&(c===d))");

    assert(jsAnd(["a>b"]) == "(a>b)");
    assert(jsAnd(["(a>b)"]) == "(a>b)");
    assert(jsAnd(["a>b", "c===d"]) == "((a>b)&&(c===d))");
    assert(jsAnd(["(a>b)", "c===d"]) == "((a>b)&&(c===d))");
}}

string jsArray() { return "[]"; }
string jsArray(string[] values) { return "["~values.join(",")~"]"; }
version(test_uim_javascript) { unittest {
	assert(jsArray() == "[]");
	assert(jsArray(["a", "b"]) == "[a,b]");
}}

string jsObject(string[string] values, bool sorted = true) {
	string[] props;
	foreach(k; values.getKeys(sorted)) props ~= k~":"~values[k];
	return "{"~props.join(",")~"}"; }
version(test_uim_javascript) { unittest {
	assert(jsObject(["a":"1", "b":"2"]) == "{a:1,b:2}");
}}

string jsFCall(string name = "") { return "%s()".format(name); } 
string jsFCall(string name, string[] parameters) { return "%s(%s)".format(name, parameters.join(",")); } 
version(test_uim_javascript) { unittest {
	assert(jsFCall("fn") == "fn()");
	assert(jsFCall("fn", ["a", "b"]) == "fn(a,b)");
}}

string jsOCall(string name = "") { return ".%s()".format(name); } 
string jsOCall(string name, string[] parameters) { return ".%s(%s)".format(name, parameters.join(",")); } 
version(test_uim_javascript) { unittest {
	assert(jsOCall("fn") == ".fn()");
	assert(jsOCall("fn", ["a", "b"]) == ".fn(a,b)");
}}

// Building javascript functions
string jsFunc(DJS content) { return jsFunc(content.toString); } 
string jsFunc(string[] parameters, DJS content) { return jsFunc(parameters, content.toString);  } 
string jsFunc(string name, string[] parameters, DJS content) { return jsFunc(name, parameters, content.toString);  } 

string jsFunc(string content) { return "function()%s".format(jsBlock(content)); } 
string jsFunc(string[] parameters, string content) { return "function(%s)%s".format(parameters.join(","), jsBlock(content)); } 
string jsFunc(string name, string content) { return "function %s()%s".format(name, jsBlock(content)); } 
string jsFunc(string name, string[] parameters, string content) { return "function %s(%s)%s".format(name, parameters.join(","), jsBlock(content)); } 
version(test_uim_javascript) { unittest {
	assert(jsFunc("return;") == "function(){return;}");
	assert(jsFunc(["a", "b", "c"], "return;") == "function(a,b,c){return;}");
	assert(jsFunc("fn", ["a", "b", "c"], "return;") == "function fn(a,b,c){return;}");
}}

string jsLambda(string name, string content) { return "%s=>%s".format(name, jsBlock(content)); } 

// Building javascript async functions
string jsAsync(DJS content) { return jsAsync(content.toString); } 
string jsAsync(string[] parameters, DJS content) { return jsAsync(parameters, content.toString);  } 
string jsAsync(string name, string[] parameters, DJS content) { return jsAsync(name, parameters, content.toString);  } 
string jsAsync(string content) { return "async function()%s".format(jsBlock(content)); } 
string jsAsync(string[] parameters, string content) { return "async function(%s)%s".format(parameters.join(","), jsBlock(content)); } 
string jsAsync(string name, string content) { return "async function %s()%s".format(name, jsBlock(content)); } 
string jsAsync(string name, string[] parameters, string content) { return "async function %s(%s)%s".format(name, parameters.join(","), jsBlock(content)); } 
version(test_uim_javascript) { unittest {
	assert(jsAsync("return;") == "async function(){return;}");
	assert(jsAsync(["a", "b", "c"], "return;") == "async function(a,b,c){return;}");
	assert(jsAsync("fn", ["a", "b", "c"], "return;") == "async function fn(a,b,c){return;}");
}}

string jsMethod(string name, string content) { return "%s()%s".format(name, jsBlock(content)); } 
string jsMethod(string name, string[] parameters, string content) { return "%s(%s)%s".format(name, parameters.join(","), jsBlock(content)); } 
version(test_uim_javascript) { unittest {
	assert(jsMethod("fn", "return;") == "fn(){return;}");
	assert(jsMethod("fn", ["a", "b", "c"], "return;") == "fn(a,b,c){return;}");
}}

version(test_uim_javascript) { unittest {
	auto js = JS.If("x > 0", "do something;");
	assert(JS.Func() == "function(){}");

	assert(JS.Switch("value", ["1": "do something;"]) == "switch(value){case 1: do something; break;}"); 
	assert(JS.Switch("value", ["1": "do something;"], "do the rest;") == "switch(value){case 1: do something; break;default: do the rest;}"); 
		
	assert(JS.Constructor("variable", "content") == "constructor(variable){content}");
	assert(JS.Get("name", "content") == "get name(){content}");
	assert(JS.Set("name", ["A", "B"], "content") == "set name(A, B){content}");
}}

auto jsThen(string code) { return ".then(function (response) { %s })".format(code); }
auto jsCatch(string code) { return ".catch(function (error) { %s })".format(code); }

auto jsImports(string[string] imports) {
	string result;
	foreach(k,v; imports) if (v) result~=`import %s from "%s";`.format(v, k); else `import "%s";`.format(k);
	return result;
} 

auto jsFor(string init, string condition, string finalize, string content) { 
  return "for(%s;%s;%s){%s}".format(init, condition, finalize, content); }

auto jsForIn(string item, string items, string content) { return "for(let %s in %s){%s}".format(item, items, content); }
auto jsForOf(string item, string items, string content) { return "for(let %s ofs %s){%s}".format(item, items, content); }

// Generates class definition - Classes in JavaScript are templates for JavaScript Objects.
auto jsClass(string className, string[] methods) {
	return "class %s{%s}".format(className, methods.join(""));
}
auto jsClass(string className, string superClass, string[] methods) {
	return "class %s extends %s{%s}".format(className, superClass, methods.join(""));
}
version(test_uim_javascript) { unittest {
	/// TODO
}}

auto jsClassExtends(string superName, string name, string[] superFields, string[] newFields, string[] methods) {
	string setFields;
	foreach(field; newFields) setFields ~= "this.%s=%s;".format(field, field);
	return "class %s extends %s{constructor(%s){super(%);%s}%s}".format(name, superName, superFields.join(","), (superFields~newFields).join(","), setFields, methods.join(""));
}
auto jsClassExtends(string superName, string name, string[] superFields, string[] newFields, string methods = null) {
	string setFields;
	foreach(field; newFields) setFields ~= "this.%s=%s;".format(field, field);
	return "class %s extends %s{constructor(%s){super(%s);%s}%s}".format(name, superName, superFields.join(","), (superFields~newFields).join(","), setFields, methods);
}
version(test_uim_javascript) { unittest {
	/// TODO
}}

auto jsWhile(string[] conditions, string content) { return jsWhile(jsAnd(conditions), content); }
auto jsWhile(string condition, string content) { return "while%s%s".format(condition, jsBlock(content)); }
version(test_uim_javascript) { unittest {
	assert(jsWhile(["(a>b)", "(b<10)"], "b++;") == "while((a>b)&&(b<10)){b++;}");
	assert(jsWhile("(a>b)", "b++;") == "while(a>b){b++;}");
}}

auto jsConst(string[string] settings) { 
	string result;
	foreach(k, v; settings) result ~= jsConst(k, v);
	return result;	
 }
auto jsConst(string name, string setting) { return "const %s=%s;".format(name, setting); }
version(test_uim_javascript) { unittest {
	///
}}

auto jsLet(string[string] settings) { 
	string result;
	foreach(k, v; settings) result ~= jsLet(k, v);
	return result;	
 }
auto jsLet(string name, string setting = null) { 
	if (setting) return "let %s=%s;".format(name, setting); 
	return "let %s;".format(name); }
version(test_uim_javascript) { unittest {
	///
}}

auto jsForEach(string arrayName, string content) {
	return "%s.forEach(%s);".format(arrayName, content);
}
version(test_uim_javascript) { unittest {
	///
}}
auto jsForEach(string arrayName, string item, string content) {
	return "%s.forEach(%s=>%s);".format(arrayName, item, jsBlock(content));
}
version(test_uim_javascript) { unittest {
	///
}}



auto jsAppendChilds(string target, string[] childs...) {
	string results;
	foreach(c; childs) results ~= "%s.appendChild(%s);".format(target, c);
	return results;
}
version(test_uim_javascript) { unittest {
	writeln(jsAppendChilds("a", "b"));
	assert(jsAppendChilds("a", "b") == "a.appendChild(b);");
}}

auto defineCustomElements(string[string] elements) {
	string results;
	foreach(k, v; elements) results ~= defineCustomElements(k, v);
	return results;
}
auto defineCustomElements(string tag, string className) {
	return "customElements.define('%s', %s);".format(tag, className);
}

auto jsElementById(STRINGAA elements) {
  string result;
  foreach(k,v; elements) result ~= jsLet(k, jsElementById(v));
	return result;
}
auto jsElementById(string[] elements) {
  string result;
  elements.each!(a => result ~= jsLet(a, jsElementById(a)));
	return result;
}
auto jsElementById(string id) {
	return `document.getElementById("%s")`.format(id);
}
auto jsElementById(string target, string id) {
	return `%s=document.getElementById("%s");`.format(target, id);
}


auto jsFetch(string url, string[] thens = null) {
	string result = "fetch(%s)".format(url);
	foreach(t; thens) result ~= ".then(%s)".format(t);
	return result~";";
} 
version(test_uim_javascript) { unittest {
	assert(jsFetch("'/abc/dec'") == "fetch('/abc/dec');");
}}

auto jsFetch(string url, string[string] options, string[] thens = null, string catch_ = null) {
	string result = "fetch(%s,%s)".format(url, toJS(options));
	foreach(t; thens) result ~= ".then(%s)".format(t);
  if (catch_.length > 0) result ~= ".catch(%s)".format(catch_);
	return result~";";
} 
version(test_uim_javascript) { unittest {
	assert(jsFetch("'/abc/dec'", ["a":"b"]) == "fetch('/abc/dec',{a:b});");	
}}
