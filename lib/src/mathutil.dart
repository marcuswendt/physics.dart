part of physics;

void lerp3(Vector3 a, Vector3 b, double delta) {
  double complement = 1 - delta;
  a.x = a.x * complement + b.x * delta;
  a.y = a.y * complement + b.y * delta;
  a.z = a.z * complement + b.z * delta;
}

// simplified versions of the default dart:math min, max functions which have lots of type checks and may be slow 
num max(num a, num b) => (a > b) ? a : b;

num min(num a, num b) => (a < b) ? a : b;