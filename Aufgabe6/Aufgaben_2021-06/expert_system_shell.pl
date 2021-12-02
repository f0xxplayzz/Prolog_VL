/*
 * Interactive shell with "why" explanations
 *
 * Basiert auf Programm 19.8 und 19.9 aus
 * Sterling & Shapiro, The Art of Prolog
 * MIT Press 1986, Seite 315, 316
 *
 * Verändert, erweitert und an SWI-Prolog
 * angepasst von AVH, 2010
 *
 */



:- dynamic untrue/1.
:- dynamic askable/1.

cleanup_shell :- retractall(untrue(_)).


%%	solve( Goal)
% Goal is deducible from a pure Prolog Programm
% (Programm ohne Cut oder Seiteneffektprogrammierung)
% The user is prompted for missing information,
% and can ask for a "why" explanation.
solve( Goal) :-
	prompt(Old, '(please answer: "yes.", "no.", or "why."):: '),
	solve( Goal, []),
	!, prompt(_,Old).
solve( Goal) :-
	nl, write('Sorry, but I cannot find any (further) solutions for '),
	writeln(Goal).



solve( true, _Rules) :- !.
solve( (A,B), Rules) :-
	!, solve( A, Rules), solve( B, Rules).
solve( A, Rules) :-
	clause( A, B), solve( B, [rule(A,B)|Rules]).
solve( A, Rules) :-
	askable( A), \+ known(A),
	ask( A, Answer), respond( Answer, A, Rules).


ask( A, Answer) :-
	display_query( A), nl, read( Answer).

respond( Yes, A, _Rules) :-
	member( Yes,[yes, y, ja, j, jawohl]), !, assert(A).
respond( No, A, _Rules) :-
	member( No,[no, n, nein, nee, nope]),!, assert(untrue(A)), fail.
respond( Why, A, []) :-
	member( Why,[why, w, warum, wieso]),
	!, writeln( ['No more explanation possible']),
	ask( A, Answer),
	respond( Answer, A, _Rules).
respond( Why, A, [Rule|Rules]) :-
	member( Why,[why, w, warum, wieso]),
	!, display_rule( Rule),
	ask( A, Answer),
	respond( Answer, A, Rules).
respond( Quit, _,_) :-
	member( Quit, [quit, q, stop, halt, exit]),
	!, writeln( 'you want me to stop advising you. Bye.'),
	abort.         %% stop execution of the complete proof
respond( _, A, Rules) :-
	writeln('(please answer: "yes.", "no.", or "why.") '),
	ask( A, Answer),
	respond( Answer, A, Rules).


known( A) :- A.
known( A) :- untrue( A).

display_query( A) :-
	write( A), write('?  ').

display_rule( rule(A,B)) :-
	nl, write( '    IF  '),
	write_conjunction(B),
	write( '        THEN '), writeln(A), nl.

write_conjunction( (A,B)) :-
	!, write(A), write(' AND '), write_conjunction(B).
write_conjunction( A) :-
	writeln( A).



/*
 * askable(A) muss im Expertensystem (Den Kern mit den Regeln)
 * definiert werden als Fakt für alle Goals,A, die Abfragbar sein
 * sollen. SWI-Prolog verlangt überdies wegen der Benutzung von
 * assert/1 in der ersten respond/3 Klausel, dass diese
 * Goalprädikate als dynamic deklariert werden (wie oben untrue/1)
 *
 */





























