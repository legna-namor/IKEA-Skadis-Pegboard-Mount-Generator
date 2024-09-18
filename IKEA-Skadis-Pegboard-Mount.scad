// --------------------------------------------------------------
//  Author: Angel Roman
//  GitHub: https://github.com/legna-namor
//  Purpose: This project generates a custom IKEA Skadis pegboard mount using OpenSCAD, allowing users to adjust dimensions based on their needs. 
// --------------------------------------------------------------
// Variables, width (45-231), depth (1-230)
width = 55;
depth = 453;
// Function to adjust width to be between 45 and 235
function adjust_width(w) = w < 45 ? 45 : (w > 235 ? 235 : w);
// Function to adjust depth to be between 6 and 235
function adjust_depth(d) = d < 6 ? 6 : (d > 235 ? 235 : d);
// Function to calculate half of the remainder when adjusted width is divided by 40
function half_remainder(w) = 
    (adjust_width(w) == 45 || 
     adjust_width(w) == 85 || 
     adjust_width(w) == 125 || 
     adjust_width(w) == 165 || 
     adjust_width(w) == 205) ? 0 : (adjust_width(w) % 40) / 2;   
// Adjusted variable call outs
adjusted_width = adjust_width(width+4);
adjusted_depth = adjust_depth(depth+5);
half_rem = half_remainder(width+4);
// --------------------------------------------------------------
// Peg module
module peg(height, width, length) {
    linear_extrude(height) {
        hull() {
            translate([length - width, 0, 0]) circle(d = width);
            circle(d = width);
        }
    }
}
// Peg generator module to generate pegs based on adjusted width
module peg_generator(w) {
    num_pegs = floor(w / 40);
    for (i = [0:num_pegs]) {
        n = i * 40;
        translate([0, n, 0]) peg(5, 5, 15);
        translate([0, n, 5]) peg(5.2, 5, 7.5);
    }
}
// --------------------------------------------------------------
// mount module
module mount(w, r, d) {
    translate([-2.5, (r == 0) ? -2.5 : -r, 10.2])
    difference() {
        linear_extrude(d) {
            square([15, w]);
        }
        translate([-2, 2, 2])
        linear_extrude(d-4) {
            square([15, w-4]);
        }
    }
}
// --------------------------------------------------------------
// Generates skadis mount
peg_generator(adjusted_width);
mount(adjusted_width, half_rem, adjusted_depth);
