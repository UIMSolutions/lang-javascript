module uim.javascript;

// Standard libraries
public import std.stdio;
public import std.string;
public import std.uuid;

// Dub libraries
public import vibe.d;

// UIM libraries
public import uim.core;
public import uim.oop;

// Local packages
public import uim.javascript.functions;
public import uim.javascript.classes;
public import uim.javascript.tools;
public import uim.javascript.error;
public import uim.javascript.conditional;

auto jsEvent(string target, string event, string listener) {
  return "%s.addEventListener(%s, %s);".format(target, event, listener);
}

auto jsReturn(string result) {
  return "return "~result~";";
}
