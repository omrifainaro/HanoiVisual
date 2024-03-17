
static final int NUM_POLES = 3;
static final int MAX_POLE = 6;

int[][] disks;

int prevSection = -1;

int button[] = {10, 10, 100, 60};

int solveSpeed = 50;

void init() {
  disks = new int[NUM_POLES][MAX_POLE]; 
  
  for (int i = 1; i <= MAX_POLE; i++) {
    disks[0][MAX_POLE-i] = i;
    disks[1][MAX_POLE-i] = 0;
    disks[2][MAX_POLE-i] = 0;
  }
  
} 

void setup() {
  init();
  size(800, 600);
  background(color(200, 200, 200));
}

void drawBoard() {
  int poleWidth = 10;
  int poleHeight = 300;
  
  int widthWithPad = 600;
  
  // Draw the button
  fill(0, 0, 0);
  rect(button[0], button[1], button[2], button[3]);
  textSize(30);
  fill(255,0,0);
  text("solve", button[0] + 10, button[1] + 40); 
  
  // Draw the poles
  for(int i = 1; i < 4; i++) {
    int x = i * (widthWithPad / 3);
    fill(100, 100, 100);
    if (prevSection + 1 == i) {
      fill(200, 50, 100);
    }
    rect(x, height - poleHeight, poleWidth, poleHeight);
  }
  
  //draw the disks
  for(int i = 1; i < 4; i++) {
    int x = i * (widthWithPad / 3);
    for(int j = 0; j < MAX_POLE; j++) {
      int diskVal = disks[i-1][j];
      int diskWidth = diskVal * 30 + 20;
      int diskHeight = 30;
      if (diskVal == 0) continue;
      fill(diskVal*50, diskVal*10, diskVal*100);
      rect(x - diskWidth / 2, height - diskHeight - (j*diskHeight), diskWidth, diskHeight);
    }
  }
  
}

void draw() {
  background(color(200, 200, 200));
  drawBoard();
}

boolean checkMove(int start, int end) {
  println(start + " -> " + end);
  return true;
}

boolean moveDisk(int start, int end) {
  if (!checkMove(start, end))
    return false;
  
  int diskVal = 0;
  for (int i = MAX_POLE - 1; i >= 0; i--){
    diskVal = disks[start][i];
    if (diskVal != 0){
      disks[start][i] = 0;
      break;
    }
  }
  
  for (int i = 0; i < MAX_POLE; i++) {
    if (disks[end][i] == 0) {
      disks[end][i] = diskVal;
      break;
    }
  }
  
  return true;
}

class Tuple<X, Y> { 
  final X x; 
  final Y y; 
  Tuple(X x, Y y) { 
    this.x = x; 
    this.y = y; 
  } 
} 

ArrayList doHanoi(int n, int start, int end) {
  ArrayList<Tuple<Integer, Integer>> list = new ArrayList<>();
  
  if (n == 1) {
    list.add(new Tuple(start - 1, end - 1));
  }
  else {
    int other = 6 - (start + end);
    list.addAll(doHanoi(n -1, start, other));
    list.add(new Tuple(start - 1, end - 1));
    list.addAll(doHanoi(n -1, other, end));
  }
  
  return list;
}

ArrayList<Tuple> solution;

void solve() {
  if (solution == null)
    solution = doHanoi(MAX_POLE, 1, 3);
  
  Tuple t = solution.get(0);
  moveDisk((int)t.x, (int)t.y);
  solution.remove(0);
  if (solution.size() == 0)
    solution = doHanoi(MAX_POLE, 3, 1);
}

boolean inButton() {
  return (mouseX >= button[0] && mouseX <= button[0] + button[2] &&
  mouseY >= button[1] && mouseY <= button[1] + button[3]);
}

void mousePressed() {
  int section = (int) ((mouseX / (width * 1.0))*3);
  println("Section: " + section);
  
  if (inButton()) {
    println("Solve!!!!");
    solve();
    return;
  }
  
  if (prevSection == -1) {
    prevSection = section;
    return;
  }
  
  if (prevSection != section) {
    //Do move
    println("Make move " + prevSection + " -> " + section);
    moveDisk(prevSection, section);
  }
  
  prevSection = -1;
}
