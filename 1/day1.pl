:- use_module('../readLines').


part1 :-
        read_file_construct_list('1/input.txt', List),
        construct_lists_split_by_space(List, [],[], List1, List2),
        compute_total(List1, List2, 0).

part2 :-
        read_file_construct_list('1/input.txt', List),
        construct_lists_split_by_space(List, [],[], List1, List2),
        compute_total_2(List1, List2, 0).


construct_lists_split_by_space([], Acc1, Acc2, List1, List2) :-
    reverse(Acc1, List1),
    reverse(Acc2, List2),
    asserta(list1(List1)),
    asserta(list2(List2)).

construct_lists_split_by_space([Line|List], Acc1, Acc2, List1, List2) :-
    split_string(Line, " ", "", RawWords),
    exclude(==( ""), RawWords, [NumString1, NumString2]),
    number_string(Num1, NumString1),
    number_string(Num2, NumString2),
    NewAcc1 = [Num1|Acc1],
    NewAcc2 = [Num2|Acc2],
    construct_lists_split_by_space(List, NewAcc1, NewAcc2, List1, List2).


min_in_list([Min], Min).

min_in_list([H|T], Min) :-
    min_in_list(T, TailMin),
    Min is min(H, TailMin).


remove_first(_, [], []).
remove_first(Elem, [Elem|Tail], Tail). % Remove the first occurrence and stop.
remove_first(Elem, [Head|Tail], [Head|Result]) :-
    Elem \= Head,
    remove_first(Elem, Tail, Result).

compute_total([], [], Total) :-
    write("Total is "), write(Total).

compute_total(List1, List2, Total) :-
    min_in_list(List1, Min1),
    min_in_list(List2, Min2),
    NewTotal is Total + abs(Min1 - Min2),
    remove_first(Min1, List1, NewList1),
    remove_first(Min2, List2, NewList2),
    compute_total(NewList1, NewList2, NewTotal).


count_occurences(Val, [], Accumulated, Total) :-
    Total = Accumulated.

count_occurences(Val, [H|T], Count, Total) :-
    Val == H -> (NewCount is Count + 1, count_occurences(Val, T, NewCount, Total) );
    count_occurences(Val, T, Count, Total).


compute_total_2([], _, Total) :-
    write("Total is "), write(Total).

compute_total_2([H|T], List2, Total ) :-
    % Multiple each element in list1 by the frequency of occurence in list2, add them all together for the total
    count_occurences(H, List2, 0, Count),
    NewTotal is Total + Count * H,
    compute_total_2(T, List2, NewTotal).