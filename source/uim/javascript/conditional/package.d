module uim.javascript.conditional;

@safe:
import uim.javascript;

auto jsSwitch(string value, STRINGAA caseConditions, string defaultCondition = "break;") {
  string conditions;
  foreach(kv; caseConditions.byKeyValue) conditions ~= "case %s:%s".format(kv.key, kv.value);
  conditions ~= "default:%s".format(defaultCondition);
  return "switch("~value~")"~jsBlock(conditions);
}

// If statements
auto jsIf(STRINGAA ifConditions) { 
  string result;
  foreach(kv; ifConditions.byKeyValue) result ~= "if(%s){%s}".format(kv.key, kv.value);
  return result; } 
unittest {
// 
}

// If statement
auto jsIf(string condition, string content) { return "if(%s){%s}".format(condition, content); }
unittest {
// 
}

// ElseIf part of if- else-if statement
auto jsElseIf(string condition, string content) { return "else if(%s){%s}".format(condition, content); }
unittest {
// 
}

// Else part of if-else-statement
auto jsElse(string content) { return "else { %s }".format(content); }
unittest {
// 
}

// IfElse statement
auto jsIfElse(string condition, string ifContent, string elseContent) { 
	return jsIf(condition, ifContent)~jsElse(elseContent); }
unittest {
// 
}

auto jsIfElse(string condition, string ifContent, STRINGAA elseIfConditions, string elseCondition) { 
  string result;
  result ~= jsIf(condition, ifContent);
  foreach(kv; elseIfConditions.byKeyValue) result ~= jsElseIf(kv.key, kv.value);
  return result~jsElse(elseCondition); } 
unittest {
// 
}
