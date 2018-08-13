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

VAR1 //143
  : '?' VARNAME
;

VAR2 //144
  : '$' VARNAME
;

LANGTAG //145
  : '@' ('a'..'z' | 'A' .. 'Z')+ ('-' ('a'..'z' | 'A'..'Z' | '0'..'9')+)*
;

INTEGER //146
  : ('0'..'9')+
;

DECIMAL //147
  : ('0'..'9')* '.' ('0'..'9')+
;

DOUBLE //148
  : ('0'..'9')+ '.' ('0'..'9')* EXPONENT | '.' ('0'..'9')+ EXPONENT | ('0'..'9')+ EXPONENT
;

INTEGER_POSITIVE //149
  : '+' INTEGER
;

DECIMAL_POSITIVE //150
  : '+' DECIMAL
;

DOUBLE_POSITIVE //151
  : '+' DOUBLE
;

INTEGER_NEGATIVE //152
  : '-' INTEGER
;

DECIMAL_NEGATIVE //153
  : '-' DECIMAL
;

DOUBLE_NEGATIVE //154
  : '-' DOUBLE
;

EXPONENT //155
  : ('e' | 'E') ('+'|'-')? ('0'..'9')+
;

