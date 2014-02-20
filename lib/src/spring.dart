part of physics;

/** Verlet Spring */
abstract class Spring<T>
{
	T a;
	T b;
	double strength = 1.0;
	double restLength = 0.0;

	Spring(this.a, this.b) {
		restLength = a.position.distanceTo(b.position);
	}

	update() {}
}

/** A 3D Verlet Spring */ 
class Spring3 extends Spring<Particle3>
{
	Spring3(Particle3 a, Particle3 b) : super(a, b);

	update() {
		Vector3 delta = b.position - a.position;
    	double dist = delta.length() + double.MIN_POSITIVE;
    	double normDistStrength = (dist - restLength) / dist * strength;

	    if(normDistStrength == 0) return;

    	delta.sale(normDistStrength);

    	if(!a.isLocked) 
      		a.position.add(delta);
  		
  		if(!b.isLocked) 
      		b.position.sub(delta);
	}
}
