int cols, rows;
int scl = 1;
int w = 2000;
int h = 1600;

float scale = 400.0;
float lacunarity = 2;
float persistence = 0.5;
int octaves = 3;

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

void setup() {
  size(900, 600, P3D);
  cols = w / scl;
  rows = h/ scl;
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
  
  
  float maxHeight = -1000.0;
  float minHeight = 1000.0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float noiseHeight = 0.0;
      float frequency = 1.0;
      float amplitude = 1.0;
      for (int i = 0; i < octaves; i++){
        float sampleX = x / scale * frequency;
        float sampleY = y / scale * frequency;
        float perlinValue = noise(sampleX, sampleY) * 2 - 1;
        noiseHeight += perlinValue * amplitude;
        amplitude *= persistence;
        frequency *= lacunarity;
      }
      if (noiseHeight > maxHeight)
        maxHeight = noiseHeight;
      if (noiseHeight < minHeight)
        minHeight = noiseHeight;
      terrain[x][y] = noiseHeight;
    }
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
