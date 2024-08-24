//KEYBOARD SHOARTCUTS
/***
g => GO/STOP; run/stop circuit 
w => new wire 
n => return to neutral
l => new LED
s => new Switch
r => rotate a selected node 
backspace/delete => delete currently selected item
***/

void mousePressed() {
  Button b = menu.anyButtonClicked(); //the button that we have clicked on (null if not clicked on anything)
  
  //Running is the first priority
  if (b!= null && b.name.equals("Run Button")){
    menu.runButtonClicked();
  }
  
  //Only if we are running the circuit, check for toggling switches
  if(mouseMode.equals("Run")){
    Node n = circuit.anyNodeClickedOn(); //the node that is clicked on (null if nothing clicked on)
    if (n!=null && n.type.equals("SWITCH")){
      n.isClosed = !n.isClosed; //turn on to off or vice versa
    }
  }
  
  //only run the rest of these commands if the circuit isn't currently run
  else{ 
    ///deal with buttons
    if (b!=null && b.name.equals("Wire Button")){
      menu.wireButtonClicked();
    }
    else if (b!=null && b.name.equals("LED Button")){
      menu.ledButtonClicked();
    }
    else if (b!=null && b.name.equals("Switch Button")){
      menu.switchButtonClicked();
    }
    else if (b!= null && b.name.equals("Rotate Button")){
      circuit.rotateNode(circuit.currentNode);
    }
    else if (b!= null && b.name.equals("Delete Button")){
      menu.deleteButtonClicked();
    }
    
    //don't run the rest of the code if our mouse is in the menu zone
    if(menu.isPointOverMenu(new PVector(mouseX, mouseY))){
      return;
    }
    
    //check for selecting new circuit components
    else if (mouseMode.equals("None")){
      //check for selecting a new wire or node
      Wire w = circuit.anyWireClickedOn();
      Node n = circuit.anyNodeClickedOn();
      if (w != null) {
        circuit.selectWire(w); //select any wire that is clicked
      } 
      else if(n != null) {
        circuit.selectNode(n); //select any node that is clicked
      }
      else {
        deselectAllComponents(); //we clicked in empty space. Deselect all
      }
      
      //check for changing one of the points on the selected wire at the end
      if (circuit.currentWire != null && circuit.currentWire.isPointOnWireEnd(new PVector(mouseX, mouseY)) && !circuit.currentWire.lastPointHasNode()){
        mouseMode = "Adding To Wire";
      }
    }
    
    //check for placing a new wire or adding to a wire
    else if (mouseMode.equals("New Wire")){
      if (circuit.placeWireIfPossible()){
        mouseMode = "Adding To Wire";
      }
    }
    else if (mouseMode.equals("Adding To Wire")){
      if (circuit.finishWireIfPossible()){
        stopMakingNewComponents();
        deselectAllComponents();
        mouseMode = "None";
      }
    }
    
    //check for placing a node
    else if (mouseMode.equals("New Node")){
      deselectAllComponents();
      mouseMode = "None";
    }
  }
}

void mouseDragged(){
  //only use of this is for dragging nodes
  if (mouseMode.equals("None") && circuit.currentNode!=null){
    mouseMode = "New Node";
    wasJustDragging = true;
  }
}

void mouseReleased(){
  //when we stop dragging a node, place it if possible
  if (!mouseMode.equals("Run") && wasJustDragging && !menu.isPointOverMenu(new PVector(mouseX, mouseY))){
    menu.noButtonClicked();
    wasJustDragging = false;
  }
}


void keyPressed() {
  //same thing as the buttons, but with keyboard shortcuts
  
  if (key == 'g'){ //equivalent to Run Button
    menu.runButtonClicked();
  }
  
  if (! mouseMode.equals("Run")){ //Equivalent to unclicking a button
    if (key == 'n' || key == ENTER){
      menu.noButtonClicked();
    }
    else if (key == 'w') { //equivalent to Wire Button
      menu.wireButtonClicked();
    }
    else if (key == 'l'){ //equivalent to LED Button
      menu.ledButtonClicked();
    }
    else if (key == 's'){ //equivalent to Switch Button
      menu.switchButtonClicked();
    }
    else if (key == 'r'){ //equivalent to Rotate Button
      circuit.rotateNode(circuit.currentNode);
    }
    else if ((key == DELETE || key == BACKSPACE)) { //Equivalent to Delete Button
      menu.deleteButtonClicked();
    }
  }
}




void stopMakingNewComponents(){
  //stops making new components (e.g. if adding to wire, stop showing preview)
  if (mouseMode.equals("Adding To Wire")){
    circuit.currentWire.previewPoint = null;
    circuit.currentWire.wireCol = regularCol;
    if(! circuit.currentWire.hasAtLeast2Points()){
      circuit.removeWire(circuit.currentWire);
    }
  }
}

void deselectAllComponents(){
  //deselect both the current wire or the current node (or whichever is applicable)
  circuit.deselectWire(circuit.currentWire);
  circuit.deselectNode(circuit.currentNode);
}
