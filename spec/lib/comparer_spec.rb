require 'spec_helper'

describe Comparer do

  describe "compare" do
    context "success" do
      it "2 eql strings" do
        expect( Comparer.compare({output: "output\n1", expected: "output\n1"}) ).to eq(:success)
      end 
      it "has single trailing \n" do
        expect( Comparer.compare({output: "output\n1\n", expected: "output\n1"}) ).to eq(:success)
      end
    end

    context "format error" do
      it "has caps issues" do
        expect( Comparer.compare({output: "Output\n1", expected: "output\n1"}) ).to eq(:format_error)
      end
      it "has double trailing \n" do
        expect( Comparer.compare({output: "output\n1\n\n", expected: "output\n1"}) ).to eq(:format_error)
      end
      it "has extra spaces" do
        expect( Comparer.compare({output: "out put\n1", expected: "output\n1"}) ).to eq(:format_error)
      end
      it "has extra lines" do
        expect( Comparer.compare({output: "\n\noutput\n1", expected: "output\n1"}) ).to eq(:format_error)
      end
    end

    context "wrong answer" do
      it "is wrong" do
        expect( Comparer.compare({output: "putput\n1", expected: "output\n1"}) ).to eq(:wrong_answer)
      end
    end
  end

end