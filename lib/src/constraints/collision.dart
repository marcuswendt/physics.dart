part of physics;

/**
 * Stops particles from colliding with each other.
 */
class Collision extends Constraint
{
  double searchRadius;
  double bouncyness = 0.5;
  
  Physics _physics;
  Vector3 _tmp = new Vector3.zero();
  
  Collision(this._physics, [this.searchRadius = 100.0]);
  
  apply(Particle particle) {
    Vector3 position = particle.position;
    List<Particle> neighbours = _physics.space.search(position, searchRadius);
    
    for(Particle neighbour in neighbours) {
      _tmp.setFrom(neighbour.position).sub(position);
      var distSq = _tmp.length2;
      
      var radius = (particle.size + neighbour.size) * .5 + double.MIN_POSITIVE;
      var radiusSq = radius * radius;
      
      if(distSq < radiusSq) {
        var dist = Math.sqrt(distSq);
        _tmp.scale( (dist - radius) / radius * bouncyness);
        particle.position.add(_tmp);
        if(!neighbour.isLocked) neighbour.position.sub(_tmp);
      }
    }
  }
}