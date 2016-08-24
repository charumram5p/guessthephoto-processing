public class GameData {
  
  private boolean randomGame;
  private ArrayList<Game> games;
  public GameData() {
    this.randomGame = false;
    this.games = new ArrayList<Game>();
  }
  
  public void setRandomGame(boolean random) {
    this.randomGame = random;
  }
  
  public boolean isRandomGame() {
    return this.randomGame;
  }
  
  public void setGames(ArrayList<Game> games) {
    this.games = games;
  }
  
  public ArrayList<Game> getGames() {
    return this.games;
  }
  
  public void addGame(Game game) {
    this.games.add(game);
  }
  
}