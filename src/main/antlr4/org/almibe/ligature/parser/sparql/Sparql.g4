parser grammar Sparql;

options { tokenVocab = ModalSparqlLexer; }

queryUnit
  : query
;

query
  : prologue ( selectQuery | constructQuery | describeQuery | askQuery ) valuesClause
;

prologue
  : ( baseDecl | prefixDecl )*
;

baseDecl
  : BASE iriRef
;

prefixDecl
  : PREFIX PNAME_NS iriRef
;

selectQuery
  : selectClause datasetClause* whereClause solutionModifier
;

subSelect
  : selectClause whereClause solutionModifier valuesClause
;

selectClause
  : SELECT ( DISTINCT | REDUCED )? ( ( var | ( OPEN_PAREN expression AS var CLOSE_PAREN ) )+ | STAR )
;

constructQuery
  : CONSTRUCT
    ( constructTemplate datasetClause* whereClause solutionModifier
    | datasetClause* WHERE OPEN_BRACE triplesTemplate? CLOSE_BRACE solutionModifier )
;

describeQuery
  : DESCRIBE ( varOrIri+ | STAR ) datasetClause* whereClause? solutionModifier
;

askQuery
  : ASK datasetClause* whereClause solutionModifier
;

datasetClause
  : FROM ( defaultGraphClause | namedGraphClause )
;

defaultGraphClause
  : sourceSelector
;

namedGraphClause
  : NAMED sourceSelector
;

sourceSelector
  : iri
;

whereClause
  : WHERE? groupGraphPattern
;

solutionModifier
  : groupClause? havingClause? orderClause? limitOffsetClauses?
;

groupClause
  : GROUP BY groupCondition+
;

groupCondition
  : builtInCall | functionCall | OPEN_PAREN expression ( AS var )? CLOSE_PAREN | var
;

havingClause
  : HAVING havingCondition+
;

havingCondition
  : constraint
;

orderClause
  : ORDER BY orderCondition+
;

orderCondition
  : ( ( ASC | DESC ) brackettedExpression )
  | ( constraint | var )
;

limitOffsetClauses
  : limitClause offsetClause?
  | offsetClause limitClause?
;

limitClause
  : LIMIT INTEGER
;

offsetClause
  : OFFSET INTEGER
;

valuesClause
  : ( VALUES dataBlock )?
;

triplesTemplate
  : triplesSameSubject ( PERIOD triplesTemplate? )?
;

groupGraphPattern
  : OPEN_BRACE ( subSelect | groupGraphPatternSub ) CLOSE_BRACE
;

groupGraphPatternSub
  : triplesBlock? ( graphPatternNotTriples PERIOD ? triplesBlock? )*
;

triplesBlock
  : triplesSameSubjectPath ( PERIOD triplesBlock? )?
;

graphPatternNotTriples
  : groupOrUnionGraphPattern
  | optionalGraphPattern
  | minusGraphPattern
  | graphGraphPattern
  | serviceGraphPattern
  | filter
  | bind
  | inlineData
;

optionalGraphPattern
  : OPTIONAL groupGraphPattern
;

graphGraphPattern
  : GRAPH varOrIri groupGraphPattern
;

serviceGraphPattern
  : SERVICE SILENT? varOrIri groupGraphPattern
;

bind
  : BIND OPEN_PAREN expression AS var CLOSE_PAREN
;

inlineData
  : VALUES dataBlock
;

dataBlock
  : inlineDataOneVar | inlineDataFull
;

inlineDataOneVar
  : var OPEN_BRACE dataBlockValue* CLOSE_BRACE
;

inlineDataFull
  : ( NIL | OPEN_PAREN var* CLOSE_PAREN ) OPEN_BRACE ( OPEN_PAREN dataBlockValue* CLOSE_PAREN | NIL )* CLOSE_BRACE
;

dataBlockValue
  : iri | rdfLiteral | numericLiteral | booleanLiteral | UNDEF
;

minusGraphPattern
  : MINUS groupGraphPattern
;

groupOrUnionGraphPattern
  : groupGraphPattern ( UNION groupGraphPattern )*
;

filter
  : FILTER constraint
;

constraint
  : brackettedExpression
  | builtInCall
  | functionCall
;

functionCall
  : iri argList
;

argList
  : NIL
  | OPEN_PAREN DISTINCT? expression ( COMMA expression )* CLOSE_PAREN
;

expressionList
  : NIL
  | OPEN_PAREN expression ( COMMA expression )* CLOSE_PAREN
;

constructTemplate
  : OPEN_BRACE constructTriples? CLOSE_BRACE
;

constructTriples
  : triplesSameSubject ( PERIOD constructTriples? )?
;

triplesSameSubject
  : varOrTerm propertyListNotEmpty
  | triplesNode propertyList
;

propertyList
  : propertyListNotEmpty?
;

propertyListNotEmpty
  : verb objectList ( SEMICOLON ( verb objectList )? )*
;

verb
  : varOrIri | A
;

objectList
  : object ( COMMA object )*
;

object
  : graphNode
;

triplesSameSubjectPath
  : varOrTerm propertyListPathNotEmpty
  | triplesNodePath propertyListPath
;

propertyListPath
  : propertyListPathNotEmpty?
;

propertyListPathNotEmpty
  : ( verbPath | verbSimple ) objectListPath ( SEMICOLON ( ( verbPath | verbSimple ) objectList )? )*
;

verbPath
  : path
;

verbSimple
  : var
;

objectListPath
  : objectPath ( COMMA objectPath )*
;

objectPath
  : graphNodePath
;

path
  : pathAlternative
;

pathAlternative
  : pathSequence ( BAR pathSequence )*
;

pathSequence
  : pathEltOrInverse ( FORWARD_SLASH pathEltOrInverse )*
;

pathElt
  : pathPrimary pathMod?
;

pathEltOrInverse
  : pathElt
  | CARET pathElt
;

pathMod
  : QUESTION_MARK
  | STAR
  | PLUS
;

pathPrimary
  : iri
  | A
  | EXCLAMATION pathNegatedPropertySet
  | OPEN_PAREN path CLOSE_PAREN
;

pathNegatedPropertySet
  : pathOneInPropertySet
  | OPEN_PAREN ( pathOneInPropertySet ( BAR pathOneInPropertySet )* )? CLOSE_PAREN
;

pathOneInPropertySet
  : iri
  | A
  | CARET ( iri | A )
;

integer
  : INTEGER
;

triplesNode
  : collection
  | blankNodePropertyList
;

blankNodePropertyList
  : OPEN_BRACKET propertyListNotEmpty CLOSE_BRACKET
;

triplesNodePath
  : collectionPath
  | blankNodePropertyListPath
;

blankNodePropertyListPath
  : OPEN_BRACKET propertyListPathNotEmpty CLOSE_BRACKET
;

collection
  : OPEN_PAREN graphNode+ CLOSE_PAREN
;

collectionPath
  : OPEN_PAREN graphNodePath+ CLOSE_PAREN
;

graphNode
  : varOrTerm
  | triplesNode
;

graphNodePath
  : varOrTerm
  | triplesNodePath
;

varOrTerm
  : var | graphTerm
;

varOrIri
  : var | iri
;

var
  : VAR1 | VAR2
;

graphTerm
  : iri
  | rdfLiteral
  | numericLiteral
  | booleanLiteral
  | blankNode
  | NIL
;

expression
  : conditionalOrExpression
;

conditionalOrExpression
  : conditionalAndExpression ( LOGICAL_OR conditionalAndExpression )*
;

conditionalAndExpression
  : valueLogical ( LOGICAL_AND valueLogical )*
;

valueLogical
  : relationalExpression
;

relationalExpression
  : numericExpression ( '=' numericExpression | '!=' numericExpression | '<' numericExpression | '>' numericExpression | '<=' numericExpression | '>=' numericExpression | 'IN' expressionList | 'NOT' 'IN' expressionList )?
;

numericExpression
  : additiveExpression
;

additiveExpression
  : multiplicativeExpression ( '+' multiplicativeExpression | '-' multiplicativeExpression | ( numericLiteralPositive | numericLiteralNegative ) ( ( '*' unaryExpression ) | ( '/' unaryExpression ) )* )*
;

multiplicativeExpression
  : unaryExpression ( '*' unaryExpression | '/' unaryExpression )*
;

unaryExpression
  : '!' primaryExpression
  | '+' primaryExpression
  | '-' primaryExpression
  | primaryExpression
;

primaryExpression
  : brackettedExpression
  | builtInCall
  | iriOrFunction
  | rdfLiteral
  | numericLiteral
  | booleanLiteral
  | var
;

brackettedExpression
  : '(' expression ')'
;

builtInCall
  : aggregate
    | 'STR' '(' expression ')'
    | 'LANG' '(' expression ')'
    | 'LANGMATCHES' '(' expression ',' expression ')'
    | 'DATATYPE' '(' expression ')'
    | 'BOUND' '(' Var ')'
    | 'IRI' '(' expression ')'
    | 'URI' '(' expression ')'
    | 'BNODE' ( '(' expression ')' | NIL )
    | 'RAND' NIL
    | 'ABS' '(' expression ')'
    | 'CEIL' '(' expression ')'
    | 'FLOOR' '(' expression ')'
    | 'ROUND' '(' expression ')'
    | 'CONCAT' expressionList
    | substringExpression
    | 'STRLEN' '(' expression ')'
    | strReplaceExpression
    | 'UCASE' '(' expression ')'
    | 'LCASE' '(' expression ')'
    | 'ENCODE_FOR_URI' '(' expression ')'
    | 'CONTAINS' '(' expression ',' expression ')'
    | 'STRSTARTS' '(' expression ',' expression ')'
    | 'STRENDS' '(' expression ',' expression ')'
    | 'STRBEFORE' '(' expression ',' expression ')'
    | 'STRAFTER' '(' expression ',' expression ')'
    | 'YEAR' '(' expression ')'
    | 'MONTH' '(' expression ')'
    | 'DAY' '(' expression ')'
    | 'HOURS' '(' expression ')'
    | 'MINUTES' '(' expression ')'
    | 'SECONDS' '(' expression ')'
    | 'TIMEZONE' '(' expression ')'
    | 'TZ' '(' expression ')'
    | 'NOW' NIL
    | 'UUID' NIL
    | 'STRUUID' NIL
    | 'MD5' '(' expression ')'
    | 'SHA1' '(' expression ')'
    | 'SHA256' '(' expression ')'
    | 'SHA384' '(' expression ')'
    | 'SHA512' '(' expression ')'
    | 'COALESCE' expressionList
    | 'IF' '(' expression ',' expression ',' expression ')'
    | 'STRLANG' '(' expression ',' expression ')'
    | 'STRDT' '(' expression ',' expression ')'
    | 'sameTerm' '(' expression ',' expression ')'
    | 'isIRI' '(' expression ')'
    | 'isURI' '(' expression ')'
    | 'isBLANK' '(' expression ')'
    | 'isLITERAL' '(' expression ')'
    | 'isNUMERIC' '(' expression ')'
    | regexExpression
    | existsFunc
    | notExistsFunc
;

regexExpression
  : 'REGEX' '(' expression ',' expression ( ',' expression )? ')'
;

substringExpression
  : 'SUBSTR' '(' expression ',' expression ( ',' expression )? ')'
;

strReplaceExpression
  : 'REPLACE' '(' expression ',' expression ',' expression ( ',' expression )? ')'
;

existsFunc
  : 'EXISTS' groupGraphPattern
;

notExistsFunc
  : 'NOT' 'EXISTS' groupGraphPattern
;

aggregate
  : 'COUNT' '(' 'DISTINCT'? ( '*' | expression ) ')'
  | 'SUM' '(' 'DISTINCT'? expression ')'
  | 'MIN' '(' 'DISTINCT'? expression ')'
  | 'MAX' '(' 'DISTINCT'? expression ')'
  | 'AVG' '(' 'DISTINCT'? expression ')'
  | 'SAMPLE' '(' 'DISTINCT'? expression ')'
  | 'GROUP_CONCAT' '(' 'DISTINCT'? expression ( ';' 'SEPARATOR' '=' string )? ')'
;

iriOrFunction
  : iri argList?
;

rdfLiteral
  : string ( LANGTAG | ( '^^' iri ) )?
;

numericLiteral
  : numericLiteralUnsigned
  | numericLiteralPositive
  | numericLiteralNegative
;

numericLiteralUnsigned
  : INTEGER
  | DECIMAL
  | DOUBLE
;

numericLiteralPositive
  : INTEGER_POSITIVE
  | DECIMAL_POSITIVE
  | DOUBLE_POSITIVE
;

numericLiteralNegative
  : INTEGER_NEGATIVE
  | DECIMAL_NEGATIVE
  | DOUBLE_NEGATIVE
;

booleanLiteral
  : 'true'
  | 'false'
;

string
  : STRING_LITERAL1
  | STRING_LITERAL2
  | STRING_LITERAL_LONG1
  | STRING_LITERAL_LONG2
;

iri
  : iriRef
  | PREFIXED_NAME
;

prefixedName
  : PNAME_LN
  | PNAME_NS
;

blankNode
  : BLANK_NODE_LABEL
  | ANON
;

iriRef
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
;
