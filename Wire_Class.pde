class Wire {
  //FIELDS
  ArrayList<PVector> segmentPoints; //the endpoints of the line segments making up this wire
  PVector previewPoint; //an additional preview point not yet part of the wire
  int thickness;
  color wireCol;
  //startNode is the node whose outPin we are connected to
  //endNode is the node whose inPin we are connected to
  Node startNode, endNode; 
  Boolean hasStartNode, hasEndNode;

  //Constructor
  Wire(PVector p, color c){
    this.segmentPoints = new ArrayList<PVector>();
    this.previewPoint = null;
    this.segmentPoints.add(p); //add the first point to the arrayList
    this.thickness = wireThickness;
    this.wireCol = c;
    this.startNode = null;
    this.endNode = null;
    this.hasStartNode = false;
    this.hasEndNode = false;
  }
  
  void addWirePoint(PVector p){
    //adds point p to the wire
    this.segmentPoints.add(p);
  }
  
  void drawWire() {
    //dont draw the wire if we don't have at least 2 poitns to make a line segment
    if (this.segmentPoints.size() < 1){
      return;
    }
    
    //draw wire's start/end points as circles (red = start, blue = end)
    strokeWeight(3);
    //red <=> startpoint (first item in segmentPoints)
    stroke(255, 0, 0);
    circle(this.segmentPoints.get(0).x, this.segmentPoints.get(0).y, 10);
    //blue <=> endpoint (last item in segmentPoints)
    stroke(0, 0, 255);
    circle(this.segmentPoints.get(this.segmentPoints.size()-1).x, this.segmentPoints.get(this.segmentPoints.size()-1).y, 10);
    
    //draw actual wire line segments
    //set stroke and thickness
    stroke(this.wireCol);
    strokeWeight(this.thickness);
    
    //the two points defining the line segment
    PVector p1;
    PVector p2;
    
    //iterate through the list of segment points, and make a line segment from this point to the next point.
    for (int i = 0; i<this.segmentPoints.size(); i++) {
      
      //draw line segments from the 2 adjacent PVectors in segmentPoints
      if (i+1 < this.segmentPoints.size()){
        p1 = this.segmentPoints.get(i);
        p2 = this.segmentPoints.get(i+1);
        line(p1.x, p1.y, p2.x, p2.y);
      }
      
      //if we are at the end of the arrayList, draw a preview point if applicable
      else if (this.previewPoint != null){
        p1 = this.segmentPoints.get(i);
        p2 = this.previewPoint;
        line(p1.x, p1.y, p2.x, p2.y);
      }
    }
  }
  
  boolean hasAtLeast2Points(){
    //returns whether a line is drawable (has at least 2 points)
    if (this.segmentPoints.size() >= 2){
      return true;
    }
    return false;
  }
  
  boolean isPointOnWire(PVector p) {
    //returns whether p is on the wire
    //uses a surprising amount of math to figure it out
    
    //we will iterate through all the line segments defined by segmentpoints
    //for each line segment AB, see if p is on AB
    for (int i = 0; i<this.segmentPoints.size() - 1; i++){
      //First, we will find the distance from p to the infinitely extending line through AB.
      
      //We need to find out if this distance is also the distance to the line segment AB.
      //Let l2 be the intersection of the line perpendicular to AB passing through p
      //let POI be the intersection of l2 and the line through AB
      //if POI is between A and B, then the distance we calculated is also the distance to the line segment
      
      float d; //the distance from the p to this line segment
      PVector POI; //the point of intersection from a perpendicular line through p and the line AB
      
      PVector A = this.segmentPoints.get(i);
      PVector B = this.segmentPoints.get(i+1); //A, B are the endpoints of this line segment
      
      //deal with the cases for the slope of AB
      // 0 < m 
      // m = 0
      // m is undefined
      
      //check for a defined slope of AB
      if (A.x - B.x != 0) {
        //AB has a defined slope (but could be 0)
        Line l1 = new Line(A, B); //use the line object constructor to create a line through this line segment
        
        //If Neither l2 nor l1 have an undefined slope, we can make use of the Line class to find the POI
        if (l1.getSlope() !=  0) {
          Line l2 = new Line(  -1 / l1.getSlope()  , p); //the line perpendicular to this line segment passing through p
          POI = l1.findPOI(l2); //intersection of the two lines
        } 
        //l2 has an undefined slope
        else {
          //AB is a horizontal line segment. l2 has a vertical line
          POI = new PVector(p.x, A.y);
        }
      } 
      
      //l2 is horizontal; AB is a vertical line
      else {
        POI = new PVector(A.x, p.y);
      }
      
      //We have found the POI
      //check if POI is between A and B (if POI is within the line segment, not the infinitely extending line)
      //check this by seeing if dist(A, POI) + dist(POI, B) = dist(A, B)
      if ( round(dist(A.x, A.y, POI.x, POI.y) + dist(POI.x, POI.y, B.x, B.y) - dist(A.x, A.y, B.x, B.y)) == 0) {
        //POI is between the lines. 
        d = dist(p.x, p.y, POI.x, POI.y);
      }
      else {
        //POI is not between the lines
        //The distance from p to the line segment is the minimum distance to A or B
        d = min(dist(p.x, p.y, A.x, A.y), dist(p.x, p.y, B.x, B.y));
      }
      
      //Now that we finally know the distance, see if p is within 4 pixels of the wire
      if (d <= this.thickness + 4){
        return true;
      }
    }
    
    return false; //return false if the distance is too large
  }
  
  
  boolean isPointOnWireEnd(PVector p){
    //checks if p is close enough to the endPoint of this wire
    PVector lastPoint = this.segmentPoints.get(this.segmentPoints.size()-1);
    return (dist(p.x, p.y, lastPoint.x, lastPoint.y) <= snapDistance);
  }
  
  
  void removeStartNodePointer(){
    //removes the pointers to the starting node of this wire
    this.hasStartNode = false;
    if (this.startNode == null){
      return; //avoid null errors
    }
    this.startNode.hasOutWire = false;
    this.startNode.outWire = null;
  }
  
  void removeEndNodePointer(){
    //remove the pointers to the ending node of this wire
    this.hasEndNode = false;
    if (this.endNode == null){
      return; //avoid null errors
    }
    this.endNode.hasInWire = false;
    this.endNode.inWire = null;
  }
  
  boolean isFinished(){
    //a wire is only finished if it has a startNode pointer and and EndNode pointer
    return (this.hasStartNode && this.hasEndNode);
  }
  
  boolean lastPointHasNode(){
    return this.hasEndNode;
  }
}
