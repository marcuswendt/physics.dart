part of physics;

abstract class Space<T>
{
  T dimensions; 
}

class Space3 extends Space<Vector3>
{ 
  Space3() {
    dimensions = new Vector3.zero();
  }
}