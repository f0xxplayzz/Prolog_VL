:-use_module(library(clpfd)).


scan_in([Token|Tokens]) :-
	get_char(C),
	get_token(C,Token,C1),
	get_rest(Token,C1,Tokens).

scan_in_files([Token|Tokens]) :-
	get(In),
        ( In == -1, seen,told,abort; true),
        char_code(C,In),
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
	member((C),['0','1','2','3','4','5','6','7','8','9']).

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

calc(Input,Result):-
	expr(Result,Input,[]).

expr(X) -->
	term(T1),
	{X is T1}. 
expr(X) --> 
	term(T1),
    ['+'],
    term(T2),
    {X is T1+T2}.
expr(X) --> 
	term(T1),
    ['-'],
    term(T2),
    {X is T1-T2}.
term(X) -->
	term2(T1),
	{X is T1}.
term(X) --> 
	term2(T1),
    ['*'],
    term2(T2),
    {X is T2 *T1}.
term(X) --> 
	term2(T1),
    ['/'],
    term2(T2),
    {X is T2 /T1}.
term2(X) --> 
	[A],
    {term_to_atom(Y,A),
	integer(Y),
	X is Y}.
term2(X) -->
	[A,',',B],
	{term_to_atom(Y,A),
	term_to_atom(Y2,B),
	integer(Y),
	integer(Y2),
	number_chars(Y,Start),
	number_chars(Y2,End),
	append(['.'],End,F1),
	append(Start,F1,F2),
	number_chars(Float,F2),
	X is Float}.
term2(X) --> 
	['-'],
	term2(Y),
	{X is -Y}.
term2(X) -->
	['('], 
	expr(Y),
	[')'],
	{X is Y}.

calcIO:-
	prompt(Old_Prompt,'Term eingeben oder "quit."'),
	scan_in(Input),
	prompt(_,Old_Prompt),
	(   Input == [quit,'.'] -> abort ; true ),
	delete(Input,'.',Tokens),
	calc(Tokens,Out),
	write('Ergebnis:'),
	writeln(Out),!,
	calcIO.