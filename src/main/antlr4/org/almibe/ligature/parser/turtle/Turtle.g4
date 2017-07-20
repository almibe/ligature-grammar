parser grammar Turtle;

options { tokenVocab = ModalTurtleLexer; }

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
  : '@prefix' PNAME_NS START_IRI '.'
;

base
  : '@base' START_IRI '.'
;

sparqlBase
  : START_SPARQL_BASE START_IRI
;

sparqlPrefix
  : START_SPARQL_PREFIX PNAME_NS START_IRI
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
  : START_TRIPLE_DOUBLE_QUOTE | START_TRIPLE_SINGLE_QUOTE | START_SINGLE_QUOTE | START_DOUBLE_QUOTE
;

iri
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
  | PREFIXED_NAME
;

blankNode
  : BLANK_NODE_LABEL | ANON
;
