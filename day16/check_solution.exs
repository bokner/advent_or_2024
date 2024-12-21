# result = [
# {6,16},
# {7,19,27,49},
# {8,20},
# {9,18,22,42},
# {10,17,26,39,40,41},
# {11,24,36,45},
# {12,25,30,46},
# {13,21,29,33,35,37,43,48},
# {14,23},
# {15,28,31,32,34,38,44,47,50}
# ] |> Enum.map(fn t -> Tuple.to_list(t) end)

result =
[
{29,42},
{30,45},
{31,36,46},
{32,47},
{33,39,48},
{34,38,40,44,49},
{35,37,43,50}
] |> Enum.map(fn t -> Tuple.to_list(t) end)

true = Enum.all?(result, fn seq ->
    Enum.all?(0..length(seq) - 2,
        fn idx ->
        task = Enum.at(seq, idx)
        next_task = Enum.at(seq, idx + 1)
        Enum.at(end_times, task - 1) < Enum.at(start_times, next_task - 1)
    end)
end)

total_weight =
    Enum.reduce(result, 0, fn seq, acc ->
        Enum.reduce(0..length(seq) - 2, acc,
            fn idx, acc2 ->
            task = Enum.at(seq, idx)
            next_task = Enum.at(seq, idx + 1)
            acc2 + (Enum.at(cost_matrix, task - 1) |> Enum.at(next_task - 1))
        end)
    end)
