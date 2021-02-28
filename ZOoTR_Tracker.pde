ArrayList<Button> buttons = new ArrayList<Button>(0);
float padding = 15;
float margin = 5;
float rows = 8;
float cols = 6;
float cellW;
int w, h = 0;
Boolean update = true;
PGraphics tracker;
PImage background;
void setup() {
  background = loadImage("Background.jpg");
  surface.setTitle("BoppOpp's ZOoTR Tracker");
  surface.setResizable(true);
  registerMethod("pre", this);
  size(400, 400);
  //pixelDensity(2);
  tracker = createGraphics(floor(width-margin*2), floor(width-margin*2));
  buttons.add(new Button(1, 1, "Kokiri_Sword"));
  buttons.add(new Button(2, 1, "Master_Sword"));
  buttons.add(new Button(3, 1, "Biggoron's_Sword"));
  buttons.add(new Button(4, 1, "Nut"));//
  buttons.add(new Button(5, 1, "Deku_Stick"));//
  buttons.add(new Button(6, 1, "Slingshot"));//
  buttons.add(new Button(1, 2, "Deku_Shield"));
  buttons.add(new Button(2, 2, "Hylian_Shield"));
  buttons.add(new Button(3, 2, "Mirror_Shield"));
  buttons.add(new Button(4, 2, "Bombs"));//
  //buttons.add(new Button(5, 2, "Silver_Scale"));
  buttons.add(new Button(6, 2, "Boomerang"));
  background.filter(BLUR, 6);
}

void draw() {
  if (frameCount%100==0) tracker.save("obs/recording.png");
  if (update) {
    background(255);
    imageMode(CENTER);
    float aspectR = (float) background.height / (float) background.width;
    if (w*aspectR<h) {
      image(background, width/2, height/2, h/aspectR, h);
    } else {
      image(background, width/2, height/2, w, w*aspectR);
    }
    stroke(255);
    fill(0, 100);
    strokeWeight(3);
    rect(padding/2, padding/2, width-padding, height-padding, padding, padding, padding, padding);
    imageMode(CORNER);

    tracker.beginDraw();
    tracker.clear();
    for (Button b : buttons) {
      b.draw();
    }
    tracker.endDraw();
    image(tracker, padding, padding);
    tracker.save("obs/recording.png");
    update = false;
  }
}

class Button {
  int state = 0;
  int states;
  ArrayList<PImage> imgs;
  float r, c;
  String name;
  Button(ArrayList<PImage> imgs, float col, float row, String name) {
    this.imgs = imgs;
    c=col;
    r=row;
    this.name = name;
  }
  Button(float col, float row, String name) {
    c=col;
    r=row;
    this.name = name;
    states = 2;
    imgs = new ArrayList<PImage>(2);
    imgs.add(loadImage("Sprites/No_"+name+".png"));
    imgs.add(loadImage("Sprites/"+name+".png"));
  }

  void draw() {
    tracker.image(imgs.get(state), (c-1)*(cellW+margin), (r-1)*(cellW+margin), cellW, cellW);
  }

  Boolean check() {
    if (mouseX > padding+(c-1)*(cellW+margin) && mouseX < padding+(c-1)*(cellW+margin) + cellW && mouseY > padding+(r-1)*(cellW+margin) && mouseY < padding+(r-1)*(cellW+margin) + cellW) {
      state = (state+1<states)?state+1:0;
      println(state);
      update = true;
      return true;
    }
    return false;
  }
}

void pre() {
  if (w != width || h != height) {
    w = width;
    h = height;
    tracker = createGraphics(floor(w-margin*2), floor(h-margin*2));
    cellW = ((width-margin*(cols-1)-padding*2)/cols < (height-margin*(rows-1)-padding*2)/rows)?(width-margin*(cols-1)-padding*2)/cols:(height-margin*(rows-1)-padding*2)/rows;
    println(cellW);
    update = true;
  }
}

void mousePressed() {
  for (Button b : buttons) {
    if (b.check()) break;
  }
}
