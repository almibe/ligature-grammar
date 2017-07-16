grammar Turtle;

import ModalTurtleLexer;

@parser::header {
    package org.almibe.ligature.parser.turtle;
}

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
  : 'BASE' iriRef
;

sparqlPrefix
  : 'PREFIX' PNAME_NS iriRef
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
  : iriRef | PREFIXED_NAME
;

blankNode
  : BLANK_NODE_LABEL | ANON
;

iriRef
  : '<' (ABSOLUTE_IRI | RELATIVE_IRI) '>'
;
