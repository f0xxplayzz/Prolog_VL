/*
 *
 *
 * ein lexer und parser fuer eine kleine
 * aussagenlogischen Logik-Grammatik
 *
 * (c) AVH 2010
 *
 */


/**************************************************************************/

%%
%%	top_level Aufrufe für wiederholte Abfrage von Eingaben:
%%	go/0:       scannen und parsen
%%	gosat/0:    scannen, parsen, und Erfüllbarkeit prüfen
%%	gosatall/0: scannen, parsen und vollständige
%%	            Erfüllbarkeitsprüfung



%% Theorembeweiser einbinden für evtl. Beweise
:- consult('boole_erweiterung.pl').

go :-   prompt(OldPrompt,'Enter formula or "quit.": '),
	scan_in(Input),
	prompt(_,OldPrompt),
	(   Input == [quit,'.'] -> abort ; true ),
	delete(Input,'.',Tokens),
	parse(Tokens,Formula),
	write('FORMULA:  '), writeln(Formula),
	!,
	go.

gosat :-
	prompt(OldPrompt,'Enter formula or "quit.": '),
	scan_in(Input),
	prompt(_,OldPrompt),
	(   Input == [quit,'.'] -> abort ; true ),
	delete(Input,'.',Tokens),
	parse(Tokens,Formula),
	write('FORMULA:  '), writeln(Formula),
	satisfy(Formula,Trues,Falses),
	write('Trues  = '), writeln(Trues),
	write('Falses = '), writeln(Falses), nl,
	!,
	gosat.

gosatall :-
	prompt(OldPrompt,'Enter formula or "quit.": '),
	scan_in(Input),
	prompt(_,OldPrompt),
	(   Input == [quit,'.'] -> abort ; true ),
	delete(Input,'.',Tokens),
	parse(Tokens,Formula),
	write('FORMULA:  '), writeln(Formula),
	all_satisfy([Formula],SatList),
	write('SatList mit (Trues,Falses) = '), writeln(SatList), nl,
	!,
	gosatall.



/**************************************************************************/

%%
%%	Der Lexer
%%

scan_in([Token|Tokens]) :-
	get_char(C),
	get_token(C,Token,C1),
	get_rest(Token,C1,Tokens).

get_rest(Token,_,[]) :-
	last_token(Token), !.
get_rest(_Token,C,[RToken|RTokens]) :-
	get_token(C,RToken,C1),
	get_rest(RToken,C1,RTokens).


get_token(C,C,C1) :-
	(   single_char(C) ; special_char(C) ), !, get_char(C1).
get_token(C,Token,C2) :-
	in_token(C,NewC), !,
	get_char(C1),
	rest_token(C1,Cs,C2),
	atom_chars(Token,[NewC|Cs]).
get_token(_C,Token,C2) :-  %% das aktuelle Zeichen wird ignoriert
	get_char(C1),
	get_token(C1,Token,C2).

rest_token(C,[NewC|Cs],C2) :-
	in_token(C,NewC), !,
	get_char(C1),
	rest_token(C1,Cs,C2).
rest_token(C,[],C).



in_token('_','_') :- !.
in_token(C,C) :-
	member(C,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]).
in_token(C,H) :-
	member((C,H),[('A',a),('B',b),('C',c),('D',d),('E',e),('F',f),('G',g),
		      ('H',h),('I',i),('J',j),('K',k),('L',l),('M',m),('N',n),
		      ('O',o),('P',p),('Q',q),('R',r),('S',s),('T',t),('U',u),
		      ('V',v),('W',w),('X',x),('Y',y),('Z',z)]).
in_token(C,C) :-
	member(C,['0','1','2','3','4','5','6','7','8','9']).



last_token('.').

special_char(T) :-
	T \== ' ', T \== '\n', T \== '\t',
	\+ last_token(T),
	\+ in_token(T,_).

single_char('.').
single_char('~').
single_char('-').
single_char('+').
single_char('*').
single_char('(').
single_char(')').
single_char('=').
single_char('<').
single_char('>').





/**************************************************************************/


%%
%%	Der Parser
%%


parse(Input,Formula) :-
  expr(Formula,Input,[]).



expr(X) -->
	subexpr(A), expr2(B),
	{ B == epsilon -> X = A ;
	  (   B = (Op,R), X =.. [Op,A,R] )
	}.

expr2(X) -->
	impeq(A), subexpr(B), expr2(C),
	{ C == epsilon -> X = (A,B) ;
	  (   C = (Op,R), RR =.. [Op,B,R], X = (A,RR) )
	}.
expr2(epsilon) --> [], {}.

subexpr(X) -->
	form(A), subexpr2(B),
	{ B == epsilon -> X = A ;
	  (   B = (Op,R), X =.. [Op,A,R] )
	}.

subexpr2(X) -->
	andor(A), form(B), subexpr2(C),
	{ C == epsilon -> X = (A,B) ;
	  (   C = (Op,R), RR =.. [Op,B,R], X = (A,RR) )
	}.
subexpr2(epsilon) --> [], {}.

form(X) -->
	['('], expr(X), [')'],
	{}.
form(X) -->
	unary(A), form(B),
	{X =.. [A,B]}.
form(X) -->
	basic(X),
	{}.


unary(neg) -->
	[not], {}.
unary(neg) -->
	[neg], {}.
unary(neg) -->
	['~'], {}.
unary(neg) -->
	['-'], {}.

andor(X) -->
	conjunction(X).
andor(X) -->
	disjunction(X).
impeq(X) -->
	implication(X).
impeq(X) -->
	equivalence(X).


conjunction(and) -->
	[and], {}.
conjunction(and) -->
	['*'], {}.

disjunction(or) -->
	[or], {}.
disjunction(or) -->
	['+'], {}.

implication(imp) -->
	[imp], {}.
implication(imp) -->
	['-'],['>'], {}.
implication(imp) -->
	['='], ['>'], {}.

equivalence(eq) -->
	[eq], {}.
equivalence(eq) -->
	['<'], ['-'], ['>'], {}.
equivalence(eq) -->
	['<'], ['='], ['>'], {}.


basic(X) -->
	[X],
	{ atom(X) }.





