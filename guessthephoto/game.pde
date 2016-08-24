public class Game {
  private String name;
  private String image;
  private String answerImage;
  private boolean randomHint;
  private ArrayList<String> hints;
  public Game() {
    this.name = "";
    this.image = "";
    this.answerImage = "";
    this.randomHint = false;
    this.hints = new ArrayList<String>();
  }
  
  public void setName(String name) {
    this.name = name;
  }
  
  public String getName() {
    return this.name;
  }
  
  public void setImage(String image) {
    this.image = image;
  }
  
  public String getImage() {
    return this.image;
  }
  
  public void setAnswerImage(String answerImage) {
    this.answerImage = answerImage;
  }
  
  public String getAnswerImage() {
    return this.answerImage;
  }
  
  public void setRandomHint(boolean randomHint) {
    this.randomHint = randomHint;
  }
  
  public boolean isRandomHint() {
    return this.randomHint;
  }
  
  public void setHints(ArrayList<String> hints) {
    this.hints = hints;
  }
  
  public ArrayList<String> getHints() {
    return this.hints;
  }
  
  public void addHint(String hint) {
    this.hints.add(hint);
  }
  
}