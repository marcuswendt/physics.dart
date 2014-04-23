import 'package:physics/physics.dart';

class StateChange extends Behaviour<Particle>
{
  String label;
  bool once = false;
  StateChange(this.label); 

  @override
  apply(Particle p) {
    if(once) return;
    print(label);
    once = true;
  }
}

main()
{
  var physics = new Physics<Particle, Spring>();
  physics.emitter.max = 1;
  physics.emitter.init = (Particle p) {
    p.lifetime = 500.0;
  };
  
  physics.addEffector(new StateChange("ALIVE"), Particle.ALIVE);
  physics.addEffector(new StateChange("LOCKED"), Particle.LOCKED);
  physics.addEffector(new StateChange("IDLE"), Particle.IDLE);
  physics.addEffector(new StateChange("DEAD"), Particle.DEAD);
  
  for(var f=0; f<1000; f++) {
    var dt = (1000 / 60.0);
    physics.update(dt);
  }
} 