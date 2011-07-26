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
    float h_i = floor(var_h);
    //float f = var_h - h_i;
    float p = hsv.z * (1.0 - hsv.y);
    float q = hsv.z * (1.0 - hsv.y * (var_h-h_i));
    float t = hsv.z * (1.0 - hsv.y * (1.0 - (var_h-h_i)));

    int i = int(h_i) % 6;

    switch (i) {
      case  0: rgb = vec3(hsv.z, t, p); break;
      case  1: rgb = vec3(q, hsv.z, p); break;
      case  2: rgb = vec3(p, hsv.z, t); break;
      case  3: rgb = vec3(p, q, hsv.z); break;
      case  4: rgb = vec3(t, p, hsv.z); break;
      default: rgb = vec3(hsv.z, p, q); break;
    }
  }
  return rgb;
}
