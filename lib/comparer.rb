class Comparer

  # Do the comparison of two strings to see if they match the following criteria
  #   Success : Equal with trailing newlines removed
  #   Output Format Error : Equal with spaces removed and converted to lowercase
  #   Wrong Answer : Neither of those
  def self.compare(output: "", expected: "")
    # Chomp off the last whitespace character because some users put it and some don't
    # This is a pain. Output has literal newlines while expected has \n. Replace the literal
    # new lines with \n to get out any inconsistencies
    output = output.chomp.gsub(/\r\n?/, "\n")
    expected = expected.chomp.gsub(/\r\n?/, "\n")

    if output == expected
      :success
    else
      output = output.downcase.gsub(/\s+/, "")
      expected = expected.downcase.gsub(/\s+/, "")
      if output == expected
        :format_error
      else
        :wrong_answer
      end
    end
  end

end
