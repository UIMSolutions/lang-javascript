module langs.javascript.functions.elements;

import langs.javascript;

@safe:
string jsBlock(DJS content, DJS[] contents...) { return jsBlock(content~contents); }
string jsBlock(DJS[] contents) {
  string[] results;  
  foreach(c; contents) results ~= c.toString;
  return jsBlock(results); }
string jsBlock(string[] contents...) { return jsBlock(contents); }
string jsBlock(string[] contents) { return "{"~contents.join()~"}"; }
version(test_uim_javascript) { unittest {
	assert(jsBlock() == "{}");
	assert(jsBlock("return;") == "{return;}");
  assert(jsBlock("var a=2;") == "{var a=2;}");
  assert(jsBlock(JS.var("a", "2")) == "{var a=2;}");
}}
