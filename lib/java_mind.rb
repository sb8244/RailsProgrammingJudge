require 'open3'

class JavaMind

  def initialize(directory)
    @directory = directory
  end

  def compile!
    out = `javac #{@directory}/*.java #{standard_error}`
    raise CompileTimeError.new(out) unless out.blank?
    true
  end

  def run!(input: nil)
    # popen2e combines stdin and stderr into a single stream
    Open3.popen2e("cd #{@directory}; java #{self.class.default_class_name}") do |i, o|
      # prints the whole input including \n
      i.print(input)
      i.close
      # reads the whole file even \n
      o.read
    end
  end

  def self.default_class_name
    "Solution"
  end

  private

    # Capture stderr to out by default
    def standard_error
      "2>&1"
    end
end