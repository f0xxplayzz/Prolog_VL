:-use_module(manhattan_distances).
:-use_module(library(clpfd)).

left([A,0,C,D,E,F,H,I,J],[0,A,C,D,E,F,H,I,J]).
left([A,B,C,D,0,F,H,I,J],[A,B,C,0,D,F,H,I,J]).
left([A,B,C,D,E,F,H,0,J],[A,B,C,D,E,F,0,H,J]).
left([A,B,0,D,E,F,H,I,J],[A,0,B,D,E,F,H,I,J]).
left([A,B,C,D,E,0,H,I,J],[A,B,C,D,0,E,H,I,J]).
left([A,B,C,D,E,F,H,I,0],[A,B,C,D,E,F,H,0,I]).

up([A,B,C,0,E,F,H,I,J],[0,B,C,A,E,F,H,I,J]).
up([A,B,C,D,0,F,H,I,J],[A,0,C,D,B,F,H,I,J]).
up([A,B,C,D,E,0,H,I,J],[A,B,0,D,E,C,H,I,J]).
up([A,B,C,D,E,F,0,I,J],[A,B,C,0,E,F,D,I,J]).
up([A,B,C,D,E,F,H,0,J],[A,B,C,D,0,F,H,E,J]).
up([A,B,C,D,E,F,H,I,0],[A,B,C,D,E,0,H,I,F]).

right([A,0,C,D,E,F,H,I,J],[A,C,0,D,E,F,H,I,J]).
right([A,B,C,D,0,F,H,I,J],[A,B,C,D,F,0,H,I,J]).
right([A,B,C,D,E,F,H,0,J],[A,B,C,D,E,F,H,J,0]).
right([0,B,C,D,E,F,H,I,J],[B,0,C,D,E,F,H,I,J]).
right([A,B,C,0,E,F,H,I,J],[A,B,C,E,0,F,H,I,J]).
right([A,B,C,D,E,F,0,I,J],[A,B,C,D,E,F,I,0,J]).

down([A,B,C,0,E,F,H,I,J],[A,B,C,H,E,F,0,I,J]).
down([A,B,C,D,0,F,H,I,J],[A,B,C,D,I,F,H,0,J]).
down([A,B,C,D,E,0,H,I,J],[A,B,C,D,E,J,H,I,0]).
down([0,B,C,D,E,F,H,I,J],[D,B,C,0,E,F,H,I,J]).
down([A,0,C,D,E,F,H,I,J],[A,E,C,D,0,F,H,I,J]).
down([A,B,0,D,E,F,H,I,J],[A,B,F,D,E,0,H,I,J]).

goal([0,1,2,3,4,5,6,7,8]).

%! solve(+Input:list,-output:list) is nondet
% this predicate solves a given constellation for the puzzle
% can find all solutions, no duplicate constellations of the puzzle allowed
% in the solution. Is implemnented using DCGs
% as search strategy IDAstar is used
solve(X,[X|Result]):-
    solver(X,1,Result,[]).


solver(X,D) -->
    move(X,0,D,[X]). %try to solve with current bound
solver(X,D) -->
    {NewDepth is D +1}, % deepening step
    solver(X,NewDepth). % try to solve with new bound

move(X,Cost,Bound,L1) --> % left move
    [Y],
    {Cost #=< Bound,
    left(X,Y),
    dif(X,Y), % check that move has changed anything
    \+member(Y,L1), % check that state hasnt apperaed before
    has_manhattan_heuristic(X,A),
    NewCost is Cost + 1 +A},
    move(Y,NewCost,Bound,[Y|L1]).
move(X,Cost,Bound,L1) --> % right move
    [Y],
    {Cost #=< Bound,
    right(X,Y),
    dif(X,Y),
    \+member(Y,L1),
    has_manhattan_heuristic(X,A),
    NewCost is Cost + 1 +A},
    move(Y,NewCost,Bound,[Y|L1]).
move(X,Cost,Bound,L1) --> %up move
    [Y],
    {Cost #=< Bound,
    up(X,Y),
    dif(X,Y),
    \+member(Y,L1),
    has_manhattan_heuristic(X,A),
    NewCost is Cost + 1 +A},
    move(Y,NewCost,Bound,[Y|L1]).
move(X,Cost,Bound,L1) --> % down move
    [Y],
    {Cost #=< Bound,
    down(X,Y),
    dif(X,Y),
    \+member(Y,L1),
    has_manhattan_heuristic(X,A),
    NewCost is Cost + 1 +A},
    move(Y,NewCost,Bound,[Y|L1]).
move(X,_,_,_) -->
    [],
    {goal(X)}.


estimate(NewState,Est):-has_manhattan_heuristic(NewState,Est).

% Manhattan heuristic
% uses module Manhttan_distances for calculation
%! has_manhattan_heuristic(+Puzzle:list,-Heuristic:Int) is det
has_manhattan_heuristic([A,B,C,D,E,F,G,H,I],Dist):-
    a(A,DistA),
    b(B,DistB),
    c(C,DistC),
    d(D,DistD),
    e(E,DistE),
    f(F,DistF),
    g(G,DistG),
    h(H,DistH),
    i(I,DistI),
    Dist is DistA + DistB + DistC + DistD + DistE + DistF + DistG + DistH + DistI.