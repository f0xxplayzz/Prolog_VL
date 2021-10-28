:-module(cnf_dnf,[translate_main/2,translate_DNF/2]).

translate1(A,A):-atom(A).
translate1(neg(A),neg(Result)):-translate1(A,Result).
translate1(eq(A,B),Result):-translate1(and(imp(A,B),imp(B,A)),Result).
translate1(imp(A,B),Result):-translate1(or(neg(A),B),Result).
translate1(and(A,B),and(Result1,Result2)):-translate1(A,Result1),translate1(B,Result2).
translate1(or(A,B),or(Result1,Result2)):-translate1(A,Result1),translate1(B,Result2).
translate1(nand(A,B),neg(and(Result1,Result2))):-translate1(A,Result1),translate1(B,Result2).
translate1(nor(A,B),neg(or(Result1,Result2))):-translate1(A,Result1),translate1(B,Result2).


translate2(A,A):-atom(A).
translate2(neg(or(A,B)),Result):-translate2(and(neg(A),neg(B)),Result),!.
translate2(neg(and(A,B)),Result):-translate2(or(neg(A),neg(B)),Result),!.
translate2(neg(neg(A)),Result):-translate2(A,Result),!.
translate2(and(A,B),and(Result1,Result2)):-translate2(A,Result1),translate2(B,Result2).
translate2(or(A,B),or(Result1,Result2)):-translate2(A,Result1),translate2(B,Result2).
translate2(neg(A),neg(Result)):-translate2(A,Result).

translate3(A,A):-atom(A).
translate3(neg(A),neg(Result)):-translate3(A,Result).
translate3(or(and(A,B),C),Result):-translate3(and(or(A,C),or(B,C)),Result),!.
translate3(or(C,and(A,B)),Result):-translate3(and(or(A,C),or(B,C)),Result),!.
translate3(and(A,B),and(Result1,Result2)):-translate3(A,Result1),translate3(B,Result2).
translate3(or(A,B),or(Result1,Result2)):-translate3(A,Result1),translate3(B,Result2).

translate4(A,A):-atom(A).
translate4(neg(A),neg(Result)):-translate4(A,Result).
translate4(and(or(A,C),or(B,C)),Result):-translate4(or(and(A,B),C),Result),!.
translate4(and(A,B),and(Result1,Result2)):-translate4(A,Result1),translate4(B,Result2).
translate4(or(A,B),or(Result1,Result2)):-translate4(A,Result1),translate4(B,Result2).

translate_main(A,Result):-translate1(A,T),translate2(T,T2),translate3(T2,Result).

translate_DNF(A,Result):-translate1(A,T),translate2(T,T2),translate4(T2,Result).