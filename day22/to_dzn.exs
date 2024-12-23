instance_file = "instance_abz7.txt"
dzn = String.replace(instance_file, ".txt", ".dzn")
File.rm(dzn)


  [header | data] =
  (File.read!(instance_file)
  |> String.split(["\n"], trim: true))


  [n_jobs, n_machines] = String.split(header, " ", trim: true)
  n = String.to_integer(n_jobs)
  m = String.to_integer(n_machines)
  File.write(dzn, "N = #{n};\n", [:append])
  File.write(dzn, "M = #{m};\n", [:append])

  {steps, durations} =
    (Enum.join(data, "")
    |> String.split(" ", trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [m, d] -> {String.to_integer(m) + 1, d} end)
    |> Enum.unzip())
  # duration_matrix = Enum.map(data, fn row -> ["" | String.split(row, " ", trim: true)]
  #   |> Enum.take_every(2) |> tl() end)
  File.write(dzn, "steps = array2d(1..#{n}, 1..#{m}, [\n#{Enum.join(steps, ", ")}]);\n\n", [:append])

  File.write(dzn, "durations = array2d(1..#{n}, 1..#{m}, [\n#{Enum.join(durations, ", ")}]);\n\n", [:append])

  # formatted_distances = Enum.map_join(distance_rows, ",\n", fn row -> Enum.join(row, ", ") end)

  # File.write(dzn, "distances = array2d(1..#{n}, 1..#{n}, [\n#{formatted_distances}]);\n\n", [:append])
