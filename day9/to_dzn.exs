dzn = "instance_day9.dzn"
File.rm(dzn)

{items_w, items_h} =
  (File.read!("bin_packing2d_items.txt")
  |> String.split("\r\n", trim: true)
  |> List.foldr({[], []}, fn line, {w_acc, h_acc} ->
    [w, h] = String.split(line, " ", trim: true)
    {[w | w_acc], [h | h_acc]}
  end))

  File.write(dzn, "N = #{length(items_w)};\n", [:append])
  File.write(dzn, "item_width = [#{Enum.join(items_w, ",")}];\n", [:append])
  File.write(dzn, "item_height = [#{Enum.join(items_h, ",")}];\n", [:append])

  {bin_w, bin_h} =
    (File.read!("bin_packing2d_bins.txt")
    |> String.split("\n", trim: true)
    |> List.foldr({[], []}, fn line, {w_acc, h_acc} ->
      [w, h, n] = String.split(line, "\t", trim: true)
      {List.duplicate(String.to_integer(w),
        String.to_integer(n)) ++ w_acc,
        List.duplicate(String.to_integer(h), String.to_integer(n)) ++ h_acc}
    end))

    File.write(dzn, "B = #{length(bin_w)};\n", [:append])
    File.write(dzn, "bin_width = [#{Enum.join(bin_w, ",")}];\n", [:append])
    File.write(dzn, "bin_height = [#{Enum.join(bin_h, ",")}];\n", [:append])

  #File.write(dzn, "C = #{capacity};\n", [:append])
  #File.write(dzn, "item_sizes = array1d(1..#{num_items}, [#{Enum.join(items, ",")}]);\n",
