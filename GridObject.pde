public class GridObject  {
  
  private int x;
  private int y;
  private float fCost;
  private float hCost;
  private float gCost;
  private long dim;
  private color fill;
  private int strokeColor;
  private boolean isWall;
  private boolean isOpen;
  private boolean isClosed;
  private int index;
  GridObject parent;
  
  public GridObject(int x, int y, int size){
    this.x = x;
    this.y = y;
    this.dim = size;
    fill = color(75,75,175);
    strokeColor = 153;
    isWall = false;
    isOpen = false;
    isClosed = false;
    index = -1;
    parent = null;
  }
  
  //draws the square
  public void render(){
    colorMode(HSB, 360, 100, 100);
    fill(this.fill);
    stroke(0);
    strokeWeight(0);
    rect(x, y, dim, dim);
  }
  
  public void setCost(float g, float h){
    this.hCost = h;
    this.gCost = g;
    this.fCost = h + g;
  }
  
  //accessor methods
  public float getH(){
    return this.hCost;
  }
  
  public float getG(){
    return this.gCost;
  }
  
  public float getF(){
    return this.fCost;
  }
  
  public void setColor(int r, int g, int b){
    this.fill = color(r, g, b);
  }
  
  public void setX(int x){
    this.x = x;
  }
  
  public void setY(int y){
    this.y = y;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public void setStrokeColor(int c){
    this.strokeColor = c;
  }
  
  public void setWall(){
    this.isWall = true;
  }
  
  public void setOpen(boolean temp){
    this.isOpen = temp;
  }
  
  public void setClosed(boolean temp){
    this.isOpen = temp;
  }
  
  public void setIndex(int index){
    this.index = index;
  }
  
  public int getIndex(){
    return index;
  }
  
  public boolean getClosed(){
    return this.isClosed;
  }
  
  public boolean getOpen(){
    return this.isOpen;
  }
  
  public boolean getIsWall(){
    return this.isWall;
  }
  
  public void setParent(GridObject parent){
    this.parent = parent;
  }
  
  public GridObject getParent(){
    return this.parent;
  }
}
