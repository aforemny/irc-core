#! /usr/bin/perl
# $XTermId: 256colres.pl,v 1.16 2007/06/08 23:58:37 tom Exp $
# -----------------------------------------------------------------------------
# this file is part of xterm
#
# Copyright 1999-2002,2007 by Thomas E. Dickey
# 
#                         All Rights Reserved
# 
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE ABOVE LISTED COPYRIGHT HOLDER(S) BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# Except as contained in this notice, the name(s) of the above copyright
# holders shall not be used in advertising or otherwise to promote the
# sale, use or other dealings in this Software without prior written
# authorization.
# -----------------------------------------------------------------------------

# Construct a header file defining default resources for the 256-color model
# of xterm.  This is modeled after the 256colors2.pl script.

# use the resources for colors 0-15 - usually more-or-less a
# reproduction of the standard ANSI colors, but possibly more
# pleasing shades

use strict;

our ( $line1, $line2, $line3 );
our ( $red, $green, $blue, $gray );
our ( $level, $code, @steps );

print <<EOF;
{-
 - This header file was generated by $0
 -}
module Graphics.Vty.Attributes.Color240 where

import Graphics.Vty.Attributes.Color

import Text.Printf

-- | RGB color to 240 color palette.
--
-- generated from 256colres.pl which is forked from xterm 256colres.pl
-- todo: all values get clamped high.
rgbColor :: Integral i => i -> i -> i -> Color
rgbColor r g b
    | r < 0 && g < 0 && b < 0 = error "rgbColor with negative color component intensity"
EOF

my $grey_line="    | r == %d && g == %d && b == %d = Color240 %d\n";
my $rgb_line="    | r <= %d && g <= %d && b <= %d = Color240 %d\n";

# colors 216-239 are a grayscale ramp, intentionally leaving out
# black and white
for ($gray = 0; $gray < 24; $gray++) {
    $level = ($gray * 10) + 8;
    $code = 216 + $gray;
    printf($grey_line, $level, $level, $level, $code);
}

# colors 16-231 are a 6x6x6 color cube
for ($red = 0; $red < 6; $red++) {
    for ($green = 0; $green < 6; $green++) {
        for ($blue = 0; $blue < 6; $blue++) {
            $code = ($red * 36) + ($green * 6) + $blue;
            printf($rgb_line,
             ($red ? ($red * 40 + 55) : 0),
             ($green ? ($green * 40 + 55) : 0),
             ($blue ? ($blue * 40 + 55) : 0),
             $code);
        }
    }
}

print <<EOF;
    | otherwise = error (printf "RGB color %d %d %d does not map to 240 palette." 
                                (fromIntegral r :: Int)
                                (fromIntegral g :: Int)
                                (fromIntegral b :: Int))

EOF