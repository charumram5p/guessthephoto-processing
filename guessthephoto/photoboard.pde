public class PhotoBoard {
  private int originX, originY, disW, disH, blockRow, blockCol;
  private boolean loaded, showAnswer;

  private PImage image;   
  private PImage answerImage; 
  private PShape boardFrame;
  private PShape answerFrame;
  private PShape[] blockRects;
  private boolean[] blockSelected;
  
  private color rectBGStrokeColor = color(255);
  private color rectBGStrokeWeight = 4;
  private color rectNStrokeColor = color(255);
  private color rectNStrokeWeight = 4;
  private color rectNFillColor = color(127, 255);
  private color rectHFillColor = color(100, 255);
  
  PFont font;
  private int textSize = 45;
  private int answerTextSize = 50;
  private color textNColor = color(255);
  private color textSColor = color(127, 0);
  private color textAnswerColor = color(255);
  
  public PhotoBoard(int x, int y, int w, int h, int row, int col) {
    this.originX = x;
    this.originY = y;
    this.disW = w;
    this.disH = h;
    this.blockRow = row;
    this.blockCol = col;
  }
  
  public void init() {
    font = loadFont("SuperspaceRegular-48.vlw"); 
    
    createBlocks();
    createData();
  }
  
  public void clearBoard() {
    showAnswer = false;
    
    int blockId;
    for (int i = 0; i < blockRow; i++) {
      for (int j = 0; j < blockCol; j++) {
        blockId = (blockRow * i) + j;
        setSelected(blockId, false);
      }
    }
  }
  
  public void setImage(PImage image) {
    this.image = image;
    loaded = false;
  }
  
  public void setAnswerImage(PImage answerImage) {
    this.answerImage = answerImage;
    loaded = false;
  }
  
  public boolean isLoaded() {
    return this.loaded;
  }
  
  private void createBlocks() {
    // Board Frame
    boardFrame = createShape(RECT, originX, originY, disW, disH);
    boardFrame.setStroke(rectBGStrokeColor);
    boardFrame.setStrokeWeight(rectBGStrokeWeight);
    
    // Answer Frame
    int answerFrameSize = 200;
    answerFrame = createShape(RECT, originX, originY + ((disH - answerFrameSize ) / 2.0), disW, answerFrameSize);
    answerFrame.setFill(color(127, 100));
    answerFrame.setStrokeWeight(0);
    
    // Create all blocks
    blockRects = new PShape[blockRow * blockCol];
    int rectW = disW / blockCol;
    int rectH = disH / blockRow;
    PShape rectangle;
    for (int i = 0; i < blockRow; i++) {
      for (int j = 0; j < blockCol; j++) {
        rectangle = createShape(RECT, originX + (j * rectW), originY +(i * rectH), rectW, rectH);
        rectangle.setStroke(rectNStrokeColor);
        rectangle.setStrokeWeight(rectNStrokeWeight);
        rectangle.setFill(rectNFillColor);
        
        blockRects[(blockRow * i) + j] = rectangle;
      }
    }
  }
  
  private void createData() {
    blockSelected = new boolean[blockRow * blockCol];
  }
  
  void checkImageLoadState() {
    if (loaded) return;
    
    if ((image != null && image.width != 0 && image.width != -1)
       && (answerImage != null && answerImage.width != 0 && answerImage.width != -1)) {
      loaded = true;
    }
  }

  public void drawBoard() {
    // Check image load state
    checkImageLoadState();
    
    if (!isLoaded()) return;
    
    // Draw frame
    shape(boardFrame);
    
    // Draw Image
    image(image, originX, originY, disW, disH);
    
    if (showAnswer) 
      drawAnswer();
    
    // Draw Block
    drawBlocks(findPressedBlock(mouseX, mouseY));
    drawBlockId();
    
  }
  
  private void drawAnswer() {
     //shape(answerFrame);
     int answerFrameH = (int) (disH / 3.0); 
     int answerFrameW = (int) (answerFrameH * (answerImage.width / (answerImage.height * 1.0))); 
     image(answerImage, originX + ((disW - answerFrameW) / 2.0), originY + ((disH - answerFrameH ) / 2.0), answerFrameW, answerFrameH);
  }

  private void drawBlocks(int hoverBlockId) {
    int blockId;
    for (int i = 0; i < blockRow; i++) {
      for (int j = 0; j < blockCol; j++) {
        blockId = (blockRow * i) + j;
        // Draw Shape
        if (!blockSelected[blockId]) {
          if (hoverBlockId == blockId) {
            blockRects[blockId].setFill(rectHFillColor);
            shape(blockRects[blockId]);  
          } else {
            blockRects[blockId].setFill(rectNFillColor);
            shape(blockRects[blockId]); 
          }
        }
      }
    }
  }
  
  private void drawBlockId() {
    int blockId;
    color textColor;
    int rectW = disW / blockCol;
    int rectH = disH / blockRow;
    for (int i = 0; i < blockRow; i++) {
      for (int j = 0; j < blockCol; j++) {
        blockId = (blockRow * i) + j;
        textColor = (getBlockStatus(blockId))?textSColor : textNColor;
        // Draw label
        drawBlockIdLabel(blockId + 1, textColor, originX + (j * rectW), originY + (i * rectH), rectW, rectH);
      }
    }
  }
  
  private void drawBlockIdLabel(int blockId, color textColor, int rectX, int rectY, int rectW, int rectH) {
    // set the FontSize to the height of the rect
    textFont(font, textSize); 
    
    String text = String.valueOf(blockId);
    
    float nTextSize = textSize;
    //the textSize() is shorten by 1 until the textWidth() smaller then the width of the rect
    while(textWidth(text) > rectW){
     nTextSize -= 1;
     textSize(nTextSize);
     println(textWidth(text));
    }
    
    //draw the text in the middle of the rect
    int textX = rectX + (int)((rectW - textWidth(text)) / 2);
    int textY = rectY + (rectH/ 2) + (int)(nTextSize/ 2);
    fill(textColor);
    text(text, textX, textY);

  }
  
  public int findPressedBlock(int mouseX, int mouseY) {
    int rectW = disW / blockCol;
    int rectH = disH / blockRow;
    double row = Math.floor((mouseY - originY) / (rectH * 1.0)); 
    double col = Math.floor((mouseX - originX) / (rectW * 1.0));
    
    if (row < 0 || row >= blockRow) {
      return -1;
    }
    
    if (col < 0.0 || col >= blockCol) {
      return -1;
    }
    
    return (int)((blockRow * row) + col);
  }
  
  public void setSelected(int blockId, boolean selected) {
    blockSelected[blockId] = selected;
  }
  
  public boolean getBlockStatus(int blockId) {
    return blockSelected[blockId];
  }
  
  public void showFullImage() {
    showAnswer = true;
    
    int blockId;
    for (int i = 0; i < blockRow; i++) {
      for (int j = 0; j < blockCol; j++) {
        blockId = (blockRow * i) + j;
        setSelected(blockId, true);
      }
    }
  }

}