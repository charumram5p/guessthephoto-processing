public class ControlBox {
 
  private int boxX, boxY, boxW, boxH, hintFontSize, buttonTextSize;
  private boolean loaded, isSetFont;
  
  private ControlP5 cp5;
  private PFont pFont, buttonfont;
  private Button hintBtn;
  private Button answerBtn;
  private Button nextBtn;
  private Textarea hintTextarea;
  private ControlBoxListener listener;
  private StringBuilder hintSb;
  private PImage hintImg1, answerImg1, nextImg1;
 
  private int hintXMargin, hintYMargin, hintTextW, hintTextH;
  private color hintTextColor, hintBackgroundColor, hintForegroundColor, buttonTextColor;
  private ArrayList<String> chaA;
  private ArrayList<String> chaB;
  
  public ControlBox(ControlP5 cp5, int x, int y, int w, int h) {
     this.cp5 = cp5;
     this.boxX = x;
     this.boxY = y;
     this.boxW = w;
     this.boxH = h;
    
     // add the above callback to controlP5
     cp5.addCallback(new ControlBoxCallbackListener());
  }
  
  public void init() {
    // Create hint text string
    hintSb = new StringBuilder();
    
    // Load 
    loadData();
    loadChar();
    
    createButtons();
    createHintTextBox();
  };  
  
  private void loadChar() {
    chaA = new ArrayList<String>();
    chaB = new ArrayList<String>();
    
    JSONObject jobj = loadJSONObject("char-map.json");
    JSONArray jarr;
    String ch;
    jarr = jobj.getJSONArray("cha_a");
    for(int i = 0; i < jarr.size(); i++) {
      ch = jarr.getString(i);
      chaA.add(ch);
    }
    jarr = jobj.getJSONArray("cha_b");
    for(int i = 0; i < jarr.size(); i++) {
      ch = jarr.getString(i);
      chaB.add(ch);
    }
  }
  
  public void setListener(ControlBoxListener listener) {
    this.listener = listener;
  }
  
  public ControlBoxListener getListener() {
    return this.listener;
  }
  
  public boolean isLoaded() {
    return this.loaded;
  }
  
  private void loadData() {
    //pFont = loadFont("LucidaSans-48.vlw");
    pFont = createFont("LucidaSans", 24, true);
    //pFont = createFont("ArialUnicodeMS", 24, true);
    buttonfont = loadFont("SuperspaceRegular-48.vlw"); 
    hintImg1 = requestImage("images/space window.png");
    answerImg1 = requestImage("images/satellite.png");
    nextImg1 = requestImage("images/spaceship.png"); //<>//
  };  
  
  void checkImageLoadState() {
    if (loaded) return;
    
    boolean unload = false;
    PImage[] images = {hintImg1, answerImg1, nextImg1};
    PImage image;
    for(int i = 0; i < images.length; i++) {
      image = images[i];
      if (image.width == 0 || image.width == -1) {
        unload = true;
        break;
      }
    }
    
    if (!unload) {
      updateButtonImages();
      
      hintTextarea.setVisible(true);
        
      loaded = true;
    }
  }
  
  private void setHintTextFont() {
    ControlFont font = new ControlFont(pFont, hintFontSize);
    hintTextarea.setFont(font);
    isSetFont = true;
  }

  private void createButtons() {
    int xMargin, yMargin, btnW, btnH;
    buttonTextColor = color(255);
    buttonTextSize = 24;
    
    xMargin = 5;
    yMargin = 5;
    btnW = 200;
    btnH = 200;
    hintBtn = cp5.addButton("HINT")
     .setPosition(this.boxX + xMargin + 25, this.boxY + yMargin + 15)
     .setSize(btnW, btnH)
     .setVisible(false);
     
    btnW = 300;
    btnH = 140;
    answerBtn = cp5.addButton("ANSWER")
     .setPosition(this.boxW - btnW - xMargin, this.boxY + yMargin - 30)
     .setSize(btnW, btnH)
     .setVisible(false);
     
    btnW = 180;
    btnH = 115;
    nextBtn = cp5.addButton("NEXT GAME")
     .setPosition(this.boxW - btnW - xMargin - 50 , this.boxY + yMargin + answerBtn.getHeight() - 30)
     .setSize(btnW, btnH)
     .setVisible(false);
                 
     hintBtn.addCallback(new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (theEvent.getAction() == ControlP5.ACTION_PRESS) {
            onClickHint();
          }
          
        }
      });
    answerBtn.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction() == ControlP5.ACTION_PRESS) {
          onClickAnswer();
        }
      }
    });
    nextBtn.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction() == ControlP5.ACTION_PRESS) {
          onClickNext();
        }
      }
    });
  }
  
  private void updateButtonImages() {
    int btnW, btnH;
    
    btnW = hintBtn.getWidth();
    btnH = hintBtn.getHeight();
    hintImg1.resize(btnW, btnH);
    hintBtn.setView(new CustomButton(hintImg1, 30.0, buttonTextColor, buttonfont, buttonTextSize));
    hintBtn.setVisible(true);
    
    btnW = answerBtn.getWidth();
    btnH = answerBtn.getHeight();
    answerImg1.resize(btnW, btnH);
    answerBtn.setView(new CustomButton(answerImg1, 30.0, buttonTextColor, buttonfont, buttonTextSize));
    answerBtn.setVisible(true);
    
    btnW = nextBtn.getWidth();
    btnH = nextBtn.getHeight();
    nextImg1.resize(btnW, btnH);
    nextBtn.setView(new CustomButton(nextImg1, 30.0, buttonTextColor, buttonfont, buttonTextSize));
    nextBtn.setVisible(true);
  }
  
  private void createHintTextBox() {
    // Hint font size
    hintFontSize = 32;
    // Hint positon
    hintXMargin = boxX + hintBtn.getWidth() + 50;
    hintYMargin = boxY + 30;
    hintTextW = boxW - (hintBtn.getWidth() + nextBtn.getWidth() + 200);
    hintTextH = boxH - 60;
    hintTextColor = color(0, 255, 0);
    hintBackgroundColor = color(255, 100);
    hintForegroundColor = color(255, 100);
    hintTextarea = cp5.addTextarea("hintTxt")
                  .setPosition(hintXMargin, hintYMargin)
                  .setSize(hintTextW, hintTextH)
                  .setColor(hintTextColor)
                  .setColorBackground(hintBackgroundColor)
                  .setColorForeground(hintForegroundColor)
                  .setVisible(false);
                  
  }
  
  public void drawControl() {
    checkImageLoadState();
    if (isLoaded())
      drawHintText();
  }
  
  public void drawHintText() {
    fill(hintTextColor);
    textFont(pFont);
    textSize(hintFontSize);
    String hintText = hintSb.toString();
    int x = hintXMargin;
    int y = hintYMargin + 30;
    float sub;
    for (int i = 0; i < hintText.length(); i++) {
      if (chaA.contains("" + hintText.charAt(i))) {
        x -= (textWidth(hintText.charAt(i)) / 1.0);
      }
      if (chaB.contains("" + hintText.charAt(i))) {
        x -= (textWidth(hintText.charAt(i)) / 2.0);
      }
      sub = 0.0;
      //if (chaA.contains("" + hintText.charAt(i))) {
      //  sub = (textWidth(hintText.charAt(i-1)) / 1.0);
      //}
      //if (chaB.contains("" + hintText.charAt(i))) {
      //  sub = (textWidth(hintText.charAt(i-1)) / 1.0);
      //}
      if ('\n' == hintText.charAt(i)) {
        y += textAscent() + 10;
        x = hintXMargin;
        continue;
      }
      text(hintText.charAt(i), x - sub, y);
      x += textWidth(hintText.charAt(i)); 
    }
  }
  
  public void addHintText(String hintText) {
    if (isLoaded() && !isSetFont)
      setHintTextFont();
      
    hintSb.append(hintText);
    //hintTextarea.setText(hintSb.toString());
  }
  
  public void clearHintText() {
    hintSb = new StringBuilder();
    hintTextarea.setText(hintSb.toString());
  }
  
  private void onClickHint() {
    if (getListener() != null) getListener().onClickHint();
  }
  
  private void onClickAnswer() {
    if (getListener() != null) getListener().onClickAnswer();
  }
  
  private void onClickNext() {
    if (getListener() != null) getListener().onClickNext();
  }
  
  class ControlBoxCallbackListener implements CallbackListener {
    public void controlEvent(CallbackEvent theEvent) {
    }
  }
  
}