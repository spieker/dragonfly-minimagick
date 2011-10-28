require 'mini_magick'
require 'dragonfly'
require 'dragonfly-minimagick/utils'

module Dragonfly
  module Minimagick
    class Generator

      FONT_STYLES = {
        'normal'  => 'normal', #Magick::NormalStyle,
        'italic'  => 'italic', #Magick::ItalicStyle,
        'oblique' => 'oblique' #Magick::ObliqueStyle
      }

      FONT_STRETCHES = {
        'normal'          => 'normal', #Magick::NormalStretch,
        'semi-condensed'  => 'semi-condensed', #Magick::SemiCondensedStretch,
        'condensed'       => 'condensed', #Magick::CondensedStretch,
        'extra-condensed' => 'extra-condensed', #Magick::ExtraCondensedStretch,
        'ultra-condensed' => 'ultra-condensed', #Magick::UltraCondensedStretch,
        'semi-expanded'   => 'semi-expanded', #Magick::SemiExpandedStretch,
        'expanded'        => 'expanded', #Magick::ExpandedStretch,
        'extra-expanded'  => 'extra-expanded', #Magick::ExtraExpandedStretch,
        'ultra-expanded'  => 'ultra-expanded' #Magick::UltraExpandedStretch
      }

      FONT_WEIGHTS = {
        'normal'  => 'normal', #Magick::NormalWeight,
        'bold'    => 'bold', #Magick::BoldWeight,
        'bolder'  => 'bolder', #Magick::BolderWeight,
        'lighter' => 'lighter', #Magick::LighterWeight,
        '100'     => 100,
        '200'     => 200,
        '300'     => 300,
        '400'     => 400,
        '500'     => 500,
        '600'     => 600,
        '700'     => 700,
        '800'     => 800,
        '900'     => 900
      }

      include Utils
      include Dragonfly::Configurable

      def plasma(width, height, format='png')
        image = MiniMagick::Image.read("plasma:fractal"){self.size = "#{width}x#{height}"}.first
        image.format = format.to_s
        content = write_to_tempfile(image)
        image.destroy!
        [
          content,
          {:format => format.to_sym, :name => "plasma.#{format}"}
        ]
      end

      def text(text_string, opts={})
        opts = Dragonfly::HashWithCssStyleKeys[opts]

        draw = MiniMagick::Draw.new
        draw.gravity = 'center'
        draw.text_antialias = true

        # Font size
        font_size = (opts[:font_size] || 12).to_i

        # Scale up the text for better quality -
        #  it will be reshrunk at the end
        s = scale_factor_for(font_size)

        # Settings
        draw.pointsize    = font_size * s
        draw.font         = opts[:font] if opts[:font]
        draw.font_family  = opts[:font_family] if opts[:font_family]
        draw.fill         = opts[:color] if opts[:color]
        draw.stroke       = opts[:stroke_color] if opts[:stroke_color]
        draw.font_style   = FONT_STYLES[opts[:font_style]] if opts[:font_style]
        draw.font_stretch = FONT_STRETCHES[opts[:font_stretch]] if opts[:font_stretch]
        draw.font_weight  = FONT_WEIGHTS[opts[:font_weight]] if opts[:font_weight]

        # Padding
        # NB the values are scaled up by the scale factor
        pt, pr, pb, pl = parse_padding_string(opts[:padding]) if opts[:padding]
        padding_top    = (opts[:padding_top]    || pt || 0) * s
        padding_right  = (opts[:padding_right]  || pr || 0) * s
        padding_bottom = (opts[:padding_bottom] || pb || 0) * s
        padding_left   = (opts[:padding_left]   || pl || 0) * s

        # Calculate (scaled up) dimensions
        metrics = draw.get_type_metrics(text_string)
        width, height = metrics.width, metrics.height

        scaled_up_width = padding_left + width + padding_right
        scaled_up_height = padding_top + height + padding_bottom

        # Draw the background
        image = MiniMagick::Image.new(scaled_up_width, scaled_up_height){
          self.background_color = opts[:background_color] || 'transparent'
        }
        # Draw the text
        draw.annotate(image, width, height, padding_left, padding_top, text_string)

        # Scale back down again
        image.scale!(1/s)

        format = opts[:format] || :png
        image.format = format.to_s

        # Output image either as a string or a tempfile
        content = write_to_tempfile(image)
        image.destroy!
        [
          content,
          {:format => format, :name => "text.#{format}"}
        ]
      end

      private

      # Use css-style padding declaration, i.e.
      # 10        (all sides)
      # 10 5      (top/bottom, left/right)
      # 10 5 10   (top, left/right, bottom)
      # 10 5 10 5 (top, right, bottom, left)
      def parse_padding_string(str)
        padding_parts = str.gsub('px','').split(/\s+/).map{|px| px.to_i}
        case padding_parts.size
        when 1
          p = padding_parts.first
          [p,p,p,p]
        when 2
          p,q = padding_parts
          [p,q,p,q]
        when 3
          p,q,r = padding_parts
          [p,q,r,q]
        when 4
          padding_parts
        else raise ArgumentError, "Couldn't parse padding string '#{str}' - should be a css-style string"
        end
      end

      def scale_factor_for(font_size)
        # Scale approximately to 64 if below
        min_size = 64
        if font_size < min_size
          (min_size.to_f / font_size).ceil
        else
          1
        end.to_f
      end

    end

  end
end
