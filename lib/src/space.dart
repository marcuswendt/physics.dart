part of physics;


/**
 * Base class for all types of spatial search implementations.
 * Subclasses may override this to organise particles so they can be found more efficiently.
 */
abstract class Space
{
  Vector3 dimensions = new Vector3(100.0, 100.0, 100.0);
  Space();
  update(Physics physics) {}
  List<Particle> search(Vector3 center, double radius);
}


/**
 * simple brute force spatial searches.
 */
class BasicSpace extends Space
{
  Physics _physics;
  
  BasicSpace(this._physics);
  
  List<Particle> search(Vector3 center, double radius) 
  {
    List<Particle> result = new List();
    double radiusSq = radius * radius;
    
    for(Particle p in _physics.particles) {
      if(center.distanceToSquared(p.position) < radiusSq) {
        result.add(p);
      }
    }
    
    return result;
  }
}
