dzn = "instance_day20.dzn"
File.rm(dzn)

  [n_str, _ | data] =
  (File.read!("instance_day20_clean.txt")
  |> String.split(["\n", "\t", " "], trim: true))


  n = String.to_integer(n_str)
  File.write(dzn, "N = #{n};\n", [:append])

  data_rows = Enum.chunk_every(data, n)

  {flow_rows, distance_rows} = Enum.split(data_rows, n)

  formatted_flow_rows = Enum.map_join(flow_rows, ",\n", fn row -> Enum.join(row, ", ") end)

  File.write(dzn, "flow = array2d(1..#{n}, 1..#{n}, [\n#{formatted_flow_rows}]);\n\n", [:append])

  formatted_distances = Enum.map_join(distance_rows, ",\n", fn row -> Enum.join(row, ", ") end)

  File.write(dzn, "distances = array2d(1..#{n}, 1..#{n}, [\n#{formatted_distances}]);\n\n", [:append])
