module uim.javascript.js;

import uim.javascript;

class DJS {
    protected string[string] _parameters;

	this() {}
	this(string[string] someParameters) { this(); _parameters = someParameters; }

	@safe string[] _jsCode;

	@safe O opCall(this O)(string value) { _jsCode ~= value; return cast(O)this; }
	@safe O opCall(this O)(DJS value) { _jsCode ~= value.toString; return cast(O)this; }

	@safe bool opEquals(string value) {
		return toString() == value;
	}

	@safe string obj(string[string] values) {
		string[] entries;
		foreach(k, v; values) {
			entries ~= "%s:%k".format(k,v);
		}
		return "{ %s }".format(entries.join(" "));
	}

	@safe string block(DJS content) { return block(content.toString); } 
	@safe string block(string content) { return `{`~content~`}`; } 
    unittest {
        assert(JS.block("var a=2;") == "{var a=2;}");
        assert(JS.block(JS.Var("a", "2")) == "{var a=2;}");
    }

	@safe string andConditions(string[] conditions) {
        string[] cs; 
        foreach(condition; conditions) {
            if (condition.startsWith("(")) cs~= condition; else cs ~= "("~condition~")"; 
        }
        return cs.join("&&"); } 
    unittest {
        assert(JS.andConditions(["a>b"]) == "(a>b)");
        assert(JS.andConditions(["(a>b)"]) == "(a>b)");
        assert(JS.andConditions(["a>b", "c===d"]) == "(a>b)&&(c===d)");
        assert(JS.andConditions(["(a>b)", "c===d"]) == "(a>b)&&(c===d)");
    }

	@safe O Func(this O)() { _jsCode ~= "function(){}"; return cast(O)this; } 
	@safe O Func(this O)(string content) { _jsCode ~= "function()%s".format(block(content)); return cast(O)this; } 
	@safe O Func(this O)(DJS content) { _jsCode ~= "function()%s".format(block(content)); return cast(O)this; } 
	@safe O Func(this O)(string name, string content) { _jsCode ~= "function %s()%s".format(name, block(content)); return cast(O)this; } 
	@safe O Func(this O)(string name, DJS content) { _jsCode ~= "function %s()%s".format(name, block(content)); return cast(O)this; } 
	@safe O Func(this O)(string[] parameters, string content) { _jsCode ~= "function(%s)%s".format(parameters.join(", "), block(content)); return cast(O)this; } 
	@safe O Func(this O)(string name, string[] parameters, string content) { _jsCode ~= "function %s(%s)%s".format(name, parameters.join(", "), block(content)); return cast(O)this; }
	@safe O Func(this O)(string name, string[] parameters, DJS content) { _jsCode ~= "function %s(%s)%s".format(name, parameters.join(", "), block(content)); return cast(O)this; }
    unittest {
        writeln(JS.Func().Func("return 1;"));
        assert(JS.Func().Func("return 1;") == "function(){}function(){return 1;}");
        assert(JS.Func("test", "return 1;") == "function test(){return 1;}");
        assert(JS.Func(["a", "b"], "return 1;") == "function(a, b){return 1;}");
        assert(JS.Func("test", ["a", "b"], "return 1;") == "function test(a, b){return 1;}");
    }

	@safe O Switch(this O)(string expression, string[string] cases, string defaultCase = null) {
		string result = "switch(%s){".format(expression);
		foreach(k, v; cases) result ~= "case %s: %s break;".format(k, v);
		if (defaultCase) result ~= "default: %s".format(defaultCase);
		_jsCode ~= result ~ "}"; 
		return cast(O)this; }

	@safe O If(this O)(string condition, string content) { 
		_jsCode ~= "if (%s)".format(condition)~block(content); 
		return cast(O)this; }
	@safe O Else(this O)(string content) { 
		_jsCode ~= "else "~block(content); 
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
		_jsCode ~= block(result.join(","));
		return cast(O)this;	} 

	@safe O ForOf(this O)(string variable, string source, string statement) {
		_jsCode ~= "for (let %s of %s)".format(variable, source)~block(statement);
		return cast(O)this;
	}
	@safe O ForIn(this O)(string variable, string source, string statement) {
		_jsCode ~= "for (let %s in %s)".format(variable, source)~block(statement);
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	@safe O ForEach(this O)(string variable, string content, bool withIndex = true) {
		_jsCode ~= "%s.forEach(function (element %s) { %s });".format(variable, (withIndex) ? ", index" : "", content);
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	@safe O Try(this O)(string content) { 
		_jsCode ~= "try { %s }".format(content); 
		return cast(O)this; }
    unittest {
        ///TODO        
    }

	@safe O Catch(this O)(string content, string errorName = "e") { 
		_jsCode ~= "catch (%s) { %s }".format(errorName, content); 
		return cast(O)this; }
    unittest {
        ///TODO        
    }

	@safe O CatchIf(this O)(string errorType, string content, string errorName = "e") { 
		_jsCode ~= "catch (%s if %s instanceof %s) { %s }".format(errorName, errorName, errorType, content); 
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	@safe O Finally(this O)(string content) { 
		_jsCode ~= "finally { %s }".format(content); 
		return cast(O)this; }
    unittest {
        ///TODO        
    }

	@safe O Constructor(this O)(string variable, string content) {
		_jsCode ~= "constructor(%s) { %s }".format(variable, content);
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	@safe O Get(this O)(string name, string content) {
		_jsCode ~= "get %s() { %s }".format(name, content);
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	@safe O Set(this O)(string name, string[] parameters, string content) {
		_jsCode ~= "set %s(%s) { %s }".format(name, parameters.join(", "), content);
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	@safe O Array(this O)(string[] items) { 
		_jsCode ~= "["~items.join(",")~"]"; 
		return cast(O)this; }
    unittest {
        ///TODO        
    }

    @safe O Let(this O)(string name, string value) { 
		_jsCode ~= "let %s=%s;".format(name, value); 
		return cast(O)this; }
    unittest {
        ///TODO        
    }
    
    @safe O Var(this O)(string name, string value = null) { 
        if (value !is null)
		_jsCode ~= "var %s=%s;".format(name, value);
		else
        _jsCode ~= "var %s;".format(name);
		return cast(O)this; }
    unittest {
        assert(JS.Var("a") == "var a;");
        assert(JS.Var("a", "1") == "var a=1;");
    }

    @safe O Var(this O)(string[string] declarations) {
        string[] declas;
        string[] keys; foreach(key, name; declarations) keys ~= key; keys = keys.sort.array;
        foreach(key; keys) declas ~= key~"="~declarations[key]; 
		_jsCode ~= "var %s;".format(declas.join(",")); 
		return cast(O)this; }
    unittest {
        assert(JS.Var(["a":"1"]) == "var a=1;");
        assert(JS.Var(["a":"1", "b":"2"]) == "var a=1,b=2;");
    }        

	override string toString() { return _jsCode.join(""); }	
}
auto JS() { return new DJS(); }
auto JS(string[string] someParameters) { return new DJS(someParameters); }

unittest {
    assert(JS.Var("a", "1") == "var a=1;");
    assert(JS.Var(["a":"1"]) == "var a=1;");
    assert(JS.Var(["a":"1", "b":"2"]) == "var a=1,b=2;");
    assert(JS.Var("a", "1").Var("b", "2") == "var a=1;var b=2;");
}