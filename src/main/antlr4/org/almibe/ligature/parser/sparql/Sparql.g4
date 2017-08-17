parser grammar Sparql;

//options { tokenVocab = ModalSparqlLexer; }

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
  : 'BASE' iriRef
;

prefixDecl
  : 'PREFIX' PNAME_NS iriRef
;

selectQuery
  : selectClause datasetClause* whereClause solutionModifier
;

subSelect
  : selectClause whereClause solutionModifier valuesClause
;

selectClause
  : 'SELECT' ( 'DISTINCT' | 'REDUCED' )? ( ( var | ( '(' expression 'AS' var ')' ) )+ | '*' )
;

constructQuery
  : 'CONSTRUCT'
    ( constructTemplate datasetClause* whereClause solutionModifier
    | datasetClause* 'WHERE' '{' triplesTemplate? '}' solutionModifier )
;

describeQuery
  : 'DESCRIBE' ( varOrIri+ | '*' ) datasetClause* whereClause? solutionModifier
;

askQuery
  : 'ASK' datasetClause* whereClause solutionModifier
;

datasetClause
  : 'FROM' ( defaultGraphClause | namedGraphClause )
;

defaultGraphClause
  : sourceSelector
;

namedGraphClause
  : 'NAMED' sourceSelector
;

sourceSelector
  : iri
;

whereClause
  : 'WHERE'? groupGraphPattern
;

solutionModifier
  : groupClause? havingClause? orderClause? limitOffsetClauses?
;

groupClause
  : 'GROUP' 'BY' groupCondition+
;

groupCondition
  : builtInCall | functionCall | '(' expression ( 'AS' var )? ')' | var
;

havingClause
  : 'HAVING' havingCondition+
;

havingCondition
  : constraint
;

orderClause
  : 'ORDER' 'BY' orderCondition+
;

orderCondition
  : ( ( 'ASC' | 'DESC' ) brackettedExpression )
  | ( constraint | var )
;

limitOffsetClauses
  : limitClause offsetClause?
  | offsetClause limitClause?
;

limitClause
  : 'LIMIT' INTEGER
;

offsetClause
  : 'OFFSET' INTEGER
;

valuesClause
  : ( 'VALUES' dataBlock )?
;

triplesTemplate
  : triplesSameSubject ( '.' triplesTemplate? )?
;

groupGraphPattern
  : '{' ( subSelect | groupGraphPatternSub ) '}'
;

groupGraphPatternSub
  : triplesBlock? ( graphPatternNotTriples '.'? triplesBlock? )*
;

triplesBlock
  : triplesSameSubjectPath ( '.' triplesBlock? )?
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
  : 'OPTIONAL' groupGraphPattern
;

graphGraphPattern
  : 'GRAPH' varOrIri groupGraphPattern
;

serviceGraphPattern
  : 'SERVICE' 'SILENT'? varOrIri groupGraphPattern
;

bind
  : 'BIND' '(' expression 'AS' var ')'
;

inlineData
  : 'VALUES' dataBlock
;

dataBlock
  : inlineDataOneVar | inlineDataFull
;

inlineDataOneVar
  : var '{' dataBlockValue* '}'
;

inlineDataFull
  : ( NIL | '(' var* ')' ) '{' ( '(' dataBlockValue* ')' | NIL )* '}'
;

dataBlockValue
  : iri | rdfLiteral | numericLiteral | booleanLiteral | 'UNDEF'
;

minusGraphPattern
  : 'MINUS' groupGraphPattern
;

groupOrUnionGraphPattern
  : groupGraphPattern ( 'UNION' groupGraphPattern )*
;

filter
  : 'FILTER' constraint
;

constraint
  : brackettedExpression | builtInCall | functionCall
;

functionCall
  : iri argList
;

argList
  : NIL | '(' 'DISTINCT'? expression ( ',' expression )* ')'
;

expressionList
  : NIL | '(' expression ( ',' expression )* ')'
;

constructTemplate
  : '{' constructTriples? '}'
;

constructTriples
  : triplesSameSubject ( '.' constructTriples? )?
;

triplesSameSubject
  : varOrTerm propertyListNotEmpty
  | triplesNode propertyList
;

propertyList
  : propertyListNotEmpty?
;

propertyListNotEmpty
  : verb objectList ( ';' ( verb objectList )? )*
;

verb
  : varOrIri | 'a'
;

objectList
  : object ( ',' object )*
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
  : ( verbPath | verbSimple ) objectListPath ( ';' ( ( verbPath | verbSimple ) objectList )? )*
;

verbPath
  : path
;

verbSimple
  : var
;

objectListPath
  : objectPath ( ',' objectPath )*
;

objectPath
  : graphNodePath
;

path
  : pathAlternative
;

pathAlternative
  : pathSequence ( '|' pathSequence )*
;

pathSequence
  : pathEltOrInverse ( '/' pathEltOrInverse )*
;

pathElt
  : pathPrimary pathMod?
;

pathEltOrInverse
  : pathElt
  | '^' pathElt
;

pathMod
  : '?' | '*' | '+'
;

pathPrimary
  : iri
  | 'a'
  | '!' pathNegatedPropertySet
  | '(' path ')'
;

pathNegatedPropertySet
  : pathOneInPropertySet
  | '(' ( pathOneInPropertySet ( '|' pathOneInPropertySet )* )? ')'
;

pathOneInPropertySet
  : iri
  | 'a'
  | '^' ( iri | 'a' )
;

integer
  : INTEGER
;

triplesNode
  : collection
  | blankNodePropertyList
;

blankNodePropertyList
  : '[' propertyListNotEmpty ']'
;

triplesNodePath
  : collectionPath
  | blankNodePropertyListPath
;

blankNodePropertyListPath
  : '[' propertyListPathNotEmpty ']'
;

collection
  : '(' graphNode+ ')'
;

collectionPath
  : '(' graphNodePath+ ')'
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
  : conditionalAndExpression ( '||' conditionalAndExpression )*
;

conditionalAndExpression
  : valueLogical ( '&&' valueLogical )*
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
