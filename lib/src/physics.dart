part of physics;

abstract class Behaviour 
{
  prepare() {}
  apply(Particle p) {}
}

abstract class Constraint extends Behaviour {}


/**
 * Core Physics Simulation Class
 */
class Physics 
{  
  Space space;
  Emitter emitter;
  List<Particle> particles = [];
  List<Spring> springs = [];
  
  Map behaviours = new Map();
  
  int constraintIterations = 1;
  Map constraints = new Map();
  
  int springIterations = 1;
  
  Physics() {
    space = new BasicSpace(this);
    emitter = new Emitter(this); 
  }
  
  addEffector(Behaviour effector, [int state=Particle.ALIVE]) {
    var list = (effector is Constraint) ? constraints : behaviours;
    if(list[state] == null) list[state] = [];
    list[state].add(effector);
  }
  
  update(num dt) {

    emitter.update(dt);
    
    space.update(this);
    
    // apply behaviours
    applyEffectors(behaviours);

    // update springs
    for(int j=0; j<springIterations; j++) {
      for(Spring s in springs)
        s.update();
    }

    // apply constraints
    for(int i=0; i<constraintIterations; i++)
      applyEffectors(constraints);
    
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
