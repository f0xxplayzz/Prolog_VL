/**********************************************************************
 *
 * Blocksworld Programm
 * Program f�r Goal-Action Planning
 *
 * F�r bl�cke benutzt es simple characters (a,b,c, etc).
 * Bl�cke k�nnen sich auf dem Tisch befinden: on(a,table), bedeutet
 * "block a is on the table". Oder sie k�nnen auf einander gestapelt
 * sein: on(a,b), bedeutet "block a is on block b.
 *
 * Um ein Block bewegen zu k�nnen, muss er frei sein: es darf kein
 * anderer Block auf dem Block gestapelt sein.
 * EinBblock a kann auf Block b gestapelt werden (bewogen werden) wenn
 * beide frei sind. (jeder Block der frei ist kann auf den Tisch bewogen
 * werden, der Tisch darf selbstverst�ndlich nicht auf Bl�cke bewogen
 * werden).
 *
 * Wenn ein Block nicht frei ist, dann muss man ihn freimachen (clear),
 * bevor man ihn bewegen kann. Das Programm hat eine
 * Anfangskonfiguration (Die d�rfen sie nat�rlich �ndern),
 * worin a auf b, b auf c, und c auf dem Tisch steht (somit eine S�ule)
 *
 * Hauptaufruf is das Pr�dikat do/1, das als Argument eine Liste von
 * Sachverhalten bzgl. Bl�cke hat, die als Zielzustand zu erreichen ist
 *
 * Wenn do/1 erfolgreich ist, dann k�nnen Sie mit
 * show_plan/0 den Plan abrufen: es zeigt die Reihenfolge der Aktionen,
 * die zum Zielzustand f�hren.
 * Mit show_world/0 k�nnen Sie sich den Zustand der Welt nach
 * Plandurchf�hrung anzeigen lassen.
 * Schlie�lich k�nnen Sie mit restore_all/0 den Anfangszustand
 * wiederherstellen.
 *
 * Das vorliegende Programm benutzt der Einfachkeit halber
 * Seiteneffekt-Programmierung mittels assert und retract.
 * Es pr�ft derzeit nicht, ob do/1 eine g�ltige Zielzustand als Argument
 * bekommt. Das kann durchaus zu Probleme (Endlosschleife) f�hren.
 *
 * Im Rahmen einer Aufgabe sollen Sie dieses Programm so ab�ndern, dass
 * 1. eine Pr�fung der Validit�t des verlangten Zielzustandes gepr�ft
 * wird, und 2. das Programm auf assert und retract verzichtet,dadurch
 * das Zust�nde und Plan als Argumente mitgef�hrt werden.
 *
 * Dieses Programm ist weit davon entfernt gut zu sein, es findet z.B.
 * oft umschlungene Pl�ne. Sie d�rfen ruhig weitere Verbesserungen
 * anbringen. Evtl. bekommen Sie sp�ter in der Vorlesung dazu noch
 * Ideen.
 *
 ************************************************************************/



:- dynamic on/2.
:- dynamic move/3.


% Anfangszustand der Blocksworld

% Anfangszustand der Blocksworld herstellen
restore_all :-
	retractall(on(_,_)), retractall(move(_,_,_)),
	assert(on(a,b)), assert(on(b,c)), assert(on(c,table)).

% Blocksworld Zustand anzeigen
show_world :-
	listing(on/2).

% Ausgef�hrter Plan anzeigen
show_plan :-
	listing(move/3).


%%	do(+Konfiguration:list,+State:list,-Moves:list) is nondet.
%  Konfiguration ist die beschreibung der Zustand der Bl�cke, die man
%  erreichen will. Die Konfiguration ist eine Liste von on/2 Klauseln
%
do(Glist,State,Result) :-
     order_goals(Glist,Opt_Glist),
     valid(Opt_Glist),
     do_all(Opt_Glist,Opt_Glist,State,[],State,Moves),
     reverse(Moves,Result).

valid([on(_,B),on(_,D),on(_,F)]):-
     dif(B,D),
     dif(B,F),
     dif(D,F). %Every block stand on another block then the rest
valid([on(_,B),on(_,D),on(_,_)]):-
     \+ dif(B,D),
     \+ dif(B,table),!. % two blocks on the table
valid([on(_,B),on(_,_),on(_,F)]):-
     \+ dif(B,F),
     \+ dif(B,table),!. % two blocks on the table
valid([on(_,_),on(_,D),on(_,F)]):-
     \+ dif(F,D),
     \+ dif(F,table),! % two blocks on the table
     .		   /* Nur Platzhalter, siehe Aufgabe */

do_all([G|R],Allgoals,State,Moves,NewState,NewMoves) :-
     member(G,State),                      % Goal G is already accomplished
     !,
     do_all(R,Allgoals,State,Moves,NewState,NewMoves).	   % continue with rest of goals
do_all([G|_],Allgoals,State,Moves,ActualState,NewerMoves) :-
     achieve(G,State,Moves,NewState,NewMoves),                   % must first achieve goal G
     do_all(Allgoals,Allgoals,NewState,NewMoves,ActualState,NewerMoves).    % go back and check previous goals
do_all([],_Allgoals,_,Moves,_,Moves).              % we are finished!


achieve(on(A,B),State,Moves,NewState,NewMoves) :-
     put_on(A,B,State,Moves,NewState,NewMoves).


put_on(A,B,State,Moves,State,Moves) :-
     member(on(A,B),State), !.	  % Nothing to do
put_on(A,B,State,Moves,[on(A,B)|ActualState],[move(A,X,B)|NewerMoves]) :-
     not(member(on(A,B),State)),
     dif(A,table),
     dif(A,B),
     clear_off(A,State,Moves,NewState,NewMoves),        % N.B. "action" used as precondition
     clear_off(B,NewState,NewMoves,NewerState,NewerMoves),
     member(on(A,X),NewerState),
     select(on(A,X),NewerState,ActualState). % und merke diese Aktion als Teil vom Plan


clear_off(table,State,Moves,State,Moves).         % This means there is (always) room on table
clear_off(A,State,Moves,State,Moves) :-		  % Nothing to do if A is already clear
     dif(A,table),
     not(member(on(_,A),State)).
clear_off(A,State,Moves,[on(X,table)|ActualState],[move(X,A,table)|NewMoves]) :-
     dif(A,table),
     member(on(X,A),State),
     clear_off(X,State,Moves,NewState,NewMoves),
     select(on(X,A),NewState,ActualState).        % N.B. recursion (but not TCO)

%! order_goals(+Goals:list,-Ordered_Goals:list) is det
% order the goals so the shortest solutions can be found by the program
% first fact must be a fact, where a Block is on the table,
% second the fact where a block is on thtaq block on the table or another table fact
% and so on
order_goals(Input,[on(A,table)|P2]):-
     length(Input,3),
     member(on(A,table),Input),!,
     select(on(A,table),Input,P1),
     order_goals(P1,P2).
order_goals(Input,[on(A,table)|P1]):-
     length(Input,2),
     member(on(A,table),Input),
     select(on(A,table),Input,P1),!.
order_goals(Input,[on(A,B)|P1]):-
     length(Input,2),
     member(on(A,B),Input),
     member(on(_,A),Input),
     select(on(A,B),Input,P1),!.