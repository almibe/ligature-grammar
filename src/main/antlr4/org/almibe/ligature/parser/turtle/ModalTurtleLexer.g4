lexer grammar ModalTurtleLexer;

//START TOKENS
START_IRI : '<' -> pushMode(IRI);
START_TRIPLE_SINGLE_QUOTE : '\'\'\'' -> pushMode(TRIPLE_SINGLE_QUOTE);
START_TRIPLE_DOUBLE_QUOTE : '"""' -> pushMode(TRIPLE_DOUBLE_QUOTE);
START_SINGLE_QUOTE : '\'' -> pushMode(SINGLE_QUOTE);
START_DOUBLE_QUOTE : '"' -> pushMode(DOUBLE_QUOTE);
START_SPARQL_BASE : [Bb] [Aa] [Ss] [Ee];
START_SPARQL_PREFIX : [Pp] [Rr] [Ee] [Ff] [Ii] [Xx];
START_BASE : '@base';
START_PREFIX : '@prefix';

//COMMON TOKENS/FRAGMENTS
PERIOD : '.';
SEMICOLON : ';';
COMMA : ',';
A : 'a';
TRUE : 'true';
FALSE : 'false';
LITERAL_TYPE : '^^';
OPEN_PAREN : '(';
CLOSE_PAREN : ')';
OPEN_BRACKET : '[';
CLOSE_BRACKET : ']';
LANGTAG : '@' LANG;

fragment LANG //possible dupe
  : [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
;

PNAME_NS //TODO I don't think this is correct
  : PN_PREFIX? ':'
;

PREFIXED_NAME
  : PNAME_LN | PNAME_NS
;

fragment PNAME_LN
  : PNAME_NS PN_LOCAL
;

BLANK_NODE_LABEL //possible dupe
  : '_:' BLANK_NODE_NAME
;

BLANK_NODE_NAME //possible dupe
  : (PN_CHARS_U | '0' .. '9') ((PN_CHARS | '.')* PN_CHARS)?
;

INTEGER
  : [+-]? [0-9]+
;

DECIMAL
  : [+-]? [0-9]* '.' [0-9]+
;

DOUBLE
  : [+-]? ([0-9]+ '.' [0-9]* EXPONENT | '.' [0-9]+ EXPONENT | [0-9]+ EXPONENT)
;

fragment EXPONENT
  : [eE] [+-]? [0-9]+
;

fragment SINGLE_QUOTE
  : '\''
;

UCHAR //possible dupe
  : '\\u' HEX HEX HEX HEX | '\\U' HEX HEX HEX HEX HEX HEX HEX HEX
;

fragment ECHAR //possible dupe
  : '\\' [tbnrf"'\\]
;

ANON
  : '[' ']'
;

fragment PN_CHARS_BASE //possible dupe
  : 'A' .. 'Z' | 'a' .. 'z' | '\u00C0' .. '\u00D6' | '\u00D8' .. '\u00F6' | '\u00F8' .. '\u02FF' | '\u0370' .. '\u037D' | '\u037F' .. '\u1FFF' | '\u200C' .. '\u200D' | '\u2070' .. '\u218F' | '\u2C00' .. '\u2FEF' | '\u3001' .. '\uD7FF' | '\uF900' .. '\uFDCF' | '\uFDF0' .. '\uFFFD' | '\u{10000}' .. '\u{EFFFF}'
;

fragment PN_CHARS_U //slightly different from ntriples impl
  : PN_CHARS_BASE | '_'
;

fragment PN_CHARS //possible dupe
  : PN_CHARS_U | '-' | '0' .. '9' | '\u00B7' | '\u0300' .. '\u036F' | '\u203F' .. '\u2040'
;

fragment PN_PREFIX
  : PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?
;

fragment PN_LOCAL
  : (PN_CHARS_U | ':' | [0-9] | PLX) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX))?
;

fragment PLX
  : PERCENT | PN_LOCAL_ESC
;

fragment PERCENT
  : '%' HEX HEX
;

fragment HEX //possible dupe
  : '0' .. '9' | 'A' .. 'F' | 'a' .. 'f'
;

fragment PN_LOCAL_ESC
  : '\\' ('_' | '~' | '.' | '-' | '!' | '$' | '&' | SINGLE_QUOTE | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')
;

WS
  : (' ' | '\t' | '\n' | '\r')+ -> skip
;

COMMENT
  : '#' ~('\r' | '\n')* -> skip
;

//MODES
mode IRI;
CLOSE_IRI : '>'  -> popMode;

ABSOLUTE_IRI
  : SCHEME ':' (~('\u0000' .. '\u0020' | '<' | '>' | '"' | '{' | '}' | '|' | '^' | '`' | '\\') | UCHAR)+
;

fragment SCHEME
  : ('a' .. 'z' | 'A' .. 'Z')+ ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '+' | '-' | '.')*
;

RELATIVE_IRI
  : (~('\u0000' .. '\u0020' | '<' | '>' | '"' | '{' | '}' | '|' | '^' | '`' | '\\') | UCHAR)+
;

mode TRIPLE_SINGLE_QUOTE;
CLOSE_TRIPLE_SINGLE_QUOTE : '\'\'\'' -> popMode;

STRING_CONTENT_TRIPLE_SINGLE_QUOTE //TODO not sure this is correct needs thorough testing
  : ((SINGLE_QUOTE | SINGLE_QUOTE SINGLE_QUOTE)? (~('\'' | '\\') | ECHAR | UCHAR))+
;

mode TRIPLE_DOUBLE_QUOTE;
CLOSE_TRIPLE_DOUBLE_QUOTE : '"""' -> popMode;

STRING_CONTENT_TRIPLE_DOUBLE_QUOTE //TODO not sure this is correct needs thorough testing
  : (('"' | '""')? (~('"' | '\\') | ECHAR | UCHAR))+
;

mode SINGLE_QUOTE;
CLOSE_SINGLE_QUOTE : '\'' -> popMode;

STRING_CONTENT_SINGLE_QUOTE
  : (~('\u0027' | '\u005C' | '\u000A' | '\u000D') | ECHAR | UCHAR)+ /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
;

mode DOUBLE_QUOTE;
CLOSE_DOUBLE_QUOTE : '"' -> popMode;

STRING_CONTENT_DOUBLE_QUOTE
  : (~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR | UCHAR)+ /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
;
