:- module(readLines, [read_file_construct_list/2]).

read_file_construct_list(File, Lines) :-
    open(File, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).


read_lines(Stream, []) :-
    at_end_of_stream(Stream).

read_lines(Stream, [Line|Lines]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    read_lines(Stream, Lines).


