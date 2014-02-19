part of physics;

class Behaviour<T> {
  prepare() {}
  apply(T p) {}
}

class Constraint<T> extends Behaviour<T> {}


/**
 * core physics simulation class
 */
class Physics {
  
  Space space;
  Emitter emitter;
  List<Particle> particles = [];
  List<Spring> springs = [];
  
  Map behaviours = new Map();
  
  int constraintIterations = 1;
  Map constraints = new Map();
  
  int springIterations = 1;
  
  Physics() {
    space = new Space3();
    emitter = new Emitter3(this); 
  }
  
  addEffector(Behaviour effector, [int state=Particle.ALIVE]) {
    var list = (effector is Constraint) ? constraints : behaviours;
    if(list[state] == null) list[state] = [];
    list[state].add(effector);
  }
  
  update(num dt) {
    emitter.update(dt);
    
    // apply behaviours
    applyEffectors(behaviours);
    
    // apply constraints
    for(int i=0; i<constraintIterations; i++) {
      applyEffectors(constraints);
      
      for(int j=0; j<springIterations; j++) {
        for(Spring s in springs)
          s.update();
      }
    }
    
    // update particles
    particles.forEach((Particle p) => p.update());
    
    // remove dead
    particles.removeWhere((Particle p) => p.state == Particle.DEAD);
  }
  
  // applies all effectors to the given particle list when their states match
  applyEffectors(Map effectors)
  {
    // go through all states in effectors list
    effectors.forEach((int state, List<Behaviour> stateEffectors) {
      for(Behaviour effector in stateEffectors) {
        effector.prepare();
        
        for(Particle p in particles) {
          if(p.state == state && !p.isLocked)
            effector.apply(p);
        }
      }
    });
  }
}
