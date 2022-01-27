/* -------------------------------------------------------------------------- */
/*                            D4SCO HELPERS - 0.0.0                           */
/* -------------------------------------------------------------------------- */

const float D10 = 1e-10;

bool same2(vec2 v) { return v.x == v.y; }
bool same3(vec3 v) { return v.x == v.y && v.y == v.z; }
bool same4(vec4 v) { return v.x == v.y && v.y == v.z && v.z == v.w; }