Dragonfly-Minimagick
=================

Dragonfly-Minimagick was extracted from the original dragonfly code and provides an analyser, processor, encoder and generator for Dragonfly using the MiniMagick image library. 

It shouldn't be necessary and is provided here in case it's needed for some reason!

Usage
-----

    require 'dragonfly-minimagick'
    Dragonfly[:images].configure_with(:minimagick)

In Rails, the above would be done in an initializer.

See the [dragonfly documentation](http://markevans.github.com/dragonfly) for more info, as the equivalent ImageMagick methods have the same API.

