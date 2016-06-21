  //Linear Extrude with Scale as an interpolated function
  // This module does not need to be modified, 
  //  - unless default parameters want to be changed 
  //  - or additional parameters want to be forwarded
  module linear_extrude_fs(height=1,isteps=20,twist=0,slices=0){
    //union of piecewise generated extrudes
    union(){  
        for(i = [ 0: 1: isteps-1]){
            //each new piece needs to be adjusted for height
            translate([0,0,i*height/isteps])
              linear_extrude(
                height=height/isteps
                ,twist=twist/isteps
                ,scale=f_lefs((i+1)/isteps)/f_lefs(i/isteps)
                ,slices=slices
              )
                // if a twist constant is defined it is split into pieces
                rotate([0,0,-(i/isteps)*twist])
                  // each new piece starts where the last ended
                  scale(f_lefs(i/isteps))
                    children();
        }
    }
  }
  // This function defines the scale function
  //  - Function name must not be modified
  //  - Modify the contents/return value to define the function
  function f_lefs(x) = 
    let(span=150,start=20,normpos=45)
    sin(x*span+start)/sin(normpos);
  
  //Example use
  linear_extrude_fs(height=20,twist=30,slices=7)
    translate([-4,-3])
      square([9,12]);