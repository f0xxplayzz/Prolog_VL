isa_set([]).
isa_set([H|T]) :- sort([H|T],[H|T]), not(member(H,T)), isa_set(T).

isa_set_l([]).
isa_set_l([E|Es]):- maplist(dif(E),Es), maplist(@<(E),Es), isa_set_l(Es).

list_2_set([],[]).
list_2_set(L,X):- list_2_unordered_set(L,Y), sort(Y,X).

list_2_unordered_set([],[]).
list_2_unordered_set([H|T],[H|X]):- maplist(dif(H),T),list_2_unordered_set(T,X).
list_2_unordered_set([H|T],X):- not(maplist(dif(H),T)) ,list_2_unordered_set(T,X).

set_set_union(In1,In2,Out):- append(In1,In2,Rem), list_2_set(Rem,Out).

set_set_intersection([],_,[]).
set_set_intersection([H|T],In,[H|Out]) :- not(maplist(dif(H),In)), set_set_intersection(T,In,Out).
set_set_intersection([H|T],In,Out) :- maplist(dif(H),In), set_set_intersection(T,In,Out).

set_set_subtract_diff([],[],[]).
set_set_subtract_diff([H|T],In,[H|Out]):- set_set_intersection([H|T],In,Rem), not(member(H,Rem)), 
                            delete(In,H,In2), set_set_subtract_diff(T,In2,Out).
set_set_subtract_diff([H|T],In,Out):- set_set_intersection([H|T],In,Rem), member(H,Rem),delete(In,H,In2),
                             set_set_subtract_diff(T,In2,Out).
set_set_subtract_diff([],[H|T],[H|Out]):- set_set_subtract_diff([],T,Out).

subset_set([],M):- isa_set_l(M). 
subset_set([H|T],Set):- subset_set(T,Set), isa_set([H|T]),not(maplist(dif(H),Set)).

set_powerset([],[[]]).
set_powerset(Set,[H|T]):- length(Set,Length), pow(2,Length,Size),
             length([H|T],Size),subset_set(H,Set),set_setOfSubs(Set,T), isa_set([H|T]).

set_setOfSubs(Set,[H|T]):- subset_set(H,Set),set_setOfSubs(Set,T),isa_set([H|T]).
set_setOfSubs(_,[]).