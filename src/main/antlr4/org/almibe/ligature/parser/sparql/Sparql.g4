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
  : 'WHERE'? GroupGraphPattern
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
