class Comparer

  # Do the comparison of two strings to see if they match the following criteria
  #   Success : Equal with trailing newlines removed
  #   Output Format Error : Equal with spaces removed and converted to lowercase
  #   Wrong Answer : Neither of those
  def self.compare(output: "", expected: "")
    output = output.chomp
    expected = expected.chomp

    if output.eql?(expected)
      :success
    else
      output = output.downcase.gsub(/\s+/, "")
      expected = expected.downcase.gsub(/\s+/, "")
      if output.eql?(expected)
        :format_error
      else
        :wrong_answer
      end
    end
  end

end