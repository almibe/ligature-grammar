parser grammar Sparql;

options { tokenVocab = SparqlTerminals; }

commandUnit //0
  : queryUnit | updateUnit
;

queryUnit //1
  : query
;

query //2
  : prologue ( selectQuery | constructQuery | describeQuery | askQuery ) valuesClause
;

updateUnit //3
  : update
;

prologue //4
  : ( baseDecl | prefixDecl )*
;

baseDecl //5
  : BASE IRIREF
;

prefixDecl //6
  : PREFIX PNAME_NS IRIREF
;

selectQuery //7
  : selectClause datasetClause* whereClause solutionModifier
;

subSelect //8
  : selectClause whereClause solutionModifier valuesClause
;

selectClause //9
  : SELECT ( DISTINCT | REDUCED )? ( ( var | ( OPEN_PAREN expression AS var CLOSE_PAREN ) )+ | STAR )
;

constructQuery //10
  : CONSTRUCT
    ( constructTemplate datasetClause* whereClause solutionModifier
    | datasetClause* WHERE OPEN_BRACE triplesTemplate? CLOSE_BRACE solutionModifier )
;

describeQuery //11
  : DESCRIBE ( varOrIri+ | STAR ) datasetClause* whereClause? solutionModifier
;

askQuery //12
  : ASK datasetClause* whereClause solutionModifier
;

datasetClause //13
  : FROM ( defaultGraphClause | namedGraphClause )
;

defaultGraphClause //14
  : sourceSelector
;

namedGraphClause //15
  : NAMED sourceSelector
;

sourceSelector //16
  : iri
;

whereClause //17
  : WHERE? groupGraphPattern
;

solutionModifier //18
  : groupClause? havingClause? orderClause? limitOffsetClauses?
;

groupClause  //19
  : GROUP BY groupCondition+
;

groupCondition //20
  : builtInCall
  | functionCall
  | OPEN_PAREN expression ( AS var )? CLOSE_PAREN
  | var
;

havingClause //21
  : HAVING havingCondition+
;

havingCondition //22
  : constraint
;

orderClause //23
  : ORDER BY orderCondition+
;

orderCondition //24
  : ( ( ASC | DESC ) brackettedExpression )
  | ( constraint | var )
;

limitOffsetClauses //25
  : limitClause offsetClause?
  | offsetClause limitClause?
;

limitClause //26
  : LIMIT INTEGER
;

offsetClause //27
  : OFFSET INTEGER
;

valuesClause //28
  : ( VALUES dataBlock )?
;

update //29
  : prologue ( update1 ( SEMICOLON update )? )?
;

update1 //30
  : load | clear | drop | add | move | copy | create | insertData | deleteData | deleteWhere | modify
;

load //31
  : LOAD SILENT? iri ( INTO graphRef )?
;

clear //32
  : CLEAR SILENT? graphRefAll
;

drop //33
  : DROP SILENT? graphRefAll
;

create //34
  : CREATE SILENT? graphRef
;

add //35
  : ADD SILENT? graphOrDefault TO graphOrDefault
;

move //36
  : MOVE SILENT? graphOrDefault TO graphOrDefault
;

copy //37
  : COPY SILENT? graphOrDefault TO graphOrDefault
;

insertData //38
  : INSERT DATA quadData
;

deleteData //39
  : DELETE DATA quadData
;

deleteWhere //40
  : DELETE WHERE quadPattern
;

modify //41
  : ( WITH iri )? ( deleteClause insertClause? | insertClause ) usingClause* WHERE groupGraphPattern
;

deleteClause //42
  : DELETE quadPattern
;

insertClause //43
  : INSERT quadPattern
;

usingClause //44
  : USING ( iri | NAMED iri )
;

graphOrDefault //45
  : DEFAULT | GRAPH? iri
;

graphRef //46
  : GRAPH iri
;

graphRefAll //47
  : graphRef | DEFAULT | NAMED | ALL
;

quadPattern //48
  : OPEN_BRACE quads CLOSE_BRACE
;

quadData //49
  : OPEN_BRACE quads CLOSE_BRACE
;

quads //50
  : triplesTemplate? ( quadsNotTriples PERIOD? triplesTemplate? )*
;

quadsNotTriples //51
  : GRAPH varOrIri OPEN_BRACE triplesTemplate? CLOSE_BRACE
;

triplesTemplate //52
  : triplesSameSubject ( PERIOD triplesTemplate? )?
;

groupGraphPattern //53
  : OPEN_BRACE ( subSelect | groupGraphPatternSub ) CLOSE_BRACE
;

groupGraphPatternSub //54
  : triplesBlock? ( graphPatternNotTriples PERIOD ? triplesBlock? )*
;

triplesBlock //55
  : triplesSameSubjectPath ( PERIOD triplesBlock? )?
;

graphPatternNotTriples //56
  : groupOrUnionGraphPattern
  | optionalGraphPattern
  | minusGraphPattern
  | graphGraphPattern
  | serviceGraphPattern
  | filter
  | bind
  | inlineData
;

optionalGraphPattern //57
  : OPTIONAL groupGraphPattern
;

graphGraphPattern //58
  : GRAPH varOrIri groupGraphPattern
;

serviceGraphPattern //59
  : SERVICE SILENT? varOrIri groupGraphPattern
;

bind //60
  : BIND OPEN_PAREN expression AS var CLOSE_PAREN
;

inlineData //61
  : VALUES dataBlock
;

dataBlock //62
  : inlineDataOneVar | inlineDataFull
;

inlineDataOneVar //63
  : var OPEN_BRACE dataBlockValue* CLOSE_BRACE
;

inlineDataFull //64
  : ( NIL | OPEN_PAREN var* CLOSE_PAREN ) OPEN_BRACE ( OPEN_PAREN dataBlockValue* CLOSE_PAREN | NIL )* CLOSE_BRACE
;

dataBlockValue //65
  : iri | rdfLiteral | numericLiteral | booleanLiteral | UNDEF
;

minusGraphPattern //66
  : MINUS groupGraphPattern
;

groupOrUnionGraphPattern //67
  : groupGraphPattern ( UNION groupGraphPattern )*
;

filter //68
  : FILTER constraint
;

constraint //69
  : brackettedExpression
  | builtInCall
  | functionCall
;

functionCall //70
  : iri argList
;

argList //71
  : NIL
  | OPEN_PAREN DISTINCT? expression ( COMMA expression )* CLOSE_PAREN
;

expressionList //72
  : NIL
  | OPEN_PAREN expression ( COMMA expression )* CLOSE_PAREN
;

constructTemplate //73
  : OPEN_BRACE constructTriples? CLOSE_BRACE
;

constructTriples //74
  : triplesSameSubject ( PERIOD constructTriples? )?
;

triplesSameSubject //75
  : varOrTerm propertyListNotEmpty
  | triplesNode propertyList
;

propertyList //76
  : propertyListNotEmpty?
;

propertyListNotEmpty //77
  : verb objectList ( SEMICOLON ( verb objectList )? )*
;

verb //78
  : varOrIri | A_KEYWORD
;

objectList //79
  : object ( COMMA object )*
;

object //80
  : graphNode
;

triplesSameSubjectPath //81
  : varOrTerm propertyListPathNotEmpty
  | triplesNodePath propertyListPath
;

propertyListPath //82
  : propertyListPathNotEmpty?
;

propertyListPathNotEmpty //83
  : ( verbPath | verbSimple ) objectListPath ( SEMICOLON ( ( verbPath | verbSimple ) objectList )? )*
;

verbPath //84
  : path
;

verbSimple //85
  : var
;

objectListPath //86
  : objectPath ( COMMA objectPath )*
;

objectPath //87
  : graphNodePath
;

path //88
  : pathAlternative
;

pathAlternative //89
  : pathSequence ( BAR pathSequence )*
;

pathSequence //90
  : pathEltOrInverse ( FORWARD_SLASH pathEltOrInverse )*
;

pathElt //91
  : pathPrimary pathMod?
;

pathEltOrInverse //92
  : pathElt
  | CARET pathElt
;

pathMod //93
  : QUESTION_MARK
  | STAR
  | PLUS
;

pathPrimary //94
  : iri
  | A_KEYWORD
  | EXCLAMATION pathNegatedPropertySet
  | OPEN_PAREN path CLOSE_PAREN
;

pathNegatedPropertySet //95
  : pathOneInPropertySet
  | OPEN_PAREN ( pathOneInPropertySet ( BAR pathOneInPropertySet )* )? CLOSE_PAREN
;

pathOneInPropertySet //96
  : iri
  | A_KEYWORD
  | CARET ( iri | A_KEYWORD )
;

integer //97
  : INTEGER
;

triplesNode //98
  : collection
  | blankNodePropertyList
;

blankNodePropertyList //99
  : OPEN_BRACKET propertyListNotEmpty CLOSE_BRACKET
;

triplesNodePath //100
  : collectionPath
  | blankNodePropertyListPath
;

blankNodePropertyListPath //101
  : OPEN_BRACKET propertyListPathNotEmpty CLOSE_BRACKET
;

collection //102
  : OPEN_PAREN graphNode+ CLOSE_PAREN
;

collectionPath //103
  : OPEN_PAREN graphNodePath+ CLOSE_PAREN
;

graphNode //104
  : varOrTerm
  | triplesNode
;

graphNodePath //105
  : varOrTerm
  | triplesNodePath
;

varOrTerm //106
  : var | graphTerm
;

varOrIri //107
  : var | iri
;

var //108
  : VAR1 | VAR2
;

graphTerm //109
  : iri
  | rdfLiteral
  | numericLiteral
  | booleanLiteral
  | blankNode
  | NIL
;

expression //110
  : conditionalOrExpression
;

conditionalOrExpression //111
  : conditionalAndExpression ( LOGICAL_OR conditionalAndExpression )*
;

conditionalAndExpression //112
  : valueLogical ( LOGICAL_AND valueLogical )*
;

valueLogical //113
  : relationalExpression
;

relationalExpression //114
  : numericExpression ( EQUAL numericExpression | NOT_EQUAL numericExpression | LESS_THAN numericExpression | GREATER_THAN numericExpression | LESS_THAN_OR_EQUAL numericExpression | GREATER_THAN_OR_EQUAL numericExpression | IN expressionList | NOT IN expressionList )?
;

numericExpression //115
  : additiveExpression
;

additiveExpression //116
  : multiplicativeExpression ( PLUS multiplicativeExpression | MINUS_SIGN multiplicativeExpression | ( numericLiteralPositive | numericLiteralNegative ) ( ( STAR unaryExpression ) | ( FORWARD_SLASH unaryExpression ) )* )*
;

multiplicativeExpression //117
  : unaryExpression ( STAR unaryExpression | FORWARD_SLASH unaryExpression )*
;

unaryExpression //118
  : EXCLAMATION primaryExpression
  | PLUS primaryExpression
  | MINUS_SIGN primaryExpression
  | primaryExpression
;

primaryExpression //119
  : brackettedExpression
  | builtInCall
  | iriOrFunction
  | rdfLiteral
  | numericLiteral
  | booleanLiteral
  | var
;

brackettedExpression //120
  : OPEN_PAREN expression CLOSE_PAREN
;

builtInCall //121
  : aggregate
  | STR OPEN_PAREN expression CLOSE_PAREN
  | LANG OPEN_PAREN expression CLOSE_PAREN
  | LANGMATCHES OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | DATATYPE OPEN_PAREN expression CLOSE_PAREN
  | BOUND OPEN_PAREN var CLOSE_PAREN
  | IRI OPEN_PAREN expression CLOSE_PAREN
  | URI OPEN_PAREN expression CLOSE_PAREN
  | BNODE ( OPEN_PAREN expression CLOSE_PAREN | NIL )
  | RAND NIL
  | ABS OPEN_PAREN expression CLOSE_PAREN
  | CEIL OPEN_PAREN expression CLOSE_PAREN
  | FLOOR OPEN_PAREN expression CLOSE_PAREN
  | ROUND OPEN_PAREN expression CLOSE_PAREN
  | CONCAT expressionList
  | substringExpression
  | STRLEN OPEN_PAREN expression CLOSE_PAREN
  | strReplaceExpression
  | UCASE OPEN_PAREN expression CLOSE_PAREN
  | LCASE OPEN_PAREN expression CLOSE_PAREN
  | ENCODE_FOR_URI OPEN_PAREN expression CLOSE_PAREN
  | CONTAINS OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | STRSTARTS OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | STRENDS OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | STRBEFORE OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | STRAFTER OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | YEAR OPEN_PAREN expression CLOSE_PAREN
  | MONTH OPEN_PAREN expression CLOSE_PAREN
  | DAY OPEN_PAREN expression CLOSE_PAREN
  | HOURS OPEN_PAREN expression CLOSE_PAREN
  | MINUTES OPEN_PAREN expression CLOSE_PAREN
  | SECONDS OPEN_PAREN expression CLOSE_PAREN
  | TIMEZONE OPEN_PAREN expression CLOSE_PAREN
  | TZ OPEN_PAREN expression CLOSE_PAREN
  | NOW NIL
  | UUID NIL
  | STRUUID NIL
  | MD5 OPEN_PAREN expression CLOSE_PAREN
  | SHA1 OPEN_PAREN expression CLOSE_PAREN
  | SHA256 OPEN_PAREN expression CLOSE_PAREN
  | SHA384 OPEN_PAREN expression CLOSE_PAREN
  | SHA512 OPEN_PAREN expression CLOSE_PAREN
  | COALESCE expressionList
  | IF OPEN_PAREN expression COMMA expression COMMA expression CLOSE_PAREN
  | STRLANG OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | STRDT OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | SAMETERM OPEN_PAREN expression COMMA expression CLOSE_PAREN
  | ISIRI OPEN_PAREN expression CLOSE_PAREN
  | ISURI OPEN_PAREN expression CLOSE_PAREN
  | ISBLANK OPEN_PAREN expression CLOSE_PAREN
  | ISLITERAL OPEN_PAREN expression CLOSE_PAREN
  | ISNUMERIC OPEN_PAREN expression CLOSE_PAREN
  | regexExpression
  | existsFunc
  | notExistsFunc
;

regexExpression //122
  : REGEX OPEN_PAREN expression COMMA expression ( COMMA expression )? CLOSE_PAREN
;

substringExpression //123
  : SUBSTR OPEN_PAREN expression COMMA expression ( COMMA expression )? CLOSE_PAREN
;

strReplaceExpression //124
  : REPLACE OPEN_PAREN expression COMMA expression COMMA expression ( COMMA expression )? CLOSE_PAREN
;

existsFunc //125
  : EXISTS groupGraphPattern
;

notExistsFunc //126
  : NOT EXISTS groupGraphPattern
;

aggregate //127
  : COUNT OPEN_PAREN DISTINCT? ( STAR | expression ) CLOSE_PAREN
  | SUM OPEN_PAREN DISTINCT? expression CLOSE_PAREN
  | MIN OPEN_PAREN DISTINCT? expression CLOSE_PAREN
  | MAX OPEN_PAREN DISTINCT? expression CLOSE_PAREN
  | AVG OPEN_PAREN DISTINCT? expression CLOSE_PAREN
  | SAMPLE OPEN_PAREN DISTINCT? expression CLOSE_PAREN
  | GROUP_CONCAT OPEN_PAREN DISTINCT? expression ( SEMICOLON SEPARATOR EQUALS string )? CLOSE_PAREN
;

iriOrFunction //128
  : iri argList?
;

rdfLiteral //129
  : string ( LANGTAG | ( LITERAL_TYPE iri ) )?
;

numericLiteral //130
  : numericLiteralUnsigned
  | numericLiteralPositive
  | numericLiteralNegative
;

numericLiteralUnsigned //131
  : INTEGER
  | DECIMAL
  | DOUBLE
;

numericLiteralPositive //132
  : INTEGER_POSITIVE
  | DECIMAL_POSITIVE
  | DOUBLE_POSITIVE
;

numericLiteralNegative //133
  : INTEGER_NEGATIVE
  | DECIMAL_NEGATIVE
  | DOUBLE_NEGATIVE
;

booleanLiteral //134
  : TRUE
  | FALSE
;

string //135
  : STRING_LITERAL1
  | STRING_LITERAL2
  | STRING_LITERAL_LONG1
  | STRING_LITERAL_LONG2
;

iri //136
  : IRIREF
  | PREFIXED_NAME
;

prefixedName //137
  : PNAME_LN
  | PNAME_NS
;

blankNode //138
  : BLANK_NODE_LABEL
  | ANON
;
