dzn = "instance_day19.dzn"
File.rm(dzn)
instance_file = "instance_car1.txt"

  [header | data] =
  (File.read!(instance_file)
  |> String.split(["\n"], trim: true))


  [n_cars, n_machines] = String.split(header, " ", trim: true)
  n = String.to_integer(n_cars)
  m = String.to_integer(n_machines)
  File.write(dzn, "N = #{n};\n", [:append])
  File.write(dzn, "M = #{m};\n", [:append])

  duration_matrix = Enum.map(data, fn row -> ["" | String.split(row, " ", trim: true)]
    |> Enum.take_every(2) |> tl() end)

  File.write(dzn, "durations = array2d(1..#{n}, 1..#{m}, [\n#{Enum.map(duration_matrix, fn car -> Enum.join(car, ", ") end) |> Enum.join(", \n")}]);\n\n", [:append])

  formatted_distances = Enum.map_join(distance_rows, ",\n", fn row -> Enum.join(row, ", ") end)

  File.write(dzn, "distances = array2d(1..#{n}, 1..#{n}, [\n#{formatted_distances}]);\n\n", [:append])
