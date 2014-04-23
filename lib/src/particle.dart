part of physics;

/**
 * VerLer Particle Baseclass
 *
 * FIELD flavoured particle integrator.
 * Supports Verlet-style integration for 'strict' relationships e.g. Springs + Constraints
 * and also Euler-style continous force integration for smooth/ flowing behaviour e.g. Flocking
 */
class Particle 
{
  int id = 0;
  int state = ALIVE;
  num age = 0;
  num lifetime = -1;
  double drag = 0.03;
  double size = 1.0;
  
  get mass => _mass;  
  set mass(double value) {
  	_mass = value;
  	_invMass = 1.0 / _mass;
  }

  Vector3 position = new Vector3.zero();
  
  // Verlet style previous position  
  Vector3 prev = new Vector3.zero();
  
  // Euler
  Vector3 force = new Vector3.zero();

  // Springs
  bool get isLocked => state == LOCKED;

  // state  
  static const ALIVE = 0;
  static const LOCKED = 1;
  static const IDLE = 2;
  static const DEAD = 3;  

  // internal 
  Vector3 tmp_ = new Vector3.zero();
  double _mass = 1.0;  
  double _invMass = 1.0;
  
  Particle(this.id);
  
  update(num dt) 
  {
    if(state > Particle.ALIVE) return; 
    
    // integrate velocity
    tmp_.setFrom(position);
    position.x += (position.x - prev.x) + force.x;
    position.y += (position.y - prev.y) + force.y;
    position.z += (position.z - prev.z) + force.z;
    prev.setFrom(tmp_);
    lerp3(prev, position, drag);
    force.setZero();
    
    // check if particle died
    age += dt;
    if(lifetime > 0 && age >= lifetime)
      state = Particle.DEAD;
  }
  
  applyForce(Vector3 force) => this.force += force.scale(_invMass);

  scaleVelocity(double amount) => lerp3(prev, position, 1.0 - amount);
  clearVelocity() => prev.setFrom(position);

  Vector3 get velocity => position - prev;
  set velocity(Vector3 velocity) => prev.setFrom(position).add(velocity);
 
  setPosition(Vector3 pos) {
    position.setFrom(pos);
    prev.setFrom(pos);
  }
}
