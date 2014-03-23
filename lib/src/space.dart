part of physics;



/**
 * Base class for all types of spatial search implementations.
 * Subclasses may override this to organise particles so they can be found more efficiently.
 */
abstract class Space
{
  Vector3 dimension = new Vector3(100.0, 100.0, 100.0);
  Space();
  update(Physics physics) {}
  List<Particle> search(Vector3 center, double radius);
}


/**
 * simple brute force spatial searches.
 */
class BasicSpace extends Space
{
  Physics _physics;
  
  BasicSpace(this._physics);
  
  List<Particle> search(Vector3 center, double radius) 
  {
    List<Particle> result = new List();
    double radiusSq = radius * radius;
    
    for(Particle p in _physics.particles) {
      if(center.distanceToSquared(p.position) < radiusSq) {
        result.add(p);
      }
    }
    
    return result;
  }
}


/**
 * Utility class used by SpatialHash
 */
class SpatialHashCell {
  List<Particle> spatials = new List<Particle>();
}


/**
 * Spatial hashing class used to efficiently retrieve large numbers of uniformly distributed objects
 */
class SpatialHash extends Space
{
  Aabb3 aabb;
  
  List<SpatialHashCell> _cells = new List<SpatialHashCell>();
  double _cellSize;
  int _cellsX, _cellsY, _cellsZ;
  int _cellsXY;
  
  SpatialHash();
  
  init(Vector3 offset, Vector3 dimension, double cellSize)
  {
    // init bounds
    var _position = offset; // + dimension * 0.5;
    var _extent = dimension * 0.5;    
    aabb = new Aabb3.minmax(_position - _extent, _position + _extent);
    
    // init cells
    this._cellSize = cellSize;
    _cellsX = hash(dimension.x);
    _cellsY = hash(dimension.y);
    _cellsZ = hash(dimension.z);
    
    _cellsXY = _cellsX * _cellsY;
    
    int ncells = _cellsX * _cellsY * _cellsZ;
    for(int i=0; i<ncells; i++) {
      _cells.add(new SpatialHashCell());
    }
  }
  
  int hash(double value) => value ~/ _cellSize;
  
  /**
   * insert particles into spatial hash cell structure
   */
  update(Physics physics) {
    // clear cells
    for(SpatialHashCell cell in _cells)
      cell.spatials.clear();
    
    // insert particles
    Vector3 min = aabb.min;
    
    for(Particle particle in physics.particles) {
      Vector3 p = particle.position - min;
      int hashX = hash(p.x);
      int hashY = hash(p.y);
      int hashZ = hash(p.z);
      
      int index = hashX + _cellsX * hashY + _cellsXY * hashZ;
      
      if(index < 0 || index > _cells.length) {
//        print("couldnt fit particle ${particle.position}");
        return;
      }
      _cells[index].spatials.add(particle);
    }
  }
  
  List<Particle> search(Vector3 center, double radius) 
  {
    // find search center position in cell space
    Vector3 p = center - aabb.min;
    int hashX = hash(p.x);
    int hashY = hash(p.y);
    int hashZ = hash(p.z);
        
    // figure out search radius
    int search = (radius / _cellSize).ceil();
    
    int sx = max(hashX - search, 0);
    int sy = max(hashY - search, 0);
    int sz = max(hashZ - search, 0);
    
    int ex = min(hashX + search, _cellsX);
    int ey = min(hashY + search, _cellsY);
    int ez = min(hashZ + search, _cellsZ);
    
    // put all spatials from the selected cells into result
    List<Particle> result = new List();

    int index;
    
    for(int iz=sz; iz<ez; iz++) {
      for(int iy=sy; iy<ey; iy++) {
        for(int ix=sx; ix<ex; ix++) 
        {
           index = ix + _cellsX * iy + _cellsXY * iz;
           result.addAll(_cells[index].spatials);
        }
      }
    }
    
    return result;
  }
}