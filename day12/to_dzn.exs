dzn = "instance_day12.dzn"
File.rm(dzn)

  distances =
  (File.read!("instance_day12_clean.txt")
  |> String.split(["\n", " "], trim: true))

  n = floor(:math.sqrt(length(distances)))
  formatted_distances = Enum.chunk_every(distances, n) |> Enum.map_join(",\n", fn row -> Enum.join(row, ", ") end)
  File.write(dzn, "N = #{n};\n", [:append])
  File.write(dzn, "distances = array2d(1..#{n}, 1..#{n}, [#{formatted_distances}]);\n", [:append])
