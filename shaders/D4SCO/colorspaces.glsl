/* -------------------------------------------------------------------------- */
/*                          D4SCO COLORSPACES - 0.0.0                         */
/* -------------------------------------------------------------------------- */

/* ---------------------------- Common Transforms --------------------------- */

// ANCHOR | sRGB <> sRGB' | Rec. 709 | D65
vec3 sRGBtosRGBl(vec3 color)
{
  const float a = 0.055;
  const float b = 0.0404482362771082;
  return vec3(
    color.r <= b ? color.r / 12.92 : pow((color.r + a) / (1.0 + a), 2.4),
    color.g <= b ? color.g / 12.92 : pow((color.g + a) / (1.0 + a), 2.4),
    color.b <= b ? color.b / 12.92 : pow((color.b + a) / (1.0 + a), 2.4)
  );
}
vec3 sRGBltosRGB(vec3 color)
{
  const float a = 0.055;
  const float b = 0.00313066844250063;
  return vec3(
    color.r <= b ? color.r * 12.92 : (1.0 + a) * pow(color.r, 1.0 / 2.4) - a,
    color.g <= b ? color.g * 12.92 : (1.0 + a) * pow(color.g, 1.0 / 2.4) - a,
    color.b <= b ? color.b * 12.92 : (1.0 + a) * pow(color.b, 1.0 / 2.4) - a
  );
}