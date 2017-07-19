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
  : STRING_LITERAL_QUOTE | STRING_LITERAL_SINGLE_QUOTE | STRING_LITERAL_LONG_SINGLE_QUOTE | STRING_LITERAL_LONG_QUOTE
;

iri
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
  | PREFIXED_NAME
;

blankNode
  : BLANK_NODE_LABEL | ANON
;
