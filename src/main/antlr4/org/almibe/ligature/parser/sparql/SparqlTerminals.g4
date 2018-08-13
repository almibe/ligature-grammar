lexer grammar SparqlTerminals;

IRIREF //139
  : '<' IRI '>'
;

fragment IRI
  : (~('\u0000' .. '\u0020' | '<' | '>' | '"' | '{' | '}' | '|' | '^' | '`' | '\\') | UCHAR)+
;

fragment UCHAR //possible dupe
  : '\\u' HEX HEX HEX HEX | '\\U' HEX HEX HEX HEX HEX HEX HEX HEX
;

fragment HEX //possible dupe
  : '0' .. '9' | 'A' .. 'F' | 'a' .. 'f'
;

PNAME_NS //140
  : PN_PREFIX? ':'
;

PNAME_LN //141
  : PNAME_NS PN_LOCAL
;

BLANK_NODE_LABEL //142
  : '_:' ( PN_CHARS_U | '0' .. '9') ((PN_CHARS | '.')* PN_CHARS)?
;

