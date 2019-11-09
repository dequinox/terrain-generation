int w = 500;
int h = 1000;
int[][] terrain;
int[][] tmp;
int scl = 3;
int n = 2;

int deathLimit = 4;
int birthLimit = 3;


int countNeighbours(int x, int y)
{
  int count = 0;
  for (int i = -1; i <= 1; i++)
  {
    for (int j = -1; j <= 1; j++)
    {
      if (i == 0 && j == 0)
      {
        count += tmp[x][y];
        continue;
      }
      if (x + i < 0 || x + 1 == h / scl || y + j < 0 || y + j == w / scl)
      {
        count++;
        continue;
      }
      
      count += tmp[x + i][y + j];
    }
  }
  return count;
}

void setup()
{
  size(1000, 500);
  terrain = new int[h + 5][w + 5];
  tmp = new int[h + 5][w + 5];
  
  for (int i = 0; i < h / scl; i++)
  {
    for (int j = 0; j < w / scl; j++)
    {
      terrain[i][j] = 0;
      if (random(1) > 0.5)
        terrain[i][j] = 1;
       
      tmp[i][j] = terrain[i][j];
    }
  }
  
  for (int k = 0; k < n; k++)
  {
  
    for (int i = 0; i < h / scl; i++)
    {
      for (int j = 0; j < w / scl; j++)
      {
        int count = countNeighbours(i, j);
        if (count < 2)
          terrain[i][j] = 0;
        if (count >= 5 && count <= 7)
        {
          terrain[i][j] = 1;
        }
        else if (count >= 8 && count <= 10)
        {
          terrain[i][j] = 2;
        }
        else if (count >= 11)
          terrain[i][j] = 3;
        else 
          terrain[i][j] = 0;
         
        /*if (tmp[i][j] == 1)
        {
          if (count < deathLimit)
          {
            terrain[i][j] = 0;
          }
          else 
          {
            terrain[i][j] = 1;
          }
        }
        else 
        {
          if (count > birthLimit)
          {
            terrain[i][j] = 1;
          }
          else 
          {
            terrain[i][j] = 0;
          }
        }*/
      }
    }
    
    for (int i = 0; i < h / scl; i++)
    {
      for (int j = 0; j < w / scl; j++)
      {
        tmp[i][j] = terrain[i][j];
      }
    }
  }
  
  
}

void draw()
{
  for (int i = 0; i < h / scl; i++)
  {
    for (int j = 0; j < w / scl; j++)
    {
      noStroke();
      fill(44, 44, 134);
      if (terrain[i][j] == 1)
        fill(0, 163, 32);
      if (terrain[i][j] == 2)
        fill(89, 85, 88);
      if (terrain[i][j] == 3)
        fill(255, 255, 255);
      rect(i * scl, j * scl, (i + 1) * scl, (j + 1) * scl);
    }
  }
}
