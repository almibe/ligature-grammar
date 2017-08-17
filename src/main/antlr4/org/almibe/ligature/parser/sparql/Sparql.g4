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
  : numericExpression ( '=' numericExpression | '!=' numericExpression | '<' numericExpression | '>' numericExpression | '<=' numericExpression | '>=' numericExpression | 'IN' nxpressionList | 'NOT' 'IN' nxpressionList )?
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
  | rDFLiteral
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
    | 'LANG' '(' expresion ')'
    | 'LANGMATCHES' '(' expresion ',' expresion ')'
    | 'DATATYPE' '(' expresion ')'
    | 'BOUND' '(' Var ')'
    | 'IRI' '(' expresion ')'
    | 'URI' '(' expresion ')'
    | 'BNODE' ( '(' expresion ')' | NIL )
    | 'RAND' NIL
    | 'ABS' '(' expresion ')'
    | 'CEIL' '(' expresion ')'
    | 'FLOOR' '(' expresion ')'
    | 'ROUND' '(' expresion ')'
    | 'CONCAT' expresionList
    | substringExpression
    | 'STRLEN' '(' expresion ')'
    | strReplaceExpression
    | 'UCASE' '(' expresion ')'
    | 'LCASE' '(' expresion ')'
    | 'ENCODE_FOR_URI' '(' expresion ')'
    | 'CONTAINS' '(' expresion ',' expresion ')'
    | 'STRSTARTS' '(' expresion ',' expresion ')'
    | 'STRENDS' '(' expresion ',' expresion ')'
    | 'STRBEFORE' '(' expresion ',' expresion ')'
    | 'STRAFTER' '(' expresion ',' expresion ')'
    | 'YEAR' '(' expresion ')'
    | 'MONTH' '(' expresion ')'
    | 'DAY' '(' expresion ')'
    | 'HOURS' '(' expresion ')'
    | 'MINUTES' '(' expresion ')'
    | 'SECONDS' '(' expresion ')'
    | 'TIMEZONE' '(' expresion ')'
    | 'TZ' '(' expresion ')'
    | 'NOW' NIL
    | 'UUID' NIL
    | 'STRUUID' NIL
    | 'MD5' '(' expresion ')'
    | 'SHA1' '(' expresion ')'
    | 'SHA256' '(' expresion ')'
    | 'SHA384' '(' expresion ')'
    | 'SHA512' '(' expresion ')'
    | 'COALESCE' expresionList
    | 'IF' '(' expresion ',' expresion ',' expresion ')'
    | 'STRLANG' '(' expresion ',' expresion ')'
    | 'STRDT' '(' expresion ',' expresion ')'
    | 'sameTerm' '(' expresion ',' expresion ')'
    | 'isIRI' '(' expresion ')'
    | 'isURI' '(' expresion ')'
    | 'isBLANK' '(' expresion ')'
    | 'isLITERAL' '(' expresion ')'
    | 'isNUMERIC' '(' expresion ')'
    | regexExpression
    | existsFunc
    | notExistsFunc
;

iri
  : iriRef
  | PREFIXED_NAME
;

iriRef
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
;
