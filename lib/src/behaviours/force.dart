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
 * A simple single point + radius based attractor 
 */
class AttractorForce extends Behaviour
{
  Vector3 target = new Vector3.zero();
  double weight = 1.0;
  
  double _radius;
  double _radiusSq;
  
  Vector3 _tmp = new Vector3.zero();
  
  AttractorForce([double radius=100.0]) {
    this.radius = radius;
  }
 
  set radius(double value) {
      _radius = value;
      _radiusSq = _radius * _radius;
    }
    
  get radius => _radius;
    
  apply(Particle particle)
  {
    _tmp.setFrom(target).sub(particle.position);
    double distSq = _tmp.length2;
    
    if(distSq < _radiusSq) {
      double dist = Math.sqrt(distSq);
      _tmp.scale( (1.0 / dist) * (1.0 - dist/ radius) * weight);
      particle.position.add(_tmp);
//      particle.force.add(_tmp); // ?
    }    
  }
}