class Circuit {
  //FIELDS
  ArrayList<Node> allNodes; //allNodes.get(0) contains the power source node
  ArrayList<Wire> allWires;
  
  Wire currentWire; //the wire we are currently editing
  Node currentNode; //the node we are currently editing
  //currentWire and currentNode are set to null if we aren't editing anything
  
  
  //CONSTRUCTOR
  Circuit() {
    //initialize the arrayLists and set currentWire/currentNode to null
    this.allNodes = new ArrayList<Node>();
    this.allWires = new ArrayList<Wire>();
    
    this.currentWire = null;
    this.currentNode = null;
  }
  
  
  //METHODS
  void drawCircuit() {
    //itertates through and draws all the elements of the circuit
    for (Wire w : this.allWires){
      w.drawWire();
    }
    for (Node n : this.allNodes){
      n.drawNode();
    }
  }
  
  void runCircuit(){
    //goes through the circuit's connections and sees whether it will run
    
    //We will start at the battery and work our way through the circuit as if we were an electron
    Node thisNode = this.allNodes.get(0); //contains the node that the electron is currently on. Start off at the battery.
    boolean reachedBattery = false; //keeps track of if we made it back to the battery
    ArrayList<Node> poweredNodes = new ArrayList<Node>(); //keeps track of which nodes our electron has powered
    
    
    //keep on moving from node --> wire --> node --> wire, etc. until we reach a dead end or the battery
    while (true){ //we will exit the loop with breaks
    
      //check if the node we are on has a wire going out of it
      //and if there is a node at the other end of that wire
      if (thisNode.hasOutWire && thisNode.outWire.hasEndNode){
        
        //update thisNode to the node at the other end of the wire
        thisNode = thisNode.outWire.endNode;
        
        //if we have made it back to the battery, the circuit is complete
        if(thisNode == this.allNodes.get(0)){
          reachedBattery = true; //update this to true and then break the loop
          break;
        }
        
        //if the node we are on right now is an LED, give it power
        else if (thisNode.type.equals("LED")){
          poweredNodes.add(thisNode);
        }
        
        //if the node we are on right now is a switch, check if it is open or closed
        else if (thisNode.type.equals("SWITCH")){
          //if the switch isn't closed, it's a dead end => break
          //if not, just keep going to the next round of the loop
          if (!thisNode.isClosed){
            break;
          }
        }
      }
      else{
        //there is no wire going out of this node
        //or there is no node at the other end of the wire
        //regardless it is a dead end, so exit the loop
        break;
      }
    }
    //we have now gone through the circuit. We exited the loop for one of 3 reasons:
    // a), we reached a dead end (incomplete circuit)
    // b), we made it back to the battery without powering any loads (short circuit)
    // c), we made it back to the battery after power at least 1 load
    
    //now we can set values in the circuit appropriately
    
    //Case a)
    if (!reachedBattery){
      //set the battery to be regular color (no short circuit)
      this.allNodes.get(0).nodeCol = regularCol;
      //don't power anything in the circuit
      this.stopCircuit();
    }
    
    //Case b)
    else if (poweredNodes.size() == 0 && reachedBattery){
      this.allNodes.get(0).nodeCol = errorCol; //change battery to red
    }
    
    //Case c)
    else if (poweredNodes.size() > 0 && reachedBattery){
      //calculate the amount of power each led gets 
      //(consant current, voltage is shared => power is shared in a series circuit);
      //we add 40 so there is a minimum brightness of 40 regardless of how many LEDs are connected
      float eachLEDBrightness = 60/poweredNodes.size() + 40; //calculate the amount of power each led gets 
      
      //set the battery to be regular color (no short circuit)
      this.allNodes.get(0).nodeCol = regularCol;
      
      //for each LED that is powered, set it's brightness 
      for (Node n : poweredNodes){
        n.brightness = eachLEDBrightness;
      }
    }
  }
  
  void stopCircuit(){
    //stop the circuit by turning everything off 
    //also the battery from being red
    for (Node n : this.allNodes){
      n.brightness = 0;
      n.nodeCol = regularCol;
    }
  }
  
  void openAllSwitches(){
    //reset the states of all the switches (called when we press stop)
    for (Node n : this.allNodes){
      n.isClosed = false;
    }
  }
  
  
  void addWireToCircuit(Wire w, Node n) {
    //adds a wire to the circuit (adds to to allWires)
    //also must handle the appropriate pointers (startNode)
    
    //if the node we are pointing to is n, return (a wire must start at a node)
    if (n == null){
      return;
    }
    
    //set all the pointers in both directions
    w.startNode = n;
    w.hasStartNode = true;
    n.outWire = w;
    n.hasOutWire = true;
    
    //after pointers are added, add w to allWires and select it
    this.allWires.add(w);
    this.selectWire(w);
  }
  
  void removeWire(Wire w) {
    //removes a wire from allWires and destroyes any pointers that existed
    
    //make sure we are trying to delete the correct wire
    if (this.currentWire == w && w!=null) { 
      
      //remove any pointers this wire has
      w.removeStartNodePointer();
      w.removeEndNodePointer();
      //then remove it from allWires
      this.allWires.remove(w);
    }
    
    //deselect the wire we just deleted
    this.currentWire = null;
  }
  
  boolean finishWire(Wire w, Node n){
    //a wire can only be finished if it ends at a node. If not, it is considered unfinished
    //this method finishes the wire if possible and returns if we were able to finish it as a boolean
    
    //return if either of the wire or it's node are not initialized
    if (n==null || w==null){
      return false;
    }
    
    //if the wire doesn't have an ending node, we can finish the wire
    if (!w.hasEndNode && w.hasStartNode){
      //set the appropriate pointers to finish the wire
      w.endNode = n;
      w.hasEndNode = true;
      n.inWire = w;
      n.hasInWire = true;
      //return true because we were able to finish the wire
      return true;
    }
    
    //if we haven't returned yet, we couldn't finish the wire
    return false;
  }
  
  
  void addNodeToCircuit(Node n) {
    //adds n to the circuit (allnodes)
    //we don't have to deal with pointers here - that's dealt with whe we add/remove wires
    this.allNodes.add(n);
    this.selectNode(n);
  }
  
  void removeNode(Node n) {
    //removes n from the circuit
    
    if (this.currentNode == this.allNodes.get(0)){
      return; //we don't want to do anything to the circuits power source
    }
    
    //make sure we are deleting the right node 
    if (this.currentNode == n && n!=null) {
      
      //if there is a wire that is rooted on this node, delete that as well
      if (n.hasOutWire){
        this.selectWire(n.outWire);
        this.removeWire(n.outWire);
      }
      
      //reset any pointers to this node
      n.removeInWirePointer();
      n.removeOutWirePointer();
      
      //once we remove pointers, we can remove n
      this.allNodes.remove(n);
    }
    
    //deselect the node we just deleted
    this.currentNode = null;
  }
  
  void rotateNode(Node n) {
    //rotates a node 90 degrees counterclockwise
    if (this.currentNode == n && n!=null) {
      n.rotate90();
    }
  }
  
  void selectWire (Wire w) {
    //deselect any previous wire or node that was selected:
    this.deselectWire(this.currentWire);
    this.deselectNode(this.currentNode);
    
    //now select a new wire
    this.currentWire = w;
    w.wireCol = selectedCol;
  }
  
  void deselectWire (Wire w) {
    //set currentWire to null and reset the color to default
    this.currentWire = null;
    if (w != null){
      w.wireCol = regularCol;
    }
  }
  
  void selectNode (Node n) {
    //deselect any previous node or wire that was selected
    this.deselectNode(this.currentNode);
    this.deselectWire(this.currentWire);
    
    //now select a new node
    this.currentNode = n;
    n.nodeCol = selectedCol;
  }
  
  void deselectNode (Node n) {
    //set curretnNode to null and reset the color to default
    this.currentNode = null;
    if (n != null){
      n.nodeCol = regularCol;
    }
  }
  
  Wire anyWireClickedOn() {
    //goes throught the wires in the circuit and sees if any of them are clicked on
    //returns the wire that is clicked on. If nothing is clicked on it returns null
    
    for (Wire w : this.allWires){
      //iterate through each wire and see if the mouse coordinates are above the wire
      if ( w.isPointOnWire(new PVector(mouseX, mouseY)) ){
        return w;
      }
    }
    return null; //return null if we haven't returned a wire
  }
  
  
  Node anyNodeClickedOn() {
    //goes through the nodes in the circuit and sees if any of them are clicked on
    //returns the node that is clicked on. Returns null if nothing is clicked.
    for (Node n : this.allNodes){
      //iterate through each node and see if the mouse coords are above the node
      if (n.isPointOnNode(new PVector(mouseX, mouseY)) ){
        return n;
      }
    }
    return null; //return null if we didn't return a node
  }
  
  
  Node snapMouseToPoints() {
    //checks if the current wire we are making should snap to any of the pins of any of the nodes
    //returns the node we snapped to as well. Returns null if we didn't snap to anything.
    
    PVector targetCoords; //the place we are snapping to
    
    //iterate through every node in the circuit
    for (Node n : this.allNodes){
      
      //check for the inpin of this node
      if (n.isPointOnInPin(new PVector(mouseX, mouseY))){
        //snap mouse to the coordinates of the inpin
        targetCoords = n.getInPinCoords();
        //move the mouse to its target for this frame
        mouseX = int(targetCoords.x);
        mouseY = int(targetCoords.y);
        return n; //return the node we snapped to
      }
      
      //check for snapping to the outpin of this node
      else if (n.isPointOnOutPin(new PVector(mouseX, mouseY))){
        //snap mouse to the coordinates of the outpin
        targetCoords = n.getOutPinCoords();
        //move the mouse to its target for this frame
        mouseX = int(targetCoords.x);
        mouseY = int(targetCoords.y);
        return n; //return the node we snapped to
      }
    }
    
    return null; //return null if we didn't snap to anything
  }
  
  boolean placeWireIfPossible(){
    //places a wire if possible. Returns whether or not we could place the wire
    
    //to begin making a new wire, the following conditions must be met:
    //a) we must be connected to a node (our mouse should be snapped there)
    //b) the node pin we are connecting to must NOT have another wire connected to it already
    
    Node snappingNode = snapMouseToPoints(); //this will store the node that we have snapped to, if it exists
    
    //check for condition a)
    if (snappingNode == null){ 
      //condition a) is not satisfied
      println("Cannot make a new wire here. Wires must be anchored to a component. Please connect to the appropriate pin of a component");
      return false; 
    }
    
    
    //condition a is satisfied
    //check for condition b)
    PVector snapPoint = new PVector(mouseX, mouseY);
    
    //check if we are snapping to the outpin of the node
    if (snappingNode.isPointOnOutPin(snapPoint)){
      //check that there aren't wires connected here already
      if (snappingNode.outWire == null){
        
        //condition b is now satisfied - place the wire and make appropriate pointers
        this.addWireToCircuit(new Wire(new PVector(mouseX, mouseY), selectedCol), snappingNode);
        snappingNode.outWire = this.currentWire;
        snappingNode.hasOutWire = true;
        this.currentWire.startNode = snappingNode;
        this.currentWire.hasStartNode = true;
        
        return true; //we were able to place the wire
      } 
      else {
        println("A new wire cannot be created here as there is already a wire connected.");
        return false;
      }
      
    }
    else {
      println("A wire cannot be created here. Please create wires in the same direction that electrons will flow");
      println("Wires must be created starting at the negative terminal of a battery or at the anode of an LED");
      return false;
    }
  }
  
  boolean finishWireIfPossible(){
    //finishes a wire if possible. Returns whether or not we could place the wire
    
    //check if we are snaped to a node
    Node snappingNode = snapMouseToPoints();
    
    if (snappingNode == null){ 
      this.currentWire.addWirePoint(circuit.currentWire.previewPoint);
      return false; //dont finish the wire - there is no node for it to finish on
    } 
    //we are trying to snap to some node (snappingNode) - either we put down a point and finish the wire OR we don't put down a point and dont finish the wire


    //make sure we aren't snapping to the same node this wire started on
    if (this.currentWire.startNode == snappingNode || this.currentWire.endNode == snappingNode){
      //we dont want to add a wire point if the node we are connecting to is the same node as the one we started
      println("A wire cannot connect a component to itself");
      return false; // we can't even place a point, let alone finish the wire
    }
    
    PVector snapPoint = new PVector(mouseX, mouseY); //the coords of the point we snapped to
    
    //make sure we are snapping to an eligible pin (must be the inpin of snappingNode)
    if (snappingNode.isPointOnInPin(snapPoint)){
      
      //make sure we don't snap to a pin with a wire connected already
      if (!snappingNode.hasInWire){ 
        //we can add the point here and finish the wire
        this.currentWire.addWirePoint(circuit.currentWire.previewPoint);
        this.finishWire(this.currentWire, snappingNode);
        return true; //we were able to finish the wire
      } 
      else {
        //the inpin of the node we are snapping to has a wire connected already
        println("A wire cannot have an endpoint here. There is already a wire at this pin");
        return false; //we cannot make a new point here as this pin is already connected to a wire
      }
    }
    else {
      //We are snapping to an ineligible point
      println("A wire cannot have an endpoint here. Wires must be created in the same direction electrons flow");
      return false;
    }
  }
}
