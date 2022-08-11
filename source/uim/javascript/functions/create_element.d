module uim.javascript.functions.create_element;

import uim.javascript;

auto jsCreateElement(string tag) {
	return "document.createElement('%s')".format(tag);
}
version(test_uim_javascript) { unittest {
  assert(jsCreateElement("div") == "document.createElement('div')");
}}

auto jsCreateElement(string target, string tag, string text = null) {
	string result;
	result ~= jsLet(target, jsCreateElement(tag));
	if (target) {
		if (text.length > 0) {
      result ~= jsLet("node", "document.createTextNode('%s')".format(text.replace("'", "\\'"))); 
      result ~= target~`.appendChild(node);`;
    }
		return  result;
	}
	return jsCreateElement(tag);
}
version(test_uim_javascript) { unittest {
	assert(jsCreateElement("a", "b") == "let a=document.createElement('b');");
	assert(jsCreateElement("a", "b", "text") == "let a=document.createElement('b');let node=document.createTextNode('text');a.appendChild(node);");
}}

auto jsCreateElement(string target, string tag, STRINGAA attributes, string text = null) {
	string results = jsCreateElement(target, tag, text);
	if (target) foreach(k, v; attributes) results ~= "%s.setAttribute('%s','%s');".format(target, k, v);
	return results;
}
version(test_uim_javascript) { unittest {
	assert(jsCreateElement("a", "b", ["c":"d"]) == "let a=document.createElement('b');a.setAttribute('c','d');");
}}

auto jsCreateElement(string target, string tag, string[] classes, string text = null) {
	string results = jsCreateElement(target, tag, text);
	if (target) foreach(c; classes) results ~= "%s.classList.add('%s');".format(target, c);
	return results;
}
version(test_uim_javascript) { unittest {
	assert(jsCreateElement("a", "b", ["c":"d"]) == "let a=document.createElement('b');a.setAttribute('c','d');");
}}

auto jsCreateElement(string target, string tag, string[] classes, STRINGAA attributes, string text = null) {
	string results = jsCreateElement(target, tag, classes, text);
	if (target) foreach(k, v; attributes) results ~= "%s.setAttribute('%s','%s');".format(target, k, v);
	return results;
}
version(test_uim_javascript) { unittest {
	assert(jsCreateElement("a", "b", ["c":"d"]) == "let a=document.createElement('b');a.setAttribute('c','d');");
}}