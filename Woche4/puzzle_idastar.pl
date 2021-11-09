:-use_module(manhattan_distances).
:- dynamic '$next_bound'/1.

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

solve_idastar(Node,Path) :-
	retract('$next_bound'(_)), fail   % clear old $next_bound
	;
	asserta('$next_bound'(0)),        % initialize Bound
	estimate(Node,Estimate),
	idastar(Node/0/Estimate,[], RevPath),
	reverse(RevPath, Path).


idastar(Node/Cost/Estimate,Path,Solution) :-
	retract('$next_bound'(Bound)),    % get current Bound
	assert('$next_bound'(999999)),    % initialize next Bound (INFINITE)
	Heuristic is Cost+Estimate,		  % heuristic Value of Node
	(	depthfirst([Node]/Cost,Heuristic,Bound,Solution)
	%	find Solution; if not change Bound
	    ;
	%   and retry
		'$next_bound'(NextBound),
		NextBound < 999999,           % Bound must be finite ( < FINITE)
		idastar(Node/Cost/Estimate,Path,Solution)   % retry with new Bound
	).

depthfirst([Node|Nodes]/_,Cost,Bound,[Node|Nodes]) :-
	goal(Node),
	Cost =< Bound.                    % succeed: Solution found
depthfirst([Node|Nodes]/Cost,Heuristic,Bound,Solution) :-
	Heuristic =< Bound,				  % Node within Bound
	move(Node,NextNode,C1),			  % expand Node
	\+ member(NextNode,Nodes),        % loop check
	estimate(NextNode,C2),
	NewCost is Cost+C1,
	NewHeuristic is NewCost+C2,
	depthfirst([NextNode,Node|Nodes]/NewCost,NewHeuristic,Bound,Solution).
depthfirst(_,Cost,Bound,_) :-
	Cost > Bound,					  % beyond current Bound
	update_next_bound(Cost),		  % just update the Bound
	fail.    

update_next_bound(NewBound) :-
    '$next_bound'(Bound),
    (	Bound =< NewBound, !          % do nothing if not necessary
    ;
        retract('$next_bound'(Bound)),% update the Bound
        asserta('$next_bound'(NewBound))
    ).