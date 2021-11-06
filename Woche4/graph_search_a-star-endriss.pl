%
%   The following is taken from a series of slides,
%   given by Ulle Endriss in a course on Prolog
%   see: https://staff.science.uva.nl/u.endriss/teaching/prolog/
%   Chapter 8 Search
%


/***********************************************************************
 *
 *       The A* Algorithm in Prolog
 *
 ************************************************************************/

% The central idea in the so-called A* algorithm is to guide best-first
% search by both
%  * the estimate to the goal as given by the heuristic function h and
%  * the cost of the path developed so far.
%
% Let n be a node, g(n) the cost of moving from the initial node to n
% along the current path, and h(n) the estimated cost of reaching a
% goal node from n. Define f(n) as follows:
%    f(n) = g(n) + h(n)
%
% This is the estimated cost of the cheapest path through n leading
% from the initial node to a goal node. A* is the best-first search
% algorithm that always expands a node n such that f(n) is minimal.




/***********************************************************************
 *
 *       The A* Algorithm in Prolog
 *
 ************************************************************************/


% Users of this algorithm will have to implement the following
% application-dependent predicates themselves:
%     * move(+State,-NextState,-Cost).
%       Given the current State, instantiate the variable NextState
%       with a possible follow-up state and the variable Cost with the
%       associated cost (all possible follow-up states should get
%       generated through backtracking).
%     * goal(+State).
%       Succeed if State represents a goal state.
%     * estimate(+State,-Estimate).
%	    Given a State, instantiate the variable Estimate with an
%       estimate of the cost of reaching a goal state. This predicate
%       implements the heuristic function h.

% Further down this file, you can find an example definition of these
% predicates, taken from Bratko's book Prolog Programming for AI.



/***********************************************************************
 *
 *       A* in Prolog: User Interface
 *
 ************************************************************************/

% Now we are not only going to maintain a list of paths (as in
% breadth-first search, for instance), but a list of (reversed) paths
% labelled with the current cost g(n) and the current estimate h(n):
%       General form: Path/Cost/Estimate
%       Example: [c,b,a,s]/6/4
% Our usual "user interface" initialises the list of labelled paths with
% the path consisting of just the initial node, labelled with cost 0 and
% the appropriate estimate:

solve_astar(Node, Path/Cost) :-
	estimate(Node, Estimate),
	astar([[Node]/0/Estimate], RevPath/Cost/_),
	reverse(RevPath, Path).

% That is, for the final output, we are not interested in the estimate
% anymore, but we do report the cost of solution paths.


/***********************************************************************
 *
 *       A* in Prolog: Moves
 *
 ************************************************************************/

% The following predicate serves as a "wrapper" around the move/3
% predicate supplied by the application developer:

move_astar([Node|Path]/Cost/_, [NextNode,Node|Path]/NewCost/Est) :-
	move(Node, NextNode, StepCost),
	\+ member(NextNode, Path),
	NewCost is Cost + StepCost,
	estimate(NextNode, Est).

% After calling move/3 itself, the predicate (1) checks for cycles,
% (2) updates the cost of the current path, and (3) labels the new
% path with the estimate for the new node.
% The predicate move_astar/2 will be used to generate all
% expansions of a given path by a single state:

expand_astar(Path, ExpPaths) :-
	findall(NewPath, move_astar(Path,NewPath), ExpPaths).

/***********************************************************************
 *
 *       A* in Prolog: Getting the Best Path
 *
 ************************************************************************/

% The following predicate implements the search strategy of A*: from
% a list of labelled paths, we select one that minimises the sum of the
% current cost and the current estimate.

get_best([Path], Path) :- !.
get_best([Path1/Cost1/Est1,_/Cost2/Est2|Paths], BestPath) :-
	Cost1 + Est1 =< Cost2 + Est2,
	!,
	get_best([Path1/Cost1/Est1|Paths], BestPath).
get_best([_|Paths], BestPath) :-
	get_best(Paths, BestPath).

% Remark: Implementing a different bestfirst search algorithm only
% involves changing get_best/2; the rest can stay the same.


/***********************************************************************
 *
 *       A* in Prolog: Main Algorithm
 *
 ************************************************************************/


% Stop in case the best path ends in a goal node:
astar(Paths, Path) :-
	get_best(Paths, Path),
	Path = [Node|_]/_/_,
	goal(Node).
% Otherwise, extract the best path, generate all its expansions, and
% continue with the union of the remaining and the expanded paths:
astar(Paths, SolutionPath) :-
	get_best(Paths, BestPath),
	select(BestPath, Paths, OtherPaths),
	expand_astar(BestPath, ExpPaths),
	append(OtherPaths, ExpPaths, NewPaths),
	astar(NewPaths, SolutionPath).



/***********************************************************************
 *
 *       Example (From Bratko, Prolog Programming for AI
 *
 ************************************************************************/


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

estimate(s, 100).
estimate(t, 0).

goal(t).
