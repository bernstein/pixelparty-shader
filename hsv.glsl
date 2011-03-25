float 
minChannel(in vec3 v)
{
  float t = (v.x<v.y) ? v.x : v.y;
  t = (t<v.z) ? t : v.z;
  return t;
}

float 
maxChannel(in vec3 v)
{
  float t = (v.x>v.y) ? v.x : v.y;
  t = (t>v.z) ? t : v.z;
  return t;
}

vec3 
rgbToHsv(in vec3 rgb)
{
  vec3  hsv = vec3(0.0);
  float minVal = minChannel(rgb);
  float maxVal = maxChannel(rgb);
  float delta = maxVal - minVal;

  hsv.z = maxVal;

  if (delta != 0.0) {
    hsv.y = delta / maxVal;
    vec3 delRGB;
    delRGB = (((vec3(maxVal) - rgb) / 6.0) + (delta/2.0)) / delta;

    if (rgb.x == maxVal) {
      hsv.x = delRGB.z - delRGB.y;
    } else if (rgb.y == maxVal) {
      hsv.x = ( 1.0/3.0) + delRGB.x - delRGB.z;
    } else if (rgb.z == maxVal) {
      hsv.x = ( 2.0/3.0) + delRGB.y - delRGB.x;
    }

    if ( hsv.x < 0.0 ) { 
      hsv.x += 1.0; 
    }
    if ( hsv.x > 1.0 ) { 
      hsv.x -= 1.0; 
    }
  }
  return hsv;
}

vec3 
hsvToRgb(in vec3 hsv)
{
  vec3 rgb = vec3(hsv.z);
  if ( hsv.y != 0.0 ) {
    float var_h = hsv.x * 6.0;
    float var_i = floor(var_h);   // Or ... var_i = floor( var_h )
    float var_1 = hsv.z * (1.0 - hsv.y);
    float var_2 = hsv.z * (1.0 - hsv.y * (var_h-var_i));
    float var_3 = hsv.z * (1.0 - hsv.y * (1.0 - (var_h-var_i)));

    switch (int(var_i)) {
      case  0: rgb = vec3(hsv.z, var_3, var_1); break;
      case  1: rgb = vec3(var_2, hsv.z, var_1); break;
      case  2: rgb = vec3(var_1, hsv.z, var_3); break;
      case  3: rgb = vec3(var_1, var_2, hsv.z); break;
      case  4: rgb = vec3(var_3, var_1, hsv.z); break;
      default: rgb = vec3(hsv.z, var_1, var_2); break;
    }
  }
  return rgb;
}
