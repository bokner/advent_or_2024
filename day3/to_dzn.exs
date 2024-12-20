dzn = "instance_day3.dzn"
File.rm(dzn)
content = File.read!("instance_day3.txt")

#{from, to, data} =

  lines = String.split(content, "\n")

  costs = Enum.reduce(lines, [], fn line, acc ->
      rec = String.split(line, " ", trim: true)
      acc ++ rec
    end)

  File.write(dzn, "N = 100;\n", [:append])
  File.write(dzn, "T = 100;\n", [:append])

  cost_values = Enum.join(costs, ", ")

  File.write(dzn, "costs = array2d(1..100, 1..100, [#{cost_values}]);\n\n", [:append])
