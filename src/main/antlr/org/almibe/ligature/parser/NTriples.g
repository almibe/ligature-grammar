grammar NTriples;

@lexer::header {
    package org.almibe.ligature.parser;
}

@parser::header {
    package org.almibe.ligature.parser;
}

ntriplesDoc
  : triple? (EOL triple)* EOL?
;

triple
  : subject predicate object PERIOD
;

subject
  : IRIREF | BLANK_NODE_LABEL
;

predicate
  : IRIREF
;

object
  : IRIREF | BLANK_NODE_LABEL | literal
;

literal
  : STRING_LITERAL_QUOTE (LITERAL_TYPE IRIREF | LANGTAG)?
;

LANGTAG
  : '@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
;

EOL
  : ('\u000D' | '\u000A')+
;

IRIREF
  : '<' .* '>' //TODO this needs completed -- see spec
;

STRING_LITERAL_QUOTE
  : .* //TODO this needs completed -- see spec
;

BLANK_NODE_LABEL
  : '_:' PN_CHARS_U
;

UCHAR
  : '\\u' HEX HEX HEX HEX | '\\U' HEX HEX HEX HEX HEX HEX HEX HEX
;

ECHAR
  : '\\' [tbnrf"'\\]
;

PN_CHARS_BASE
  : 'A' .. 'Z' | 'a' .. 'z' | '\u00C0' .. '\u00D6' | '\u00D8' .. '\u00F6' | '\u00F8' .. '\u02FF' | '\u0370' .. '\u037D' | '\u037F' .. '\u1FFF' | '\u200C' .. '\u200D' | '\u2070' .. '\u218F' | '\u2C00' .. '\u2FEF' | '\u3001' .. '\uD7FF' | '\uF900' .. '\uFDCF' | '\uFDF0' .. '\uFFFD'
;

PN_CHARS_U
  : PN_CHARS_BASE | '_'
;

PN_CHARS
  : PN_CHARS_U | '-' | [0-9] | '\u00B7' | [\u0300-\u036F] | [\u203F-\u2040]
;

HEX
  : [0-9] | [A-F] | [a-f]
;

WS
  : (' ' | '\t' | '\n' | '\r')+ -> skip
;

PERIOD
  : '.'
;

LITERAL_TYPE
  : '^^'
;