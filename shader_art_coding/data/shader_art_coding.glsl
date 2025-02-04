#ifdef GL_ES
precision highp float;
#endif

// Variables

uniform vec2 resolution;
uniform float time;

//////////////////

// Palette
vec3 palette(float t) {
  vec3 a = vec3 (0.5, 0.5, 0.5);
  vec3 b = vec3 (0.5, 0.5, 0.5);
  vec3 c = vec3 (1.0, 1.0, 1.0);
  vec3 d = vec3 (0.0, 0.1, 0.2);

  return a + b * cos(6.28318 * (c * t + d));
}

// Lerp functions for float, vec2 and vec3
float lerp(float before, float after, float a, float start, float end) {
  return mix(before, after, clamp((a - start) / (end - start), 0., 1.));
}

vec2 lerp(vec2 before, vec2 after, float a, float start, float end) {
  return mix(before, after, clamp((a - start) / (end - start), 0., 1.));
}

vec3 lerp(vec3 before, vec3 after, float a, float start, float end) {
  return mix(before, after, clamp((a - start) / (end - start), 0., 1.));
}

// Get the distance during the animation
float getDistance(vec2 uv, vec2 uv0, float time) {

  // Get the distance
  float d = lerp(1, length(uv), time, 0., 1.);

  // At 14 seconds, add a falloff effect
  if (time > 14.) {
    d *= lerp(1, exp(-length(uv0)), time, 14., 15.);
  }

  // At 1 second, make the circle bigger
  if (time > 1.) {
    d -= lerp(0., .5, time, 1., 2.);
  }

  // From 4 to 5 seconds, duplicate the circle
  if (time > 4. && time <= 5.) {
    d = lerp(d, sin(d * 8.) / 8., time, 4., 5.);
  }

  // At 5 seconds, make the circles move inwards
  if (time > 5.) {
    d = sin(d * 8. + time - 5.) / 8.;
  }

  // At 2 seconds, make the cirle hollow
  if (time > 2.) {
    d = lerp(d, abs(d), time, 2., 3.);
  }

  // From 3 to 6 seconds, smooth the circle's edges
  if (time > 3. && time <= 6.) {
    d = lerp(d, smoothstep(0., .1, d), time, 3., 4.);
  }

  // From 6 to 17 seconds, smooth the circle's edges even more
  if (time > 6. && time <= 17.) {
    d = lerp(smoothstep(0., .1, d), .01 / d, time, 6., 7.);
  }

  // At 17 seconds, darken the circles
  if (time > 17.) {
    d = lerp(.01 / d, pow(.01 / d, 1.2), time, 17., 18.);
  }
  return d;
}

// Get the color during the animation
vec3 getCol(vec2 uv, vec2 uv0, float i, float time) {

  // Start with white
  vec3 col = vec3(1.);

  // From 7 to 8 seconds, use the palette
  if (time > 7. && time <= 8.) {
    col = lerp(col, palette(length(uv)), time, 7., 8.);
  }

  // From 8 to 10 seconds, move the palette
  if (time > 8. && time <= 10.) {
    col = palette(length(uv) + time);
  }

  // From 10 to 13 seconds, use the palette based on the ditance to the scene's center
  if (time > 10. && time <= 13.) {
    col = lerp(palette(length(uv) + time), palette(length(uv0) + time), time, 10., 11.);
  }

  // From 13 to 15 seconds, reduce the palette movement intensity
  if (time > 13. && time <= 15.) {
    col = lerp(palette(length(uv0) + time), palette(length(uv0) + time * .4), time, 13., 14.);
  }

  // At 15 seconds, introduce differences for each iterations
  if (time > 15.) {
    col = lerp(palette(length(uv0) + time * .4), palette(length(uv0) + i * .4 + time * .4), time, 15., 16.);
  }
  return col;
}

// Main function
void main() {

  // Initialize uv and color
  vec2 uv = (gl_FragCoord.xy * 2. - resolution) / resolution.y;
  vec2 uv0 = uv;
  vec3 finalColor = vec3(0.);

  // 4 fractal iterations
  // start at 1 iteration until 11 seconds, then 2 until 12 seconds, then 3 until 16 seconds, then 4 iterations
  float maxI = 1.;
  if (time > 11.) {
    maxI++;
  } 
  if (time > 12.) {
    maxI++;
  }
  if (time > 16.) {
    maxI++;
  }
  
  for (float i = 0.; i < maxI; i++) {

    // At 9 seconds, use the fractal of the uv
    if (time > 9.) {
      uv = lerp(uv, fract(uv * 1.5) - .5, time, 9., 10.);
    }

    // Distance to the center
    float d = getDistance(uv, uv0, time);

    // Initialize color
    vec3 col = getCol(uv, uv0, i, time);

    // Add color to the final color
    finalColor += col * d;
  }
  
  gl_FragColor = vec4(finalColor, 1);
}
