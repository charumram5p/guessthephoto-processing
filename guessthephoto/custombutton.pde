public class CustomButton implements ControllerView<Button> {
  
  public static final float ZOOM_STEP = 4;
  public static final float ROTATE_MIN = 0;
  public static final float ROTATE_MAX = 0.5;
  public static final float ROTATE_STEP = 0.1;
  
  private PImage img1;
  private float maxZoomScale;
  private float zoomScale;
  private float zoomStep;
  private float rotate;
  private float rotateStep;

  private color textColor;
  private PFont textFont;  
  private int textSize;
  
  public CustomButton(PImage img1, float zoomScale, color textColor, PFont textFont, int textSize) {
    this.img1 = img1;
    this.maxZoomScale = zoomScale;
    this.textColor = textColor;
    this.textFont = textFont;
    this.textSize = textSize;
    
    clearZoom();
    clearRotate();
  }
  
  public void display(PGraphics graphics, Button button) {
    // center
    int x = button.getWidth()/2;
    int y = button.getHeight()/2;
    
    
    // Draw image
    // Enter to Matrix
    graphics.pushMatrix();
     
    graphics.translate(x, y);
    graphics.rotate(rotate);
    graphics.imageMode(CENTER);
    graphics.image(img1, 0, 0, button.getWidth() + zoomScale, button.getHeight() + zoomScale);
    
    // Draw caption
    //button.getCaptionLabel().draw(graphics);
   
    // Find zoom scale and rotate
    if (button.isInside()) {
      if (button.isPressed()) { // button is pressed
        clearZoom();
        clearRotate();
      }  else { // mouse hovers the button
        updateZoom();
        updateRotate();
      }
    } else { // the mouse is located outside the button area
      updateToNormalZoom();
      updateToNormalRotate();
    }
    // Exit matrix
    graphics.popMatrix();
    
    
    // Draw caption
    graphics.pushMatrix();
    if (button.isInside()) {
      graphics.translate(x, y);
      graphics.fill(textColor);
      graphics.textFont(textFont);
      graphics.textSize(textSize);
      graphics.textAlign(CENTER, CENTER);
      graphics.text(button.getName(), 0, button.getHeight() / 2.0);
    }
    graphics.popMatrix();
    
  }
  
  private void clearZoom() {
    zoomScale = 0.0;
    zoomStep = ZOOM_STEP;
  }
  
  private void updateToNormalZoom() {
    float zoomMin = 0;
    if (zoomScale == zoomMin) 
      return;
    zoomScale -= ZOOM_STEP;
    if (zoomScale < zoomMin)
      zoomScale = zoomMin;
  }
  
  private void updateZoom() {
    zoomScale += zoomStep;
    if (zoomScale > maxZoomScale) {
      zoomScale = maxZoomScale;
    }
  }
  
  private void clearRotate() {
    this.rotate = ROTATE_MIN;
    this.rotateStep = ROTATE_STEP;
  }
  
  private void updateToNormalRotate() {
    float rotateMin = ROTATE_MIN;
    if (rotate == rotateMin) 
      return;
    if (rotate < rotateMin) {
      rotate += ROTATE_STEP;
      if (rotate > rotateMin)
        rotate = rotateMin;
    } else {
      rotate -= ROTATE_STEP;
      if (rotate < rotateMin)
        rotate = rotateMin;
    }
  }
  
  private void updateRotate() {
      float maxRotate = ROTATE_MAX;
      
      // Update rotate
      rotate += rotateStep;
      
      if (rotate < -maxRotate) {
        rotate = -maxRotate;
        rotateStep = -rotateStep;
      }
      
      if (rotate > maxRotate) {
        rotate = maxRotate;
        rotateStep = -rotateStep;
      }
      
  }
}