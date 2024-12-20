dzn = "instance_day8_(xx).dzn"
File.rm(dzn)
content = File.read!("instance_day8_clean.txt")

lines = String.split(content, "\n") |> Enum.reject(fn line -> String.starts_with?(line, "#") end)

Enum.reduce_while(lines, lines, fn line, [] -> {:halt, :done}
  line, rest_acc ->
  [instance_id, instance_header | rest] = rest_acc
  [capacity, num_items, best_solution] = String.split(instance_header, " ", trim: true)
  n = String.to_integer(num_items)
  {items, new_rest} = Enum.split(rest, n)
  dzn = "instance_day8_#{instance_id}.dzn"
  File.rm(dzn)
  File.write(dzn, "%% BKS: #{best_solution};\n", [:append])
  File.write(dzn, "N = #{num_items};\n", [:append])
  File.write(dzn, "C = #{capacity};\n", [:append])
  File.write(dzn, "item_sizes = array1d(1..#{num_items}, [#{Enum.join(items, ",")}]);\n",
  [:append])
  {:cont, new_rest}
end)
