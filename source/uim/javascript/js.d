module uim.javascript.js;

import uim.javascript;

class DJS {
    protected string[string] _parameters;

	this() {}
	this(string[string] someParameters) { this(); _parameters = someParameters; }

	string[] _jsCode;

	O opCall(this O)(string value) { _jsCode ~= value; return cast(O)this; }
	O opCall(this O)(DJS value) { _jsCode ~= value.toString; return cast(O)this; }

	bool opEquals(string value) {
		return toString() == value;
	}

	string obj(string[string] values) {
		string[] entries;
		foreach(k, v; values) {
			entries ~= "%s:%k".format(k,v);
		}
		return "{ %s }".format(entries.join(" "));
	}

	O Func(this O)() { _jsCode ~= "function(){}"; return cast(O)this; } 
	O Func(this O)(string content) { _jsCode ~= "function()%s".format(block(content)); return cast(O)this; } 
	O Func(this O)(DJS content) { _jsCode ~= "function()%s".format(block(content)); return cast(O)this; } 
	O Func(this O)(string name, string content) { _jsCode ~= "function %s()%s".format(name, block(content)); return cast(O)this; } 
	O Func(this O)(string name, DJS content) { _jsCode ~= "function %s()%s".format(name, block(content)); return cast(O)this; } 
	O Func(this O)(string[] parameters, string content) { _jsCode ~= "function(%s)%s".format(parameters.join(","), block(content)); return cast(O)this; } 
	O Func(this O)(string name, string[] parameters, string content) { _jsCode ~= "function %s(%s)%s".format(name, parameters.join(","), block(content)); return cast(O)this; }
	O Func(this O)(string name, string[] parameters, DJS content) { _jsCode ~= "function %s(%s)%s".format(name, parameters.join(","), block(content)); return cast(O)this; }
    unittest {
        assert(JS.Func().Func("return 1;") == "function(){}function(){return 1;}");
        assert(JS.Func().Func("return 1;") == "function(){}function(){return 1;}");
        assert(JS.Func("test", "return 1;") == "function test(){return 1;}");
        assert(JS.Func(["a", "b"], "return 1;") == "function(a,b){return 1;}");
        assert(JS.Func("test", ["a", "b"], "return 1;") == "function test(a,b){return 1;}");
    }

	O Switch(this O)(string expression, DJS[string] cases, string defaultCase = null) {
		string[string] results;
		foreach(k,v; cases) results[k] = v.toString;
		return this.Switch(expression, results, defaultCase);
	}
	O Switch(this O)(string expression, string[string] cases, string defaultCase = null) {
		string result = "switch(%s){".format(expression);
		foreach(k, v; cases) result ~= "case %s: %s break;".format(k, v);
		if (defaultCase) result ~= "default: %s".format(defaultCase);
		_jsCode ~= result ~ "}"; 
		return cast(O)this; }

	O If(this O)(string condition, DJS content) { return this.If(condition, content.toString); } 
	O If(this O)(string condition, string content) { 
		_jsCode ~= "if(%s)".format(condition)~block(content); 
		return cast(O)this; }
	unittest {
		assert(JS.If("A>B", "do something;") == "if(A>B){do something;}");
	}

	O Else(this O)(DJS content) { return this.Else(content.toString); }
	O Else(this O)(string content) { 
		_jsCode ~= "else"~block(content); 
		return cast(O)this; }
	unittest {
		/// TODO
	}

	O IfElse(this O)(string condition, DJS ifContent, string elseContent) { return this.IfElse(condition, ifContent.toString, elseContent); } 
	O IfElse(this O)(string condition, string ifContent, DJS elseContent) { return this.IfElse(condition, ifContent, elseContent.toString); } 
	O IfElse(this O)(string condition, DJS ifContent, DJS elseContent)    { return this.IfElse(condition, ifContent.toString, elseContent.toString); } 
	O IfElse(this O)(string condition, string ifContent, string elseContent) { 
		_jsCode ~= JS.If(condition, ifContent).toString~" "~JS.Else(elseContent).toString; 
		return cast(O)this; }
	unittest {
		assert(JS.IfElse("A>B", "do something;", "do something else;") == "if(A>B){do something;} else{do something else;}");
		assert(JS.IfsElse(["A>B"], ["do something;"], "do something else;") == "if(A>B){do something;} else{do something else;}");
		assert(JS.IfsElse(["A>B", "C>D"], ["do something;","or do this;"]) == "if(A>B){do something;} else if(C>D){or do this;}");
		assert(JS.IfsElse(["A>B", "C>D"], ["do something;","or do this;"], "do something else;") == "if(A>B){do something;} else if(C>D){or do this;} else{do something else;}");
	}

	O IfsElse(this O)(string[] conditions, string[] ifContents, string elseContent = null) { 
		string result = JS.If(conditions[0], ifContents[0]).toString;
		if (conditions.length > 1) for(size_t i = 1; i < conditions.length; i++) result ~= " else "~JS.If(conditions[i], ifContents[i]).toString;
		if (elseContent) result ~= " "~JS.Else(elseContent).toString; 
		_jsCode ~= result;
		return cast(O)this; }

	O Object(this O)(string[string] values) {
		string[] result;
		foreach(k, v; values) result ~= "%s:%s".format(k, v);
		_jsCode ~= block(result.join(","));
		return cast(O)this;	} 

	O ForOf(this O)(string variable, string source, DJS statement) { return this.ForOf(variable, source, statement.toString); }
	O ForOf(this O)(string variable, string source, string statement) {
		_jsCode ~= "for(let %s of %s)".format(variable, source)~block(statement);
		return cast(O)this;
	}
    unittest {
        assert(JS.ForOf("item", "items", "document.write(item);") == `for(let item of items){document.write(item);}`);
    }

	O ForIn(this O)(string variable, string source, DJS statement) { return this.ForIn(variable, source, statement.toString); }
	O ForIn(this O)(string variable, string source, string statement) {
		_jsCode ~= "for(let %s in %s)".format(variable, source)~block(statement);
		return cast(O)this;	}
    unittest {
        assert(JS.ForIn("item", "items", "counter++;") == `for(let item in items){counter++;}`);
    }

	O ForEach(this O)(string variable, DJS content, bool withIndex = true) { return this.ForEach(variable, content.toString, withIndex); }
	O ForEach(this O)(string variable, string content, bool withIndex = true) {
		_jsCode ~= "%s.forEach(function (element %s) { %s });".format(variable, (withIndex) ? ", index" : "", content);
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	O Try(this O)(DJS content) { return this.Try(content.toString); }
	O Try(this O)(string content) { 
		_jsCode ~= "try%s".format(block(content)); 
		return cast(O)this; }
    unittest {
		assert(JS.Try("content") == "try{content}");
    }

	O Catch(this O)(DJS content, string errorName = "e") { return this.Catch(content.toString, errorName); }
	O Catch(this O)(string content, string errorName = "e") { 
		_jsCode ~= "catch(%s)%s".format(errorName, block(content)); 
		return cast(O)this; }
    unittest {
		assert(JS.Catch("content", "error") == "catch(error){content}");
		assert(JS.CatchIf("errorType", "content") == "catch(e if e instanceof errorType){content}");
		assert(JS.CatchIf("errorType", "content", "errorName") == "catch(errorName if errorName instanceof errorType){content}");
    }

	O CatchIf(this O)(string errorType, string content, string errorName = "e") { 
		_jsCode ~= "catch(%s if %s instanceof %s)%s".format(errorName, errorName, errorType, block(content)); 
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	O Finally(this O)(DJS content) { return this.Finally(content.toString); }
	O Finally(this O)(string content) { 
		_jsCode ~= "finally%s".format(block(content)); 
		return cast(O)this; }
    unittest {
		assert(JS.Finally("content") == "finally{content}");
    }

	O Constructor(this O)(string variable, DJS content) { return this.Constructor(variable, content.toString); }
	O Constructor(this O)(string variable, string content) {
		_jsCode ~= "constructor(%s)%s".format(variable, block(content));
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	/*
	DE: Get - bindet eine Objekteigenschaft an eine Funktion welche aufgerufen wird, wenn die Eigenschaft abgefragt wird.
	*/
	O Get(this O)(string name, DJS content) { return this.Get(name, content.toString); }
	O Get(this O)(string name, string content) {
		_jsCode ~= "get %s()%s".format(name, block(content));
		return cast(O)this;	}
    unittest {
        assert(JS.Get("abc", "xyz") == "get abc(){xyz}");       
    }

	/*
	DE: Löschen eines Getters
	*/
	O DeleteGet(this O)(string objName, string getName){ 
		_jsCode ~= "delete %s.%s;".format(objName, getName);
		return cast(O)this;	}
    unittest {
        // assert(JS.DeleteGet("abc", "xyz") == "get abc(){xyz}");       
    }

	O Set(this O)(string name, string[] parameters, DJS content) { return this.Set(name, parameters, content.toString); }
	O Set(this O)(string name, string[] parameters, string content) {
		_jsCode ~= "set %s(%s)%s".format(name, parameters.join(", "), block(content));
		return cast(O)this;	}
    unittest {
        ///TODO        
    }

	O array(this O)(string[] items) { 
		_jsCode ~= "["~items.join(",")~"]"; 
		return cast(O)this; }
    unittest {
        assert(JS.array(["1", "2", "3"]) == "[1,2,3]");        
    }

    O let(this O)(string name, string value) { 
		_jsCode ~= "let %s=%s;".format(name, value); 
		return cast(O)this; }
    unittest {
        assert(JS.let("a", "'b'") == "let a='b';");       
    }
    
    O var(this O)(string name, string value = null) { 
			if (value !is null)
				_jsCode ~= "var %s=%s;".format(name, value);
			else
				_jsCode ~= "var %s;".format(name);
			return cast(O)this; }
		unittest {
        assert(JS.var("a") == "var a;");
        assert(JS.var("a", "1") == "var a=1;");
    }

    O var(this O)(string[string] declarations) {
			string[] declas;
			foreach(key; declarations.keys.sort) declas ~= key~"="~declarations[key]; 
			_jsCode ~= "var %s;".format(declas.join(",")); 
			return cast(O)this; }
    unittest {
        assert(JS.var(["a":"1"]) == "var a=1;");
        assert(JS.var(["a":"1", "b":"2"]) == "var a=1,b=2;");
    }        

	override string toString() { return _jsCode.join(""); }	
}
auto JS() { return new DJS(); }
auto JS(string[string] someParameters) { return new DJS(someParameters); }

unittest {
}