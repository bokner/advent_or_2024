File.rm!("instance_day1.mzn")
content = File.read!("instance_day1.txt")
String.split(content, "\n")
|> Enum.each(fn str ->
    if String.starts_with?(str, "e ") do
      [e1, e2] = String.split(str) |> tl
      c = "constraint event_room[#{e1}] != event_room[#{e2}];\n"
      File.write("instance_day1.mzn", c, [:append])
    else
      :ok
    end
  end)
