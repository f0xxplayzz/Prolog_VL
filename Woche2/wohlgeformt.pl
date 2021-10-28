wff(X) :- atom(X).
wff(neg(X)):- wff(X).
wff(and(X,Y)):- wff(X), wff(Y).
wff(or(X,Y)):- wff(X), wff(Y).
wff(imp(X,Y)):- wff(X), wff(Y).
wff(eq(X,Y)):- wff(X), wff(Y).
wff(xor(X,Y)):- wff(X), wff(Y).
wff(nand(X,Y)):- wff(X), wff(Y).
wff(nor(X,Y)):- wff(X), wff(Y).

