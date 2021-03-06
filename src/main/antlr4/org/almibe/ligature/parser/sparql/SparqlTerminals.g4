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
  : PN_CHARS_U | MINUS_SIGN | ('0'..'9') | '\u00B7' | ('\u0300'..'\u036F') | ('\u203F'..'\u2040')
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
  : D E L E T E
;

WITH
  : W I T H
;

USING
  : U S I N G
;

DEFAULT
  : D E F A U L T
;

GRAPH
  : G R A P H
;

ALL
  : A L L
;

PERIOD
  : '.'
;

OPTIONAL
  : O P T I O N A L
;

BIND
  : B I N D
;

UNDEF
  : U N D E F
;

MINUS
  : M I N U S
;

FILTER
  : F I L T E R
;

COMMA
  : ','
;

BAR
  : '|'
;

FORWARD_SLASH
  : '/'
;

CARET
  : '`'
;

QUESTION_MARK
  : '?'
;

PLUS
  : '+'
;

EXCLAMATION
  : '!'
;

OPEN_BRACKET
  : '['
;

CLOSE_BRACKET
  : ']'
;

LOGICAL_OR
  : '||'
;

LOGICAL_AND
  : '&&'
;

EQUAL
  : '='
;

NOT_EQUAL
  : '!='
;

LESS_THAN
  : '<'
;

GREATER_THAN
  : '>'
;

LESS_THAN_OR_EQUAL
  : '<='
;

GREATER_THAN_OR_EQUAL
  : '>='
;

IN
  : I N
;

NOT
  : N O T
;

MINUS_SIGN
  : '-'
;

STR
  : S T R
;

LANG
  : L A N G
;

LANGMATCHES
  : L A N G M A T C H E S
;

DATATYPE
  : D A T A T Y P E
;

BOUND
  : B O U N D
;

IRI_STRING
  : I R I
;

URI
  : U R I
;

BNODE
  : B N O D E
;

RAND
  : R A N D
;

ABS
  : A B S
;

CEIL
  : C E I L
;

FLOOR
  : F L O O R
;

ROUND
  : R O U N D
;

CONCAT
  : C O N C A T
;

STRLEN
  : S T R L E N
;

UCASE
  : U C A S E
;

LCASE
  : L C A S E
;

ENCODE_FOR_URI
  : E N C O D E '_' F O R '_' U R I
;

CONTAINS
  : C O N T A I N S
;

STRSTARTS
  : S T R S T A R T S
;

STRENDS
  : S T R E N D S
;

STRBEFORE
  : S T R B E F O R E
;

STRAFTER
  : S T R A F T E R
;

YEAR
  : Y E A R
;

MONTH
  : M O N T H
;

DAY
  : D A Y
;

HOURS
  : H O U R S
;

MINUTES
  : M I N U T E S
;

SECONDS
  : S E C O N D S
;

TIMEZONE
  : T I M E Z O N E
;

TZ
  : T Z
;

NOW
  : N O W
;

UUID
  : U U I D
;

STRUUID
  : S T R U U I D
;

MD5
  : M D '5'
;

SHA1
  : S H A '1'
;

SHA256
  : S H A '256'
;

SHA384
  : S H A '384'
;

SHA512
  : S H A '512'
;

COALESCE
  : C O A L E S C E
;

IF
  : I F
;

STRLANG
  : S T R L A N G
;

STRDT
  : S T R D T
;

SAMETERM
  : S A M E T E R M
;

ISIRI
  : I S I R I
;

ISURI
  : I S U R I
;

ISBLANK
  : I S B L A N K
;

ISLITERAL
  : I S L I T E R A L
;

ISNUMERIC
  : I S N U M E R I C
;

REGEX
  : R E G E X
;

SUBSTR
  : S U B S T R
;

REPLACE
  : R E P L A C E
;

EXISTS
  : E X I S T S
;

COUNT
  : C O U N T
;

SUM
  : S U M
;

MIN
  : M I N
;

MAX
  : M A X
;

AVG
  : A V G
;

SAMPLE
  : S A M P L E
;

GROUP_CONCAT
  : G R O U P '_' C O N C A T
;

SEPARATOR
  : S E P A R A T O R
;

LITERAL_TYPE
  : '^^'
;

TRUE
  : T R U E
;

FALSE
  : F A L S E
;

SERVICE
  : S E R V I C E
;

UNION
  : U N I O N
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
