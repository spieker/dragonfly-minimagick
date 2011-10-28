module Dragonfly
  module Minimagick

    # Minimagick is a saved configuration for Dragonfly apps, which does the following:
    # - registers an minimagick analyser
    # - registers an minimagick processor
    # - registers an minimagick encoder
    # - registers an minimagick generator
    # - adds thumb shortcuts like '280x140!', etc.
    # Look at the source code for apply_configuration to see exactly how it configures the app.
    module Config
      def self.apply_configuration(app, opts={})
        app.configure do |c|
          c.analyser.register(Analyser) do |a|
          end
          c.processor.register(Processor) do |p|
          end
          c.encoder.register(Encoder) do |e|
          end
          c.generator.register(Generator) do |g|
          end
          c.job :thumb do |geometry, format|
            process :thumb, geometry
            encode format if format
          end
          c.job :gif do
            encode :gif
          end
          c.job :jpg do
            encode :jpg
          end
          c.job :png do
            encode :png
          end
        end
      end
    end
    
  end
end
