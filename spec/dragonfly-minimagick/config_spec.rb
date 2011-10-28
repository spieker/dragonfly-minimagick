require 'spec_helper'

describe Dragonfly::Minimagick::Config do

  before(:each) do
    @app = test_app
  end

  it "should configure all to use the filesystem by default" do
    @app.configure_with(Dragonfly::Minimagick::Config)
  end
  
  it "should allow configuring with :minimagick" do
    @app.configure_with(:minimagick)
    @app.analyser.objects.first.should be_a(Dragonfly::Minimagick::Analyser)
  end

  it "should allow configuring with :mini_magick" do
    @app.configure_with(:mini_magick)
    @app.analyser.objects.first.should be_a(Dragonfly::Minimagick::Analyser)
  end

end
