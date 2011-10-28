require "dragonfly-minimagick/version"

module Dragonfly
  module Minimagick
    # Your code goes here...
  end
end

require 'dragonfly-minimagick/analyser'
require 'dragonfly-minimagick/processor'
require 'dragonfly-minimagick/encoder'
require 'dragonfly-minimagick/generator'
require 'dragonfly-minimagick/config'

Dragonfly::App.register_configuration(:minimagick){ Dragonfly::Minimagick::Config }
Dragonfly::App.register_configuration(:mini_magick){ Dragonfly::Minimagick::Config }
