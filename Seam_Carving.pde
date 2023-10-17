// This code carves out the vertical path with the least contrast, taking one pixel from each row
// It can only be run in Processing

PImage img;
ArrayList<ArrayList<Float>> memory = new ArrayList<ArrayList<Float>>();

void setup() {
  size(800, 800);
  img = loadImage("castle.jpeg");
  img.resize(width, 0);
  img.loadPixels();

  for (int y = 0; y < img.height - 2; y++) {
    memory.add(new ArrayList());
    for (int x = 0; x < img.width - 2; x++) {
      memory.get(y).add(0.0);
    }
  }
}

void draw() {
  clear();
  img = carveSeam(img, findSeam(getEnergy(img)));
  image(img, 0, 0);
  if (img.width == 3) {
    noLoop();
  }
}

float[][] getEnergy(PImage reference) {

  float reddiff, greendiff, bluediff;
  float [][] colors = new float[reference.height - 2][reference.width - 2];
  for (int y = 1; y < reference.height - 1; y++) {
    for (int x = 1; x< reference.width - 1; x++) {
      reddiff = red(reference.pixels[y * reference.width + x - 1]) - red(reference.pixels[y * reference.width + x + 1]);
      greendiff = green(reference.pixels[y * reference.width + x - 1]) - green(reference.pixels[y * reference.width + x + 1]);
      bluediff = blue(reference.pixels[y * reference.width + x - 1]) - blue(reference.pixels[y * reference.width + x + 1]);

      float horizontal = pow(reddiff, 2) + pow(greendiff, 2) + pow(bluediff, 2);

      reddiff = red(reference.pixels[(y + 1) * reference.width + x]) - red(reference.pixels[(y - 1) * reference.width + x]);
      greendiff = green(reference.pixels[(y + 1) * reference.width + x]) - green(reference.pixels[(y - 1) * reference.width + x]);
      bluediff = blue(reference.pixels[(y + 1) * reference.width + x]) - blue(reference.pixels[(y - 1) * reference.width + x]);

      float vertical = pow(reddiff, 2) + pow(greendiff, 2) + pow(bluediff, 2);

      colors[y - 1][x - 1] = horizontal + vertical;
    }
  }
  return(colors);
}

float[] options(int y, int x, ArrayList<ArrayList<Float>> location) {
  ArrayList<float[]> answer = new ArrayList<float[]>();
  float[] temp1 = new float[2];
  float[] temp2 = new float[2];
  float[] temp3 = new float[2];

  if (x > 0) {
    temp1[0] = location.get(y - 1).get(x - 1);
    temp1[1] = -1;
    answer.add(temp1);
  }
  temp2[0] = location.get(y - 1).get(x);
  temp2[1] = 0;
  answer.add(temp2);
  if (x < location.get(0).size() - 1) {
    temp3[0] = location.get(y - 1).get(x + 1);
    temp3[1] = 1;
    answer.add(temp3);
  }
  float comp = answer.get(0)[0];
  float pos = answer.get(0)[1];
  for (int i = 0; i < answer.size(); i++) {
    if (answer.get(i)[0] < comp) {
      comp = answer.get(i)[0];
      pos = answer.get(i)[1];
    }
  }
  float[] response = {comp, pos};
  return(response);
}

ArrayList<Integer> findSeam(float[][] array) {
  for (int x = 0; x < array[0].length; x++) {
    memory.get(0).set(x, array[0][x]);
  }

  for (int y = 1; y < array.length; y++) {
    for (int x = 0; x < array[0].length; x++) {
      memory.get(y).set(x, array[y][x] + options(y, x, memory)[0]);
    }
  }
  ArrayList<Integer> path = new ArrayList<Integer>();

  int x = 0;
  float comp = array[array.length - 1][0];
  for (int i = 1; i < array[0].length; i++) {
    if (array[array.length - 1][i] < comp) {
      comp = array[array.length - 1][i];
      x = i;
    }
  }
  path.add(x);
  for (int y = array.length - 1; y > 0; y--) {
    float[] temp = options(y, x, memory);
    x = x + round(temp[1]);
    path.add(x);
  }
  return(path);
}

PImage carveSeam(PImage input, ArrayList<Integer> seam) {
  PImage temp = createImage(input.width - 1, input.height, RGB);

  for (int x = 0; x < temp.width; x++) {
    for (int y = 1; y < seam.size(); y++) {

      int border = seam.get(seam.size() - y);

      if (x < border) {
        temp.set(x, y, input.get(x, y));
      } else {
        temp.set(x, y, input.get(x + 1, y));
      }
    }
  }
  return(temp);
}
