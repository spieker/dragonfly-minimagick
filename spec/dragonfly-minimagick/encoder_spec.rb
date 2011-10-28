require 'spec_helper'

describe Dragonfly::Minimagick::Encoder do

  before(:all) do
    sample_file = SAMPLES_DIR + '/beach.png' # 280x355
    @image = Dragonfly::TempObject.new(File.new(sample_file))
    @encoder = Dragonfly::Minimagick::Encoder.new
  end

  describe "#encode" do
  
    it "should encode the image to the correct format" do
      image = @encoder.encode(@image, :gif)
      image.should have_format('gif')
    end
  
    it "should throw :unable_to_handle if the format is not handleable" do
      lambda{
        @encoder.encode(@image, :goofy)
      }.should throw_symbol(:unable_to_handle)
    end
  
    it "should do nothing if the image is already in the correct format" do
      image = @encoder.encode(@image, :png)
      image.should == @image
    end
  
    it "should work when not using the filesystem" do
      image = @encoder.encode(@image, :gif)
      image.should have_format('gif')
    end

  end

end
