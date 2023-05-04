module langs.javascript;

mixin(ImportPhobos!());

// Dub libraries
public import vibe.d;

// UIM libraries
public import uim.core;
public import uim.oop;

// Local packages
public import langs.javascript.functions;
public import langs.javascript.classes;
public import langs.javascript.tools;
public import langs.javascript.error;
public import langs.javascript.conditional;

auto jsEvent(string target, string event, string listener) {
  return "%s.addEventListener(%s, %s);".format(target, event, listener);
}

auto jsReturn(string result) {
  return "return "~result~";";
}
