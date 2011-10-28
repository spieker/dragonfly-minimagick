require 'mini_magick'
require 'dragonfly'
require 'dragonfly-minimagick/utils'

module Dragonfly
  module Minimagick
    class Processor

      GRAVITIES = {
        'nw' => 'NorthWest',
        'n'  => 'North',
        'ne' => 'NorthEast',
        'w'  => 'West',
        'c'  => 'Center',
        'e'  => 'East',
        'sw' => 'SouthWest',
        's'  => 'South',
        'se' => 'SouthEast'
      }

      # Geometry string patterns
      RESIZE_GEOMETRY         = /^\d*x\d*[><%^!]?$|^\d+@$/ # e.g. '300x200!'
      CROPPED_RESIZE_GEOMETRY = /^(\d+)x(\d+)#(\w{1,2})?$/ # e.g. '20x50#ne'
      CROP_GEOMETRY           = /^(\d+)x(\d+)([+-]\d+)?([+-]\d+)?(\w{1,2})?$/ # e.g. '30x30+10+10'
      THUMB_GEOMETRY = Regexp.union RESIZE_GEOMETRY, CROPPED_RESIZE_GEOMETRY, CROP_GEOMETRY

      include Utils
      include Dragonfly::Configurable

      def crop(temp_object, opts={})
        x       = opts[:x].to_i
        y       = opts[:y].to_i
        gravity = GRAVITIES[opts[:gravity]] || nil #Magick::ForgetGravity
        width   = opts[:width].to_i
        height  = opts[:height].to_i

        unless opts.has_key?(:width) and opts.has_key?(:height) or opts.has_key?(:x) and opts.has_key?(:y)
          return minimagick_image(temp_object) do |image|
            image
          end
        end
        minimagick_image(temp_object) do |image|
          unless opts.has_key?(:width) and opts.has_key?(:height)
            width  = image[:width] - x
            height = image[:height] - y
          end
          # Minimagick throws an error if the cropping area is bigger than the image,
          # when the gravity is something other than nw
          width  = image[:width]  - x if x + width  > image[:width]
          height = image[:height] - y if y + height > image[:height]
# p "\n\n#{opts[:width]}x#{opts[:height]}+#{opts[:x]}+#{opts[:y]} \n#{width}x#{height}+#{x}+#{y}"
          image.gravity gravity unless gravity.nil? or gravity.empty?
          image.crop "#{width}x#{height}+#{x}+#{y}" #(gravity, x, y, width, height)
          image
        end
      end

      def flip(temp_object)
        minimagick_image(temp_object) do |image|
          image.flip
          image
        end
      end

      def flop(temp_object)
        minimagick_image(temp_object) do |image|
          image.flop
          image
        end
      end

      def greyscale(temp_object, opts={})
        depth = opts[:depth] || 256
        minimagick_image(temp_object) do |image|
          image.quantize(depth, nil) #Magick::GRAYColorspace)
          image
        end
      end
      alias grayscale greyscale

      def resize(temp_object, geometry)
        minimagick_image(temp_object) do |image|
        #   image.change_geometry!(geometry) do |cols, rows, img|
        #    img.resize!(cols, rows)
        #   end
          image.resize geometry
          image
        end
      end

      def resize_and_crop(temp_object, opts={})
        unless opts.has_key?(:width) or opts.has_key?(:height)
          return minimagick_image(temp_object) do |image|
            image
          end
        end

        minimagick_image(temp_object) do |image|
          width   = opts[:width] ? opts[:width].to_i : image[:width]
          height  = opts[:height] ? opts[:height].to_i : image[:height]
          gravity = GRAVITIES[opts[:gravity]] || 'center'
          image.combine_options do |i|
            i.resize "#{width}x#{height}^"
            i.gravity gravity
            i.extent "#{width}x#{height}"
          end
          # image.crop_resized(width, height, gravity)
          image
        end
      end

      def rotate(temp_object, amount, opts={})
        args = [amount.to_f]
        args << opts[:qualifier] if opts[:qualifier]
        minimagick_image(temp_object) do |image|
          image.background_color = opts[:background_colour] if opts[:background_colour]
          image.background_color = opts[:background_color] if opts[:background_color]
          image.rotate(args.join(''))
          image
        end
      end

      def thumb(temp_object, geometry)
        case geometry
        when RESIZE_GEOMETRY
          resize(temp_object, geometry)
        when CROPPED_RESIZE_GEOMETRY
          resize_and_crop(temp_object, :width => $1, :height => $2, :gravity => $3)
        when CROP_GEOMETRY
          crop(temp_object,
            :width => $1,
            :height => $2,
            :x => $3,
            :y => $4,
            :gravity => $5
          )
        else raise ArgumentError, "Didn't recognise the geometry string #{geometry}"
        end
      end

      def vignette(temp_object, opts={})
        x      = opts[:x].to_f      || temp_object.width  * 0.1
        y      = opts[:y].to_f      || temp_object.height * 0.1
        radius = opts[:radius].to_f ||  0.0
        sigma  = opts[:sigma].to_f  || 10.0

        minimagick_image(temp_object) do |image|
          image.vignette(x, y, radius, sigma)
          image
        end
      end

    end
  end
end
