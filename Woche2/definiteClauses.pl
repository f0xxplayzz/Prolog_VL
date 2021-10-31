/**<definiteClauses> Definite Clause Translator
 * this module provides a predicate to translate a
 * Clause into a definite clause or a horn clause
 * to be exact.
*/
:-module(definiteClauses,[translated_to_definite/2]).
:-use_module(cnf).
:-use_module(wohlgeformt).

%!  translated_to_definite(+CNF:string,-DefiniteClauses:list) is det
%!  translated_to_definite(+CNF:string,+DefiniteClauses:list) is det
% this predicate translates clauses in CNF to clauses in definite form
% each clause can be transformed in a group of definite clauses or only
% one clause. if a clause can't be tranformed the predicate returns false
% can also be used tocheck if a group/list of definite clauses is the
% same as a specified Clause in CNF. 
translated_to_definite(or(neg(A),B),[B:-A]):-
    atom(A),
    atom(B).
translated_to_definite(or(A,neg(B)),[A:-B]):-
    atom(A),
    atom(B).
translated_to_definite(or(A,B),[A:-neg(B)]):-
    atom(A),
    atom(B).
translated_to_definite(or(neg(A),neg(B)),:-and(A,B)):-
    atom(A),
    atom(B).
translated_to_definite(or(neg(A),neg(B)),(:-A,B)):-
    atom(A),
    atom(B).
translated_to_definite(A,[A:-true]):-atom(A).
translated_to_definite(and(A,B),Result):-
    translated_to_definite(A,Temp1),
    translated_to_definite(B,Temp2),
    append(Temp1,Temp2,Result).

%! as_definite_clause(+Clause:string,-DefiniteClauses:list) is det
%! as_definite_clause(+Clause:string,+DefiniteClauses:list) is det
%
% this predicate can transform any clause into definite clauses if
% it is possible. if not the predicate will return false. Can also
% be used to check if a List of definite clauses is the same as a
% clause that is specified
as_definite_clause(A,_):- 
    \+ is_well_formed(A),
    !,fail.
as_definite_clause(A,Result):-
    translated_to_CNF(A,Temp),
    translated_to_definite(Temp,Result).