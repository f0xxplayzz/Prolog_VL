/** <solver> Solver for well formed clauses
 * This module provides predicates to check if a clause
 * is constructable or not.
 */
:-module(solver,[constructable_with/2]).

%!  scompare(+List1:list,+List2:list) is det
% checks if the two lists don't have same Literals with different
% values. Returns true if that is the case.
% E.g. scompare([katze=true,...],[katze=false,...]) would return false
scompare([],_).
scompare([H|T],List2):- 
    maplist(scompare_elem(H),List2), 
    scompare(T,List2).

%!  scompare_elem(+Value1:string,+Value2:string) is det
% checks if the two elems are different literals or if they are the
% same literal if they have the same value.
scompare_elem(X=A,Y=B):- 
    X == Y,A == B;
    not(X == Y).

%!  compare_and_concat(+List1:list,+List2:list,-Result:list) is det
% checks if two Lists fit hte predicate scompare and then concats them
% and makes a set out of the result. Returns false if the List doesn't
% fullfill the scompare predicate.
compare_and_concat(A,B,Result):- 
    scompare(A,B), 
    append(A,B,Temp), 
    sort(Temp,Result).

%!  not_true_with(+Clause:string,-Result:list) is nondet
% returns all possible Configuration of Literals with their values
% with that the Clause will be evaluated as false. Will return
% false if the clause is a tautology
not_true_with(X,[X=false]):- atom(X).
not_true_with(neg(X),[X=true]):- atom(X).
not_true_with(and(X,Y),Result):- 
    constructable_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result).
not_true_with(or(X,Y),Result):- 
    not_true_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result).
not_true_with(imp(X,Y),Result):- 
    constructable_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result).
not_true_with(eq(X,Y),Result):- 
    constructable_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result).
not_true_with(nor(X,Y),Result):-
    constructable_with(or(X,Y),Result).
not_true_with(nand(X,Y),Result):-
    constructable_with(and(X,Y),Result).
not_true_with(xor(X,Y),Result):- 
    constructable_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result).

%!  constructable_with(+Clause:string,-Result:list) is nondet
% returns all possible Configuration of Literals with their values
% with that the Clause will be evaluated as true. Will return
% false if the clause is a contradiction
constructable_with(X,[X=true]):- atom(X).
constructable_with(neg(X),[X=false]):- atom(X).
constructable_with(and(X,Y),Result):- 
    constructable_with(X,A),
    constructable_with(Y,B), 
    compare_and_concat(A,B,Result).
constructable_with(or(X,Y),Result):- 
    constructable_with(X,A),
    constructable_with(Y,B), 
    compare_and_concat(A,B,Result);
    constructable_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result); 
    not_true_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result).
constructable_with(imp(X,Y),Result):- 
    constructable_with(X,A),
    constructable_with(Y,B), 
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result).
constructable_with(eq(X,Y),Result):- 
    constructable_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result).
constructable_with(nor(X,Y),Result):-
    not_true_with(or(X,Y),Result).
constructable_with(nand(X,Y),Result):-
    not_true_with(and(X,Y),Result).
constructable_with(xor(X,Y),Result):- 
    constructable_with(X,A),
    not_true_with(Y,B),
    compare_and_concat(A,B,Result);
    not_true_with(X,A),
    constructable_with(Y,B),
    compare_and_concat(A,B,Result).