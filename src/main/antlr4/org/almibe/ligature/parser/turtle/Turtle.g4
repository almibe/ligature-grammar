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
  : '@prefix' PNAME_NS iriRef '.'
;

base
  : '@base' iriRef '.'
;

sparqlBase
  : START_SPARQL_BASE iriRef
;

sparqlPrefix
  : START_SPARQL_PREFIX PNAME_NS iriRef
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
  //: START_TRIPLE_DOUBLE_QUOTE | START_TRIPLE_SINGLE_QUOTE | START_SINGLE_QUOTE | START_DOUBLE_QUOTE
  : START_DOUBLE_QUOTE STRING_CONTENT_DOUBLE_QUOTE CLOSE_DOUBLE_QUOTE
;

iri
  : iriRef
  | PREFIXED_NAME
;

iriRef
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
;

blankNode
  : BLANK_NODE_LABEL | ANON
;
