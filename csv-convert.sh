awk '{
  line = ""
  for (i = 1; i <= NF; i++) {
    if ($i ~ /\(.*\)/) {
      # Field has parentheses, add commas around it
      gsub(/[(]/, ",(", $i)
      gsub(/[)]/, "),", $i)
      line = line $i " "
    } else {
      # Field doesn't have parentheses, process it
      gsub(/,/, "", $i)  # Remove commas if any
      line = line $i (i < NF ? "," : "\n")
    }
  }
  printf("%s", line)
}' input.txt > output.csv
