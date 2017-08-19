lexer grammar ModalSparqlLexer;

PNAME_NS
  : PN_PREFIX? ':'
;

PNAME_LN
  : PNAME_NS PN_LOCAL
;

BLANK_NODE_LABEL
  : '_:' ( PN_CHARS_U | [0-9] ) ((PN_CHARS|'.')* PN_CHARS)?
;

VAR1
  : '?' VARNAME
;

VAR2
  : '$' VARNAME
;

LANGTAG
  : '@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
;

INTEGER
  : [0-9]+
;

DECIMAL
  : [0-9]* '.' [0-9]+
;

DOUBLE
  :	[0-9]+ '.' [0-9]* EXPONENT | '.' ([0-9])+ EXPONENT | ([0-9])+ EXPONENT
;

INTEGER_POSITIVE
  :	'+' INTEGER
;


DECIMAL_POSITIVE
  :	'+' DECIMAL
;

DOUBLE_POSITIVE
  : '+' DOUBLE
;

INTEGER_NEGATIVE
  :	'-' INTEGER
;

DECIMAL_NEGATIVE
  : '-' DECIMAL
;

DOUBLE_NEGATIVE
  : '-' DOUBLE
;

EXPONENT
  : [eE] [+-]? [0-9]+
;

STRING_LITERAL1
  : '\'' ( ~('\u0027' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '\''
;

STRING_LITERAL2
  : '"' ( ~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '"'
;

STRING_LITERAL_LONG1
  : '\'\'\'' ( ( '\'' | '\'\'' )? ( [^'\\] | ECHAR ) )* '\'\'\''
;

STRING_LITERAL_LONG2
  : '"""' ( ( '"' | '""' )? ( [^"\\] | ECHAR ) )* '"""'
;

ECHAR
  : '\\' [tbnrf\\"']
;

NIL
  :'(' WS* ')'
;

WS
  : '\u0020' | '\u0009' | '\u000D' | '\u000A'
;

ANON
  : '[' WS* ']'
;

PN_CHARS_BASE
  : [A-Z]
  | [a-z]
  | '\u00C0' .. '\u00D6'
  | '\u00D8' .. '\u00F6'
  | '\u00F8' .. '\u02FF'
  | '\u0370' .. '\u037D'
  | '\u037F' .. '\u1FFF'
  | '\u200C' .. '\u200D'
  | '\u2070' .. '\u218F'
  | '\u2C00' .. '\u2FEF'
  | '\u3001' .. '\uD7FF'
  | '\uF900' .. '\uFDCF'
  | '\uFDF0' .. '\uFFFD'
 // | '\u10000' .. '\uEFFFF' Can ANTLR handle this?
;

PN_CHARS_U
  : PN_CHARS_BASE
  | '_'
;

VARNAME
  : ( PN_CHARS_U | [0-9] ) ( PN_CHARS_U | [0-9] | '\u00B7' | '\u0300' .. '\u036F' | '\u203F' .. '\u2040' )*
;

PN_CHARS
  : PN_CHARS_U | '-' | [0-9] | '\u00B7' | '\u0300' .. '\u036F' | '\u203F' .. '\u2040'
;

PN_PREFIX
  : PN_CHARS_BASE ((PN_CHARS|'.')* PN_CHARS)?
;

PN_LOCAL
  : (PN_CHARS_U | ':' | [0-9] | PLX ) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX) )?
;

PLX
  : PERCENT
  | PN_LOCAL_ESC
;

PERCENT
  : '%' HEX HEX
;

HEX
  : [0-9]
  | [A-F]
  | [a-f]
;

PN_LOCAL_ESC
  : '\'' ( '_' | '~' | '.' | '-' | '!' | '$' | '&' | | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%' )
;