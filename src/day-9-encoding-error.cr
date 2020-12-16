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

  invalid_data = -1_i64
  (PREAMBLE...data.size).each do |index|
    invalid_data = data[index] unless is_valid(data[index], data[(index - PREAMBLE)...index])
  end

  puts "invalid: #{invalid_data}"

  start_index, end_index = find_set(invalid_data, data)
  weakness_low = data[start_index..end_index].min
  weakness_high = data[start_index..end_index].max
  weakness = weakness_low + weakness_high

  puts "Encryption Weakness: #{weakness}"
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

def find_set(sum : Int64, data : Array(Int64))
  (0...data.size).each do |start_index|
    total = data[start_index]
    end_index = start_index
    while total < sum
      end_index += 1
      total += data[end_index]
    end
    return start_index, end_index if total == sum
  end
  return 0, 0
end