module langs.javascript.error;

@safe:
import langs.javascript;

auto  jsTryCatch(string tryContent, string catchContent) {
  return "try{%s}catch(error){%s}".format(tryContent, catchContent);
}