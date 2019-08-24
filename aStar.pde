import java.util.ArrayList;
//import java.util.Math;

int gridObjectSize = 20;
int width = 1200;
int height = 800;

int xLen = width / gridObjectSize;
int yLen = height / gridObjectSize;
int numOfObjects = xLen * yLen;

GridObject[][] grid = new GridObject[xLen][yLen];

int userIndexX = xLen / 2;
int userIndexY = yLen / 2;
GridObject user = new GridObject(userIndexX * gridObjectSize, userIndexY * gridObjectSize, gridObjectSize);

boolean wallActivated = false;

int startIndexX = -1;
int startIndexY = -1;

int endIndexX = -1;
int endIndexY = -1;

int frame = 0;
int holdFrameStart = -1;
int holdFrameEnd = -1;

void setup(){
  size(1200, 825);
  user.setColor(153, 153, 153);
  initGrid();
}

void initGrid(){
   
   for(int i = 0; i < xLen; i++){
     for(int j = 0; j < yLen; j++){
       
       int x = i * gridObjectSize;
       int y = j * gridObjectSize;
       
       grid[i][j] = new GridObject(x, y, gridObjectSize); 
     }
   }
}

void drawGrid(){
  
  for(int i = 0; i < xLen; i++){
    for(int j = 0; j < yLen; j++){
      
      grid[i][j].render();
    }
  }
}

void debugPrint(String debug){
      textSize(16); 
      fill(color(255));
      text(debug, 1000, height + 25 - 6);
}

void debugPrint(String debug, int x, int y){
      textSize(16); 
      fill(color(255));
      text(debug, x, height + 25 - y);
}

boolean showF = false;
boolean showG = false;
boolean showH = false;
boolean findStared = false;

void keyPressed(){
  
  switch(key){
    
    case 'f':
      showF = !showF;
      showG = false;
      showH = false;
      break;
    
    case 'g':
      showF = false;
      showG = !showG;
      showH = false;
      break;
      
    case 'h':
      showF = false;
      showG = false;
      showH = !showH;
      break;
      
    case 'w':
    
      wallActivated = !wallActivated;
      
      break;
    
    case 's':
    
      if(startIndexX == -1 && !wallActivated){
        
        grid[userIndexX][userIndexY].setColor(100,200,150);
        startIndexX = userIndexX;
        startIndexY = userIndexY;
      }
      
      break;
      
    case 'e':
    
      if(endIndexX == -1 && !wallActivated){
        
        grid[userIndexX][userIndexY].setColor(200,100,100);
        endIndexX = userIndexX;
        endIndexY = userIndexY;
      }
      
      break;
  }
  
  switch(keyCode){
      case UP:
      
        if(userIndexY > 0)
          userIndexY--;
          
        user.setY(userIndexY * gridObjectSize);
        break;
        
      case DOWN:
      
        if(userIndexY < yLen)
          userIndexY++;
          
        user.setY(userIndexY * gridObjectSize);
        break;
        
      case RIGHT:
      
        if(userIndexX < xLen)
          userIndexX++;
          
        user.setX(userIndexX * gridObjectSize);
        break;
        
      case LEFT:
      
        if(userIndexX > 0)
          userIndexX--;
          
        user.setX(userIndexX * gridObjectSize);
        break;
        
      case ENTER:
      
        findPath();
        break;
  }
}

void coordText(){
  
  textSize(16);
  String coords = "( " + (userIndexX + 1) + " , " + (userIndexY + 1) + " )"; 
  fill(color(255));
  text(coords, 5, height + 25 - 6);
}

boolean pathFinish = false;

void draw(){
    
  background(100);
  drawGrid();
  user.render();
  
  if(wallActivated){
    grid[userIndexX][userIndexY].setColor(0,0,0);
    grid[userIndexX][userIndexY].setWall();
    debugPrint("drawing walls");
  }
  
  if(startIndexX != -1){
    
    if(holdFrameStart == -1){
      holdFrameStart = frame;
    }
    
    if(frame - holdFrameStart < 120)
      debugPrint("Added start node at " + "(" + (startIndexX + 1) + "," + (startIndexY + 1) + ")", 500, 6);
    
  }
  
  if(endIndexX != -1){
    
    if(holdFrameEnd == -1){
      holdFrameEnd = frame;
    }
    
    if(frame - holdFrameEnd < 120)
      debugPrint("Added end node at " + "(" + (endIndexX + 1) + "," + (endIndexY + 1) + ")", 500, 6);
    
  }
  
  if(pathFinish){
    
    if(showH){
      drawChildrenByH();
      debugPrint("Visualizing H-Scores", 500, 6);
    }  
    
    else if(showG){
      drawChildrenByG();
      debugPrint("Visualizing G-Scores", 500, 6);
    }  
    
    else if(showF){
      drawChildrenByF();
      debugPrint("Visualizing F-Scores", 500, 6);
    }
    
    drawPath();
  }
    
  coordText();
  frame++;
}

// ***************************  a* algorithm  ******************************
ArrayList<Integer> openX = new ArrayList<Integer>(numOfObjects);
ArrayList<Integer> openY = new ArrayList<Integer>(numOfObjects);
ArrayList<Integer> closedX = new ArrayList<Integer>(numOfObjects);
ArrayList<Integer> closedY = new ArrayList<Integer>(numOfObjects);
ArrayList<GridObject> childrenArr = new ArrayList<GridObject>();
ArrayList<GridObject> path = new ArrayList<GridObject>();



void addToOpen(int x, int y){
  
  GridObject current = grid[x][y];
  
  openX.add(x);
  openY.add(y);
  
  current.setOpen(true);
  current.setClosed(false);  
}

void addToClosed(int x, int y){
    
  GridObject current = grid[x][y];
  
  if(current.getOpen()){
    
    for(int i = 0; i < openX.size(); i++){
      
      if(openX.get(i) == x && openY.get(i) == y){
        
        openX.remove(i);
        openY.remove(i);
        break;
      }
    }
  }
  
  closedX.add(x);
  closedY.add(y);
  
  current.setOpen(false);
  current.setClosed(true); 
}

float D = 1;

float getDistance(int x1, int y1, int x2, int y2){
  
  int dx = Math.abs(x2 - x1);
  int dy = Math.abs(y2 - y1);
  
  return D * (dx + dy);
}

void calcGridFCost(){
 
  for(int i = 0; i < xLen; i++){
    for(int j = 0; j < yLen; j++){
      
      float gCost = getDistance(i, j, startIndexX, startIndexY); //distance between start and current
      float hCost = getDistance(i, j, endIndexX, endIndexY); //distance between end and current
      
      grid[i][j].setCost(hCost, gCost); //set f cost in grid
    }
  }
}

int getLowestFCost(){

  float minFCost = grid[openX.get(0)][openY.get(0)].getF();
  int minIndex = 0;
  int size = openX.size();
  
  for(int i = 0; i < size; i++){
    
    int x = openX.get(i);
    int y = openY.get(i);
    
    float currentFCost = grid[x][y].getF();
    
    if(currentFCost <= minFCost){
      minIndex = i;
      minFCost = currentFCost;
    }
  }
  
  return minIndex;
}

void findPath(){
  //calcGridFCost();
  
  boolean isOver = false;
  grid[startIndexX][startIndexY].setCost(0, 0);
  addToOpen(startIndexX, startIndexY);
  
  while(openX.size() != 0){
    
    int currentIndex = getLowestFCost();
    int currentX = openX.get(currentIndex);
    int currentY = openY.get(currentIndex);
    
    //System.out.println(currentX + " , " + currentY);
    
    GridObject current = grid[currentX][currentY];
      
    addToClosed(currentX, currentY);
    
    if(currentX == endIndexX && currentY == endIndexY){
      
      while(current != null){

        path.add(current);
        current = current.getParent();
      }
      
      grid[startIndexX][startIndexY].setColor(0, 0, 255);
      grid[endIndexX][endIndexY].setColor(0, 255, 255);
      break;
    }
    
    int[][] children = {{1,0}, {0,1}, {-1,0}, {0,-1}};
                        
    for(int i = 0; i < 4; i++){//iterate through children
      
      int childX = currentX + children[i][0];
      int childY = currentY + children[i][1];
      
      if(isOver) break;
      
      if(childX >= xLen || childX < 0 || childY >= yLen || childY < 0)//if out of bounds then go to front of the loop
        continue;
      
      GridObject child = grid[childX][childY];

      if(child.getIsWall() || child.getClosed())
        continue;
        
        
      float g = current.getG() + 1;
      float h = getDistance(childX, childY, endIndexX, endIndexY);
      
      //for(int j = 0; j < openX.size(); j++){
        
      //  //System.out.println(1);
      //  int ox = openX.get(i);
      //  //System.out.println(2);
      //  int oy = openY.get(i);
      //  //System.out.println(3);
      //  GridObject openNode = grid[ox][oy];
      //  //System.out.println(4);
      //  if(childX == ox && childY == oy && g > openNode.getG())
      //    continue;
      //}
      
        childrenArr.add(child);
      
      if(child.getOpen()){
        
        if(g < child.getG()){
          
          System.out.println("G was less");
          child.setCost(g,h);
          child.setParent(current);
        }
        
        continue;
      }
      
      //this means child isnt in closed or open
      child.setCost(g, h);
      child.setParent(current);
      addToOpen(childX, childY);
    }
  }
  
  pathFinish = true;
}

void drawPath(){
  
  int pathSize = path.size();
  
  for(int i = 1; i < pathSize; i++){
  
    GridObject current = path.get(i);
    GridObject prev = path.get(i-1);
    stroke(255);
    strokeWeight(5);
    line(current.getX() + gridObjectSize / 2, current.getY() + gridObjectSize / 2, prev.getX() + gridObjectSize / 2, prev.getY() + gridObjectSize / 2);
  }
}

void drawChildrenByG(){
  
    for(int i = 0; i < childrenArr.size(); i++){
   
    GridObject current = childrenArr.get(i);
    
    float f = current.getG();
    
    int green = 360 - (int)(6 * f);
    
    if(green < 0) green = 0;
    
    current.setColor(green, 50, 92);
  }
  
  grid[startIndexX][startIndexY].setColor(2, 61, 86);
  grid[endIndexX][endIndexY].setColor(2, 61, 86);
}

void drawChildrenByF(){
  
  for(int i = 0; i < childrenArr.size(); i++){
   
    GridObject current = childrenArr.get(i);
    
    float f = current.getF();
    
    int green = constrain((int)(360 - 0.5*f), 0, 360);
    
    current.setColor(green, 50, 92);
  }
  
  grid[startIndexX][startIndexY].setColor(2, 61, 86);
  grid[endIndexX][endIndexY].setColor(2, 61, 86);
}

void drawChildrenByH(){
  
    for(int i = 0; i < childrenArr.size(); i++){
   
    GridObject current = childrenArr.get(i);
    
    float f = current.getH();
    
    int green = 360 - (int)(6 * f);
    
    if(green < 0) green = 0;
    
    current.setColor(green, 50, 92);
  }
  
  grid[startIndexX][startIndexY].setColor(2, 61, 86);
  grid[endIndexX][endIndexY].setColor(2, 61, 86);
}
