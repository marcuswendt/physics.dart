part of physics;

abstract class Emitter<T> {
  Physics physics;
  int rate = 1;
  int interval = 1;
  int max = 100;
  
  int timer = -1;
  int id = 0;
  
  // initialiser function
  Function init = (T p) {};
  
  Emitter(this.physics);
  
  update(num dt) {
    if(timer == -1 || timer >= interval) {
      timer = 0;
      
      int i = 0;
      while(i < rate && physics.particles.length < max) {
        T p = create(id);
        physics.particles.add(p);
        init(p);
        
//        print("created particle $p id: $id i:$i");
        id++;        
        i++;
        
      }
    }
    timer++;
  }
  
  T create(int id);
}

class Emitter3 extends Emitter<Particle3> {
  Emitter3(physics) : super(physics);
  Particle3 create(int id) => new Particle3(id);
}