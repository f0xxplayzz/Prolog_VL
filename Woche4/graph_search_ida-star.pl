/****************************************************************
 *
 *  Iterative Deepening A* Algorithmus
 *
 *  ************************************************************/


% A* ist exponential in Laufzeit- und Speicherverhalten
% Besonders dieses Speicherverhalten kann das Auffinden von Lösungen
% praktisch unmöglich machen. Eine iterative Tiefesuche macht zwar
% das Zeitverhalten nicht besser (eher noch schlechter) aber schafft
% Abhilfe bzgl. benötigter Speicher.
% In Prolog ist IDA* (idastar) leicht mittels assert und retract
% zu implementerieren



:- dynamic '$next_bound'/1.
% Für Speicherung der Bound auf der Tiefe der Suche


%%	solve_idastar(+StartNode,-SolutionPath) is semidet.
% Benutzungsschnittstelle
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
	fail.                             % and backtrack



update_next_bound(NewBound) :-
	'$next_bound'(Bound),
	(	Bound =< NewBound, !          % do nothing if not necessary
	;
	    retract('$next_bound'(Bound)),% update the Bound
	    asserta('$next_bound'(NewBound))
	).




% Example Graph

move(s, a, 2).
move(a, b, 2).
move(b, c, 2).
move(c, d, 3).
move(d, t, 3).
move(s, e, 2).
move(e, f, 5).
move(f, g, 2).
move(g, t, 2).

estimate(a, 5).
estimate(b, 4).
estimate(c, 4).
estimate(d, 3).
estimate(e, 7).
estimate(f, 4).
estimate(g, 2).

estimate(s, 6).
estimate(t, 0).

goal(t).
