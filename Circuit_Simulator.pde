/*
~Series Circuit Simulator~

Instructions (should be fairly intuitive with the buttons on screen):

A power source for the circuit is already given.

Click on the buttons on screen or use keyboard shortcuts to place LEDs, and switches

Once you have placed a component, you can rotate, drag, or delete it with the buttons on screen or keyboard shortcuts

Connect the components with wires by using the button or pressing 'w'. 
- Click to place a new wire point
- Eligible points for wire connections are shown with green circles on the components.
- You must start a wire at an eligible point but you can leave the other end free if you wish
- You can add to a wire by clicking on the free endpoint and placing more points
- Wires will snap to components

Once you have built your circuit, click the Run Button
- You cannot edit your circuit while it is running
- You can click on switches to toggle them on or off while the circuit runs
- If you create a short circuit, the battery will turn red
- LEDs will glow with appropriate brightness based on how you have wired your circuit
- Press stop to make changes to your circuit.

*/


//Parameters - change these as you wish
color selectedCol = color(255, 255, 0); //color of a selected object
color regularCol = color(190); //color of a placed object
color errorCol = color(255, 0, 0); //color for battery when there is short
color eligibileCol = color(0, 255, 0); //color of eligible wire connection places
color runCol = color(1, 80, 32); //color of the RUN button
color stopCol = color(150, 0, 0); //color of the STOP button
color regButtonCol = color(0, 0, 150); //color of all other buttons
color selectButtonCol = color(200, 0, 100); //color of all other buttons when activated

color LEDCol = color(0, 255, 255); //change this to whatever you'd like for LEDs to glow
int wireThickness = 5;
int nodeThickness = 2;
float snapDistance = 20; //distance for wire snapping
boolean showEligibleSnapPoints = true;


//Global Variables
String mouseMode;
boolean wasJustDragging;
Circuit circuit;
Menu menu;

void setup() {
  size(1000, 700); //set up screen
  
  //initialize mouse controls
  mouseMode = "None";
  wasJustDragging = false;
  
  //create a new circuit object for the program
  circuit = new Circuit();
  //add the battery to the circuit by default
  circuit.addNodeToCircuit(new Node("CELL", new PVector(5*width/6.0, height/2), selectedCol)); 
  circuit.rotateNode(circuit.allNodes.get(0)); //rotate the battery so it is positioned nicely
  circuit.deselectNode(circuit.currentNode); //stop editing this battery
  
  //create a new menu object for the program
  menu = new Menu();
  //Add appropriate buttons at appropriate locations
  menu.addButton( new Button("Run", "Run Button", new PVector(width/12.0, height/2.0-160), 80, 40, runCol) );
  menu.addButton( new Button("Wire", "Wire Button", new PVector(width/12.0, height/2.0-85), 100, 40, regButtonCol) );
  menu.addButton( new Button("LED", "LED Button", new PVector(width/12.0, height/2.0-10), 100, 40, regButtonCol) );
  menu.addButton( new Button("Switch", "Switch Button", new PVector(width/12.0, height/2.0+65), 100, 40, regButtonCol) );
  menu.addButton( new Button("Rotate", "Rotate Button", new PVector(width/12.0, height/2.0+140), 100, 40, regButtonCol) );
  menu.addButton( new Button("Delete", "Delete Button", new PVector(width/12.0, height/2.0+215), 100, 40, regButtonCol) );
}


void draw() {
  background(0);
  
  //deal with adding to a new wire
  if (mouseMode.equals("Adding To Wire")){
    circuit.snapMouseToPoints(); //do wire snapping
    //have a previewPoint on the wire so the user can see they are making a wire
    circuit.currentWire.previewPoint = new PVector(mouseX, mouseY); 
  }
  
  //deal with moving around a node. Make sure the node we are moving doesn't have wires attached to it.
  else if (mouseMode.equals("New Node") && !circuit.currentNode.hasInWire && !circuit.currentNode.hasOutWire){
    //preview the location of the node as the user moves their mouse around
    circuit.currentNode.pos = new PVector(mouseX, mouseY);
  }
  
  //deal with running the circuit
  else if (mouseMode.equals("Run")){
    circuit.runCircuit();
  }
  
  //draw circuit and menu
  circuit.drawCircuit();
  menu.drawMenu();
}
