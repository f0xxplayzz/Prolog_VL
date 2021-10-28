scompare([],_).
scompare([H|T],List2):- maplist(scompare_e(H),List2), scompare(T,List2).

scompare_e(X=A,Y=B):- X == Y,A == B; not(X == Y).

compare_(A,B,Result):- scompare(A,B), append(A,B,Temp), sort(Temp,Result).

not_true(X,[X=false]):- atom(X).
not_true(neg(X),[X=true]):- atom(X).
not_true(and(X,Y),Result):- constructable(X,A),not_true(Y,B),compare_(A,B,Result);
    not_true(X,A),constructable(Y,B),compare_(A,B,Result);
    not_true(X,A),not_true(Y,B),compare_(A,B,Result).
not_true(or(X,Y),Result):- not_true(X,A),not_true(Y,B),compare_(A,B,Result).
not_true(imp(X,Y),Result):- constructable(X,A),not_true(Y,B),compare_(A,B,Result).
not_true(eq(X,Y),Result):- constructable(X,A),not_true(Y,B),compare_(A,B,Result);
    not_true(X,A),constructable(Y,B),compare_(A,B,Result).
not_true(nor(X,Y),Result):-constructable(or(X,Y),Result).
not_true(nand(X,Y),Result):-constructable(and(X,Y),Result).
not_true(xor(X,Y),Result):- constructable(X,A),constructable(Y,B),compare_(A,B,Result);
    not_true(X,A),not_true(Y,B),compare_(A,B,Result).

constructable(X,[X=true]):- atom(X).
constructable(neg(X),[X=false]):- atom(X).
constructable(and(X,Y),Result):- constructable(X,A),constructable(Y,B), compare_(A,B,Result).
constructable(or(X,Y),Result):- constructable(X,A),constructable(Y,B), compare_(A,B,Result);
    constructable(X,A),not_true(Y,B),compare_(A,B,Result); 
    not_true(X,A),constructable(Y,B),compare_(A,B,Result).
constructable(imp(X,Y),Result):- constructable(X,A),constructable(Y,B), compare_(A,B,Result);
    not_true(X,A),constructable(Y,B),compare_(A,B,Result);
    not_true(X,A),not_true(Y,B),compare_(A,B,Result).
constructable(eq(X,Y),Result):- constructable(X,A),constructable(Y,B),compare_(A,B,Result);
    not_true(X,A),not_true(Y,B),compare_(A,B,Result).
constructable(nor(X,Y),Result):-not_true(or(X,Y),Result).
constructable(nand(X,Y),Result):-not_true(and(X,Y),Result).
constructable(xor(X,Y),Result):- constructable(X,A),not_true(Y,B),compare_(A,B,Result);
    not_true(X,A),constructable(Y,B),compare_(A,B,Result).