boolean[][] pattern = {{true,true,true},{true,false,true},{true,true,true}};
int DIMENSION = 3;
int ITERATIONS = 4;
int SIZE = 600;
int LAG_LIMIT = 256;

ArrayList <Button> buttons = new ArrayList <Button>();
boolean left = false;
boolean right = false;
boolean down = false;
boolean up = false;
boolean same = true;

void setup()
{
  size(1300, 700);
  colorMode(HSB, 360, 100, 100);
  rectMode(CORNERS);
  textAlign(CENTER);
  background(0, 0, 100);

  for (int i = 0; i < DIMENSION; i++)
  {
    for (int j = 0; j < DIMENSION; j++)
    {
      buttons.add(new Button(i, j));
    }
  }
  redraw();
}

void draw()
{
  for (Button b: buttons)
  {
    b.check();
  }
  checkKeyPresses();

  if (!same)
  {
    redraw();
  }
}

void checkKeyPresses()
{
  if (keyPressed && keyCode == LEFT)
  {
    left = true;
  }
  else
  {
    if (left)
    {
      if (DIMENSION > 1)
      {
        DIMENSION--;
      }
      left = false;
      resetDimensions();
    }
  }
  if (keyPressed && keyCode == RIGHT)
  {
    right = true;
  }
  else
  {
    if (right)
    {
      if (DIMENSION < 10)
      {
        DIMENSION++;
        while (pow(DIMENSION, ITERATIONS) > LAG_LIMIT)
        {
          ITERATIONS--;
        }
      }
      right = false;
      resetDimensions();
    }
  }
  if (keyPressed && keyCode == DOWN)
  {
    down = true;
  }
  else
  {
    if (down)
    {
      if (ITERATIONS > 1)
      {
        ITERATIONS--;
      }
      down = false;
      same = false;
    }
  }
  if (keyPressed && keyCode == UP)
  {
    up = true;
  }
  else
  {
    if (up)
    {
      if (pow(DIMENSION, ITERATIONS + 1) <= LAG_LIMIT)
      {
        ITERATIONS++;
      }
      up = false;
      same = false;
    }
  }
}

void resetDimensions()
{
  boolean[][] temp = new boolean[DIMENSION][DIMENSION];
  for (int i = 0; i < DIMENSION; i++)
  {
    for (int j = 0; j < DIMENSION; j++)
    {
      temp[i][j] = false;
      if (i < pattern.length && j < pattern.length)
      {
        temp[i][j] = pattern[i][j];
      }
    }
  }
  pattern = temp;

  buttons = new ArrayList < Button > ();
  for (int i = 0; i < DIMENSION; i++)
  {
    for (int j = 0; j < DIMENSION; j++)
    {
      buttons.add(new Button(i, j));
    }
  }
  same = false;
}

void redraw()
{
  background(0, 0, 100);
  for (Button b: buttons) b.draw();

  fill(0, 0, 0);
  strokeWeight(1);
  drawIteration(ITERATIONS, SIZE, 650, 50);
}

void drawIteration(int iter, float size, float x, float y)
{
  if (iter == 0)
  {
    rect(x, y, x + size, y + size);
    return;
  }

  float smallSide = size / DIMENSION;
  for (int i = 0; i < DIMENSION; i++)
  {
    for (int j = 0; j < DIMENSION; j++)
    {
      if (pattern[i][j])
      {
        drawIteration(iter - 1, smallSide, x + i * smallSide, y + j * smallSide);
      }
    }
  }
}

class Button
{
  int row;
  int col;
  boolean pressed;
  float sl;

  Button(int r, int c)
  {
    row = r;
    col = c;
    pressed = false;
    sl = 400 / DIMENSION;
  }

  public void draw()
  {
    stroke(0, 0, 0);
    if (pattern[row][col])
    {
      fill(0, 0, 0);
    }
    else
    {
      fill(0, 0, 100);
    }
    rect(100 + sl * row, 150 + sl * col, 100 + sl * (row + 1), 150 + sl * (col + 1));
  }

  void check()
  {
    if (mousePressed)
    {
      if (mouseX > 100 + sl * row && mouseX < 100 + sl * (row + 1) && mouseY > 150 + sl * col && mouseY < 150 + sl * (col + 1))
      {
        pressed = true;
      }
    }
    else
    {
      if (pressed)
      {
        pressed = false;
        if (pattern[row][col])
        {
          pattern[row][col] = false;
        }
        else
        {
          pattern[row][col] = true;
        }
        same = false;
      }
    }
  }
}
