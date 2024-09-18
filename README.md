# IKEA Skadis Pegboard Mount for Custom Attachments
This project generates a custom IKEA Skadis pegboard mount using OpenSCAD, allowing users to adjust dimensions based on their needs. The mount features customizable pegs and a mount, making it perfect for personalized attachments.
## Author
**Angel Roman**  
GitHub: [@legna-namor](https://github.com/legna-namor)
## Project Overview
This OpenSCAD project creates a Skadis-compatible mount with pegs for custom attachments. Users can adjust the width and depth of the mount, with pegs automatically generated and placed based on the input dimensions.
### Features
- **Customizable Peg Count:** The number of pegs is dynamically calculated based on the provided width.
- **Width Adjustment:** The width is constrained between 45mm and 235mm to fit Skadis pegboards.
- **Depth Adjustment:** The depth is adjustable between 6mm and 235mm to ensure strong mount support.
- **Automatic Centering:** The mount is centered automatically to ensure even peg placement.
- **Modular Design:** Separate modules are used for peg generation and mount creation, allowing easy customization and reuse.
## Code Breakdown
### 1. Variables
```scad
width = 55;   // User-defined width of the mount (45-231mm)
depth = 453;  // User-defined depth of the mount(6-235mm)
```
### 2. Width and Depth Adjustment Functions
These functions ensure the width and depth stay within practical ranges for use with the IKEA Skadis system.
```scad
function adjust_width(w) = w < 45 ? 45 : (w > 235 ? 235 : w);
function adjust_depth(d) = d < 6 ? 6 : (d > 235 ? 235 : d);
```
### 3. Half Remainder Calculation
This function calculates half the remainder when the adjusted width is divided by 40, centering the mount if the width is one of the specified values (45, 85, 125, 165, 205).
```scad
function half_remainder(w) = 
    (adjust_width(w) == 45 || 
     adjust_width(w) == 85 || 
     adjust_width(w) == 125 || 
     adjust_width(w) == 165 || 
     adjust_width(w) == 205) ? 0 : (adjust_width(w) % 40) / 2;
```
### 4. Adjusted Variables
These are the final width and depth values used throughout the design, taking user input and ensuring they fall within the allowed ranges.
```scad
adjusted_width = adjust_width(width+4);
adjusted_depth = adjust_depth(depth+5);
half_rem = half_remainder(width+4);
```
### 5. Peg Module
The `peg` module creates a cylindrical peg using two circles, with the `hull()` function providing a solid extrude between them. The peg is extruded along the Z-axis.
```scad
module peg(height, width, length) {
    linear_extrude(height) {
        hull() {
            translate([length - width, 0, 0]) circle(d = width);
            circle(d = width);
        }
    }
}
```
### 6. Peg Generator Module
The `peg_generator` module dynamically calculates how many pegs fit into the adjusted width and places them accordingly.
```scad
module peg_generator(w) {
    num_pegs = floor(w / 40);   // Calculate number of pegs based on width
    for (i = [0:num_pegs]) {
        n = i * 40;
        translate([0, n, 0]) peg(5, 5, 15);    // First peg
        translate([0, n, 5]) peg(5.2, 5, 7.5); // Second peg (offset in Z-axis)
    }
}
```
### 7. Mount Module
The `mount` module creates an extruded mount to the specified depth and adjusted width.

```scad
module mount(w, r, d) {
    translate([-2.5, (r == 0) ? -2.5 : -r, 10.2]) {
        difference() {
            linear_extrude(d) {
                square([15, w]);   // Outer shape
            }
            translate([-2, 2, 2])
            linear_extrude(d-4) {
                square([15, w-4]); // Top cut-out
            }
        }
    }
}
```
### 8. Final Output
To create the Skadis mount, the peg generator and mount modules are called using the adjusted dimensions:
```scad
peg_generator(adjusted_width);
mount(adjusted_width, half_rem, adjusted_depth);
```
## Usage OpenSCAD
1. Open the `.scad` file in OpenSCAD.
2. Adjust the `width` and `depth` variables as needed.
3. Render and export your custom IKEA Skadis mount as a 3D model.
## Example
- **Input:** `width = 55; depth = 53;`
- **Adjusted Width:** 59mm
- **Adjusted Depth:** 58mm
- **Peg Count:** 2 pegs generated, with the mount centered.
