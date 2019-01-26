Cell[][] grid;
ArrayList<Cell> explored = new ArrayList<Cell>(); //List of explored cell that have an unexplored cell near them
int size = 100; //Size in number of collumn and row
int numCol;
int numRow;
int scale;
boolean done = false;//When the generation is done

boolean showGene = true; //Show the generation of the maze, otherwise just show a bar (But way faster)

int speed = 1; //Number of pass for each frame

long pass = 0; // Counter off pass
int count = 0; // Count the number of cell that are explored and have no more unexplored close cell

Explorer[] exp = new Explorer[10]; //The list of explorer agents

void setup()
{
  //Create the windows and calculate the sizes
  size(801, 801);
  numCol = size;
  numRow = size;
  scale = width/size;
  
  frameRate(30);

  init();
}

void draw()
{
  
  //Generate only when there is unexplored cell left
  if (explored.size() != 0)
  {
    for (int j=0; j<speed&&!done; j++) // Do multiple pass in one frame
    {
      pass++;
      //done = true;
      for (int i = 0; i<exp.length && i<(pass/4); i++) //Explore with each agent (but create only a few at the beginning to avoid collisions)
      {
        exp[i].explore();
      }
      
      //Remove unexplorable cell
      for (int i = 0; i<explored.size(); i++)
      {
        //Check each cell close to the tested one (Protected against out of bound array)
        if (grid[constrain(explored.get(i).posX/scale+1, 0, numCol-1)][constrain(explored.get(i).posY/scale, 0, numRow-1)].explored && 
          grid[constrain(explored.get(i).posX/scale-1, 0, numCol-1)][constrain(explored.get(i).posY/scale, 0, numRow-1)].explored && 
          grid[constrain(explored.get(i).posX/scale, 0, numCol-1)][constrain(explored.get(i).posY/scale+1, 0, numRow-1)].explored && 
          grid[constrain(explored.get(i).posX/scale, 0, numCol-1)][constrain(explored.get(i).posY/scale-1, 0, numRow-1)].explored)
        {
          explored.remove(i);
          count++; //Count the number of cell 
        }
      }
      
      if (explored.size() == 0) //When there is no explorable cell left, the maze is finished
      {
        done=true;
        break;
      }
    }

    if (!showGene) //Display a loading bar if showGen is false
    {

      background(0);
      fill(255);
      stroke(255);
      textSize(height/15);
      textAlign(CENTER, CENTER);
      text("Generating maze", height/2, width/2);
      rect(2*width/20, 12*height/20, 16*width/20, 2*height/20);
      fill(0, 255, 0);
      rect(2*width/20, 12*height/20, 16*((float)(count+explored.size())/(numCol*numRow))*width/20, 2*height/20);
      println(explored.size());
    }
  }

  if (explored.size() == 0 || showGene) //Show the maze if done or if showGene is enabled
  {

    //Display
    background(186, 186, 186);
    
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
    rect(1, 1, scale-1, scale-1);
    fill(196, 35, 35);
    rect(scale*(numCol-1)+1, scale*(numRow-1)+1, scale-1, scale-1);
  }
}

void init()
{
  explored.clear(); //Empty the explorer list
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

  //Add the first cell
  explored.add(grid[0][0]);
  grid[0][0].explored = true; 

  //Create the agents
  for (int i = 0; i<exp.length; i++)
    exp[i] = new Explorer( grid, explored);
}


void keyPressed()
{
  init();
}
