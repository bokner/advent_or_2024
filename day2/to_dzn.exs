dzn = "instance_day2.dzn"
File.rm!(dzn)
content = File.read!("instance_day2.txt")

#{from, to, data} =

  lines = String.split(content, "\n")

  {from, to, data} = Enum.reduce(lines, {[], [], Map.new()}, fn str, {from_acc, to_acc, data_acc} = acc ->
      if str do
      rec = String.split(str, " ", trim: true)
      case rec do
        [c1, c2, distance, fuel] ->
          {[c1 | from_acc], [c2 | to_acc], Map.put(data_acc, {String.to_integer(c1), String.to_integer(c2)}, %{distance: distance, fuel: fuel})}
        _  -> acc
        end
      else
        acc
      end
    end)

  from_values = Enum.join(Enum.reverse(from), ", ")
  to_values = Enum.join(Enum.reverse(to), ", ")

  e = length(from)
  from_dzn = "from = array1d(1..#{e}, [#{from_values}]);"
  to_dzn = "to = array1d(1..#{e}, [#{to_values}]);"

  File.write(dzn, "N = 100;\n", [:append])
  File.write(dzn, "E = #{e};\n", [:append])

  #to_dzn =   "to = array1d(1..100,[#{from_values}]);"
  File.write(dzn, from_dzn <> "\n\n", [:append])
  File.write(dzn, to_dzn <> "\n\n", [:append])
  distances = for i <- 1..100, j <- 1..100 do
    case Map.get(data, {i, j}) do
      nil -> 0
      d -> d.distance
    end
  end
  distance_values = Enum.join(distances, ", ")
  File.write(dzn, "distances = array2d(1..100, 1..100, [#{distance_values}]);\n\n", [:append])

  fuel = for i <- 1..100, j <- 1..100 do
    case Map.get(data, {i, j}) do
      nil -> 0
      d -> d.fuel
    end
  end
  fuel_values = Enum.join(fuel, ", ")
  File.write(dzn, "fuel = array2d(1..100, 1..100, [#{fuel_values}]);\n\n", [:append])
