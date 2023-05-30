module langs.javascript.functions.elements;

import langs.javascript;
@safe:

string jsBlock(DJS someContent, DJS[] someContents...) { 
  return jsBlock(someContent~someContents); 
}

string jsBlock(DJS[] someContents) {
  return jsBlock(
    someContents.map!(c => c.toString).array); 
}

string jsBlock(string[] someContents...) { 
  return jsBlock(someContents.dup); 
}

string jsBlock(string[] someContents) { 
  return "{"~someContents.join()~"}"; 
}

version(test_uim_javascript) { unittest {
	assert(jsBlock() == "{}");
	assert(jsBlock("return;") == "{return;}");
  assert(jsBlock("var a=2;") == "{var a=2;}");
  assert(jsBlock(JS.var("a", "2")) == "{var a=2;}");
}}
