/* Cell class
 * 
 */
class Cell
{
  int size;

  boolean[] border = {true, true, true, true}; //Walls (top, right, bottom, left)
  boolean explored = false; // If the cell has been explored
  int pathCost = -1; //Cost to start from here
  boolean onPath = false;
  boolean toUpdate = true;
  
  boolean debug = false;

  int posX, posY; //Graphic position

  Cell(int posX, int posY, int size)
  {
    this.posX = posX;
    this.posY = posY;
    this.size = size;
  }

  void display()
  {
    if (toUpdate || debug)
    {
      //Color if explored
      if (explored && pathCost == -1)
      {
        fill(242, 242, 242);
        noStroke();
        rect(posX, posY, size, size);
      } else if (pathCost > 0)
      {
        fill(constrain(pathCost/15, 0, 255), constrain(255-pathCost/15, 0, 255), 50);
        noStroke();
        rect(posX, posY, size, size);
        if (onPath)
        {

          fill(255, 253, 155);
          if (size > 10)
          {
            noStroke();
            ellipse(posX+size/2, posY+size/2, size/4, size/4);
          } else
          {
            rect(posX, posY, size, size);
          }
        }
      }

      //Line colors
      if (explored)
        stroke(0); //Full black
      else
        stroke(0, 0, 0, 32); //A bit of transparency
      //Top
      if (border[0])
        line(posX, posY, posX + size, posY);
      //Right
      if (border[1])
        line(posX+size, posY, posX+size, posY+size);
      //Bottom
      if (border[2])
        line(posX, posY+size, posX+size, posY+size);
      //Left
      if (border[3])
        line(posX, posY, posX, posY + size);
        
        if(debug)
        {
          fill(128, 128, 128);
          noStroke();
          rect(posX+1, posY+1, size-1, size-1);
        }

      toUpdate = false;
    }
  }
}
