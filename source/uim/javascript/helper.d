module uim.javascript.helper;

import uim.javascript;

string jsAnd(string[] conditions...) { return jsAnd(conditions); }
string jsAnd(string[] conditions) {
    if (conditions.length == 0) return "";
    string[] cs; 
    foreach(condition; conditions) if (condition.length > 0) cs~= (condition.indexOf("(") == 0 ? condition : "("~condition~")"); 
    if (conditions.length == 1) return cs[0]; 
    return "("~cs.join("&&")~")"; } 
unittest {
    assert(jsAnd("a>b") == "(a>b)");
    assert(jsAnd("(a>b)") == "(a>b)");
    assert(jsAnd("a>b", "c===d") == "((a>b)&&(c===d))");
    assert(jsAnd("(a>b)", "c===d") == "((a>b)&&(c===d))");

    assert(jsAnd(["a>b"]) == "(a>b)");
    assert(jsAnd(["(a>b)"]) == "(a>b)");
    assert(jsAnd(["a>b", "c===d"]) == "((a>b)&&(c===d))");
    assert(jsAnd(["(a>b)", "c===d"]) == "((a>b)&&(c===d))");
}

string jsBlock(DJS content) { return jsBlock(content.toString); } 
string jsBlock(string content) { return `{`~content~`}`; } 
unittest {
    assert(jsBlock("var a=2;") == "{var a=2;}");
    assert(jsBlock(JS.var("a", "2")) == "{var a=2;}");
}
