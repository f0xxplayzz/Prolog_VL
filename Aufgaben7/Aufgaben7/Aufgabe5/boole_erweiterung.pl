/*
 * Ein Beweiser für klassische Aussagenlogik AL
 *
 * (c) AVH 2010
 *
 */

% Benutzung von Formeln:
%
% (1a) 'true' und 'false', sowie '1' und '0',
%      sind wohlgeformte AL-Formel (wff)
% (1b) eine Prologkonstante (atom) ist eine wohlgeformte AL-Formel (wff)
% (2)  wenn U und V wff sind, sowie L eine Liste von wff,
%      dann sind auch folgende Formel wff:
%
%         neg(U)      [die Negation]
%         and(U,V)    [die Konjunktion]
%         and(L)
%         or(U,V)     [die Disjunktion]
%         or(L)
%         imp(U,V)    [die Implikation]
%         eq(U,V)     [die Äquivalenz]
% (3)  nichts anderes ist eine wff
%


/*
 * Die Eingabeprädikate (top level goals, also: -? goal.)
 */

% Eingabeprädikat zum beweisen einer Formel (Tautologie)
proof(Formula) :-
	\+ satisfiable(neg(Formula),[],[],_,_).

% proof(+ListOfPremisses,+Conclusion)
proof([],Conclusion) :-
	!, proof(Conclusion).
proof(PremissesList,Conclusion) :-
	conjoin(PremissesList,PFormula),
	proof(imp(PFormula,Conclusion)).

% alternative Eingabe für proof/1
tautology(Formula) :- proof(Formula).

% prüfen, ob Formula eine Kontradikton ist
contradiction(Formula) :-
	\+ satisfiable(Formula,[],[],_,_).

% prüfen, ob Formula eine Kontingenz darstellt
contingency(Formula) :-
	\+ proof(Formula), \+ contradiction(Formula).

% satisfy(+Forumula,-Trues,-Falses)
% Eingabe: Formula, eine wff
% Ausgabe: Trues, Falses, dies sind Listen
% in dem Aussagenkonstante des Formel saufgeführt werden.
% Zusammen stellen sie eine Valuation da, die
% die Formel zu wahr valuiert.
satisfy(Formula, Trues, Falses) :-
	var(Trues), var(Falses),
	satisfiable(Formula,[],[],Trues,Falses).

% all_satisfy(+FormulaeList, -SatisfactionList)
all_satisfy(FormList,SatList) :-
	conjoin(FormList,BigFormula),
	findall((T,F),satisfy(BigFormula,T,F),SatList).


/*
 * Der eigentliche Beweiser/Valuator
 */

% satisfiable(+Formel,+TrueL,+FalseL,-Trues,-Falses) <--
%	Eingabe: Formel: wff, wie oben definiert
%		 TrueL:  eine Liste (möglicherweise leer)
%                        mit wahren Konstanten der wff
%		 FalseL: eine Liste (möglicherweise leer)
%		         mit unwahren Konstanten der wff
%	Ausgabe: Trues, Falses: Listen mit wahren, bzw
%		 unwahren Konstanten der wff

% maximale und minimale Element
satisfiable(true,TrueL,FalseL,TrueL,FalseL) :- !.
satisfiable(false,_,_,_,_) :- !, fail.
satisfiable(1,TrueL,FalseL,TrueL,FalseL) :- !.
satisfiable(0,_,_,_,_) :- !, fail.

% Erfüllbarkeit positiver komplexen Formel
satisfiable(and(X,Y),TrueL,FalseL,Trues,Falses) :-
	satisfiable(X,TrueL,FalseL,TmpTL,TmpFL),
	satisfiable(Y,TmpTL,TmpFL,Trues,Falses).
satisfiable(and([X]),TrueL,FalseL,Trues,Falses) :-
	!,satisfiable(X,TrueL,FalseL,Trues,Falses).
satisfiable(and([X|Y]),TrueL,FalseL,Trues,Falses) :-
	satisfiable(and(X,and(Y)),TrueL,FalseL,Trues,Falses).
satisfiable(or(X,Y),TrueL,FalseL,Trues,Falses) :-
	satisfiable(X,TrueL,FalseL,Trues,Falses) ;
	satisfiable(Y,TrueL,FalseL,Trues,Falses).
satisfiable(xor(X,Y),TrueL,FalseL,Trues,Falses) :-
	satisfiable(and(X,neg(Y)),TrueL,FalseL,Trues,Falses);
	satisfiable(and(neg(X),Y),TrueL,FalseL,Trues,Falses).
satisfiable(or([X]),TrueL,FalseL,Trues,Falses) :-
	!,satisfiable(X,TrueL,FalseL,Trues,Falses).
satisfiable(or([X|Y]),TrueL,FalseL,Trues,Falses) :-
	satisfiable(or(X,or(Y)),TrueL,FalseL,Trues,Falses).
satisfiable(imp(X,Y),TrueL,FalseL,Trues,Falses) :-
	satisfiable(neg(X),TrueL,FalseL,Trues,Falses) ;
	satisfiable(Y,TrueL,FalseL,Trues,Falses).
satisfiable(eq(X,Y),TrueL,FalseL,Trues,Falses) :-
	(   satisfiable(X,TrueL,FalseL,TmpT,TmpF),
	    satisfiable(Y,TmpT,TmpF,Trues,Falses))
	;
	(   satisfiable(neg(X),TrueL,FalseL,TmpT,TmpF),
	    satisfiable(neg(Y),TmpT,TmpF,Trues,Falses)).

%Erfüllbarkeit negativer komplexen Formel
satisfiable(neg(and(X,Y)),TrueL,FalseL,Trues,Falses) :-
	satisfiable(neg(X),TrueL,FalseL,Trues,Falses) ;
	satisfiable(neg(Y),TrueL,FalseL,Trues,Falses).
satisfiable(neg(and([X])),TrueL,FalseL,Trues,Falses) :-
	!, satisfiable(neg(X),TrueL,FalseL,Trues,Falses).
satisfiable(neg(and([X|Y])),TrueL,FalseL,Trues,Falses) :-
	satisfiable(neg(and(X,and(Y))),TrueL,FalseL,Trues,Falses).
satisfiable(neg(or(X,Y)),TrueL,FalseL,Trues,Falses) :-
	satisfiable(neg(X),TrueL,FalseL,TmpTL,TmpFL),
	satisfiable(neg(Y),TmpTL,TmpFL,Trues,Falses).
satisfiable(neg(xor(X,Y)),TrueL,FalseL,Trues,Falses) :-
	satisfiable(and(X,Y),TrueL,FalseL,Trues,Falses);
	satisfiable(and(neg(X),neg(Y)),TrueL,FalseL,Trues,Falses).
satisfiable(neg(or([X])),TrueL,FalseL,Trues,Falses) :-
	!, satisfiable(neg(X),TrueL,FalseL,Trues,Falses).
satisfiable(neg(or([X|Y])),TrueL,FalseL,Trues,Falses) :-
	satisfiable(neg(or(X,or(Y))),TrueL,FalseL,Trues,Falses).
satisfiable(neg(imp(X,Y)),TrueL,FalseL,Trues,Falses) :-
	satisfiable(X,TrueL,FalseL,TmpTL,TmpFL),
	satisfiable(neg(Y),TmpTL,TmpFL,Trues,Falses).
satisfiable(neg(neg(X)),TrueL,FalseL,Trues,Falses) :-
	satisfiable(X,TrueL,FalseL,Trues,Falses).
satisfiable(neg(eq(X,Y)),TrueL,FalseL,Trues,Falses) :-
	(   satisfiable(X,TrueL,FalseL,TmpT,TmpF),
	    satisfiable(neg(Y),TmpT,TmpF,Trues,Falses))
	;
	(   satisfiable(neg(X),TrueL,FalseL,TmpT,TmpF),
	    satisfiable(Y,TmpT,TmpF,Trues,Falses)).

% Erfüllbarkeit von Literalen
satisfiable(neg(X),TrueL,FalseL,TrueL,FalseL) :-
	atomprop(X), member(X,FalseL).
satisfiable(neg(X),TrueL,FalseL,TrueL,[X|FalseL]) :-
	atomprop(X), \+ member(X,TrueL), \+ member(X,FalseL).
satisfiable(X,TrueL,FalseL,TrueL,FalseL) :-
	atomprop(X), member(X,TrueL).
satisfiable(X,TrueL,FalseL,[X|TrueL],FalseL) :-
	atomprop(X), \+ member(X,FalseL), \+ member(X,TrueL).


atomprop(X) :-
	atom(X), !.
atomprop(X) :-
	ground(X),
	X =.. [Pred|_],
	\+ member(Pred,[and,or,xor,imp,eq,neg]).




/*
 * Aufgaben für Interessierten:
 * (1) Erweitern Sie das Programm so, dass es weitere Operatoren
 *     behandeln kann (eq, xor, nor, nand)
 * (2) Schreiben Sie ein Prädikat, dass alle gesamtwahren Valuationen
 *     für die Formel ausgibt
 *     [hint: benutzen Sie das builtin Prädikat findall/3 oder setof/3]
 *     [hint: Sie können mit diesen builtins mittels Klammern,
 *            z.B. (T,L), mehr als eine Liste sammeln]
 * (3) Erweitern Sie das Programm so, dass mehrere Formeln zusammen
 *     geprüft werden können: Prämissenmenge und Konklusion
 * (4) Versuchen Sie den Beweisvorgang (seine Schritten) für den
 *     Benutzer nachvollziehbar darzustellen: bauen Sie eine Ausgabe.
 */


conjoin([F],F) :- !.
conjoin([F|Fs],and(F,Rest)) :-
	conjoin(Fs,Rest).

