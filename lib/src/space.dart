part of physics;

/**
 * Simple brute force spatial searches.
 * Subclasses may override this to organise particles so they can be found more efficiently.
 */
class Space
{
  Vector3 dimensions = new Vector3.zero();
  
  Physics _physics;
  
  Space(this._physics);
  
  update() {}
  
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