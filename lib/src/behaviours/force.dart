part of physics;

/**
 * A constant force along a vector e.g. Gravity.
 */
class Force3 extends Behaviour
{
  Vector3 direction = new Vector3(0.0, 1.0, 0.0);
  double weight = 1.0;
  
  Vector3 _force = new Vector3.zero();
  
  prepare() => _force.setFrom(direction).normalize().scale(weight);
  
  apply(Particle3 particle) => particle.position.add(_force);
}