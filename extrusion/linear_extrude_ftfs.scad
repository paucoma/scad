//Linear Extrude with Twist and Scale as interpolated functions
// The local function definitions need to point to valid functions
// Otherwise, this module does not need to be modified,  
//  - unless default parameters want to be changed 
//  - or additional parameters want to be forwarded
module linear_extrude_ftfs(height=1,isteps=20,slices=0){
    //local function definitions for twist and scale, respectively
    function ftw(x) = leftfs_ftw(x);  //<--- !! User Defined Twist
    function fsc(x) = leftfs_fsc(x);  //<--- !! User Defined Scale
    //union of piecewise generated extrudes
    union(){  
      for(i=[0:1:isteps-1]){
        translate([0,0,i*height/isteps])
          linear_extrude(
            height=height/isteps
            ,twist=ftw((i+1)/isteps)-ftw(i/isteps)
            ,scale=fsc((i+1)/isteps)/fsc(i/isteps)
            ,slices=slices
          )
            rotate([0,0,-ftw(i/isteps)])
              scale(fsc(i/isteps))
                children();
      }
    }
}
// Example function defines the scale function
// Function name defined in module local function definition
function leftfs_fsc(x)=
    let(scale=3,span=140,start=20)
    scale*sin(x*span+start);
// Example function defines the twist function
// Function name defined in module local function definition
function leftfs_ftw(x)=
    let(twist=30,span=360,start=0)
    twist*sin(x*span+start);


//Left rendered object demonstrating the steps effect
translate([0,-50,0])
  linear_extrude_ftfs(height=50,isteps=3)
    square([12,9]);

//Center rendered object demonstrating the slices effect
translate([0,0,0])
  linear_extrude_ftfs(height=50,isteps=3,slices=30)
    square([12,9]);

//Right rendered object with default parameters
translate([0,50,0])
  linear_extrude_ftfs(height=50)
    square([12,9]);