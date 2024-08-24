//LED Helper Functions ------------------------------------------------------------
PVector getLEDInPin(float x, float y, float angle){
  //return the coordinates of H from drawLED() [the cathode]
  float m = 30*sqrt(2); //4*n from drawLED()
  
  //these are taken directly from drawLED() with simplifcation of the expressions
  if (angle == 90){
    return new PVector(x, y-m);
  }
  else if (angle == 180) {
    return new PVector(x-m, y);
  }
  else if (angle == 270) {
    return new PVector(x, y+m);
  }
  else {
    return new PVector(x+m, y);
  }
}

PVector getLEDOutPin(float x, float y, float angle){
  //return the coordinates of G from drawLED() [the anode]
  float m = 30*sqrt(2); //4*n from drawLED()
  
  //these are taken directly from drawLED() with simplifcation of the expressions
  if (angle == 90){
    return new PVector(x, y+m);
  }
  else if (angle == 180) {
    return new PVector(x+m, y);
  }
  else if (angle == 270) {
    return new PVector(x, y-m);
  }
  else {
    return new PVector(x-m, y);
  }
}

boolean isPointOnLED(PVector p, PVector pos){
  //returns if p is on top of an LED at position pos
  return (dist(p.x, p.y, pos.x, pos.y) <= 22.5);
}

void drawLED(float x, float y, float angle){
  //draws the LED using critical/usefull points relative to (x,y)
  float n = 15*sqrt(2)/2;
  //define useful points
  PVector A, B, C, D, E, F, G, H; //these are critical points used to draw the parts of the led
  
  if (angle == 90){ 
    //90
    A = new PVector(x-n, y+n);
    B = new PVector(x+n, y+n);
    C = new PVector(x-n, y-n);
    D = new PVector(x+n, y-n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x, F.y+3*n);
    H = new PVector(E.x, E.y-3*n);
  }
  else if (angle == 180){
    //180
    A = new PVector(x+n, y+n);
    B = new PVector(x+n, y-n);
    C = new PVector(x-n, y+n);
    D = new PVector(x-n, y-n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x+3*n, F.y);
    H = new PVector(E.x-3*n, E.y);
  }
  else if (angle == 270){
    //270
    A = new PVector(x+n, y-n);
    B = new PVector(x-n, y-n);
    C = new PVector(x+n, y+n);
    D = new PVector(x-n, y+n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x, F.y-3*n);
    H = new PVector(E.x, E.y+3*n);
  }
  else {
    //0
    A = new PVector(x-n, y-n);
    B = new PVector(x-n, y+n);
    C = new PVector(x+n, y-n);
    D = new PVector(x+n, y+n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x-3*n, F.y);
    H = new PVector(E.x+3*n, E.y);
  }
  
  //draw the LED based on what we set A-H to be
  circle(x, y, 50);
  triangle(A.x, A.y, B.x, B.y, E.x, E.y);
  line(C.x, C.y, D.x, D.y);
  line(F.x, F.y, G.x, G.y);
  line(E.x, E.y, H.x, H.y);
}

//CELL HELPER FUNCTIONS-----------------------------------------------------------------
PVector getCELLOutPin(float x, float y, float angle){
  float n = 15; //distance between the two terminals
  float m = 30; //length of the pins on either side
  
  //taken directly from drawCELL() with simplifications to the expressions
  if (angle == 90){
    return new PVector(x, y+n/2+m);
  }
  else if(angle == 180){
    return new PVector(x+n/2+m, y);
  }
  else if(angle == 270){
    return  new PVector(x, y-n/2-m);
  }
  else {
    //0
    return new PVector(x-n/2-m, y);
  }
}

PVector getCELLInPin(float x, float y, float angle){
  //returns the coords of the input pin of the cell [Positive Terminal]
  float n = 15; //distance between the two terminals
  float m = 30; //length of the pins on either side
  
  //taken directly from drawCELL() with simplifications to the expressions
  if (angle == 90){
    return new PVector(x, y-n/2-m);
  }
  else if(angle == 180){
    return new PVector(x-n/2-m, y);
  }
  else if(angle == 270){
    return new PVector(x, y+n/2+m);
  }
  else {
    //0
    return new PVector(x+n/2+m, y);
  }
}

boolean isPointOnCELL(PVector p, PVector pos, float angle){
  //returns the coords of the output pin of the cell [Negative Terminal]
  float n = 20; //distance between the two terminals
  float h2 = 60; //height of the positive terminal
  
  //taken directly from drawCELL() with simplifications to the expressions
  if (angle == 90 || angle == 270){
    return ( (pos.x-h2/2 <= p.x && p.x <= pos.x+h2/2) && (pos.y-n <= p.y && p.y <= pos.y+n) );
  } else {
    return ( (pos.y-h2/2 <= p.y && p.y <= pos.y+h2/2) && (pos.x-n <= p.x && p.x <= pos.x+n) );
  }
}

void drawCELL(float x, float y, float angle){
  //Draws a cell using critical/useful points relative to (x, y)
  PVector A, B, C, D, E, F, G, H;
  
  float n = 15; //distance between the two terminals
  float h1 = 30; //height of the negative terminal
  float h2 = 60; //height of the positive terminal
  float m = 30; //length of the pins on either side
  
  if (angle == 90){
    A = new PVector(x-h1/2, y+n/2);
    B = new PVector(x+h1/2, y+n/2);
    C = new PVector(x-h2/2, y-n/2);
    D = new PVector(x+h2/2, y-n/2);
    E = new PVector(x, y-n/2);
    G = new PVector(x, y+n/2);
    H = new PVector(x, y+n/2+m);
    F = new PVector(x, y-n/2-m);
  }
  else if(angle == 180){
    A = new PVector(x+n/2, y+h1/2);
    B = new PVector(x+n/2, y-h1/2);
    C = new PVector(x-n/2, y+h2/2);
    D = new PVector(x-n/2, y-h2/2);
    E = new PVector(x-n/2, y);
    G = new PVector(x+n/2, y);
    H = new PVector(x+n/2+m, y);
    F = new PVector(x-n/2-m, y);
  }
  else if(angle == 270){
    A = new PVector(x+h1/2, y-n/2);
    B = new PVector(x-h1/2, y-n/2);
    C = new PVector(x+h2/2, y+n/2);
    D = new PVector(x-h2/2, y+n/2);
    E = new PVector(x, y+n/2);
    G = new PVector(x, y-n/2);
    H = new PVector(x, y-n/2-m);
    F = new PVector(x, y+n/2+m);
  }
  else {
    //0
    A = new PVector(x-n/2, y-h1/2);
    B = new PVector(x-n/2, y+h1/2);
    C = new PVector(x+n/2, y-h2/2);
    D = new PVector(x+n/2, y+h2/2);
    E = new PVector(x+n/2, y);
    G = new PVector(x-n/2, y);
    H = new PVector(x-n/2-m, y);
    F = new PVector(x+n/2+m, y);
  }
  
  //Draw the cell based on what we defined A-F to be
  line(A.x, A.y, B.x, B.y);
  line(C.x, C.y, D.x, D.y);
  line(G.x, G.y, H.x, H.y); 
  line(E.x, E.y, F.x, F.y); //H and F are the out and in pins respectively
}



//SWITCH HELPER FUNCTIONS -------------------------------------------------------------
//Switches are identical to LEDS in terms of positioning and critical points, so just use the LED functions

boolean isPointOnSWITCH(PVector p, PVector pos){
  return isPointOnLED(p, pos); //use same as for LED
}
PVector getSWITCHInPin(float x, float y, float angle){
  return getLEDInPin(x, y, angle); //just use the same as for LED
}

PVector getSWITCHOutPin(float x, float y, float angle){
  return getLEDOutPin(x, y, angle); //use same as LED
}

void drawSWITCH(float x, float y, float angle, boolean closed){
  //uses the same points E, F, G, H from drawLED
  float n = 15*sqrt(2)/2;
  PVector A, B, C, D, E, F, G, H, I;
  
  if (angle == 90){ 
    //90
    A = new PVector(x-n, y+n);
    B = new PVector(x+n, y+n);
    C = new PVector(x-n, y-n);
    D = new PVector(x+n, y-n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x, F.y+3*n);
    H = new PVector(E.x, E.y-3*n);
  }
  else if (angle == 180){
    //180
    A = new PVector(x+n, y+n);
    B = new PVector(x+n, y-n);
    C = new PVector(x-n, y+n);
    D = new PVector(x-n, y-n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x+3*n, F.y);
    H = new PVector(E.x-3*n, E.y);
  }
  else if (angle == 270){
    //270
    A = new PVector(x+n, y-n);
    B = new PVector(x-n, y-n);
    C = new PVector(x+n, y+n);
    D = new PVector(x-n, y+n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x, F.y-3*n);
    H = new PVector(E.x, E.y+3*n);
  }
  else {
    //0
    A = new PVector(x-n, y-n);
    B = new PVector(x-n, y+n);
    C = new PVector(x+n, y-n);
    D = new PVector(x+n, y+n);
    F = new PVector( (A.x+B.x)/2, (A.y+B.y)/2 );
    E = new PVector( (C.x+D.x)/2, (C.y+D.y)/2 );
    G = new PVector(F.x-3*n, F.y);
    H = new PVector(E.x+3*n, E.y);
  }
  
  //Define point I to be either E or C, depending on whether the switch is open or closed
  if (closed){
    I = E;
  }
  else{
    I  = C;
  }
  
  //Draw the switch based on what we defiend points E-I to be
  line(F.x, F.y, I.x, I.y);
  circle(I.x, I.y, n/3.0);
  line(F.x, F.y, G.x, G.y);
  line(E.x, E.y, H.x, H.y);
}
