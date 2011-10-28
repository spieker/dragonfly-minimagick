require 'spec_helper'

# Needs: @generator
shared_examples_for "image generator" do
  
  describe "generating an image with the given dimensions" do
    before(:each) do
      @image, @extra = @generator.plasma(23,12)
    end
    it {@image.should have_width(23)}
    it {@image.should have_height(12)}
    it {@image.should have_format('png')}
    it {@extra.should == {:format => :png, :name => 'plasma.png'}}
  end

  describe "specifying the format" do
    before(:each) do
      @image, @extra = @generator.plasma(23, 12, :gif)
    end
    it {@image.should have_format('gif')}
    it {@extra.should == {:format => :gif, :name => 'plasma.gif'}}
  end

  describe "text" do
    before(:each) do
      @text = "mmm"
    end

    describe "creating a text image" do
      before(:each) do
        @image, @extra = @generator.text(@text, :font_size => 12)
      end
      it {@image.should have_width(20..40)} # approximate
      it {@image.should have_height(10..20)}
      it {@image.should have_format('png')}
      it {@extra.should == {:format => :png, :name => 'text.png'}}
    end

    describe "specifying the format" do
      before(:each) do
        @image, @extra = @generator.text(@text, :format => :gif)
      end
      it {@image.should have_format('gif')}
      it {@extra.should == {:format => :gif, :name => 'text.gif'}}
    end

    describe "padding" do
      before(:each) do
        no_padding_text, extra = @generator.text(@text, :font_size => 12)
        @width = image_properties(no_padding_text)[:width].to_i
        @height = image_properties(no_padding_text)[:height].to_i
      end
      it "1 number shortcut" do
        image, extra = @generator.text(@text, :padding => '10')
        image.should have_width(@width + 20)
        image.should have_height(@height + 20)
      end
      it "2 numbers shortcut" do
        image, extra = @generator.text(@text, :padding => '10 5')
        image.should have_width(@width + 10)
        image.should have_height(@height + 20)
      end
      it "3 numbers shortcut" do
        image, extra = @generator.text(@text, :padding => '10 5 8')
        image.should have_width(@width + 10)
        image.should have_height(@height + 18)
      end
      it "4 numbers shortcut" do
        image, extra = @generator.text(@text, :padding => '1 2 3 4')
        image.should have_width(@width + 6)
        image.should have_height(@height + 4)
      end
      it "should override the general padding declaration with the specific one (e.g. 'padding-left')" do
        image, extra = @generator.text(@text, :padding => '10', 'padding-left' => 9)
        image.should have_width(@width + 19)
        image.should have_height(@height + 20)
      end
      it "should ignore 'px' suffixes" do
        image, extra = @generator.text(@text, :padding => '1px 2px 3px 4px')
        image.should have_width(@width + 6)
        image.should have_height(@height + 4)
      end
      it "bad padding string" do
        lambda{
          @generator.text(@text, :padding => '1 2 3 4 5')
        }.should raise_error(ArgumentError)
      end
    end
  end

end


describe Dragonfly::Minimagick::Generator do

  before(:each) do
    @generator = Dragonfly::Minimagick::Generator.new
  end

  describe "when using the filesystem" do
    before(:each) do
    end
    it_should_behave_like 'image generator'
  end

end
