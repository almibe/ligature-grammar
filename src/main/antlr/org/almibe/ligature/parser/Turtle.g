grammar Turtle;

@lexer::header {
    package org.almibe.ligature.parser;
}

@parser::header {
    package org.almibe.ligature.parser;
}

turtleDoc
  : statement*
;

statement
  : directive | triples '.'
;

directive
  : prefixID | base | sparqlPrefix | sparqlBase
;

prefixID
  : '@prefix' PNAME_NS iriRef '.'
;

base
  : '@base' iriRef '.'
;

sparqlBase
  : 'BASE' iriRef
;

sparqlPrefix
  : 'PREFIX' PNAME_NS iriRef
;

triples
  : subject predicateObjectList | blankNodePropertyList predicateObjectList?
;

predicateObjectList
  : verbObjectList (';' (verbObjectList)?)*
;

verbObjectList
  : verb objectList
;

objectList
  : object (',' object)*
;

verb
  : predicate | 'a'
;

subject
  : iri | blankNode | collection
;

predicate
  : iri
;

object
  : iri | blankNode | collection | blankNodePropertyList | literal
;

literal
  : rdfLiteral | numericLiteral | booleanLiteral
;

blankNodePropertyList
  : '[' predicateObjectList ']'
;

collection
  : '(' object* ')'
;

numericLiteral
  : INTEGER | DECIMAL | DOUBLE
;

rdfLiteral
  : string (LANGTAG | '^^' iri)?
;

booleanLiteral
  : 'true' | 'false'
;

string
  : STRING_LITERAL_QUOTE | STRING_LITERAL_SINGLE_QUOTE | STRING_LITERAL_LONG_SINGLE_QUOTE | STRING_LITERAL_LONG_QUOTE
;

iri
  : iriRef | prefixedName
;

prefixedName
  : PNAME_LN | PNAME_NS
;

blankNode
  : BLANK_NODE_LABEL | ANON
;

iriRef
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
;

LANGTAG //possible dupe
  : '@' LANG
;

fragment LANG //possible dupe
  : [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
;

ABSOLUTE_IRI
  : SCHEME ':' (~('\u0000' .. '\u0020' | '<' | '>' | '"' | '{' | '}' | '|' | '^' | '`' | '\\') | UCHAR)+
;

fragment SCHEME
  : ('a' .. 'z' | 'A' .. 'Z')+ ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '+' | '-' | '.')*
;

RELATIVE_IRI
  : (~('\u0000' .. '\u0020' | '<' | '>' | '"' | '{' | '}' | '|' | '^' | '`' | '\\') | UCHAR)+
;

PNAME_NS
  : PN_PREFIX? ':'
;

PNAME_LN
  : PNAME_NS PN_LOCAL
;

BLANK_NODE_LABEL //possible dupe
  : '_:' BLANK_NODE_NAME
;

fragment BLANK_NODE_NAME //possible dupe
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

STRING_LITERAL_QUOTE
  : '"' (~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR | UCHAR)* '"' /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
;

STRING_LITERAL_SINGLE_QUOTE
  : SINGLE_QUOTE (~('\u0027' | '\u005C' | '\u000A' | '\u000D') | ECHAR | UCHAR)* SINGLE_QUOTE /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
;

STRING_LITERAL_LONG_SINGLE_QUOTE //TODO not sure this is correct needs thorough testing
  : SINGLE_QUOTE SINGLE_QUOTE SINGLE_QUOTE ((SINGLE_QUOTE | SINGLE_QUOTE SINGLE_QUOTE)? (~('\'' | '\\') | ECHAR | UCHAR))* SINGLE_QUOTE SINGLE_QUOTE SINGLE_QUOTE
;

fragment SINGLE_QUOTE
  : '\''
;

STRING_LITERAL_LONG_QUOTE //TODO not sure this is correct needs thorough testing
  : '"""' (('"' | '""')? (~('"' | '\\') | ECHAR | UCHAR))* '"""'
;

UCHAR //possible dupe
  : '\\u' HEX HEX HEX HEX | '\\U' HEX HEX HEX HEX HEX HEX HEX HEX
;

ECHAR //possible dupe
  : '\\' [tbnrf"'\\]
;

ANON
  : '[' ']'
;

PN_CHARS_BASE //possible dupe
  : 'A' .. 'Z' | 'a' .. 'z' | '\u00C0' .. '\u00D6' | '\u00D8' .. '\u00F6' | '\u00F8' .. '\u02FF' | '\u0370' .. '\u037D' | '\u037F' .. '\u1FFF' | '\u200C' .. '\u200D' | '\u2070' .. '\u218F' | '\u2C00' .. '\u2FEF' | '\u3001' .. '\uD7FF' | '\uF900' .. '\uFDCF' | '\uFDF0' .. '\uFFFD' | '\u{10000}' .. '\u{EFFFF}'
;

PN_CHARS_U //slightly different from ntriples impl
  : PN_CHARS_BASE | '_'
;

PN_CHARS //possible dupe
  : PN_CHARS_U | '-' | '0' .. '9' | '\u00B7' | '\u0300' .. '\u036F' | '\u203F' .. '\u2040'
;

PN_PREFIX
  : PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?
;

PN_LOCAL
  : (PN_CHARS_U | ':' | [0-9] | PLX) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX))?
;

PLX
  : PERCENT | PN_LOCAL_ESC
;

PERCENT
  : '%' HEX HEX
;

HEX //possible dupe
  : '0' .. '9' | 'A' .. 'F' | 'a' .. 'f'
;

PN_LOCAL_ESC
  : '\\' ('_' | '~' | '.' | '-' | '!' | '$' | '&' | SINGLE_QUOTE | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')
;

WS
  : (' ' | '\t' | '\n' | '\r')+ -> skip
;

COMMENT
  : '#' ~('\r' | '\n')* -> skip
;
