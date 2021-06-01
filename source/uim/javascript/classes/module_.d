module uim.javascript.classes.module_;

import uim.javascript;

@safe:

class DJSModule {
    this() {}

    protected string[] _imports;    
	O imports(this O)(string[string] someImports) { foreach(k, v; someImports) this.imports(k, v); return cast(O)this; }
	O imports(this O)(string anName, string fromFile) { this.imports(anName~" from '"~fromFile~"'"); return cast(O)this; }
	O imports(this O)(string[] someImports) { foreach(imp; someImports) this.imports(imp); return cast(O)this; }
	O imports(this O)(string anImport) { _imports ~= "import "~anImport~";"; return cast(O)this; }
	unittest {
		assert(JSModule.imports(["name":"file.js"]) == "import name from 'file.js';");
		assert(JSModule.imports(["name from 'file.js'", "othername from 'otherfile.js'"]) == "import name from 'file.js';import othername from 'otherfile.js';");

		assert(JSModule.imports("name", "file.js") == "import name from 'file.js';");
		assert(JSModule.imports("name from 'file.js'") == "import name from 'file.js';");
	}

	protected string[] _exports;
	O exportsDefault(this O)(DJS anExport) { this.exportsDefault(anExport.toString); return cast(O)this; }
	O exportsDefault(this O)(string anExport) { this.exports("default "~anExport); return cast(O)this; }
	O exports(this O)(DJS[] someExport) { foreach(ex; someExports) this.exports(ex); return cast(O)this; }
	O exports(this O)(string[] someExports) { foreach(ex; someExports) this.exports(ex); return cast(O)this; }
	O exports(this O)(DJS anExport) { this.exports(anExport.toString); return cast(O)this; }
	O exports(this O)(string anExport) { _exports ~= "export "~anExport~";"; return cast(O)this; }
	unittest {
		assert(JSModule.exportsDefault("{ var a = 1; }") == "export default { var a = 1; };");
		assert(JSModule.exports(["const foo = Math.sqrt(2)"]) == "export const foo = Math.sqrt(2);");
		assert(JSModule.exports("const foo = Math.sqrt(2)") == "export const foo = Math.sqrt(2);");
	}

    mixin(TProperty!("string", "content"));
	O content(this O)(DJS js) { _content = js.toString; return cast(O)this; }

	bool opEquals(string txt) { return (txt == toString); }
	override string toString() {
        if (!content) {
            string result;
            result ~= _imports.join("");
            result ~= _exports.join("");
            content = result; }
        return content;
	}
}
auto JSModule() { return new DJSModule; }