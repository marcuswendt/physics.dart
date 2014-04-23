part of physics;

/**
 * Base class for all physical behaviour, forces and constraint effectors.
 */
abstract class Effector<P extends Particle> 
{
  prepare() {}
  apply(P p);
}

abstract class Behaviour<P extends Particle> extends Effector<P> {}
abstract class Constraint<P extends Particle> extends Effector<P> {}


/**
 * Core Physics Simulation Class
 */
class Physics<P extends Particle, S extends Spring<P>>
{  
  Space space;
  Emitter<P> emitter;
  List<P> particles = [];
  List<S> springs = [];
  
  var behaviours = new Map<int, List<Behaviour<P>>>();
  
  int constraintIterations = 1;
  var constraints = new Map<int, List<Constraint<P>>>();
  
  int springIterations = 1;
  
  Physics() {
    space = new BasicSpace(this);
    emitter = new Emitter<P>(this); 
  }
  
  addEffector(Effector effector, [int state=Particle.ALIVE]) {
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
      for(S s in springs)
        s.update();
    }

    // apply constraints
    for(int i=0; i<constraintIterations; i++)
      applyEffectors(constraints);
    
    // update particles
    for(var p in particles)
      p.update(dt);

    // check and remove dead
    particles.removeWhere(checkDeadAndApplyEffectors);
  }
  
  // applies all effectors to the given particle list when their states match
  applyEffectors(Map effectors)
  {
    // go through all states in effectors list
    effectors.forEach((int state, List<Effector> stateEffectors) {
      for(Effector effector in stateEffectors) {
        effector.prepare();
        
        for(P p in particles) {
          if(p.state == state)
            effector.apply(p);
        }
      }
    });
  }
  
  // check and remove dead
  checkDeadAndApplyEffectors(P p) {
    if(p.state != Particle.DEAD) return false;
   
    var applyEffectorsForState = (var list)
    {
      if(list == null) return;
      for(var e in list)
        e.apply(p);
    };
    
    applyEffectorsForState(behaviours[Particle.DEAD]);
    applyEffectorsForState(constraints[Particle.DEAD]);
    
    return true;
  }
}
