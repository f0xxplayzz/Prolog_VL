/**<cnf_dnf> Converter for clauses to CNF and DNF
 * The module provides predicates to translate well formed clauses either to DNF
 * or to CNF.
 */
:-module(cnf,[translated_to_CNF/2]).
:-use_module(wohlgeformt).

%!  translated_with_rule1(+Clause:string,-Result:string) is det
%!  translated_with_rule1(+Clause:string,+Result:string) is det
% this predicates uses the first rule to transform the clause to
% CNF. The rule eliminates equivalences and implications.
% this predicates also replace nand with neg(and(...)) and replaces
% nor with neg(or(...)).
translated_with_rule1(A,A):-atom(A).
translated_with_rule1(neg(A),neg(Result)):-
    translated_with_rule1(A,Result).
translated_with_rule1(eq(A,B),Result):-
    translated_with_rule1(and(imp(A,B),imp(B,A)),Result).
translated_with_rule1(imp(A,B),Result):-
    translated_with_rule1(or(neg(A),B),Result).
translated_with_rule1(and(A,B),and(Result_A,Result_B)):-
    translated_with_rule1(A,Result_A),
    translated_with_rule1(B,Result_B).
translated_with_rule1(or(A,B),or(Result_A,Result_B)):-
    translated_with_rule1(A,Result_A),
    translated_with_rule1(B,Result_B).
% the next two rules are needed to make the second rule deterministic
translated_with_rule1(nand(A,B),neg(and(Result_A,Result_B))):-
    translated_with_rule1(A,Result_A),
    translated_with_rule1(B,Result_B).
translated_with_rule1(nor(A,B),neg(or(Result_A,Result_B))):-
    translated_with_rule1(A,Result_A),
    translated_with_rule1(B,Result_B).

%!  translated_with_rule2(+Clause:string,-Result:string) is det
%!  translated_with_rule2(*Clause:string,+Result:string) is det
% this predicate will transform the clause yousing the second rule
% the second rule removes neg(and(...))s, neg(or(...))s and doubled negations
translated_with_rule2(A,A):-atom(A).
translated_with_rule2(neg(or(A,B)),Result):-
    translated_with_rule2(and(neg(A),neg(B)),Result),!.
translated_with_rule2(neg(and(A,B)),Result):-
    translated_with_rule2(or(neg(A),neg(B)),Result),!.
translated_with_rule2(neg(neg(A)),Result):-
    translated_with_rule2(A,Result),!.
translated_with_rule2(and(A,B),and(Result_A,Result_B)):-
    translated_with_rule2(A,Result_A),
    translated_with_rule2(B,Result_B).
translated_with_rule2(or(A,B),or(Result_A,Result_B)):-
    translated_with_rule2(A,Result_A),
    translated_with_rule2(B,Result_B).
translated_with_rule2(neg(A),neg(Result)):-
    translated_with_rule2(A,Result).

%! translated_with_rule3(+Clause:string,-Result:string) is det
%! translated_with_rule3(+Clause:string,+Result:string) is det
% this predicate applies the third rule of the CNF transformation
% on a clause. The third rule distributes and over or.
translated_with_rule3(A,A):-atom(A).
translated_with_rule3(neg(A),neg(Result)):-
    translated_with_rule3(A,Result).
translated_with_rule3(or(and(A,B),C),Result):-
    translated_with_rule3(and(or(A,C),or(B,C)),Result),!.
translated_with_rule3(or(C,and(A,B)),Result):-
    translated_with_rule3(and(or(A,C),or(B,C)),Result),!.
translated_with_rule3(and(A,B),and(Result_A,Result_B)):-
    translated_with_rule3(A,Result_A),
    translated_with_rule3(B,Result_B).
translated_with_rule3(or(A,B),or(Result_A,Result_B)):-
    translated_with_rule3(A,Result_A),
    translated_with_rule3(B,Result_B).

%!  translated_to_CNF(+Clause:string,-CNF:string) is det
%!  translated_to_CNF(+Clause:string,+CNF:string) is det
% this predicate checks if a given Clause is a CNF of another or
% generates the CNF of a clause. This is done by applying all 3 Rules
% on the clause.
translated_to_CNF(A,_):- 
    is_well_formed(A),
    !,fail.
translated_to_CNF(A,Result):-
    translated_with_rule1(A,T),
    translated_with_rule2(T,T2),
    translated_with_rule3(T2,Result).