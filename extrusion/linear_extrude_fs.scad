  //Linear Extrude with Scale as an interpolated function
  // The local function definition needs to point to a valid function
  // Otherwise, this module does not need to be modified, 
  //  - unless default parameters want to be changed 
  //  - or additional parameters want to be forwarded
  module linear_extrude_fs(height=1,isteps=20,twist=0,slices=0){
    //We define our locale function that defines scaling
    function fsc(x) = f_lefs(x);
    //union of piecewise generated extrudes
    union(){  
      for(i = [ 0: 1: isteps-1]){
        //each new piece needs to be adjusted for height
        translate([0,0,i*height/isteps])
          linear_extrude(
            height=height/isteps
            ,twist=twist/isteps
            ,scale=fsc((i+1)/isteps)/fsc(i/isteps)
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
  // This is an example function to define the scale function
  //  - Function name needs to be defined in module local function definition
  //    + line: "function fsc(x) = ...."
  function f_lefs(x) = 
    let(span=150,start=20,normpos=45)
    sin(x*span+start)/sin(normpos);
  
  //Example with a slight twist, showing slices and isteps effect
  linear_extrude_fs(height=20,twist=10,slices=3,isteps=6)
    translate([-4,-3])
      square([9,12]);