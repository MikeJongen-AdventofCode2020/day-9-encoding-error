require "option_parser"
require "benchmark"
require "string_scanner"

file_name = ""
benchmark = false

PREAMBLE = 25

OptionParser.parse do |parser|
  parser.banner = "Welcome to Report Repair"

  parser.on "-f FILE", "--file=FILE", "Input file" do |file|
    file_name = file
  end
  parser.on "-b", "--benchmark", "Measure benchmarks" do
    benchmark = true
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

unless file_name.empty?
  data_str = File.read_lines(file_name)
  data = [] of Int64
  data_str.each do |value|
    data << value.to_i64
  end

  (PREAMBLE...data.size).each do |index|
    puts "invalid: #{data[index]}" unless is_valid(data[index], data[(index - PREAMBLE)...index])
  end

end

def is_valid(value : Int64, previous : Array(Int64))
  sum = 0
  (0...previous.size).each do |index1|
    (index1...previous.size).each do |index2|
      return true if (previous[index1] + previous[index2]) == value unless (previous[index1] == previous[index2])
    end
  end
  return false
end