dzn = "instance_day16.dzn"
File.rm(dzn)

  [header | rest] =

  (File.read!("instance_day16_clean.txt")
  |> String.split(["\n"], trim: true))

  n = hd(String.split(header, " ", trim: true)) |> String.to_integer()
  File.write(dzn, "T = #{n};\n", [:append])
  File.write(dzn, "C = 35;\n", [:append])

  {tasks, costs} = Enum.split(rest, 50)

  {start_times, end_times} = List.foldr(tasks, {[], []},
    fn line, {start_acc, end_acc} ->
      [_, s, e] = String.split(line, " ", trim: true)
      {[s | start_acc], [e | end_acc]}
    end)

  File.write(dzn, "start_times = array1d(1..#{n}, [#{Enum.join(start_times, ", ")}]);\n", [:append])
  File.write(dzn, "end_times = array1d(1..#{n}, [#{Enum.join(end_times, ", ")}]);\n", [:append])

  costs_map = Enum.reduce(costs, Map.new(), fn c, map_acc ->
    [task1, task2, cost] = String.split(c, " ", trim: true)
    Map.put(map_acc, {String.to_integer(task1), String.to_integer(task2)}, String.to_integer(cost))
  end)

  cost_matrix = for i <- 1..n do
    for j <- 1..n do
      Map.get(costs_map, {i, j}, 0)
    end
  end

  File.write(dzn, "cost = array2d(1..50, 1..50, [#{Enum.join(List.flatten(cost_matrix), ", ")}]);\n", [:append])
