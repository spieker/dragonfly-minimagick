require 'spec_helper'

shared_examples_for "image analyser methods" do

  # NEEDS:
  # @image
  # @processor
  
  it "should return the width" do
    @analyser.width(@image).should == 280
  end

  it "should return the height" do
    @analyser.height(@image).should == 355
  end

  it "should return the aspect ratio" do
    @analyser.aspect_ratio(@image).should == (280.0/355.0)
  end

  it "should say if it's portrait" do
    @analyser.portrait?(@image).should be_true
  end

  it "should say if it's landscape" do
    @analyser.landscape?(@image).should be_false
  end

  it "should return the number of colours" do
    # @analyser.number_of_colours(@image).should == 34703
  end

  it "should return the depth" do
    @analyser.depth(@image).should == 8
  end

  it "should return the format" do
    @analyser.format(@image).should == :png
  end

  # %w(width height aspect_ratio number_of_colours depth format portrait? landscape?).each do |meth|
  #   it "should throw unable_to_handle in #{meth.inspect} if it's not an image file" do
  #     temp_object = Dragonfly::TempObject.new('blah')
  #     lambda{
  #       @analyser.send(meth, temp_object)
  #     }.should throw_symbol(:unable_to_handle)
  #   end
  # end

end

describe Dragonfly::Minimagick::Analyser do

  before(:each) do
    image_path = SAMPLES_DIR + '/beach.png'
    @image = Dragonfly::TempObject.new(File.new(image_path))
    @analyser = Dragonfly::Minimagick::Analyser.new
    @analyser.log = Logger.new(LOG_FILE)
  end

  describe "when using the filesystem" do
    before(:each) do
    end
    it_should_behave_like "image analyser methods"
  end

end
