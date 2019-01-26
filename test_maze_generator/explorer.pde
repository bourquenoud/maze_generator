/* Explorer class
 *
 *
 * This is the agent used to explorer the grid and generate the maze.
 */

class Explorer
{
  int[] pos = {0,0}; //Position of the agent
  Cell[][] grid; //Grid it is operating on
  ArrayList<Cell> explored; // The list of already exporated cells
  int retry = 0; //Number of retry to find a new cell
  boolean done; 
  
  Explorer(Cell[][] grid, ArrayList<Cell> explored)
  {
    this.grid = grid;
    this.explored = explored;
    done = false;
  }
  
  
  boolean explore()
  {
      while(true)
      {
        //Randomly select a direction to go
        int selection = floor(random(0,4));
        
        //--Try to go in the direction-------
        if(selection == 0 && pos[0] < numCol-1)//Right
        {
          if(grid[pos[0]+1][pos[1]].explored == false)//Check if the cell is explored
          {
            grid[pos[0]][pos[1]].border[1] = false; //remove the border
            grid[pos[0]+1][pos[1]].border[3] = false; 
            pos[0]++; //Move the agent
            break; //exit the loop
          }
        }
        else if(selection == 1 && pos[1] < numRow-1)//Down
        {
          if(grid[pos[0]][pos[1]+1].explored == false)
          {
            grid[pos[0]][pos[1]].border[2] = false;
            grid[pos[0]][pos[1]+1].border[0] = false;
            pos[1]++;
            break;
          }
        }
        else if(selection == 2 && pos[0] > 0)//Left
        {
          if(grid[pos[0]-1][pos[1]].explored == false)
          {
            grid[pos[0]][pos[1]].border[3] = false;
            grid[pos[0]-1][pos[1]].border[1] = false;
            pos[0]--;
            break;
          }
        }
        else if(selection == 3 && pos[1] > 0)//Up
        {
          if(grid[pos[0]][pos[1]-1].explored == false)
          {
            grid[pos[0]][pos[1]].border[0] = false;
            grid[pos[0]][pos[1]-1].border[2] = false;
            pos[1]--;
            break;
          }
        }
          
          //Go back somewhere on an already explored cell if stuck
          if ((grid[constrain(pos[0]+1, 0, numCol-1)][constrain(pos[1], 0, numRow-1)].explored && 
          grid[constrain(pos[0]-1, 0, numCol-1)][constrain(pos[1], 0, numRow-1)].explored && 
          grid[constrain(pos[0], 0, numCol-1)][constrain(pos[1]+1, 0, numRow-1)].explored && 
          grid[constrain(pos[0], 0, numCol-1)][constrain(pos[1]-1, 0, numRow-1)].explored))
          {
            int targ = floor(random(0,explored.size())); //Randomly select a cell
            pos[0] = explored.get(targ).posX/scale;
            pos[1] = explored.get(targ).posY/scale;
            retry++; //If it did not find a valid cell after a few try, stop.
            if(retry > 50)
              return true;
          }
      }
      
      explored.add(grid[pos[0]][pos[1]]); //Add the actual cell in the explored list
      grid[pos[0]][pos[1]].explored = true; //Indicate that the cell was explored
      
     return done;
  }
  
  void display()
  {
    //Simply display a green square
    noStroke();
    fill(50,200,50);
    rect(pos[0]*scale+1,pos[1]*scale+1, scale-1, scale-1);
  }
  
}
