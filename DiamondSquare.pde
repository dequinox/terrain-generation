int cols, rows;
int scl = 1;
int w = 1025;
int h = 1025;
int maxsize = 1025;

float[][] terrain;

class TerrainType {
  private String m_type;
  private float m_height;
  private color m_color;  
  
  public TerrainType(String t, float h, color c){
    m_type = t;
    m_height = h;
    m_color = c;
  }
  
  public float getHeight(){
    return m_height;
  }
  
  public color getColor(){
    return m_color;
  }
};

TerrainType[] regions;
int n_regions = 8;

void squareStep(int x, int z, int reach)
{
 int count = 0;
 float avg = 0.0f;
 if (x - reach >= 0 && z - reach >= 0)
 {
  avg += terrain[x-reach][z-reach];
  count++;
 }
 if (x - reach >= 0 && z + reach < maxsize)
 {
  avg += terrain[x-reach][z+reach];
  count++;
 }
 if (x + reach < maxsize && z - reach >= 0)
 {
  avg += terrain[x+reach][z-reach];
  count++;
 }
 if (x + reach < maxsize && z + reach < maxsize)
 {
  avg += terrain[x+reach][z+reach];
  count++;
 }
 avg += random(-reach, reach);
 avg /= count;
 terrain[x][z] = round(avg);
}

void diamondStep(int x, int z, int reach)
{
 int count = 0;
 float avg = 0.0f;
 if (x - reach >= 0)
 {
  avg += terrain[x-reach][z];
  count++;
 }
 if (x + reach < maxsize)
 {
  avg += terrain[x+reach][z];
  count++;
 }
 if (z - reach >= 0)
 {
  avg += terrain[x][z-reach];
  count++;
 }
 if (z + reach < maxsize)
 {
  avg += terrain[x][z+reach];
  count++;
 }
 avg += random(-reach, reach);
 avg /= count;
 terrain[x][z] = (int)avg;
}

void diamondSquare(int size)
{
 int half = size / 2;
 if (half < 1)
  return ;
 
 for (int z = half; z < maxsize; z+=size)
  for (int x = half; x < maxsize; x+=size)
   squareStep(x, z, half);

 int col = 0;
 for (int x = 0; x < maxsize; x += half)
 {
  col++;
  //If this is an odd column.
  if (col % 2 == 1)
   for (int z = half; z < maxsize; z += size)
    diamondStep(x, z, half);
  else
   for (int z = 0; z < maxsize; z += size)
    diamondStep(x, z, half);
 }
 diamondSquare(size / 2);
}

void setup() {
  size(900, 600, P3D);
  cols = 1025;
  rows = 1025;
  terrain = new float[cols][rows];
  regions = new TerrainType[n_regions];
  
  regions[0] = new TerrainType("deep water", -40, color(51,99,194));
  regions[1] = new TerrainType("shallow water", -20, color(53,102,199));
  regions[2] = new TerrainType("sand", -10, color(186,198,118));
  regions[3] = new TerrainType("grass", 10, color(86,151,23));
  regions[4] = new TerrainType("grass2", 20, color(63,107,21));
  regions[5] = new TerrainType("rock", 40, color(93,69,64));
  regions[6] = new TerrainType("rock2", 80, color(75,60,56));
  regions[7] = new TerrainType("snow", 100, color(255, 255, 255));
  
  terrain[0][0] = random(-100, 100);
  terrain[0][1024] = random(-100, 100);
  terrain[1024][0] = random(-100, 100);
  terrain[1024][1024] = random(-100, 100);

  diamondSquare(1024);
  
  float minHeight = 1000.0;
  float maxHeight = -1000.0;
  for (int x = 0; x < rows; x++)
  {
    for (int y = 0; y < cols; y++)
    {
       if (minHeight > terrain[x][y])
         minHeight = terrain[x][y];
       if (maxHeight < terrain[x][y])
         maxHeight = terrain[x][y];
    }
    print("\n");
  }

  for (int y = 0; y < rows; y++){
    for (int x = 0; x < cols; x++){
      terrain[x][y] = map(terrain[x][y], minHeight, maxHeight, -100, 100);
    }
  }
}


void draw() {

  lights();


  background(0);
  noStroke();
  
  translate(width/2, height/2+50);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      int index = 0;
      while (index < n_regions && regions[index].getHeight() < terrain[x][y]) {
        index++;
      }
      fill(regions[index].getColor());
      vertex(x*scl, y*scl, max(terrain[x][y], -10));
      vertex(x*scl, (y+1)*scl, max(terrain[x][y+1], -10));
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
}
