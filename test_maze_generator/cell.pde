/* Cell class
 * 
 */
class Cell
{
  int size;
  
  boolean[] border = {true,true,true,true}; //Walls (top, right, bottom, left)
  boolean explored = false; // If the cell has been explored
  
  int posX, posY; //Graphic position
  
  Cell(int posX, int posY, int size)
  {
   this.posX = posX;
   this.posY = posY;
   this.size = size;
  }
  
  void display()
  {
    //Color if explored
    if(explored)
    {
      fill(242, 242, 242);
      noStroke();
      rect(posX,posY,size,size);
    }
    
    //Line colors
    if(explored)
      stroke(0); //Full black
    else
      stroke(0,0,0,32); //A bit of transparency
    //Top
    if(border[0])
      line(posX, posY, posX + size, posY);
    //Right
    if(border[1])
      line(posX+size, posY, posX+size, posY+size);
    //Bottom
    if(border[2])
      line(posX, posY+size, posX+size, posY+size);
    //Left
    if(border[3])
      line(posX, posY, posX, posY + size);
      
  }
}
