part of physics;

/**
 * VerLer Particle Baseclass
 *
 * FIELD flavoured particle integrator.
 * Supports Verlet-style integration for 'strict' relationships e.g. Springs + Constraints
 * and also Euler-style continous force integration for smooth/ flowing behaviour e.g. Flocking
 */
abstract class Particle<T> 
{
  int id = 0;
  int state = ALIVE;
  int age = 0;
  int lifetime = -1;
  double drag = 0.03;
  
  T position;
  
  // Verlet style previous position  
  T prev;
  
  // Euler
  T force;
  T velocity;

  // Springs
  bool isLocked = false;

  // state  
  static const ALIVE = 0;
  static const LOCKED = 1;
  static const IDLE = 2;
  static const DEAD = 3;  

  // internal 
  T tmp_;
  
  Particle(this.id);
  
  update() {}
  clearVelocity() {}
  setPosition(T position) {}
}


/**
 * 3D VerLer Particle
 */
class Particle3 extends Particle<Vector3>
{
  Particle3(int id) : super(id) 
  {
    position = new Vector3.zero();
    prev = new Vector3.zero();
    force = new Vector3.zero();
    velocity = new Vector3.zero();
    
    tmp_ = new Vector3.zero();
  }
  
  update() 
  {
    age++;
    if(state > Particle.ALIVE) return; 
    
    // integrate velocity
    tmp_.setFrom(position);
    position.x += (position.x - prev.x) + force.x;
    position.y += (position.y - prev.y) + force.y;
    position.z += (position.z - prev.z) + force.z;
    prev.setFrom(tmp_);
    lerp3(prev, position, drag);
    force.setZero();
  }
  
  clearVelocity() { prev.setFrom(position); }
 
  setPosition(Vector3 pos) {
    position.setFrom(pos);
    prev.setFrom(pos);
  }
}