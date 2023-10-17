class Cell implements Comparable<Cell> {
  int x, y;
  boolean visited;
  boolean walls[] = {true, true, true, true};
  ArrayList<Cell> neighbors;
  int chosen;
  int pos[] = new int[4];
  int start, end, fitness;

  Cell(int xpos, int ypos) {
    visited = false;
    x = xpos;
    y = ypos;
    neighbors = new ArrayList<Cell>();
    end = abs((endX - this.x)) + abs((endY - this.y));
  }

  @Override
    int compareTo(Cell other) {
    //negative --> positive one is better (smaller)
    //positive --> other one is better (smaller)
    return(this.fitness - other.fitness);
  }

  void move() {    
    //mark as visited
    this.visited = true;

    //continue recurring until the cell runs out of neighbors
    while (true) {
      this.neighborsGen();
      if (neighbors.size() > 0) {
        //choose a random neighbor
        this.chosen = round(random(neighbors.size() - 1));

        //the wall corresponding to the randonly selected neighbor is erased
        this.walls[pos[chosen]] = false;

        //that neighbor's matching wall is also erased
        cells[neighbors.get(chosen).x][neighbors.get(chosen).y].walls[(pos[chosen] + 2) % 4] = false;

        //recursion! Yay!
        cells[neighbors.get(chosen).x][neighbors.get(chosen).y].move();
      } else {
        break;
      }
    }
  }

  void show() {
    int size = width / gridSize;

    //if this cell was considered in the searching proccess, make it darker
    if (this.fitness != 0 && this.visited == true) {
      noStroke();
      fill(150);
      square(this.x * size, this.y * size, size);
    }
    if (this.x == endX && this.y == endY) {
      noStroke();
      fill(255, 150, 150);
      square(this.x * size, this.y * size, size);
    }

    //draw up to 4 lines for each potential wall of a cell
    stroke(0);

    if (this.walls[0] == true) {
      line(this.x * size, this.y * size, (this.x + 1) * size, this.y * size);
    }
    if (this.walls[1] == true) {
      line((this.x + 1) * size, this.y * size, (this.x + 1) * size, (this.y + 1) * size);
    }
    if (this.walls[2] == true) {
      line(this.x * size, (this.y + 1) * size, (this.x + 1) * size, (this.y + 1) * size);
    }
    if (this.walls[3] == true) {
      line(this.x * size, this.y * size, this.x * size, (this.y + 1) * size);
    }

    //THIS TEST SHOWS ALL FITNESSES IN THE CELLS
    //fill(0);
    //float offset = textWidth(str(fitness)) / 2;
    //text(this.fitness, (this.x + 0.5) * size - offset, (this.y + 0.5) * size);
  }

  void neighborsGen() {
    //creates a list called neighbors of all UNVISITED neighbors
    //inputs their relation to the cell into the list pos[]
    //up is 0 and it continues clockwise

    //used only for maze generation, not searching
    neighbors = new ArrayList<Cell>();

    int sum = 0;

    //NOTE: Simple is just a simple way of accessing neighbor cells. the first input is the direction. 0 is up and it continues clockwise.

    if (this.x > 0 && simple(3, x, y).visited == false) {
      neighbors.add(simple(3, x, y));
      pos[sum] = 3;
      sum += 1;
    }
    if (this.x < gridSize - 1 && simple(1, x, y).visited == false) {
      neighbors.add(simple(1, x, y));
      pos[sum] = 1;
      sum += 1;
    }
    if (this.y > 0 && simple(0, x, y).visited == false) {
      neighbors.add(simple(0, x, y));
      pos[sum] = 0;
      sum += 1;
    }
    if (y < gridSize - 1 && simple(2, x, y).visited == false) {
      neighbors.add(simple(2, x, y));
      pos[sum] = 2;
    }
  }

  ArrayList<Cell> neighborsSearch() {
    //creates a list of all unvisited neighboring cells with no walls between them
    //used only for search

    ArrayList<Cell> list= new ArrayList<Cell>();
    for (int i = 0; i < 4; i++) {
      if (this.walls[i] == false && simple(i, x, y).visited == false) {
        list.add(simple(i, x, y));
      }
    }
    return(list);
  }

  Cell simple(int num, int _x, int _y) {
    if (num == 0) {
      return cells[_x][_y - 1];
    }
    if (num == 1) {
      return cells[_x + 1][_y];
    }
    if (num == 2) {
      return cells[_x][_y + 1];
    }
    if (num == 3) {
      return cells[_x - 1][_y];
    }
    //this should NEVER happen!
    return cells[-1][-1];
  }

  void search() {
    this.visited = true;
    for (int i = 0; i < this.neighborsSearch().size(); i++) {
      //add all viable neighbors and set their fitness
      this.neighborsSearch().get(i).start = this.start + 1;
      this.neighborsSearch().get(i).fitness = this.neighborsSearch().get(i).end;
      if (include_start == true) {
        this.neighborsSearch().get(i).fitness += this.start;
      }
      frontier.add(this.neighborsSearch().get(i));
    }
  }
}
