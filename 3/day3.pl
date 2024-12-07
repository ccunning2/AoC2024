:- use_module('../readLines').

:- use_module(library(pcre)). %  regex library

part1 :-
    read_file_construct_list('3/input.txt', List),
    parse_each_line(List, [], NumList),
    add_them_up(NumList, 0, Result),
    write('The result is '), write(Result).

part2 :-
    read_file_construct_list('3/input.txt', List),
    filter_each_line(List, [], FilteredList),
    parse_each_line(FilteredList, [], NumList),
    print_pairs(NumList),
    add_them_up(NumList, 0, Result),
    write('The result is '), write(Result).


print_pairs([]).
print_pairs([ Pairs  | T]) :-
    write(Pairs),
    nl, 
    print_pairs(T).

part2_2 :-
    read_file_construct_list('3/input.txt', List),
    filter_each_line(List, [], FilteredList),
    parse_each_line_2(FilteredList, [], NumList),
    add_them_up(NumList, 0, Result),
    write('The result is '), write(Result).


parse_each_line([], Result, Result).
parse_each_line([Line|Lines], Acc, Result) :-
    extract_matches('mul\\((\\d+),(\\d+)\\)', Line, Nums),
    append(Acc, Nums, NewAcc),
    parse_each_line(Lines, NewAcc, Result).

parse_each_line_2([], Result, Result).
parse_each_line_2([Line|Lines], Acc, Result) :-
    extract_matches("(?<!don't\\(\\))(?<=do\\(\\))?mul\\((\\d+),(\\d+)\\)", Line, Nums),
    append(Acc, Nums, NewAcc),
    parse_each_line_2(Lines, NewAcc, Result).


extract_matches(Pattern, String, Matches) :-
    re_foldl(match_collector, Pattern, String, [], Matches, []).

match_collector(SubMatch, Acc, [ [Xnum,Ynum] | Acc ]) :-
    X = SubMatch.1,
    Y = SubMatch.2,
    number_string(Xnum, X),
    number_string(Ynum, Y).% Extract the actual matched substring


add_them_up([], Result, Result).
add_them_up([ [Num1, Num2] | T], Acc, Result) :-
    NewAcc is Acc + Num1 * Num2,
    add_them_up(T, NewAcc, Result).

filter_each_line([], Result, Result).
filter_each_line([Line|Lines], Acc, Result) :-
    replace_all(Line, "don\\'t\\(\\).*?do\\(\\)", "",  Filtered),
    % Now get rid of any trailing 'donts'
    re_replace("don\\'t\\(\\).*", "", Filtered, Filtered2),
    asserta(filtered_line(Filtered2)),
    append(Acc, [Filtered2], NewAcc),
    filter_each_line(Lines, NewAcc, Result).


replace_all(String, Pattern, Replacement, Result) :-
    replace_all_recursive(String, Pattern, Replacement, Result).

replace_all_recursive(String, Pattern, Replacement, Result) :-
    re_replace(Pattern, Replacement, String, NewString), % Apply the first replacement
    (String \= NewString -> % Check if the string was modified
    replace_all_recursive(NewString, Pattern, Replacement, Result) 
    ;
    Result = String
    ). % Continue replacing


test3(X) :-
    replace_all("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))", "don\\'t\\(\\).*?do\\(\\)", "", X).
