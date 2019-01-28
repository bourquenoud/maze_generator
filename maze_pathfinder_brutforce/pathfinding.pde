class Pathfinding
{
  Cell[][] grid;
  ArrayList<Cell> listed;
  boolean done = false;
  int goalX;
  int goalY;
  Cell shortest;

  Pathfinding(Cell[][] grid,int startX, int startY, int goalX, int goalY)
  {
    this.grid = grid;
    this.goalX = goalX;
    this.goalY = goalY;
    listed = new ArrayList<Cell>();
    listed.add(grid[startX][startY]);// Add the start cell
    grid[startX][startY].pathCost = 0;
    println(goalX +";" +goalY);
  }

  boolean explore()//Return true when done
  {
    ArrayList<Cell> newList = new ArrayList<Cell>();
    int sizeList = listed.size();
    for (int i = 0; i< sizeList; i++)
    {
      Cell c = listed.get(i);
      if (c.posX/scale == goalX && c.posY/scale == goalY)
      {
        println(c.pathCost);
        shortest = c;
        c.onPath = true;
        //done = true;
        //return true;
      }
      //Select the next cells to be explored and add them to the "listed" array
      if (c.border[1] == false)
      {
        if (grid[c.posX/scale+1][c.posY/scale].pathCost == -1)
        {
          grid[c.posX/scale+1][c.posY/scale].pathCost = c.pathCost + 1;
          newList.add(grid[c.posX/scale+1][c.posY/scale]);
        }
      }
      if (c.border[2] == false)
      {
        if (grid[c.posX/scale][c.posY/scale+1].pathCost == -1)
        {
          grid[c.posX/scale][c.posY/scale+1].pathCost = c.pathCost + 1;
          newList.add(grid[c.posX/scale][c.posY/scale+1]);
        }
      }
      if (c.border[3] == false)
      {
        if (grid[c.posX/scale-1][c.posY/scale].pathCost == -1)
        {
          grid[c.posX/scale-1][c.posY/scale].pathCost = c.pathCost + 1;
          newList.add(grid[c.posX/scale-1][c.posY/scale]);
        }
      }
      if (c.border[0] == false)
      {
        if (grid[c.posX/scale][c.posY/scale-1].pathCost == -1)
        {
          grid[c.posX/scale][c.posY/scale-1].pathCost = c.pathCost + 1;
          newList.add(grid[c.posX/scale][c.posY/scale-1]);
        }
      }
    }

    listed = newList;
    
    for(int i=0; i<listed.size(); i++)
      listed.get(i).toUpdate = true;

    //return done;
    return (listed.size()==0);
  }

  boolean backTrack()
  {
    boolean found = false;
    Cell tmpShortest = shortest;
    //println("Shortest coordinates : " + shortest.posX/scale + ";" + shortest.posY/scale);
    //Select the next cells to be explored and add them to the "listed" array
    if (shortest.border[1] == false && tmpShortest.pathCost > grid[shortest.posX/scale+1][shortest.posY/scale].pathCost && 0 < grid[shortest.posX/scale+1][shortest.posY/scale].pathCost)
    {
      tmpShortest = grid[shortest.posX/scale+1][shortest.posY/scale];
      found = true;
    }
    if (shortest.border[2] == false && tmpShortest.pathCost > grid[shortest.posX/scale][shortest.posY/scale+1].pathCost && 0 < grid[shortest.posX/scale][shortest.posY/scale+1].pathCost)
    {
      tmpShortest = grid[shortest.posX/scale][shortest.posY/scale+1];
      found = true;
    }
    if (shortest.border[3] == false && tmpShortest.pathCost > grid[shortest.posX/scale-1][shortest.posY/scale].pathCost && 0 < grid[shortest.posX/scale-1][shortest.posY/scale].pathCost)
    {
      tmpShortest = grid[shortest.posX/scale-1][shortest.posY/scale];
      found = true;
    }
    if (shortest.border[0] == false && tmpShortest.pathCost > grid[shortest.posX/scale][shortest.posY/scale-1].pathCost && 0 < grid[shortest.posX/scale][shortest.posY/scale-1].pathCost)
    {
      tmpShortest = grid[shortest.posX/scale][shortest.posY/scale-1];
      found = true;
    }
    tmpShortest.onPath = true;
    shortest = tmpShortest;
    shortest.toUpdate = true;

    return !found;
  }
}
