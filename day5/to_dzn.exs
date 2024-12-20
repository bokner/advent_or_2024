dzn = "instance_day5.dzn"
File.rm(dzn)
content = File.read!("instance_day5_clean.txt")

#{from, to, data} =

  lines = String.split(content, "\n")

  [num_warehouses_str, num_clients_str | rest] = all_data = Enum.reduce(lines, [], fn line, acc ->
      rec = String.split(line, " ", trim: true)
      acc ++ rec
    end) |> List.flatten()


  num_warehouses = String.to_integer(num_warehouses_str)
  num_clients = String.to_integer(num_clients_str)
  File.write(dzn, "W = #{num_warehouses};\n", [:append])
  File.write(dzn, "C = #{num_clients};\n\n", [:append])

  {w_data, client_data} = Enum.split(rest, 32)

  per_warehouse_data = Enum.chunk_every(w_data, 2)
  {max_demand, fixed_cost} = List.foldr(per_warehouse_data, {[], []},
    fn [demand, cost], {d_acc, cost_acc} ->
    {[demand | d_acc], [cost | cost_acc]}
  end)

  File.write(dzn, "max_demand = array1d(1..#{num_warehouses}, [#{Enum.join(max_demand, ", ")}]);\n\n", [:append])
  File.write(dzn, "fixed_cost = array1d(1..#{num_warehouses}, [#{Enum.join(fixed_cost, ", ")}]);\n\n", [:append])

  per_client_data = Enum.chunk_every(client_data, num_warehouses + 1)

  {client_demand, client_costs} = List.foldr(per_client_data,
    {[], []},
    fn [d | costs], {demand_acc, cost_acc} ->
      {[d | demand_acc], costs ++ cost_acc}
    end
  )

  File.write(dzn, "client_demand = array1d(1..#{num_clients}, [#{Enum.join(client_demand, ", ")}]);\n\n", [:append])
  File.write(dzn, "client_costs = array2d(1..#{num_clients}, 1..#{num_warehouses}, [#{Enum.join(client_costs, ", ")}]);\n\n", [:append])
