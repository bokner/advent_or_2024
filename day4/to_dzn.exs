dzn = "instance_day4.dzn"
File.rm(dzn)
content = File.read!("instance_req_clean.txt")

#{from, to, data} =

  lines = String.split(content, "\n")

  requirements = Enum.reduce(lines, [], fn line, acc ->
      rec = String.split(line, " ", trim: true)
      acc ++ rec
    end)



  requirements_str = Enum.join(requirements, ", ")

  File.write(dzn, "requirements = array3d(1..4, 1..4, 1..4, [#{requirements_str}]);\n\n", [:append])
