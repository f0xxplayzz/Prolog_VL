:-use_module(cnf_dnf).

translate_def(or(neg(A),B),B:-A).
translate_def(or(A,neg(B)),A:-B).
translate_def(or(A,B),Result):-translate_def(or(A,neg(neg(B))),Result),!.
translate_def(or(neg(A),neg(B)),:-and(A,B)).
translate_def(A,A:-true).

as_definite_clause(A,Result):-translate_DNF(A,Temp),translate_def(Temp,Result).