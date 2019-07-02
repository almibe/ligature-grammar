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
  : (PN_CHARS_U | '0'..'9' ) (( PN_CHARS_U | '0'..'9') | '\u00B7' | ('\u0300'..'\u036F') | ('\u203F'..'\u2040'))*
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

//Keyword Support
//Keywords in SPARQL need to be case insensitive.
//See note 1 https://www.w3.org/TR/sparql11-query/#sparqlGrammar
//See https://github.com/antlr/antlr4/blob/master/doc/case-insensitive-lexing.md

A_KEYWORD //The 'a' keyword needs to be lowercase
  : 'a'
;

BASE
  : B A S E
;

PREFIX
  : P R E F I X
;

SELECT
  : S E L E C T
;

DISTINCT
  : D I S T I N C T
;

REDUCED
  : R E D U C E D
;

OPEN_PAREN
  : '('
;

AS
  : A S
;

CLOSE_PAREN
  : ')'
;

STAR
  : '*'
;

CONSTRUCT
  : C O N S T R U C T
;

WHERE
  : W H E R E
;

OPEN_BRACE
  : '{'
;

CLOSE_BRACE
  : '}'
;

DESCRIBE
  : D E S C R I B E
;

ASK
  : A S K
;

FROM
  : F R O M
;

NAMED
  : N A M E D
;

GROUP
  : G R O U P
;

BY
  : B Y
;

HAVING
  : H A V I N G
;

ORDER
  : O R D E R
;

ASC
  : A S C
;

DESC
  : D E S C
;

LIMIT
  : L I M I T
;

OFFSET
  : O F F S E T
;

VALUES
  : V A L U E S
;

SEMICOLON
  : ';'
;

LOAD
  : L O A D
;

SILENT
  : S I L E N T
;

INTO
  : I N T O
;

CLEAR
  : C L E A R
;

DROP
  : D R O P
;

CREATE
  : C R E A T E
;

ADD
  : A D D
;

TO
  : T O
;

MOVE
  : M O V E
;

COPY
  : C O P Y
;

INSERT
  : I N S E R T
;

DATA
  : D A T A
;

DELETE
  : TODO
;

WITH
  : TODO
;

USING
  : TODO
;

DEFAULT
  : TODO
;

GRAPH
  : TODO
;

ALL
  : TODO
;

PERIOD
  : TODO
;

OPTIONAL
  : TODO
;

BIND
  : TODO
;

UNDEF
  : TODO
;

MINUS
  : TODO
;

FILTER
  : TODO
;

COMMA
  : TODO
;

BAR
  : TODO
;

FORWARD_SLASH
  : TODO
;

CARET
  : TODO
;

QUESTION_MARK
  : TODO
;

PLUS
  : TODO
;

EXCLAMATION
  : TODO
;

OPEN_BRACKET
  : TODO
;

CLOSE_BRACKET
  : TODO
;

LOGICAL_OR
  : TODO
;

LOGICAL_AND
  : TODO
;

EQUAL
  : TODO
;

NOT_EQUAL
  : TODO
;

LESS_THAN
  : TODO
;

GREATER_THAN
  : TODO
;

LESS_THAN_OR_EQUAL
  : TODO
;

GREATER_THAN_OR_EQUAL
  : TODO
;

IN
  : TODO
;

NOT
  : TODO
;

MINUS_SIGN
  : TODO
;

FOWARD_SLASH
  : TODO
;

STR
  : TODO
;

LANG
  : TODO
;

LANGMATCHES
  : TODO
;

DATATYPE
  : TODO
;

BOUND
  : TODO
;

IRI
  : TODO
;

URI
  : TODO
;

BNODE
  : TODO
;

RAND
  : TODO
;

ABS
  : TODO
;

CEIL
  : TODO
;

FLOOR
  : TODO
;

ROUND
  : TODO
;

CONCAT
  : TODO
;

STRLEN
  : TODO
;

UCASE
  : TODO
;

LCASE
  : TODO
;

ENCODE_FOR_URI
  : TODO
;

CONTAINS
  : TODO
;

STRSTARTS
  : TODO
;

STRENDS
  : TODO
;

STRBEFORE
  : TODO
;

STRAFTER
  : TODO
;

YEAR
  : TODO
;

MONTH
  : TODO
;

DAY
  : TODO
;

HOURS
  : TODO
;

MINUTES
  : TODO
;

SECONDS
  : TODO
;

TIMEZONE
  : TODO
;

TZ
  : TODO
;

NOW
  : TODO
;

UUID
  : TODO
;

STRUUID
  : TODO
;

MD5
  : TODO
;

SHA1
  : TODO
;

SHA256
  : TODO
;

SHA384
  : TODO
;

SHA512
  : TODO
;

COALESCE
  : TODO
;

IF
  : TODO
;

STRLANG
  : TODO
;

STRDT
  : TODO
;

SAMETERM
  : TODO
;

ISIRI
  : TODO
;

ISURI
  : TODO
;

ISBLANK
  : TODO
;

ISLITERAL
  : TODO
;

ISNUMERIC
  : TODO
;

REGEX
  : TODO
;

SUBSTR
  : TODO
;

REPLACE
  : TODO
;

EXISTS
  : TODO
;

COUNT
  : TODO
;

SUM
  : TODO
;

MIN
  : TODO
;

MAX
  : TODO
;

AVG
  : TODO
;

SAMPLE
  : TODO
;

GROUP_CONCAT
  : TODO
;

SEPARATOR
  : TODO
;

EQUALS
  : TODO
;

LITERAL_TYPE
  : TODO
;

TRUE
  : TODO
;

FALSE
  : TODO
;

PREFIXED_NAME
  : TODO
;

fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];
