class Button{
  //FIELDS
  String text, name; //have two different fields so we can change the text on a button without changing its name
  PVector center; //coordinates of the center
  float buttonWidth, buttonHeight;
  color buttonCol;
  
  
  //CONSTRUCTOR
  Button(String t, String n, PVector c, float w, float h, color col){
    this.text = t;
    this.name = n;
    this.center = c;
    this.buttonWidth = w;
    this.buttonHeight = h;
    this.buttonCol = col;
  }
  
  //METHODS
  void drawButton(){
    //Draws the button on screen with appropriate text and color
    
    //draw the back rectangle
    noStroke();
    fill(this.buttonCol);
    rect(this.center.x-this.buttonWidth/2.0, this.center.y-this.buttonHeight/2.0, buttonWidth, buttonHeight);
    
    //draw the text on top
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(this.text, this.center.x, this.center.y-2);
  }
  
  boolean isClickedByPoint(PVector p){
    //returns if a button is clicked by point p
    
    //p1 and p2 are the top-right and bottom-left corners of the button respectively
    PVector p1 = new PVector(this.center.x - this.buttonWidth/2.0, this.center.y - this.buttonHeight/2.0);
    PVector p2 = new PVector(this.center.x + this.buttonWidth/2.0, this.center.y + this.buttonHeight/2.0);
    return (p1.x <= p.x && p.x <= p2.x) && (p1.y <= p.y && p.y <= p2.y);
  }
}
