class Menu{
  //FIELDS
  ArrayList<Button> allButtons;
  
  //CONSTRUCTOR
  Menu(){
    allButtons = new ArrayList<Button>();
  }
  
  //METHODS
  void drawMenu(){
    //draws the menu and all its buttons on screen
    
    //highlight the appropriate button
    this.deselectAllButtons(); //first deselect everything, then select based on mouseMode
    if (mouseMode.equals("New Wire") || mouseMode.equals("Adding To Wire")){
      this.allButtons.get(1).buttonCol = selectButtonCol;
    }
    else if (circuit.currentNode!=null && circuit.currentNode.type.equals("LED")){
      this.allButtons.get(2).buttonCol = selectButtonCol;
    }
    else if (circuit.currentNode!=null && circuit.currentNode.type.equals("SWITCH")){
      this.allButtons.get(3).buttonCol = selectButtonCol;
    }
   
   //draw divding line between menu and rest of screen
    strokeWeight(2);
    stroke(255);
    line(width/6.0, 0, width/6.0, height);
    
    //drwa all the buttons
    for (Button b : allButtons){
      b.drawButton();
    }
  }
  
  
  void addButton(Button b){
    //add a button to the menu
    this.allButtons.add(b);
  }
  
  Button anyButtonClicked(){
    //checks if any button is clicked on by the mouse coordinates
    //return the button that is clicked on. Returns null if nothing is clicked on.
    for (Button b : allButtons){
      if (b.isClickedByPoint(new PVector(mouseX, mouseY))){
        return b; 
      }
    }
    return null; //return null if nothing has been returned
  }
  
  
  boolean isPointOverMenu(PVector p){
    //returns if p is over the menu (used to make sure we don't draw nodes or wires in the menu region)
    return ((0 <= p.x && p.x <= width/6.0) && (0 <= p.y && p.y <= height));
  }
  
  void runButtonClicked(){
    //what to do whenever the user presses run
    stopMakingNewComponents();
    deselectAllComponents();
    
    //if we previously were set to Run, we should stop the circuit
    if (mouseMode.equals("Run")){
      circuit.stopCircuit();
      circuit.openAllSwitches(); //reset the state of all switches when we stop
      mouseMode = "None";
      //Reset the button back to "Run" and Green.
      this.allButtons.get(0).text = "Run"; 
      this.allButtons.get(0).buttonCol = runCol;
    }
    
    //we previously were not running, so we should run the circuit
    else{
      mouseMode = "Run";
      //Change the button from saying "Run" to saying "Stop". Change col to red as well.
      this.allButtons.get(0).text = "Stop";
      this.allButtons.get(0).buttonCol = stopCol;
    }
  }
  
  void deselectAllButtons(){
    //resets the color of all buttons to default, except for Run Button
    for (Button b : this.allButtons){
      if (!b.name.equals("Run Button")){
        b.buttonCol = regButtonCol;
      }
    }
  }
  
  void wireButtonClicked(){
    //what to do when the user presses the New Wire button
    
    //if we previously were making a node, delete it as we have changed modes
    if (circuit.currentNode != null && this.isPointOverMenu(circuit.currentNode.pos)){
      circuit.removeNode(circuit.currentNode);
    }
    
    //if we previously were making a wire, stop making the wire and deselect
    if (mouseMode.equals("New Wire") || mouseMode.equals("Adding To Wire")){
      this.noButtonClicked(); //run the command for nothing clicked
      return;
    }
    
    //here, we can actually start to make a new wire
    stopMakingNewComponents();
    deselectAllComponents();
    mouseMode = "New Wire";
  }
  
  void ledButtonClicked(){
    //what to do when the user presses the LED button
    
    //if we previously were making a node, delete it as we have changed modes
    if (mouseMode.equals("New Node")){
      circuit.removeNode(circuit.currentNode);
      this.noButtonClicked(); //run the command for nothing clicked
      return;
    }
    
    //here, we can actually start to make a new LED
    stopMakingNewComponents();
    deselectAllComponents();
    mouseMode = "New Node";
    circuit.addNodeToCircuit( new Node("LED", new PVector(mouseX, mouseY), selectedCol));
  }
  
  void switchButtonClicked(){
    //what to do if the user presses the new Switch button
    
    //if we previously were making a node, delete it as we have changed modes
    if (mouseMode.equals("New Node")){
      circuit.removeNode(circuit.currentNode);
      this.noButtonClicked(); //deselect node if it is already pressed
      return;
    }
    
    //here, we can actually start to make a new LED
    stopMakingNewComponents();
    deselectAllComponents();
    mouseMode = "New Node";
    circuit.addNodeToCircuit( new Node("SWITCH", new PVector(mouseX, mouseY), selectedCol));
  }
  
  void noButtonClicked(){
    //what to do when no button is clicked
    //i.e. return your mouseMode to None
    
    stopMakingNewComponents();
    deselectAllComponents();
    mouseMode = "None";
  }
  
  void deleteButtonClicked(){
    //what to do when delete button is clicked
    //remove the currentWire and currentNode (whatever is selected) from the circuit
    circuit.removeWire(circuit.currentWire);
    circuit.removeNode(circuit.currentNode);
    mouseMode = "None";
  }
}
