/*
 * Oven placement expert system
 *
 * Nach einem Beispiel von Sterling & Shapiro
 * aus "The Art of Prolog", Seite 312
 *
 * SWI-Prolog Anpassung von AVH, 2010
 *
 */

:- dynamic isof_type/2.
:- dynamic size/2.

cleanup :- retractall(isof_type(_,_)), retractall(size(_,_)), cleanup_shell.


:- consult('expert_system_shell').
%% :- consult('expert_system_shell2').



%%	place_in_oven( Dish, Rack)
% Dish should be placed in the oven at Level Rack for baking
%
% This is the top-level predicate, to be used as Goal in solve(Goal),
% the top-level predicate of the expert system shell
%
place_in_oven( Dish, top_rack) :-
	pastry( Dish), size(Dish,small).
place_in_oven( Dish, middle_rack) :-
	pastry( Dish), size(Dish,big).
place_in_oven( Dish, middle_rack) :-
	main_meal( Dish).
place_in_oven( Dish, low_rack) :-
	slow_cooker( Dish).

pastry( Dish) :- isof_type( Dish, cake).
pastry( Dish) :- isof_type( Dish, bread).

main_meal( Dish) :- isof_type( Dish, meat).
main_meal( Dish) :- isof_type( Dish, stew).

slow_cooker( Dish) :- isof_type( Dish, milk_pudding).
slow_cooker( Dish) :- isof_type( Dish, rice_pudding).

askable( isof_type(_,_)).
askable( size(_,_)).

