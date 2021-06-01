module uim.javascript.error;

@safe:
import uim.javascript;

auto  jsTryCatch(string tryContent, string catchContent) {
  return "try{%s}catch(error){%s}".format(tryContent, catchContent);
}