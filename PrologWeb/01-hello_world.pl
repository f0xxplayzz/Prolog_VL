:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).		% new


:- http_handler(root(hello_world), say_hi, []).		% (1)
:- http_handler('/',say_root,[]).

:- use_module(library(http/http_error)).


server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).


say_root(Request) :-
        format('Content-type: text/plain~n~n'),
        format('You are at the root of this prolog server~n'),
        writeln(Request).

say_hi(_Request) :-
        reply_html_page(title('Hello World'),
                        [ h1('Hello World'),
                          p(['This example demonstrates generating HTML ',
                             'messages from Prolog'
                            ])
                        ]).
