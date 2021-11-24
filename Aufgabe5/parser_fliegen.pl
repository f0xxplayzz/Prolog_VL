/*
 *
 *
 * ein recursive descent parser fuer eine kleine Grammatik
 * (c) AVH 2008
 *
 *
 */
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
	member(C,['0','1','2','3','4','5','6','7','8','9']).

last_token('.').
last_token(end_of_file).

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

satz(X) -->
        wsatz(W),
        dsatz(D),
        {X=satz(W,D)}.
satz(X) -->
        nsatz(X).


wsatz(X) -->
        [wenn], pp(PP), sub(Sub), verb(Verb),
        {X=wsatz(wenn,PP,Sub,Verb)}.
wsatz(X) -->
        [wenn], sub(Sub), obj(Obj), verb(Verb),
        {X=wsatz(wenn,Sub,Obj,Verb)}.

dsatz(X) -->
        [dann], verb(Verb), sub(Sub), obj(Obj), vv(VV),
        {X=dsatz(dann,Verb,Sub,Obj,VV)}.
dsatz(X) -->
        verb(Verb), sub(Sub), obj(Obj), vv(VV),
        {X=dsatz(Verb,Sub,Obj,VV)}.

nsatz(X) -->
        sub(Sub), verb(Verb), obj(Obj), vv(VV),
        {X=nsatz(Sub,Verb,Obj,VV)}.
nsatz(X) -->
        sub(Sub), verb(Verb),
        {X=nsatz(Sub,Verb)}.


pp(X) -->
        [hinter],nom(Nom),
        {X=pp(hinter,Nom)}.
pp(X) -->
        [vor],nom(Nom),
        {X=pp(vor,Nom)}.

sub(X) -->
        nom(Nom),
        {X=sub(Nom)}.

obj(X) -->
        nom(Nom),
        {X=obj(Nom)}.

verb(X) -->
        [fliegen],
        {X=verb(fliegen)}.
verb(X) -->
        [fahren],
        {X=verb(fahren)}.
verb(X) -->
        [marschieren],
        {X=verb(marschieren)}.

nom(X) -->
        [fliegen],
        {X=nom(fliegen)}.
nom(X) -->
        [ameisen],
        {X=nom(ameisen)}.
nom(X) -->
        [menschen],
        {X=nom(menschen)}.
nom(X) -->
        [autos],
        {X=nom(autos)}.

vv(X) -->
        [voraus],
        {X=vv(voraus)}.
vv(X) -->
        [hinterher],
        {X=vv(hinterher)}.



parse(Input,Tree) :-
  satz(Tree,Input,[]).

parseIO:-
        prompt(OldPrompt,'Satz eingeben oder "quit.": '),
        scan_in(Input),
        prompt(_,OldPrompt),
        (   Input == [quit,'.'] -> abort ; true ),
        delete(Input,'.',Tokens),
        parse(Tokens,Out),
        write('Parsbaum:'),
        writeln(Out),!,
        parseIO.

parseFile:-
        prompt(_,'Welche Datei soll geparst werden oder "quit.": '),
        read(File),
        (   File == [quit,'.'] -> abort ; true ),
        see(File),
        scan_in_files(Input),
        delete(Input,'.',Tokens),
        parse(Tokens,Out),
        write('Parsbaum:'),
        writeln(Out),!,
        parseFile_help.

parseFile_help:-
        scan_in_files(Input),
        delete(Input,'.',Tokens),
        parse(Tokens,Out),
        write('Parsbaum:'),
        writeln(Out),!,
        parseFile_help.

parseFile_to_file:-
        prompt(_,'Welche Datei soll geparst werden oder "quit.": '),
        read(File),
        (   File == [quit,'.'] -> abort ; true ),
        prompt(_,'In welche Datei soll geschrieben werden oder "quit.": '),
        read(File2),
        (   File2 == [quit,'.'] -> abort ; true ),
        see(File),
        append(File2),
        scan_in_files(Input),
        delete(Input,'.',Tokens),
        parse(Tokens,Out),
        write('Parsbaum:'),
        write(Out),
        write('\n'),!,
        parseFile_to_file_help.

parseFile_to_file_help:-
        scan_in_files(Input),
        delete(Input,'.',Tokens),
        parse(Tokens,Out),
        write('Parsbaum:'),
        write(Out),
        write('\n'),!,
        parseFile_to_file_help.