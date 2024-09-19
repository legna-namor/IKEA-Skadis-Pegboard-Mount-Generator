// --------------------------------------------------------------
//  Author: Angel Roman
//  GitHub: https://github.com/legna-namor
//  Purpose: This project generates a custom IKEA Skadis pegboard mount using OpenSCAD, allowing users to adjust dimensions based on their needs. 
// --------------------------------------------------------------

// Variables for dimensions: length (45-231), width (6-230), height (15-233)
// Note: These measurements refer to the inner space of the mount, not the overall dimensions of the mount.
length = 55;
width = 20;
height = 33;

// --------------------------------------------------------------
// Adjusting functions to keep dimensions within their valid ranges
function adjust_length(l) = max(5, min(l, 235));
function adjust_width(w) = max(6, min(w, 235));
function adjust_height(h) = max(15, min(h, 235));

// This function calculates half the remainder when the adjusted width is divided by 40, centering the mount if the width is one of the specified values (45, 85, 125, 165, 205).
function half_remainder(l) = 
    (l == 45 || l == 85 || l == 125 || l == 165 || l == 205) ? 0 : (l % 40) / 2;

// Adjusted dimensions
adjusted_length = adjust_length(length + 4);
adjusted_width = adjust_width(width + 5);
adjusted_height = adjust_height(height + 2);
half_rem = half_remainder(adjusted_length);

// --------------------------------------------------------------
// Peg module to create a single peg using hull
module peg(peg_height, peg_diameter, peg_length) {
    linear_extrude(peg_height) {
        hull() {
            translate([peg_length - peg_diameter, 0, 0]) circle(d = peg_diameter);
            circle(d = peg_diameter);
        }
    }
}

// --------------------------------------------------------------
// Peg generator module to create pegs based on length and height
module peg_generator(length, height) {
    num_pegs_horizontal = floor(length/ 40);
    num_pegs_vertical = floor(height / 15);
    horizontal_limit = num_pegs_horizontal * 42.5;
    for (i = [0:num_pegs_horizontal]) {
        peg_offset_x = i * 40;
        translate([height - 15, peg_offset_x, 0]) peg(5, 5, 15);
        translate([height - 15, peg_offset_x, 5]) peg(5.2, 5, 7.5);
        if (num_pegs_vertical > 1) {
            for (j = [1:num_pegs_vertical]) {
                peg_offset_z = j * 20;
                toggle_offset = (j % 2 == 0) ? 0 : 20;
                peg_offset_t = toggle_offset + peg_offset_x;
                if (peg_offset_t < horizontal_limit && (peg_offset_z + 15) <= height) {
                    translate([height - 15 - peg_offset_z, peg_offset_t, 0]) peg(5, 5, 15);
                    translate([height - 15 - peg_offset_z, peg_offset_t, 5]) peg(5.2, 5, 7.5);
                }
            }
        }
    }
}

// --------------------------------------------------------------
// Mount module to create the backplate with a hole
module mount(length, remainder, width, height) {
    translate([-2.5, remainder == 0 ? -2.5 : -remainder, 10.2]) {
        difference() {
            linear_extrude(width) square([height, length]);
            translate([-2, 2, 2]) {
                linear_extrude(width - 4) square([height - 4, length - 4]);
            }
        }
    }
}

// --------------------------------------------------------------
// Generate Skadis peg and mount system
peg_generator(adjusted_length, adjusted_height);
mount(adjusted_length, half_rem, adjusted_width, adjusted_height);
