dzn = "instance_day18.dzn"
File.rm(dzn)

  [header | data] =

  (File.read!("instance_day18_clean.txt")
  |> String.split(["\n"], trim: true))

  [n, e] = (String.split(header, " ", trim: true))
  File.write(dzn, "N = #{n};\n", [:append])
  File.write(dzn, "E = #{e};\n", [:append])

  {edge_data, [node_count, mandatory_nodes]} = Enum.split(data, String.to_integer(e))

  m = String.trim(node_count) |> String.to_integer()
  File.write(dzn, "M = #{m};\n", [:append])
  File.write(dzn, "mandatory = array1d(1..#{m}, [#{String.split(mandatory_nodes, " ", trim: true) |> Enum.join(", ")}]);\n", [:append])

  {from, to, weight} = List.foldr(edge_data, {[], [], []},
    fn line, {from_acc, to_acc, weight_acc} ->
     [f, t, w] = String.split(line, " ", trim: true)
     {[f | from_acc], [t | to_acc], [w | weight_acc]}
    end
  )

  File.write(dzn, "from = array1d(1..#{e}, [#{Enum.join(from, ", ")}]);\n", [:append])
  File.write(dzn, "to = array1d(1..#{e}, [#{Enum.join(to, ", ")}]);\n", [:append])
  File.write(dzn, "weight = array1d(1..#{e}, [#{Enum.join(weight, ", ")}]);\n", [:append])


