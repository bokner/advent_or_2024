dzn = "instance_day6.dzn"
File.rm(dzn)
content = File.read!("instance_day6_clean.txt")

#{from, to, data} =

  lines = String.split(content, "\n") |> Enum.reject(fn line -> String.starts_with?(line, "#") end)

  [header | data] = lines

  [num_segments, num_combos] = String.split(header, " ", trim: true)

  {costs, combinations} = List.foldr(data, {[], []}, fn line, {costs_acc, combs_acc} = acc ->
      [c | combs] = String.split(line, " ", trim: true)
      {[c | costs_acc], ["{#{Enum.join(combs, ",")}}" | combs_acc]}
    end)

  File.write(dzn, "NUM_SEGMENTS = #{num_segments};\n", [:append])
  File.write(dzn, "NUM_SUBSETS = #{num_combos};\n\n", [:append])

  File.write(dzn, "costs = array1d(1..#{num_combos}, [#{Enum.join(costs, ", ")}]);\n\n", [:append])
  File.write(dzn, "combinations = array1d(1..#{num_combos}, [#{Enum.join(combinations, ", ")}]);\n\n", [:append])
