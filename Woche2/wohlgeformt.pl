/** <wohlgeformt> wellformed clauses
 * This module helps to decide wether a clause is well fomred
 * or not
 * @author Jan Stöffler
 */
:-module(wohlgeformt,[is_well_formed/1]).

%!  is_well_formed(+Clause:clause) is det
% true if the clause is well formed
is_well_formed(X) :- 
    atom(X).
is_well_formed(neg(X)):- 
    is_well_formed(X).
is_well_formed(and(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).
is_well_formed(or(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).
is_well_formed(imp(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).
is_well_formed(eq(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).
is_well_formed(xor(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).
is_well_formed(nand(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).
is_well_formed(nor(X,Y)):- 
    is_well_formed(X), 
    is_well_formed(Y).