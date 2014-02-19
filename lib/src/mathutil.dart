part of physics;

void lerp3(Vector3 a, Vector3 b, double delta) {
  double complement = 1 - delta;
  a.x = a.x * complement + b.x * delta;
  a.y = a.y * complement + b.y * delta;
  a.z = a.z * complement + b.z * delta;
}