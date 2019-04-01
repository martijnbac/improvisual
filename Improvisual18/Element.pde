
class Element {
  float startY, gridX, gridY, startS, margin, velocity, pitch, elementSize, offset, gridWidth, rowWidth;
  float easing = 0.1;
  float rowOffset = 0;
  int rows = 1;
  String type;

  Element(String typeTemp, float velocityTemp, float pitchTemp) {
    velocity = velocityTemp;
    type = typeTemp;
    pitch = pitchTemp;

    // (max) width and height of every element in the grid
    rowWidth = width/20;
    //rowHeight = rowWidth*3;

    // margin around the grid
    margin = parseInt(rowWidth);

    // grid width
    gridWidth = width - (margin*2);

    // every element moves from a starting position to a psotion in the grid 
    startY = 0;
    startS = height/4;
    elementSize = height/3;

    // current position in the grid
    offset = elements.size() * rowWidth;

    // calculate x and y postion in grid
    rows = floor(offset / gridWidth);
    gridX = offset - (gridWidth*rows) + margin;
    gridY = rows * rowHeight + margin + 40;
  }

  void display() {
    float dy = gridY - startY;
    startY += dy * easing;

    if (velocity > 100) {
      velocity = 100;
    }
    if (startS > elementSize) {// && type == "drum"
      startS = map(velocity, 4, 100, 1, rowHeight - 20);
    }



    if (startS > 50) {
      elementSize = rowHeight;
    }

    if (type == "synth") {
      //pitch = map(pitch,4,50,0,127);
      fill(#6FA883);
    } else if (type == "drum") {
      fill(#A383AA);
    } 

    noStroke();

    float elementMargin = 1;
    float elementSize = rowWidth - (2 * elementMargin);

    float x = gridX + 2 + elementMargin;
    float y = startY + (elementSize - elementMargin);

    text(parseInt(velocity), x + elementSize/2 + 1, (y + elementSize) - startS - 6);
    rect(x + 2, y + elementSize, elementSize, - startS);

    if (elementSize > 50) {
      y = startY;
    }
  }
}
