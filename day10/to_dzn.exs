dzn = "instance_day10_small.dzn"
File.rm(dzn)

[header | connections] =
  (File.read!("instance_small.txt")
  |> String.split("\n", trim: true))

  [num_components, num_connections] = String.split(header, " ", trim: true)
  File.write(dzn, "N = #{num_components};\n", [:append])
  File.write(dzn, "C = #{num_connections};\n", [:append])

  {from, to} =
    List.foldr(connections, {[], []}, fn line, {from_acc, to_acc} ->
      [f, t] = String.split(line, " ", trim: true)
      {[f | from_acc], [t | to_acc]}
    end)

    File.write(dzn, "from = array1d(1..#{num_connections}, [#{Enum.join(from, ",")}]);\n", [:append])
    File.write(dzn, "to = array1d(1..#{num_connections}, [#{Enum.join(to, ",")}]);\n", [:append])
