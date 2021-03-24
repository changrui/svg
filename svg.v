// svg implenment
// by Charles WANG, 2021
module svg 

import os 

pub const (
	svg_file_head1 = '<?xml version="1.0" standalone="no"?>\n'
	svg_file_head2 = '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
	svg_ref = 'xmlns="http://www.w3.org/2000/svg" version="1.1">\n'
	svg_footer = '</svg>'
)

pub fn new_svg(w int, h int) SVG {
	return SVG{
		header: svg_file_head1 + svg_file_head2 + '<svg width="$w" heigth="$h" ' + svg_ref
	}
}

pub fn (mut s SVG) polyline(point map[int]int, style string) {
	mut x := ''
	for k,v in point {
		x += '$k,$v '
	}
	s.body << '<polyline points="$s" style="$style" />'
}

pub fn (mut s SVG) line(x1 int, y1 int, x2 int, y2 int, style string) {
	s.body << '<line x1="$x1" y1="$y1" x2="$x2" y2="$y2" style=$style />'
}

pub fn (mut s SVG) text(x int, y int, str string, style string) {
	s.body << '<text x="$x" y="$y" style="$style" >$str</text>'
}

pub fn (mut s SVG) rect(x int, y int, w int, h int, style string) {
	s.body << '<rect x="$x" y="$y" width="$w" height="$h" style="$style" />'
}

pub fn (mut s SVG) circle(cx int, cy int, r int, style string) {
	s.body << '<circle cx="$cx" cy="$cy" r="$r" style="$style" />'
}

pub fn (s SVG) write_file(path string) bool {
	mut str := s.header + '\n'
	str += s.body.join('\n') + '\n' + s.footer
	os.write_file(path, str) or { return false }
	return true
}

pub struct SVG {
mut:
	header string 
	body []string 
	footer string = svg_footer
	width int 
	heigth int 
}

pub enum Style {
	fill 
	stroke 
	stroke_width 
	fill_opacity 
	stroke_opacity 

}

pub struct Draw {
	name string 
	cx int 
	cy int 
	r int 
	x int 
	y int 
	stroke string 
	fill string 
	stroke_width int 
	fill_opacity f64
}