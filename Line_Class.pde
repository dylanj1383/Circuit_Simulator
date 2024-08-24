class Line {
  //this class is used to help with calculations for wires being clicked on/placed
  
  //contains a line of the scalar form ax + by + c = 0
  //Get scalar equation from slope
  //m = (y - y1)/(x-x1)
  //mx - mx1 = y - y1
  //mx - y - mx1 + y1 = 0
  //(m)x + (-1)y + (-mx1 + y1) = 0
  //a = m; b = -1; c = -mx1 + y1;  leave as floats
  //therefore, b =-1
  // so we can say y = ax + c as well
  
  //FIELDS
  float a; //a is also the slope (since b =-1)
  float b; //should always be -1
  float c; //c is also the y-intercept (since b = -1)

  //Constructors
  Line(float m, float c){
    //creates a line with slope m and y-int c
    //y = mx + c
    //mx -y + c = 0
    this.a = m;
    this.b = -1;
    this.c = c;
  }
  
  Line (float m, PVector p){
    //creates a line with slope m passing through point p
    this.a = m;
    this.b = -1;
    this.c = -m*p.x + p.y;
  }
  
  Line(PVector p1, PVector p2){
    //creates a line passing through points p1 and p2
    float m = (p2.y - p1.y)/(p2.x - p1.x); //slope
    
    this.a = m;
    this.b = -1;
    this.c = -m*p1.x + p1.y;
  }
  
  //METHODS
  float getSlope(){ 
    return this.a;
  }
  
  PVector findPOI(Line l2){
    //returns the point of intersection of this and l2
    //B = -1 for both lines, so we can eliminate
    float x = (l2.c - this.c) / (this.a - l2.a);
    float y = this.getY(x); //sub x back into this line
    return new PVector(x, y);
  }
  
  float getY(float x){
    //ax + c = y
    return this.a*x + this.c;
  }
  
}
