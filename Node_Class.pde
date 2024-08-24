class Node {
  //FIELDS
  String type; //"LED", "CELL", or "SWITCH"
  float angleOfRotation; //0, 90, 180, 270
  PVector pos; //coords on screen
  int thickness; //thickness of the lines used to draw it
  color nodeCol;
  Wire inWire, outWire; //the wire pointers for this node
  boolean hasInWire, hasOutWire;
  float brightness; //0-100, only used for LED
  boolean isClosed; //only used for SWITCH
  
  //CONSTRUCTORS
  Node (String t, PVector p, color c) {
    this.angleOfRotation = 0;
    this.pos = p;
    this.thickness = nodeThickness;
    this.nodeCol = c;
    this.type = t;
    this.inWire = null;
    this.outWire = null;
    this.hasInWire = false;
    this.hasOutWire = false;
    this.brightness = 0;
    this.isClosed = false;
  }

  
  //METHODS
  void drawNode() {
    //draw the glowing of the led (skip for battery/switch)
    if (this.type.equals("LED") && this.brightness > 0){
      //make use of the alpha channel (transparancy) instead of just rgb
      noStroke();
      float d = this.brightness;
      for(float alpha = 0; alpha <= 255; alpha += 0.3){
        fill(LEDCol, alpha);
        circle(this.pos.x, this.pos.y, d);
        d--;
        if (d<=1){
          break;
        }
      }
      fill(LEDCol, 255); //add at least 1 circle with full opacity
      circle(this.pos.x, this.pos.y, d);
    }
    
    
    //draw the actual component 
    
    //set color, thickness, stroke
    noFill();
    stroke(this.nodeCol);
    strokeWeight(this.thickness);
    
    //use the helper functions to draw the LED, CELL or SWITCH
    if (this.type.equals("LED")){
      drawLED(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    else if (this.type.equals("CELL")){
      drawCELL(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    else if (this.type.equals("SWITCH")){
      fill(this.nodeCol);
      drawSWITCH(this.pos.x, this.pos.y, this.angleOfRotation, this.isClosed);
    }
    
    
    //draw places the user can connect a wire (eligible snap points)
    if (showEligibleSnapPoints){
      //set fill and stroke
      noFill();
      stroke(eligibileCol);
      
      //p is the location of the eligible snap point for this node
      PVector p;
      
      //if we are creating a new wire, a point is only eligible if 
      // a) there is no wire taking up the pin, and b) we aren't connect the two ends of the same component
      if (mouseMode.equals("New Wire") && !this.hasOutWire && !(this.hasInWire && this.inWire == circuit.currentWire)){
        p = this.getOutPinCoords();
        circle(p.x, p.y, snapDistance/2); //draw the circle at the snap point
      }
      
      //with similar logic, to finish a wire, a point is only eligible if
      // a)  there is no wire taking up the pin, and b)we aren't connecting the two ends of the same component
      else if (mouseMode.equals("Adding To Wire") && !this.hasInWire && !(this.hasOutWire && this.outWire == circuit.currentWire)){
        p = this.getInPinCoords();
        circle(p.x, p.y, snapDistance/2); //draw the circle at the snap point
      }
    }
    
    
  }
  
  void rotate90() {
    //rotates a node by 90 degrees counter clockwise
    //doesn't rotate if there are wires tethered to this component
    
    if (!this.hasInWire && !this.hasOutWire){
      this.angleOfRotation = (this.angleOfRotation+90)%360;
    }
    else{
      println("Cannot rotate this component as there are wires connected to it. Please delete the connected wires before continuing");
    }
  }
  
  boolean isPointOnNode(PVector p) {
    //returns if p is over the node (e.g. it would be clicked on by the mouse)
    
    //use the helper functions to do this for LED, CELL, SWITCH
    if (this.type.equals("LED")){
      return isPointOnLED(p, this.pos);
    }
    else if (this.type.equals("CELL")){
      return isPointOnCELL(p, this.pos, this.angleOfRotation);
    }
    else if (this.type.equals("SWITCH")){
      return isPointOnSWITCH(p, this.pos);
    }
    
    return false; //return a boolean if none of the above is satisfied
  }
  
  PVector getInPinCoords() {
    //gets the coordinates of the inpin to this node using the helper functions
    if (this.type.equals("LED")){
      return getLEDInPin(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    else if (this.type.equals("CELL")){
      return getCELLInPin(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    else if (this.type.equals("SWITCH")){
      return getSWITCHInPin(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    
    return null; //return a null PVector object if none of the above is satisfied
  }
  
  PVector getOutPinCoords() {
    //get the coordinates of the outpin to this node using the helper functions
    if (this.type.equals("LED")){
      return getLEDOutPin(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    else if (this.type.equals("CELL")){
      return getCELLOutPin(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    else if (this.type.equals("SWITCH")){
      return getSWITCHOutPin(this.pos.x, this.pos.y, this.angleOfRotation);
    }
    
    return null; //return a null PVector object if none of the above is satisfied
  }
  
  
  boolean isPointOnInPin(PVector p){
    //Returns whether point p is close enough to the inPin of this node (within snapDistance)
    PVector inPin = this.getInPinCoords();
    return (dist(p.x, p.y, inPin.x, inPin.y) <= snapDistance);
  }
  
  boolean isPointOnOutPin(PVector p){
    //Returns whether point p is close enough to the outPin of this node (within snapDistance)
    PVector outPin = this.getOutPinCoords();
    return (dist(p.x, p.y, outPin.x, outPin.y) <= snapDistance);
  }
  
  void removeInWirePointer(){
    //removes the pointer with the inwire of this node
    this.hasInWire = false;
    if (this.inWire != null){ //prevent null errors
      this.inWire.hasEndNode = false;
      this.inWire.endNode = null;
    }
  }
  
  void removeOutWirePointer(){
    //removes the pointerw ith the outWire of this node
    this.hasOutWire = false;
    if (this.outWire != null){ //prevent null errors
      this.outWire.hasStartNode = false;
      this.outWire.startNode = null;
    }
  }
  
}
