require 'mini_magick'
require 'dragonfly'
require 'dragonfly-minimagick/utils'

module Dragonfly
  module Minimagick
    class Analyser

      include Utils
      include Dragonfly::Configurable

      def width(temp_object)
        ping_minimagick_image(temp_object) do |image|
          image[:width]
        end
      end

      def height(temp_object)
        ping_minimagick_image(temp_object) do |image|
          image[:height]
        end
      end

      def aspect_ratio(temp_object)
        ping_minimagick_image(temp_object) do |image|
          image[:width].to_f / image[:height].to_f
        end
      end

      def portrait?(temp_object)
        ping_minimagick_image(temp_object) do |image|
          image[:width] <= image[:height]
        end
      end

      def landscape?(temp_object)
        ping_minimagick_image(temp_object) do |image|
          image[:width] >= image[:height]
        end
      end

      def depth(temp_object)
        minimagick_image(temp_object) do |image|
          image.verbose.match(/(\d{1,2})-bit/)[1].to_i
        end
      end

      def number_of_colours(temp_object)
        minimagick_image(temp_object) do |image|
          # image.colors
          0
        end
      end
      alias number_of_colors number_of_colours

      def format(temp_object)
        ping_minimagick_image(temp_object) do |image|
          image[:format].downcase.to_sym
        end
      end

      def image?(temp_object)
        !!catch(:unable_to_handle){ format(temp_object) }
      end
    end
  end
end
