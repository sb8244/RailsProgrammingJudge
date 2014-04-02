require 'spec_helper'

describe JavaMind do
  let(:source_count) { Dir["spec/java_source/**/*.java"].length }

  def clean_class!
    FileUtils.rm_f(Dir["spec/java_source/**/*.class"])
  end

  describe "compiling" do
    it "should create .class files for a directory" do
      expect {
        JavaMind.new("spec/java_source").compile!
      }.to change { Dir["spec/java_source/**/*.class"].length }.from(0).to(source_count)
      clean_class!
    end

    context "when directory does not exist" do
      it "should not create .class files" do
        expect {
          expect {
            JavaMind.new("spec/java_source_not_directory").compile!
          }.not_to change { Dir["spec/java_source/**/*.class"].length }
        }.to raise_error(CompileTimeError)
      end
      it "should have error" do
        expect{ JavaMind.new("spec/java_source_not_directory").compile! }.to raise_error(CompileTimeError)
      end
    end

    context "when java has errors" do 
      it "should not create .class files" do
        expect {
          expect {
            JavaMind.new("spec/java_source_error").compile!
          }.not_to change { Dir["spec/java_source_error/**/*.class"].length }
        }.to raise_error(CompileTimeError)
      end

      it "should have error when compile fails" do
        expect{ JavaMind.new("spec/java_source_error").compile! }.to raise_error(CompileTimeError)
      end
    end
  end

  describe "run" do
    subject{ JavaMind.new("spec/java_source") }
    before(:each) { subject.compile! }
    after(:each) { clean_class! }

    it "gives the right output" do
      expect( subject.run! ).to eq("output\n")
    end

    it "reads the single line input" do
      expect( subject.run!({input: "hi"}) ).to eq("hi\noutput\n")
    end

    it "reads the multi line input" do
      expect( subject.run!({input: "hi\n1\n2"}) ).to eq("hi\n1\n2\noutput\n")
    end
  end
end
