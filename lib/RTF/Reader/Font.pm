
package RTF::Reader::Font;

	use base qw( Class::Accessor );
	
	RTF::Reader::Font->mk_accessors(qw(
		family
		charset
		pitch
		panose
		non_tagged_name
		name
		alternative_name
		codepage
	));



1;

=head1 NAME

RTF::Reader::Font

=head1 DESCRIPTION

Interface to RTF fonts

=head1 OVERVIEW

To (hopefully) make document conversion from RTF easier,
fonts are interfaced through a nice clean class of their
own. That, and I don't like the thought of throwing around
data structures, only to have the all-seeing Microsoft
change the underlying structure of RTF documents, and mess
up a bunch of legacy code.

An RTF::Reader::Font object represents a single font in 
a document.

RTF::Reader currently does B<NOT> support embedded fonts.
Patches (with copious accompanying tests) welcome.

=head1 METHODS

=head2 family

Returns a string corresponding to the family of the font.

Stolen from the RTF spec (1.6): "RTF also supports font families, so that
applications can attempt to intelligently choose fonts if the exact
font is not present on the reading system. RTF uses the following
[names] to describe the various font families."

=head3 nil

Unknown or default fonts (the default)

=head3 roman

Roman, proportionally spaced serif fonts eg: I<Times New Roman, Palatino>

=head3 swiss

Swiss, proportionally spaced sans serif fonts eg: I<Arial>

=head3 modern

Fixed-pitch serif and sans serif fonts eg: I<Courier New, Pica>

=head3 script

Script fonts eg: I<Cursive>

=head3 decor

Decorative fonts eg: I<Old English, ITC Zapf Chancery>

=head3 tech

Technical, symbol, and mathematical fonts eg: I<Symbol>

=head3 bidi

Arabic, Hebrew, or other bidirectional font eg: I<Miriam>

=head2 charset

Returns the character set of the font - the number returned is
defined by the Windows header files:

 0   ANSI

 1   Default

 2   Symbol

 3   Invalid

 77  Mac

 128 Shift Jis

 129 Hangul

 130 Johab

 134 GB2312

 136 Big5

 161 Greek

 162 Turkish

 163 Vietnamese

 177 Hebrew

 178 Arabic

 179 Arabic Traditional

 180 Arabic user

 181 Hebrew user

 186 Baltic

 204 Russian

 222 Thai

 238 Eastern European

 254 PC 437

 255 OEM

=head2 pitch

Font pitch to use: L<http://www.webopedia.com/TERM/F/fixed_pitch.html>

 0 Default pitch

 1 Fixed pitch

 2 Variable pitch

=head2 panose

PANOSE is a system for font matching - this property returns a PANOSE
description of the font as described here:

L<http://msdn.microsoft.com/library/en-us/gdi/fontext_48aa.asp>

=head2 non_tagged_name
=head2 name
=head2 alternative_name
=head2 codepage