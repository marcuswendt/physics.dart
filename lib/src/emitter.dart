part of physics;

/**
 * Creates new particle instances in regular intervals or on demand.
 * If you want to change the type, override the create method.
 */
class Emitter<T extends Particle>
{
  Physics physics;
  int rate = 1;
  int interval = 1;
  int max = 100;
  
  int timer = -1;
  int id = 0;

  // creates a new instance of the given particle type
  Function create = (int id) => new Particle(id);

  // initialiser function
  Function init = (T p) {};
  
  Emitter(this.physics);
  
  update(num dt) {
    if(timer == -1 || timer >= interval) {
      timer = 0;
      
      int i = 0;
      while(i < rate) {
        emit();
//        print("created particle $p id: $id i:$i");        
        i++;
      }
    }
    timer++;
  }
  
  // creates and initialised a single particle
  T emit() {
    if(physics.particles.length >= max) return null;
    
    T p = create(id);
    physics.particlesNew.add(p);
    init(p);
    id++;
    return p;
  }
}