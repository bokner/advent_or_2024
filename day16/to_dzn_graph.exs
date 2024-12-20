dzn = "instance_day16_graph.dzn"
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
      {[String.to_integer(s) | start_acc], [String.to_integer(e) | end_acc]}
    end)

  File.write(dzn, "start_times = array1d(1..#{n}, [#{Enum.join(start_times, ", ")}]);\n", [:append])
  File.write(dzn, "end_times = array1d(1..#{n}, [#{Enum.join(end_times, ", ")}]);\n", [:append])

  edges = for i <- 0..n-1, j <- 0..n-1, i != j, reduce: [] do
    acc ->
      if Enum.at(end_times, i) < Enum.at(start_times, j) do
        [{i, j} | acc]
      else
        acc
      end
  end

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

  ## Graph
  ## The directed edge between task[i] and task[j] iff end_times[task[i]] < start_times[task[j]]
  edges = for i <- 0..n-1, j <- 0..n-1, i != j, reduce: [] do
    acc ->
      if Enum.at(end_times, i) < Enum.at(start_times, j) do
        [{i+1, j+1} | acc]
      else
        acc
      end
  end |> Enum.reverse()

  num_edges = length(edges)
  {from, to} = Enum.unzip(edges)

  File.write(dzn, "E = #{num_edges};\n", [:append])
  File.write(dzn, "N = #{n};\n", [:append])

  File.write(dzn, "from = array1d(1..#{num_edges}, [#{Enum.join(from, ", ")}]);\n", [:append])
  File.write(dzn, "to = array1d(1..#{num_edges}, [#{Enum.join(to, ", ")}]);\n", [:append])

  weight = Enum.map(edges, fn {s, e} -> Map.get(costs_map, {s, e}, 0) end)
  File.write(dzn, "weight = array1d(1..#{num_edges}, [#{Enum.join(weight, ", ")}]);\n", [:append])
