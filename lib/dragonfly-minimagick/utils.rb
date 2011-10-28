require 'tempfile'
require 'mini_magick'
require 'dragonfly'

module Dragonfly
  module Minimagick
    module Utils

      include Dragonfly::Loggable

      private

      def minimagick_image(temp_object, &block)
        image = MiniMagick::Image.open(temp_object.path)
        result = block.call(image)
        case result
        when MiniMagick::Image
          content = write_to_tempfile(result)
          result.destroy!
        else
          content = result
        end
        image.destroy!
        content
      rescue Exception => e
        log.warn("Unable to handle content in #{self.class} - got:\n#{e}")
        throw :unable_to_handle
      end

      def ping_minimagick_image(temp_object, &block)
        image = MiniMagick::Image.open(temp_object.path)
        result = block.call(image)
        image.destroy!
        result
      rescue Exception => e
        log.warn("Unable to handle content in #{self.class} - got:\n#{e}")
        throw :unable_to_handle
      end

      def write_to_tempfile(minimagick_image)
        tempfile = Tempfile.new('dragonfly')
        tempfile.close
        minimagick_image.write(tempfile.path)
        tempfile
      end

    end
  end
end
