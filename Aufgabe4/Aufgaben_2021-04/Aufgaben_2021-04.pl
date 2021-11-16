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
on(a,b).
on(b,c).
on(c,table).

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


%%	do(+Konfiguration:list) is nondet.
%  Konfiguration ist die beschreibung der Zustand der Bl�cke, die man
%  erreichen will. Die Konfiguration ist eine Liste von on/2 Klauseln
%
%  Beispiel: do([on(c,a),on(a,table)]).
%
do(Glist) :-
      valid(Glist),
      do_all(Glist,Glist).

valid(_).		   /* Nur Platzhalter, siehe Aufgabe */

do_all([G|R],Allgoals) :-
     call(G),                      % Goal G is already accomplished
     !,
     do_all(R,Allgoals).	   % continue with rest of goals
do_all([G|_],Allgoals) :-
     achieve(G),                   % must first achieve goal G
     do_all(Allgoals,Allgoals).    % go back and check previous goals
do_all([],_Allgoals).              % we are finished!


achieve(on(A,B)) :-
     put_on(A,B).


put_on(A,B) :-
     on(A,B), !.	  % Nothing to do
put_on(A,B) :-
     not(on(A,B)),
     dif(A,table),
     dif(A,B),
     clear_off(A),        % N.B. "action" used as precondition
     clear_off(B),
     on(A,X),
     retract(on(A,X)),    % "greife" A
     assert(on(A,B)),     % "setze" A auf B
     assert(move(A,X,B)). % und merke diese Aktion als Teil vom Plan


clear_off(table).         % This means there is (always) room on table
clear_off(A) :-		  % Nothing to do if A is already clear
     \+ on(_X,A).
clear_off(A) :-
     dif(A,table),
     on(X,A),
     clear_off(X),        % N.B. recursion (but not TCO)
     retract(on(X,A)),
     assert(on(X,table)),
     assert(move(X,A,table)).



