:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_files)).
:- use_module(library(http/websocket)).
:-use_module(library(clpfd)).


:- initialization 
    http_server(http_dispatch, [port(8080)]).

:- http_handler('/',say_root,[]).

:- http_handler(root(.), http_reply_from_files('.', []), [prefix]).

say_root(_Request) :-
    get_files_from('.',Files),
    transform_to_urls(Files,Urls),
    append([
        h1('Prolog WebServer von Jan Stoeffler'),
        p('Auf dieser Webseite sind alle Dateien der Prolog Vorlesung, sowie 
            die Loesungen der Aufgaben zu finden.')
    ],Urls,Y),
    append(Y,[
            h1('Taschenrechner'),
            p('Hier befindet sich der Taschenrechner, der noch fuer Aufgabe 7 gefordert war'),
            a([href('/Aufgaben7/Calculator/SWI-Prolog%20chat%20demo.html')],'Taschnerechner')
        ],Z),
    reply_html_page(
        title('Prolog WebServer von Jan Stoeffler'),
        Z
        ). 

getFolders(Name,Folders):- setof(Entry,directory_member(Name,Entry,[recursive(true)]),Folders).



getFiles([X],[X]):-
    string_chars(X,Y),
    member(.,Y),!.
getFiles([_],[]):-!.
getFiles([Folder|Folders],[Folder|Result]):-
    string_chars(Folder,Y),
    member(.,Y),!,
    getFiles(Folders, Result).
getFiles([_|Folders],[Result]):-
    !,
    getFiles(Folders, Result).

get_files_from(Foldername,Result):-
    getFolders(Foldername,Folders),
    getFiles(Folders,Result1),
    flatten(Result1, Result).

transform_to_urls([File],[URL]):-
    split_string(File, '/', '', SubStrings),
    last(SubStrings,Name),
    string_concat('/',File, Link),
    URL = div(a([href(Link)],Name)).
transform_to_urls([File|Files],[URL|URLS]):-
    split_string(File, '/', '', SubStrings),
    last(SubStrings,Name),
    string_concat('/',File, Link),
    URL = div(a([href(Link)],Name)),
    transform_to_urls(Files,URLS).

:- http_handler(root(ws),
	http_upgrade_to_websocket(echo, []),
	[spawn([])]).

:-consult('Aufgabe5/taschenrechner.pl').

echo(WebSocket) :-
    ws_receive(WebSocket, Message),
    (   Message.opcode == close
    ->  true
    ;   web_calc(Message.data,MessageRes),
        writeln(WebSocket),writeln(MessageRes), %avh: my line
	    ws_send(WebSocket, text(MessageRes)),
        echo(WebSocket)
    ).

is_a_digit(C):-member((C),['0','1','2','3','4','5','6','7','8','9']).

tokenize([C1,C2|Chars],[C|Tokens]):-
    is_a_digit(C1),is_a_digit(C2),!,
    term_to_atom(C1,D1),term_to_atom(C2,D2),
    Mem #= D1 + D2,
    number_string(Mem, C),tokenize(Chars,Tokens).
tokenize([C1,C2],[C]):-
    is_a_digit(C1),is_a_digit(C2),!,
    term_to_atom(C1,D1),term_to_atom(C2,D2),
    Mem #= D1 + D2,
    number_string(Mem, C).
tokenize([C],[C]).
tokenize([C|Chars],[C|Tokens]):-tokenize(Chars,Tokens).



web_calc(String,Result):-
    string_chars(String, Chars),
    tokenize(Chars,Tokens),
    calc(Tokens,Result).