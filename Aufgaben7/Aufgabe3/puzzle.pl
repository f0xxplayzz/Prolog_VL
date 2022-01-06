:-use_module(manhattan_distances).

% Move predicates
% describes all possible moves in a puzzle
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

% Misplaced tile heuristic
% Not used anymore, because a better heuristic was implemented
% Just still here to use for demonstration
has_missplaced_tiles([],[],0).
has_missplaced_tiles([A|T],[B|T2],Result):-
    dif(A,B),
    !,
    has_missplaced_tiles(T,T2,Res),
    Result is Res + 1.
has_missplaced_tiles([A|T],[B|T2],Result):-
    \+ dif(A,B),
    !,
    has_missplaced_tiles(T,T2,Result).

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

move(OldState,NewState,1):-up(OldState,NewState),dif(OldState,NewState).
move(OldState,NewState,1):-down(OldState,NewState),dif(OldState,NewState).
move(OldState,NewState,1):-left(OldState,NewState),dif(OldState,NewState).
move(OldState,NewState,1):-right(OldState,NewState),dif(OldState,NewState).

estimate(NewState,Est):-has_manhattan_heuristic(NewState,Est).

goal([0,1,2,3,4,5,6,7,8]).

solve_astar(Node, Path/Cost) :-
	estimate(Node, Estimate),
	astar([[Node]/0/Estimate], RevPath/Cost/_),
	reverse(RevPath, Path).

move_astar([Node|Path]/Cost/_, [NextNode,Node|Path]/NewCost/Est) :-
	move(Node, NextNode, StepCost),
	\+ member(NextNode, Path),
	NewCost is Cost + StepCost,
	estimate(NextNode, Est).

expand_astar(Path, ExpPaths) :-
	findall(NewPath, move_astar(Path,NewPath), ExpPaths).

get_best([Path], Path) :- !.
get_best([Path1/Cost1/Est1,_/Cost2/Est2|Paths], BestPath) :-
	Cost1 + Est1 =< Cost2 + Est2,
	!,
	get_best([Path1/Cost1/Est1|Paths], BestPath).
get_best([_|Paths], BestPath) :-
	get_best(Paths, BestPath).

astar(Paths, Path) :-
	get_best(Paths, Path),
	Path = [Node|_]/_/_,
	goal(Node).

astar(Paths, SolutionPath) :-
	get_best(Paths, BestPath),
	select(BestPath, Paths, OtherPaths),
	expand_astar(BestPath, ExpPaths),
	append(OtherPaths, ExpPaths, NewPaths),
	astar(NewPaths, SolutionPath).