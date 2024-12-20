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