module svg 

fn test_svg() {
	mut s := new_svg(500, 500)
	s.circle(250, 250, 100, "fill:red; stroke:yellow")
	s.text(50,100,'Hello, SVG.', 'text-length:300')
	s.write_file("circle.svg")
	assert true
}