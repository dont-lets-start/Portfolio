//This generates a unique maze, then solves it using a priority queue which is compared by "fitness"
//The dark gray squares have been considered (added to queue)
//The light gray squares are unexplored
//The end goal is also chosen randomly
//You can download the video Maze_Search_Video.mp4 for a demonstration


//fitness is a calculation of how "good" a cell is (small numbers are better)
//it's the sum of the manhattan distance to the end and the number of moves taken to get there
//therefore faster paths are good, and paths that get close to the end are also good

import java.util.PriorityQueue;
PriorityQueue<Cell> frontier;

int gridSize = 30;
Cell cells[][] = new Cell[gridSize][gridSize];

int strokeSize = 5;
boolean done = false;
//if this becomes false, the fitness of each cell will not include the distance from the start
//(I think it's better that way with this specific kind of maze)
boolean include_start = true;

//these are the x and y values of the goal
int endX = round(random(0, gridSize - 1));
int endY = round(random(0, gridSize - 1));

void setup() {
  //create the cells
  size(750, 750);
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      cells[i][j] = new Cell(i, j);
    }
  }

  //generate their list of neighbors
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      cells[i][j].neighborsGen();
    }
  }

  //generate the maze (recursion)
  cells[0][0].move();

  //show the results
  strokeWeight(strokeSize);
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      cells[i][j].show();
    }
  }

  //reset the variable visited so that solving can begin
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      cells[i][j].visited = false;
    }
  }

  //frontier is all cells waiting to be searched. Usually only has about 1-4 items in it
  frontier = new PriorityQueue<Cell>();

  //set the first cell's stuff
  cells[0][0].start = 0;
  cells[0][0].fitness = cells[0][0].end;
  cells[0][0].search();
}

void draw() {
  background(200);

  //if the last cell is unvisited
  if (cells[endX][endY].visited == false) {
    //search the best one (basically add its neighbors to the frontier) and remove it from the frontier
    frontier.remove().search();
  } else {
    done = true;
    noLoop();
  }
  //show the results
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      cells[i][j].show();
    }
  }
  if (done == true) {
    drawLine();
  }
}

void drawLine() {
  //draw the line
  strokeWeight(strokeSize * 0.7);
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[i].length; j++) {
      cells[i][j].visited = false;
    }
  }
  int x = endX;
  int y = endY;
  while (x != 0 || y != 0) {
    for (int i = 0; i < cells[x][y].neighborsSearch().size(); i++) {
      if (cells[x][y].neighborsSearch().get(i).start == cells[x][y].start - 1) {
        int size = width / gridSize;
        int offset = size / 2;
        int newX = cells[x][y].neighborsSearch().get(i).x;
        int newY = cells[x][y].neighborsSearch().get(i).y;

        stroke(255, 0, 0);
        line(x * size + offset, y * size + offset, newX * size + offset, newY * size + offset);
        x = newX;
        y = newY;
        break;
      }
    }
  }
}
