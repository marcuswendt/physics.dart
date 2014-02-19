part of physics;

/**
 * Keeps the particle inside the given 3D box 
 */
class Box extends Constraint 
{
  var min = new Vector3.zero();
  var max = new Vector3(100.0, 100.0, 100.0);

  apply(Particle3 particle) {
    var pos = particle.position;

    if(pos.x < min.x) pos.x = min.x;
    if(pos.y < min.y) pos.y = min.y;
    if(pos.z < min.z) pos.z = min.z;

    if(pos.x > max.x) pos.x = max.x;
    if(pos.y > max.y) pos.y = max.y;
    if(pos.z > max.z) pos.z = max.z;
  }
}


/**
 * Wraps the particle inside the given 3D box 
 */
class BoxWrap extends Constraint 
{
  var min = new Vector3.zero();
  var max = new Vector3(100.0, 100.0, 100.0);

  apply(Particle3 particle) {
    var pos = particle.position;
    var wrapped = false;
    
    if(pos.x < min.x) {
      pos.x = max.x;
      wrapped = true;
    }
    
    if(pos.y < min.y) {
      pos.y = max.y;
      wrapped = true;
    }
    if(pos.z < min.z) {
      pos.z = max.z;
      wrapped = true;
    }

    if(pos.x > max.x) {
      pos.x = min.x;
      wrapped = true;
    }
    if(pos.y > max.y) {
      pos.y = min.y;
      wrapped = true;
    }
    if(pos.z > max.z) {
      pos.z = min.z;
      wrapped = true;
    }
    
    if(wrapped)
      particle.clearVelocity();
  }
}