# IKEA Skadis Pegboard Mount Generator
This project generates a custom IKEA Skadis pegboard mount using OpenSCAD. It allows users to input their desired dimensions for the mount's length, width, and height, which are then adjusted within valid ranges to fit the IKEA Skadis system.
### Features
- **Adjustable Dimensions:** The system adjusts user-defined dimensions to ensure they fit within the acceptable ranges for most 3D Printers.
- **Customizable Peg Layout:** Based on the mount's dimensions, the generator creates a pattern of pegs for attachments, both horizontally and vertically.
- **Automatic Centering:** The mount is centered automatically to ensure even peg placement.
## Code Breakdown
### 1. Variables
The system accepts three primary dimensions as input:
- **Length** (`45-231`): The length of the mount in millimeters.
- **Width** (`6-230`): The width of the mount in millimeters.
- **Height** (`15-233`): The height of the mount in millimeters.
> **Note**: These measurements refer to the inner space of the mount, not the overall dimensions.
```scad
length = 55;
width = 20;
height = 33;
```
### 2. Adjustment Functions
These functions ensure the variables stay within practical ranges for use with the IKEA Skadis system and 3D Printers.
```scad
function adjust_length(w) = max(45, min(w, 235));
function adjust_width(d) = max(6, min(d, 235));
function adjust_height(h) = max(15, min(h, 235));
```
### 3. Half Remainder Calculation
This function calculates half the remainder when the adjusted width is divided by 40, centering the mount if the width is one of the specified values (45, 85, 125, 165, 205).
```scad
function half_remainder(w) = 
    (w == 45 || w == 85 || w == 125 || w == 165 || w == 205) ? 0 : (w % 40) / 2;
```
### 4. Adjusted Variables
These are the final variable values used throughout the design, taking user input and ensuring they fall within the allowed ranges.
```scad
adjusted_length = adjust_length(length + 4);
adjusted_width = adjust_width(width + 5);
adjusted_height = adjust_height(height + 2);
half_rem = half_remainder(adjusted_length);
```
### 5. Peg Module
The `peg` module creates a cylindrical peg using two circles, with the `hull()` function providing a solid extrude between them. The peg is extruded along the Z-axis.
```scad
module peg(peg_height, peg_diameter, peg_length) {
    linear_extrude(peg_height) {
        hull() {
            translate([peg_length - peg_diameter, 0, 0]) circle(d = peg_diameter);
            circle(d = peg_diameter);
        }
    }
}
```
### 6. Peg Generator Module
The `peg_generator` module dynamically calculates how many pegs fit into the adjusted variables and places them accordingly.
```scad
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
```
### 7. Mount Module
The `mount` module creates an extruded mount to the specified depth and adjusted width.
```scad
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
```
### 8. Final Output
To create the Skadis mount, the peg generator and mount modules are called using the adjusted dimensions:
```scad
peg_generator(adjusted_length, adjusted_height);
mount(adjusted_length, half_rem, adjusted_width, adjusted_height);
```
## Usage OpenSCAD
1. Open the `.scad` file in OpenSCAD.
2. Adjust the `width`, `height` and `length` variables as needed.
3. Render and export your custom IKEA Skadis mount as a 3D model.
## Author
**Angel Roman**  
GitHub: [@legna-namor](https://github.com/legna-namor)
