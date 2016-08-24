/**
 * Guess The Photo
 * by Pachara Charumram. 
 * 
 * Guess The Photo is a game.
 * 
 */
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.Random;
import controlP5.*;

int disW, disH, framerate, 
boardX, boardY, boardW, boardH, blockRow, blockCol, 
ctrlX, ctrlY, ctrlW, ctrlH,
currentGameIndex, nextGameIndex, 
launchTime, launchCnt;
boolean loaded;

PhotoBoard gameBoard;
ControlBox controlBox;
GameData gamedata;
ControlP5 cp5;
GalaxyScreen launchScreen;

Map<String, PImage> gameImages, gameAnswerImages;
PImage gameImage, gameAnswerImage;
PImage backgroundImage;
color backgroundColor;
Set<Integer> viewedGame;
Set<Integer> viewedHint;
Random rand = new Random(); 

void setup() {
  // Setup display
  size(displayWidth, displayHeight, P3D);
  //fullScreen(P3D);
  //surface.setResizable(true);
  framerate = 30;
  smooth();
  frameRate(framerate);
  
  disW = displayWidth;
  disH = displayHeight;
  // Background
  backgroundColor = color(0);
  background(backgroundColor);
  
  // Control box size (Bottom)
  ctrlH = 250;
  ctrlW = disW;
  ctrlX = 0;
  ctrlY = disH - ctrlH;

  // Board size (Top)
  blockRow = 3;
  blockCol = 3;
  boardY = 20;
  boardH = (disH - ctrlH - (boardY * 2));
  boardW = (int)(boardH * (16.0 / 9.0));
  boardX = (disW - boardW) / 2;
  
  // Launch Screen
  launchScreen = new GalaxyScreen(framerate, disW, disH);
  launchScreen.init();
  launchTime = 60;
  launchCnt = 0;
  
  // Load data file
  gamedata = loadGameData();
  loadImageData();
  
  cp5 = new ControlP5(this);
  
  gameBoard = new PhotoBoard(boardX, boardY, boardW, boardH, blockRow, blockCol);
  gameBoard.init();
  // Set board game data
  currentGameIndex = getNextGameIndex();
  loadCurrentGame(currentGameIndex);
  // Load next image
  nextGameIndex = getNextGameIndex();
  getLoadGameImage(nextGameIndex);
  getLoadGameAnswerImage(nextGameIndex);
  
  controlBox = new ControlBox(cp5, ctrlX, ctrlY, ctrlW, ctrlH);
  controlBox.init();
  controlBox.setListener(new ControlBoxListener() {
    @Override
    public void onClickHint() {
      showHint();
    }
    @Override
    public void onClickAnswer() {
      showAnswer();
    }
    @Override
    public void onClickNext() {
      showNext();
    }
  });
  
}

void loadImageData() {
  backgroundImage = requestImage("images/bgspace.jpg");
}

PImage getLoadGameImage(int index) {
  String imagePath = gamedata.getGames().get(index).getImage();
  if (gameImages == null) 
    gameImages = new HashMap<String, PImage>();
    
  PImage gameImage = null;
  if (gameImages.containsKey(imagePath)) {
    gameImage = gameImages.get(imagePath);
  } else {
    gameImage = requestImage(imagePath);
    gameImages.put(imagePath, gameImage);
  }
  return gameImage;
}

PImage getLoadGameAnswerImage(int index) {
  String imagePath = gamedata.getGames().get(index).getAnswerImage();
  if (gameAnswerImages == null) 
    gameAnswerImages = new HashMap<String, PImage>();
    
  PImage gameImage = null;
  if (gameAnswerImages.containsKey(imagePath)) {
    gameImage = gameAnswerImages.get(imagePath);
  } else {
    gameImage = requestImage(imagePath);
    gameAnswerImages.put(imagePath, gameImage);
  }
  return gameImage;
}

void checkImageLoadState() {
  if (loaded) return;
  
  if (backgroundImage.width != 0 && backgroundImage.width != -1) {
    backgroundImage.resize(disW, disH);
    loaded = true;
  }
}

GameData loadGameData() {
  JSONObject gameDataJson = loadJSONObject("gamedata.json");
  
  GameData gamedata;
  Game game;
  JSONArray jArr;
  JSONArray jHArr;
  JSONObject jObj;
  
  gamedata = new GameData();
  gamedata.setRandomGame(gameDataJson.getBoolean("randomGame"));
  jArr = gameDataJson.getJSONArray("games");
  for(int i = 0; i < jArr.size(); i++) {
    jObj = jArr.getJSONObject(i);
    game = new Game();
    game.setName(jObj.getString("name"));
    game.setImage(jObj.getString("image"));
    game.setAnswerImage(jObj.getString("answerImage"));
    game.setRandomHint(jObj.getBoolean("randomHint"));
    jHArr = jObj.getJSONArray("hints");
    for(int j = 0; j < jHArr.size(); j++) {
      game.addHint(jHArr.getString(j));
    }
    gamedata.addGame(game);
  }
  
  return gamedata;
}

int getNextGameIndex() {
  if (viewedGame != null && viewedGame.size() == gamedata.getGames().size())
    viewedGame.clear();
    
  int nextIndex = 0;
  if (gamedata.isRandomGame()) {
    do {
      nextIndex = rand.nextInt(gamedata.getGames().size());
    } while(viewedGame != null && viewedGame.contains(nextIndex));
  } else {
    if (viewedGame != null)
      nextIndex = (currentGameIndex + 1) % gamedata.getGames().size(); 
  }
  return nextIndex;
}

void loadCurrentGame(int index) {
  // For random game
  if (viewedGame == null) 
    viewedGame = new HashSet<Integer>();
    
  viewedGame.add(index);
  gameImage = getLoadGameImage(index);
  gameAnswerImage = getLoadGameAnswerImage(index);
  gameBoard.setImage(gameImage);
  gameBoard.setAnswerImage(gameAnswerImage);
  viewedHint = new HashSet<Integer>();
}

String getNewHint() {
  String newHint = null;
  Game game = gamedata.getGames().get(currentGameIndex);
  ArrayList<String> hints = game.getHints();
  int hintIndex = viewedHint.size();
  
  if (viewedHint.size() < hints.size()) {
    if (game.isRandomHint()) {
      do {
        hintIndex = rand.nextInt(hints.size());
      } while(viewedHint.contains(hintIndex));
    }
    newHint = hints.get(hintIndex);
    viewedHint.add(hintIndex);
  }
  
  return newHint;
}

void draw() {
 checkImageLoadState();
 if (backgroundImage != null 
     && loaded 
     && controlBox.isLoaded()) {
   background(backgroundImage);
 } else { 
  launchScreen.drawScreen();
 }
 
 if (launchCnt > launchTime) {
   gameBoard.drawBoard();
   controlBox.drawControl();
 } else {
   launchCnt++;
 }
 
}

void mousePressed() {
  if (gameBoard.isLoaded()) {
    int pressedBlock = gameBoard.findPressedBlock(mouseX, mouseY);
  
    if (pressedBlock != -1) {
      //gameBoard.setSelected(pressedBlock, !gameBoard.getBlockStatus(pressedBlock));
      if (!gameBoard.getBlockStatus(pressedBlock))
        gameBoard.setSelected(pressedBlock, true);
    }
  }
}

void keyPressed() {
  if (!loaded || launchCnt < launchTime) {
    if(keyCode == UP) { launchScreen.keyUP(); }
    if(keyCode == DOWN) { launchScreen.keyDOWN(); }
    if(keyCode == LEFT) { launchScreen.keyLEFT(); }
    if(keyCode == RIGHT) { launchScreen.keyRIGHT(); }
  }
}

void showHint() {
  String newHint = getNewHint();
  if (newHint != null)
    controlBox.addHintText(newHint + "\n");
}

void showAnswer() {
  gameBoard.showFullImage();
}

void showNext() {
  gameBoard.clearBoard();
  controlBox.clearHintText();
  // Load game
  currentGameIndex = nextGameIndex;
  loadCurrentGame(currentGameIndex);
  // Load next image
  nextGameIndex = getNextGameIndex();
  getLoadGameImage(nextGameIndex);
  getLoadGameAnswerImage(nextGameIndex);
}