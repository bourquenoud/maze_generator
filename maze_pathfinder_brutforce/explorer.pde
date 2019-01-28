/* Explorer class
 *
 *
 * This is the agent used to explorer the grid and generate the maze.
 */

class Explorer
{

  ArrayList<Cell> explored; //List of explored cell that have an unexplored cell near them
  float branProb = 0.05;

  int[] pos = {0, 0}; //Position of the agent
  Cell[][] grid; //Grid it is operating on
  int retry = 0; //Number of retry to find a new cell
  boolean done; 

  Explorer(Cell[][] grid, int startPosX, int startPosY)
  {
    explored = new ArrayList<Cell>(); //List of explored cell that have an unexplored cell near them
    pos[0] = startPosX;
    pos[1] = startPosY;
    explored.add(grid[startPosX][startPosY]);
    this.grid = grid;
    done = false;
  }


  boolean explore()
  {
    while (true)
    {

      //Remove unexplorable cell
      for (int i = 0; i<explored.size(); i++)
      {
        explored.get(i).debug = true;
        //Check each cell close to the tested one (Protected against out of bound array)
        if (grid[constrain(explored.get(i).posX/scale+1, 0, numCol-1)][constrain(explored.get(i).posY/scale, 0, numRow-1)].explored && 
          grid[constrain(explored.get(i).posX/scale-1, 0, numCol-1)][constrain(explored.get(i).posY/scale, 0, numRow-1)].explored && 
          grid[constrain(explored.get(i).posX/scale, 0, numCol-1)][constrain(explored.get(i).posY/scale+1, 0, numRow-1)].explored && 
          grid[constrain(explored.get(i).posX/scale, 0, numCol-1)][constrain(explored.get(i).posY/scale-1, 0, numRow-1)].explored)
        {
          explored.get(i).toUpdate = true; //debug
          explored.get(i).debug = false;
          explored.remove(i);
          count++; //Count the number of cell
        }
      }


      if (explored.size() == 0) //When there is no explorable cell left, the maze is finished
      {
        done=true;
        return true;
      }

      //Go back somewhere on an already explored cell if stuck
      if (((
        grid[constrain(pos[0]+1, 0, numCol-1)][constrain(pos[1], 0, numRow-1)].explored && 
        grid[constrain(pos[0]-1, 0, numCol-1)][constrain(pos[1], 0, numRow-1)].explored && 
        grid[constrain(pos[0], 0, numCol-1)][constrain(pos[1]+1, 0, numRow-1)].explored && 
        grid[constrain(pos[0], 0, numCol-1)][constrain(pos[1]-1, 0, numRow-1)].explored) ||
        random(0, 1) < branProb
        ))
      {
        grid[pos[0]][pos[1]].toUpdate = true;

        int targ = floor(random(constrain(39*explored.size()/40-10, 0, explored.size()), explored.size())); //Randomly select a cell
        pos[0] = explored.get(targ).posX/scale;
        pos[1] = explored.get(targ).posY/scale;

        /*pos[0] = explored.get(explored.size()-1).posX/scale;
         pos[1] = explored.get(explored.size()-1).posY/scale;*/
         //retry++; //If it did not find a valid cell after a few try, stop.
        /*if (retry > 50)
          return true;*/
      }

      //Randomly select a direction to go
      int selection = floor(random(0, 4));

      //--Try to go in the direction-------
      if (selection == 0 && pos[0] < numCol-1)//Right
      {
        if (grid[pos[0]+1][pos[1]].explored == false)//Check if the cell is explored
        {
          grid[pos[0]][pos[1]].border[1] = false; //remove the border
          grid[pos[0]+1][pos[1]].border[3] = false; 

          grid[pos[0]][pos[1]].toUpdate = true;
          grid[pos[0]+1][pos[1]].toUpdate = true;

          pos[0]++; //Move the agent

          break; //exit the loop
        }
      } else if (selection == 1 && pos[1] < numRow-1)//Down
      {
        if (grid[pos[0]][pos[1]+1].explored == false)
        {
          grid[pos[0]][pos[1]].border[2] = false;
          grid[pos[0]][pos[1]+1].border[0] = false;

          grid[pos[0]][pos[1]].toUpdate = true;
          grid[pos[0]][pos[1]+1].toUpdate = true;

          pos[1]++;

          break;
        }
      } else if (selection == 2 && pos[0] > 0)//Left
      {
        if (grid[pos[0]-1][pos[1]].explored == false)
        {
          grid[pos[0]][pos[1]].border[3] = false;
          grid[pos[0]-1][pos[1]].border[1] = false;

          grid[pos[0]][pos[1]].toUpdate = true;
          grid[pos[0]-1][pos[1]].toUpdate = true;

          pos[0]--;

          break;
        }
      } else if (selection == 3 && pos[1] > 0)//Up
      {
        if (grid[pos[0]][pos[1]-1].explored == false)
        {
          grid[pos[0]][pos[1]].border[0] = false;
          grid[pos[0]][pos[1]-1].border[2] = false;

          grid[pos[0]][pos[1]].toUpdate = true;
          grid[pos[0]][pos[1]-1].toUpdate = true;

          pos[1]--;

          break;
        }
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
    fill(50, 200, 50);
    rect(pos[0]*scale+1, pos[1]*scale+1, scale-1, scale-1);
  }
}
