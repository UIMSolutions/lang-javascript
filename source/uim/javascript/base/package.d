module uim.javascript.base;

import uim.javascript;

@safe string toJS(T)(T[] values, bool sorted = false) {
  string[] result;
	if (sorted) 
    foreach(v; values.sort) result ~= to!string(v);
  else 
    foreach(v; values) result ~= to!string(v);
  return "["~result.join(",")~"]";
}

@safe string toJS(T)(T[string] values, bool sorted = false) {
	string[] keys;
	foreach(k, v; values) keys ~= k;
	if (sorted) keys = keys.sort.array;
	
	string[] result; 
	foreach(k; keys) result ~= k~":"~to!string(values[k]);
	return "{"~result.join(",")~"}";
}