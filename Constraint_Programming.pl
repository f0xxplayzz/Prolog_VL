/*
Simplification:
H <=> G | B.
Propagation:
H ==> G |B.
Simpagation:
H1\H2 <=> G | B.
*/
:- use_module(library(chr)).
:- use_module(library(clpfd)).


% Minimum Berechnung

:- chr_constraint min(?int).
:- chr_constraint min2(?int).
:- chr_constraint min3(?int).

min(N)\min(M) <=> N < M | true.

min2(N)\min2(M) <=> N<M | true.
min2(N)\min2(M) <=> N=M | true.

min3(N)\min3(M) <=> N =< M | true.

% Primzahlenaufzählung

:-chr_constraint prime(?number).
:-chr_constraint upto(?number).

prime(I)\prime(J) <=> J mod I =:= 0 | true.

upto(1) <=> true.
upto(N) <=> N>1 | prime(N), K #= N - 1, upto(K).

:-chr_constraint prime2(?number).

prime2(I)\prime2(J) <=> J mod I =:= 0 | true.
prime2(N) ==> N>2 | K #= N-1,prime2(K).

% Wurzelberechnung

:-chr_constraint sqrt(?number,?number).

sqrt(X,G) <=> var(G) |sqrt(X,1).
sqrt(X,G) <=> T is G*G/X-1, abs(T)>0.0001 | Res is (G+X/G)/2, sqrt(X,Res).


:-chr_constraint nonOverlapping(?any).
:-chr_constraint nonOverlapping(?any,?any,?any).

nonOverlapping(A) <=> nonOverlapping(A,[],[]).

nonOverlapping([H|T],[],[]) <=> nonOverlapping(T,[H],[]).
nonOverlapping([H|T],[H2|T2],R) <=> H #\= H2 | nonOverlapping([H|T],T2,[H2|R]).
nonOverlapping([H|_],[H2|_],_) <=> H #= H2 | false.
nonOverlapping([H|T],[],R) <=> nonOverlapping(T,[H|R],[]).
nonOverlapping([],_,_) <=> true.