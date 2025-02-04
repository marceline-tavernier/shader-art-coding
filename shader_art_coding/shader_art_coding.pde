
// Variables
PShader shaderArtCoding;
PGraphics shaderGraphics;

//////////////////

// Setup
void setup() {
  
  // Size 1024x1024 and set title
  size(1024, 1024, P2D);
  surface.setTitle("Kishimisu #1 : Shader art coding");

  // Setup screen display and shader
  shaderGraphics = createGraphics(width, height, P2D);
  shaderGraphics.loadPixels();
  shaderArtCoding = loadShader("shader_art_coding.glsl");
  
  // Give the resolution and time to the shader
  shaderArtCoding.set("resolution", float(width), float(height));
  shaderArtCoding.set("time", float(millis()) / 1000.0 - 2.0);
  
  // Display the shader
  shaderGraphics.shader(shaderArtCoding);
  shaderGraphics.rect(0, 0, width , height);
  image(shaderGraphics, 0, 0, width, height);
}

// Draw everything
void draw() {
  
    // Give the time to the shader
    shaderArtCoding.set("time", float(millis()) / 1000.0 - 2.0);
    
    // Display the shader
    shaderGraphics.shader(shaderArtCoding);
    shaderGraphics.rect(0, 0, width, height);
    image(shaderGraphics, 0, 0, width, height);
}
