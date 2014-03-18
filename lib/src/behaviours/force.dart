part of physics;

/**
 * A constant force along a vector e.g. Gravity.
 */
class DirectionalForce extends Behaviour
{
  Vector3 _direction = new Vector3(0.0, 1.0, 0.0);
  double _weight = 1.0;
  Vector3 _force = new Vector3.zero();
  
  set direction(Vector3 value) {
    _direction.setFrom(value);
    _updateForce();
  }
  
  get direction => _direction;
  
  set weight(double value) {
    _weight = value;
    _updateForce();
  }
  
  get weight => _weight;
  
  _updateForce() {
    _force.setFrom(direction).normalize().scale(weight); 
  }
  
  apply(Particle particle) => particle.position.add(_force);
}


/**
 * A simple single point based attractor 
 */
class AttractorForce extends Behaviour
{
  Vector3 target = new Vector3.zero();
  double weight = 1.0;
  
  Vector3 _tmp = new Vector3.zero();
  
  apply(Particle particle)
  {
    _tmp.setFrom(target).sub(particle.position).scale(weight);  
    particle.position.add(_tmp);
  }
}