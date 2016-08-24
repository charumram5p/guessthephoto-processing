public class DrawTextUtils {
  
  private ArrayList<String> chaA;
  private ArrayList<String> chaB;
  
  public DrawTextUtils() {
    
  }
  
  public void init() {
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
}