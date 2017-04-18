# Different methods of parsing training data
module ParseTrainingData
  # Parse training data from a file that includes the full documents
  def parse_from_file_with_docs(training_data)
    return File.read(training_data).split("\n").map{|l| l.split(", ", 2)}.map{|h| {label: h[0], data: h[1]}}
  end
end
