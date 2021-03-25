// svg implenment
// by Charles WANG, 2021
module svg

import os

pub const (
	svg_file_head1 = '<?xml version="1.0" standalone="no"?>\n'
	svg_file_head2 = '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
	svg_ref        = 'xmlns="http://www.w3.org/2000/svg" version="1.1">\n'
	svg_footer     = '\n</svg>'
	gap            = 20
)

pub fn new_svg(w int, h int) SVG {
	return SVG{
		header: svg.svg_file_head1 + svg.svg_file_head2 + '<svg width="$w" heigth="$h" ' +
			svg.svg_ref
		width: w
		heigth: h
	}
}

pub fn (mut s SVG) polyline(point map[int]int, style string) {
	mut x := ''
	for k, v in point {
		x += '$k,$v '
	}
	s.body << '<polyline points="$x" style="$style" />'
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

pub fn (mut s SVG) moveto(x int, y int) {
	s.body << '<path d="M$x $y" />'
}

pub fn (mut s SVG) lineto(x int, y int, style string) {
	s.body << '<path d="L$x $y" style="$style" />'
}

pub fn (mut s SVG) trend(p []f64, title string, xt string, yt string, c string) {
	if p.len < 1 {
		return
	}
	mut x := p.clone()
	x.sort()
	hd := s.heigth / (x[x.len - 1] + svg.gap - x[0])
	wd := (s.width - svg.gap - svg.gap) / x.len

	// s.moveto(gap, gap)
	s.rect(svg.gap, svg.gap, s.width - svg.gap, s.heigth - svg.gap, 'fill:none; stroke:black; stroke-width: 1')

	s.text(svg.gap + 5, svg.gap + 20, yt, '')
	s.text(s.width - 60, s.heigth - svg.gap, xt, '')
	s.text(100, 60, '$title', '')

	mut m := map[int]int{}
	for k, v in p {
		m[int(k * wd + svg.gap + svg.gap)] = int(s.heigth - v * hd - svg.gap)
	}
	s.polyline(m, ' stroke:$c; fill:none; stroke-width:3;')
	for k, v in m {
		s.circle(k, v, 3, '')
	}
}

pub fn (mut s SVG) path_lines(x []int, y []int, style string) ? {
	if x.len != y.len {
		return error('err: ')
	}
	s.body << '<path d="M$x[0] $y[0] '
	for i in 1 .. x.len {
		s.body << 'L$x[i] $y[i] '
	}
	s.body << ' " style="$style" />\n'
}

pub struct SVG {
mut:
	header string
	body   []string
	footer string = svg.svg_footer
pub:
	width  int
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
	name         string
	cx           int
	cy           int
	r            int
	x            int
	y            int
	stroke       string
	fill         string
	stroke_width int
	fill_opacity f64
}
