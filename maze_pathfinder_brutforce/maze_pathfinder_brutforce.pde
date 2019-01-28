Cell[][] grid;
int size = 250; //Size in number of collumn and row
int numCol;
int numRow;
int scale;
boolean pathDone = false;
boolean done = false;//When the generation is done

boolean showGene = false; //Show the generation of the maze, otherwise just show a bar (But way faster)

int speedGene = 1000; //Number of pass for each frame
int speedPathFind = 10; //Number of pass for each frame
int speedPathDisp = 10; //Number of pass for each frame

long pass = 0; // Counter off pass
int count = 0; // Count the number of cell that are explored and have no more unexplored close cell

Explorer[] exp = new Explorer[1]; //The list of explorer agents
Pathfinding path;

void setup()
{
  //Create the windows and calculate the sizes
  size(751, 751);
  numCol = size;
  numRow = size;
  scale = width/size;
  
  frameRate(30);

  init();
}

void draw()
{
  
  //Generate only when there is unexplored cell left
  if (!done)
  {
    for (int j=0; j<speedGene&&!done; j++) // Do multiple pass in one frame
    {
      pass++;
      done = true;
      for (int i = 0; i<exp.length && i<(pass/8+1); i++) //Explore with each agent (but create only a few at the beginning to avoid collisions)
      {
        if(exp[i].explore() == false)
          done = false;
      }
    }

    if (!showGene) //Display a loading bar if showGen is false
    {
      int cumulCount = count;
      background(0);
      fill(255);
      stroke(255);
      textSize(height/15);
      textAlign(CENTER, CENTER);
      text("Generating maze", height/2, width/2);
      rect(2*width/20, 12*height/20, 16*width/20, 2*height/20);
      fill(0, 255, 0);
      for (int i = 0; i<exp.length && i<(pass/8+1); i++) //Explore with each agent (but create only a few at the beginning to avoid collisions)
       cumulCount+=exp[i].explored.size();
      rect(2*width/20, 12*height/20, 16*((float)(cumulCount)/(numCol*numRow))*width/20, 2*height/20);
    }
  }

  if (done || showGene) //Show the maze if done or if showGene is enabled
  {
    
    for (int x = 0; x < numCol; x++) //for each cell
    {
      for (int y = 0; y < numRow; y++)
      {
        grid[x][y].display();
      }
    }
    
    noStroke();
    if (!done)//Display the agents
    {  
      for (int i = 0; i<exp.length; i++)
        exp[i].display();
    }
    fill(36, 105, 216);
    rect(scale*(size/2)+1, 0, scale-1, scale-1);
    fill(196, 35, 35);
    rect(scale*(size/2)+1, scale*(size-1)+1, scale-1, scale-1);
  }
  
  //Exploring
  if (done)
  {
    if(!pathDone)
    {
      for (int j=0; j<speedPathFind; j++) // Do multiple pass in one frame
      pathDone = path.explore();
    }
    else
    {
      for (int j=0; j<speedPathDisp; j++) // Do multiple pass in one frame
      path.backTrack();
    }
  }
}

void init()
{
  count = 0;
  done = false;

  grid = new Cell[numCol][numRow]; //
  
  //generate the grid
  for (int x = 0; x < numCol; x++)
  {
    for (int y = 0; y < numRow; y++)
    {
      grid[x][y] = new Cell(x*scale, y*scale, scale);
    }
  }
  grid[size/2][0].explored = true; 

  int rndPosX = floor(random(0,numCol));
  int rndPosY = floor(random(0,numCol));

  //Create the agents
  for (int i = 0; i<exp.length; i++)
    exp[i] = new Explorer( grid, size/2, 0);
    
  path = new Pathfinding(grid,size/2,0,size/2,numRow-1);
  
  
    //Display
    background(186, 186, 186);
    
    for (int x = 0; x < numCol; x++) //for each cell
    {
      for (int y = 0; y < numRow; y++)
      {
        grid[x][y].toUpdate = true;
        grid[x][y].display();
      }
    }
}


void keyPressed()
{
  init();
}
