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

STRING_LITERAL1 //156
  : '\'' (~('\u0027' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '\''
;

STRING_LITERAL2 //157
  : '"' ( ~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '"'
;

STRING_LITERAL_LONG1 //158
  : '\'\'\'' ( ( '\'' | '\'\'' )? ( ~('\\' | '\'') | ECHAR ) )* '\'\'\''
;

STRING_LITERAL_LONG2 //159
  : '"""' ( ( '"' | '""' )? ( ~('"' | '\\' ) | ECHAR ) )* '"""'
;

ECHAR //160
  : '\\' ('t' | 'b' | 'n' | 'r' | 'f' | '\\' | '"' | '\'' )
;

NIL //161
  : '(' WS* ')'
;

WS //162
  : '\u0020' | '\u0009' | '\u000D' | '\u000A'
;

ANON //163
  : '[' WS* ']'
;

PN_CHARS_BASE //164
  : ('A'..'Z')
  | ('a'..'z')
  | ('\u00C0'..'\u00D6')
  | ('\u00D8'..'\u00F6')
  | ('\u00F8'..'\u02FF')
  | ('\u0370'..'\u037D')
  | ('\u037F'..'\u1FFF')
  | ('\u200C'..'\u200D')
  | ('\u2070'..'\u218F')
  | ('\u2C00'..'\u2FEF')
  | ('\u3001'..'\uD7FF')
  | ('\uF900'..'\uFDCF')
  | ('\uFDF0'..'\uFFFD')
  | ('\u{10000}'..'\u{EFFFF}')
;

PN_CHARS_U //165
  : PN_CHARS_BASE | '_'
;

VARNAME //166
  : PN_CHARS_U | ('0'..'9' ) ( PN_CHARS_U | '0'..'9') | '\u00B7' | ('\u0300'..'\u036F') | ('\u203F'..'\u2040')*
;

PN_CHARS //167
  : PN_CHARS_U | '-' | ('0'..'9') | '\u00B7' | ('\u0300'..'\u036F') | ('\u203F'..'\u2040')
;

PN_PREFIX //168
  : PN_CHARS_BASE ((PN_CHARS|'.')* PN_CHARS)?
;

PN_LOCAL //169
  : (PN_CHARS_U | ':' | ('0'..'9') | PLX ) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX) )?
;

PLX //170
  : PERCENT | PN_LOCAL_ESC
;

PERCENT //171
  : '%' HEX HEX
;

HEX //172
  : ('0'..'9') | ('A'..'F') | ('a'..'f')
;

PN_LOCAL_ESC //173
  : '\\' ( '_' | '~' | '.' | '-' | '!' | '$' | '&' | '\'' | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%' )
;
