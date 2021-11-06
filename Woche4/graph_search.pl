/******************************************************************
 *
 * A Program to show how to implement simple search techniques
 * in Prolog:
 *     - Depth First
 *     - breadth First
 *     - Iterative Deepening
 *
 ******************************************************************/

% Example Graph (here: a tree)

edge(a,b).
edge(a,c).
edge(b,d).
edge(b,e).
edge(d,h).
edge(d,i).
edge(e,j).
edge(e,k).
edge(c,f).
edge(c,g).
edge(f,l).
edge(f,m).
edge(g,n).
edge(g,o).

start(a).
solution(f).
solution(l).


% All examples will be shown around the simple framework:
%
% find_solution(X) :-
%     start(Start),
%     <search_algorithm>(Start,...,X,...),
%     solution(X).
%




%%	simple_df_star(+Begin,-End) is nondet.
%
%	Compute in End a node in the transitive closure of Begin
%	using simple depth first strategy
%
simple_df_star(X,X).
simple_df_star(X,Z) :-
	edge(X,Y),
	simple_df_star(Y,Z).


%%	simple_df_star(+Begin,-End,-Solution:list) is nondet.
%
%	Compute in End a node in the transitive closure of Begin using
%	simple depth first strategy and showing in Solution the path
%	from Begin to End. (Solution is NOT the actual graph traversal of
%	the algorithm).
%
simple_df_star(X,X,[]).
simple_df_star(X,Z,[Y|Ys]) :-
	edge(X,Y),
	simple_df_star(Y,Z,Ys).



%%	df_star_open(+Open:list,-End) is nondet.
%
%	Compute in End a node in the transitive closure of the nodes in
%	Open, using a simple depth first strategy
%
df_star_open([X|_],X).
df_star_open([X|Open1],Z) :-
	findall(Next,edge(X,Next),NextL),
	append(NextL,Open1,Open2),
	df_star_open(Open2,Z).


%%	df_star_open(+Open:list,-Closed:list,-End) is nondet.
%
%	Compute in End a node in the transitive closure of the nodes in
%	Open, using a simple depth first strategy and showing in Closed
%	the complete search path taken from the Head of Open to End in the
%	search for End (This is NOT the solution path from Head to End).
%
df_star_open([X|_],[],X).
df_star_open([X|Open1],[X|Ys],Z) :-
	findall(Next,edge(X,Next),NextL),
	append(NextL,Open1,Open2),
	df_star_open(Open2,Ys,Z).



%%	simple_bf_star(+Begin,-End) is nondet.
%
%	Compute in End a node in the transitive closure of Begin using a
%	breadth first strategy. Begin is a list of nodes (At the start the
%	singleton list [Begin]).
%
simple_bf_star([X|_],X).
simple_bf_star([X|Open1],Z) :-
	findall(Next,edge(X,Next),NextL),
	append(Open1,NextL,Open2),
	simple_bf_star(Open2,Z).



%%	simple_bf_star(+Open:list,-Path:list,-End) is nondet.
%
%	Compute in End a node in the transitive closure of the nodes in
%	Open, using a simple depth first strategy and showing in Path the
%	complete path taken from the Head of Open to End in the search for
%	End (most often this is not the shortest path from Head of Open to
%	End).
%
simple_bf_star([X|_],[],X).
simple_bf_star([X|Open1],[X|Ys],Z) :-
	findall(Next,edge(X,Next),NextL),
	append(Open1,NextL,Open2),
	simple_bf_star(Open2,Ys,Z).



%%	bounded_df_star(+Bound:int,+Begin,-End) is nondet.
%
%	As simple_df_star, but with a Bound (should be >= 0) on the allowed
%	search depth
%
bounded_df_star(_,X,X).
bounded_df_star(N,X,Z) :-
	N > 0,
	NN is N-1,
	edge(X,Y),
	bounded_df_star(NN,Y,Z).



%%	iterative_df_star(+Begin,-End,-PathLength:int) is nondet.
%
%	Using bounded_df_star/3 to find a path from Begin to End of length
%	PathLength by iterative deepening
%
iterative_df_star(X,Z,Bound) :-
	iterative_df_star(0,X,Z,Bound).

iterative_df_star(Bound,X,Z,Bound) :-
	bounded_df_star(Bound,X,Z).
iterative_df_star(Bound,X,Z,NewBound) :-
	Bound2 is Bound + 1,
	iterative_df_star(Bound2,X,Z,NewBound).




%%	df_star_open(+OpenPaths:list,-ClosedNodes:list,-End,-Solution:list)
%%	is nondet.
%
%	call it with OpenPaths instantiated to [[StartNode]].
%
%	Compute in End a node in the transitive closure of the frontmost
%	path in OpenPaths, using a simple depth first strategy and showing
%	in ClosedNodes the complete search path taken from the Head of
%	OpenPaths to End in the search for End (This is NOT the solution
%	path from Head to End). Solution is the path from Head to End.
%
df_star_open([[X|Path]|_],[],X,[X|Path]).
df_star_open([[X|Path]|Open1],[X|Ys],Z,Sol) :-
	findall([Next,X|Path],edge(X,Next),NextPaths),
	append(NextPaths,Open1,Open2),
	df_star_open(Open2,Ys,Z,Sol).


%%	simple_bf_star(+OpenPaths:list,-ClosedNodes:list,-End,-Solution:list)
%%	is nondet.
%
%	call it with OpenPaths instantiated to [[StartNode]].
%
%	Compute in End a node in the transitive closure of the nodes in
%	Open, using a simple breadth first strategy and showing in Path the
%	complete path taken from the Head of Open to End in the search for
%	End (most often this is not the shortest path from Head of Open to
%	End).
%
simple_bf_star([[X|Path]|_],[],X,[X|Path]).
simple_bf_star([[X|Path]|Open1],[X|Ys],Z,Sol) :-
	findall([Next,X|Path],edge(X,Next),NextPaths),
	append(Open1,NextPaths,Open2),
	simple_bf_star(Open2,Ys,Z,Sol).



%%	bounded_df_star_open(+Bound:int,+OpenPaths:list,-ClosedNodes:list,-End,-Solution:list)
%%  is nondet.
%
%	As df_star_open, but with a Bound (should be >= 0) on the allowed
%	search depth.
%
%	call it with OpenPaths instantiated to [[StartNode]].
%
bounded_df_star_open(_,[[X|Path]|_],[],X,[X|Path]).
bounded_df_star_open(N,[[X|Path]|Open1],[X|Ys],Z,Sol) :-
	length(Path,NN), NN =< N,
	findall([Next,X|Path],edge(X,Next),NextPaths),
	append(NextPaths,Open1,Open2),
	bounded_df_star_open(N,Open2,Ys,Z,Sol).



%%	iterative_df_star_open(+Begin,-End,-Bound,-PathLength:int,-Solution:list)
%	is nondet.
%
%	Using bounded_df_star_open/5 to find a path from Begin to End of
%	length PathLength by iterative deepening in a depth first search
%	strategy
%
iterative_df_star_open(X,Z,Bound,Closed,Solution) :-
	iterative_df_star_open(0,[[X]],Z,Bound,Closed,Solution).

iterative_df_star_open(Bound,X,Z,Bound,Closed,Solution) :-
	bounded_df_star_open(Bound,X,Closed,Z,Solution).
iterative_df_star_open(Bound,X,Z,NewBound,Closed,Solution) :-
	Bound2 is Bound + 1,
	iterative_df_star_open(Bound2,X,Z,NewBound,Closed,Solution).



% Merke auf, dass wir in dem obigen Prädikat iterative_df_star_open/5
% das Argument Bound einfach weglassen können: Es berichtet lediglich in
% welcher Tiefe eine Lösung gefunden wurde. Falls man Bound beim Aufruf
% instanzieren würde, prüft es lediglich ob es in der Tiefe eine Lösung
% gibt. Achtung: falls nicht, dann verschwindet die Suche ins Nirwana
% des Stack Overflow! (Wie kann man das einfach reparieren?)
%
% Weiterer Grund auf Bound zu verzichten: Solution ist ein Pfad und der
% Pfad hat eine Länge die direkt mit dem Bound korrespondiert!




%%	bounded_bf_star_open(+Bound:int,+OpenPaths:list,-ClosedNodes:list,-End,-Solution:list)
%%	is nondet.
%
%	As bounded_df_star_open, but breadth first search with a Bound
%	(should be >= 0) on the allowed search depth.
%
%	call it with OpenPaths instantiated to [[StartNode]].
%
bounded_bf_star_open(_,[[X|Path]|_],[],X,[X|Path]).
bounded_bf_star_open(N,[[X|Path]|Open1],[X|Ys],Z,Sol) :-
	length(Path,NN), NN =< N,
	findall([Next,X|Path],edge(X,Next),NextPaths),
	append(Open1,NextPaths,Open2),
	bounded_bf_star_open(N,Open2,Ys,Z,Sol).


%%	iterative_bf_star_open(+Begin,-End,-Bound,-PathLength:int,-Solution:list)
%%	is nondet.
%
%	Using bounded_bf_star_open/5 to find a path from Begin to End of
%	length PathLength by iterative deepening a breadth first strategy
%
iterative_bf_star_open(X,Z,Bound,Closed,Solution) :-
	iterative_bf_star_open(0,[[X]],Z,Bound,Closed,Solution).

iterative_bf_star_open(Bound,X,Z,Bound,Closed,Solution) :-
	bounded_bf_star_open(Bound,X,Closed,Z,Solution).
iterative_bf_star_open(Bound,X,Z,NewBound,Closed,Solution) :-
	Bound2 is Bound + 1,
	iterative_bf_star_open(Bound2,X,Z,NewBound,Closed,Solution).

% Bzgl. Bound in iterative_bf_star_open/5 gilt die gleiche Bemerkung wie
% bereits gemacht bei iterative_df_star_open/5


/*
 * Gebe den Prädikaten für iterative Tiefen-/Breiten-Suche einen
 * Maximalen Bound mit, damit sie nicht ins Unendliche (bzw. Stack
 * Overflow) laufen.
 *
 */

/*
 * Die obigen Prädikaten funktionieren nur für DAGs (bzw. Bäume). Für
 * vollen Graphen braucht es: (1) das mitführen der besuchten Knoten
 * (hier als Closed, bereits in einigen Prädikaten vorhanden) und (2)
 * die Prüfung ob eine neu hinzu zu fügendene Knote nicht bereits
 * besucht wurde. Machen!
 *
 */


