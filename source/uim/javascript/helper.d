module uim.javascript.helper;

import uim.javascript;

string jsAnd(string[] conditions...) {
      string[] cs; 
      foreach(condition; conditions) {
          if (condition.indexOf("(") == 0) cs~= condition; else cs ~= "("~condition~")"; 
      }
      return cs.join("&&"); } 
  unittest {
      assert(jsAnd("a>b") == "(a>b)");
      assert(jsAnd("(a>b)") == "(a>b)");
      assert(jsAnd("a>b", "c===d") == "(a>b)&&(c===d)");
      assert(jsAnd("(a>b)", "c===d") == "(a>b)&&(c===d)");
  }

string block(DJS content) { return block(content.toString); } 
string block(string content) { return `{`~content~`}`; } 
unittest {
    assert(block("var a=2;") == "{var a=2;}");
    assert(block(JS.var("a", "2")) == "{var a=2;}");
}
