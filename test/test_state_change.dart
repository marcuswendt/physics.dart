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

class Split extends Behaviour<Particle>
{
  int nchildren = 2;
  
  Physics physics;
  Split(this.physics);
  
  apply(Particle p) {
    for(var i=0; i<nchildren; i++)
      physics.emitter.emit();
  }
}


class Init extends Behaviour<Particle>
{
  Physics physics;
  Init(this.physics);

  apply(Particle p) {
    print("initialising p ${p.id}");
    p.lifetime = 500.0;
  }
}



main()
{
  var physics = new Physics<Particle, Spring>();
  physics.emitter.max = 10;
  physics.emitter.rate = 0;
  
  physics.addEffector(new StateChange("ALIVE"), Particle.ALIVE);
  physics.addEffector(new StateChange("LOCKED"), Particle.LOCKED);
  physics.addEffector(new StateChange("IDLE"), Particle.IDLE);
  physics.addEffector(new StateChange("DEAD"), Particle.DEAD);
  
  physics.addEffector(new Split(physics), Particle.DEAD);
  physics.addEffector(new Init(physics), Particle.EMITTED);
  
  physics.emitter.emit(); // spark
  
  for(var f=0; f<2000; f++) {
    var dt = (1000 / 60.0);
    physics.update(dt);
  }
} 