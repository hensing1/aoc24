use std::collections::HashSet;
use std::fs;
use std::ops;

const DIRS: [Dir; 4] = [
    Dir {dx: 0,  dy: -1},
    Dir {dx: 1,  dy: 0},
    Dir {dx: 0,  dy: 1},
    Dir {dx: -1, dy: 0},
];

fn main() {
    let mut d: usize = 0;

    let mut grid = get_input("input");
    let agent_pos = find_agent(&grid);
    let mut pos = agent_pos;

    let mut result = 0;

    loop {

        let mut next_d = d;
        let next_pos = step(&grid, &pos, &mut next_d);

        if !in_range(&next_pos, grid[0].len(), grid.len()) {
            break;
        }

        if get_cell(&grid, &next_pos) != 'X' {
            set_cell(&mut grid, &next_pos, '#');
            if is_loop(&grid, pos.clone(), next(d)) {
                result += 1;
            }
            set_cell(&mut grid, &next_pos, 'X');
        }

        d = next_d;
        pos = next_pos;
    }

    println!("{}", result)
}

fn is_loop(grid: &Vec<Vec<char>>, mut pos: Pos, mut d: usize) -> bool {
    let mut path: HashSet<Pos> = HashSet::new();

    loop {
        while get_cell(&grid, &(&pos + &DIRS[d])) != '#' {
            pos += &DIRS[d];
            if !in_range(&pos, grid[0].len(), grid.len()) {
                return false;
            }
        }

        if path.contains(&pos) {
            return true;
        }

        path.insert(pos);
        pos = step(&grid, &pos, &mut d);
    }
}

// ------------------------- Grid-related ----------------------------

fn get_cell(grid: &Vec<Vec<char>>, pos: &Pos) -> char {
    if in_range(&pos, grid[0].len(), grid.len()) {
        grid[pos.y as usize][pos.x as usize]
    }
    else {
        '.'
    }
}

fn set_cell(grid: &mut Vec<Vec<char>>, pos: &Pos, c: char) {
    grid[pos.y as usize][pos.x as usize] = c;
}


fn in_range(pos: &Pos, size_x: usize, size_y: usize) -> bool {
    pos.x >= 0 && (pos.x as usize) < size_x &&
        pos.y >= 0 && (pos.y as usize) < size_y
}

fn step(grid: &Vec<Vec<char>>, pos: &Pos, d: &mut usize) -> Pos {
    while get_cell(&grid, &(pos + &DIRS[*d])) == '#' {
        *d = next(*d);
    }

    pos + &DIRS[*d]
}

fn next(i: usize) -> usize {
    (i+1) % 4
}

// ------------------------- Input-related ---------------------------

fn get_input (path: &str) -> Vec<Vec<char>> {
    fs::read_to_string(path)
        .expect(&format!("Expected file {path} to open"))
        .lines()
        .map(|s| s.chars().collect())
        .collect()
}

fn find_agent(grid: &Vec<Vec<char>>) -> Pos {
    for y in 0usize..grid.len() {
        for x in 0usize..grid[0].len() {
            if grid[y][x] == '^' {
                return Pos {
                    x: x as i16,
                    y: y as i16
                }
            }
        }
    }
    Pos {x: -1, y: -1}
}



// -------------------- Data Structures -------------------------


#[derive(Copy, Clone, PartialEq, Eq, Hash)]
struct Pos {
    x: i16,
    y: i16,
}

struct Dir {
    dx: i16,
    dy: i16,
}

impl ops::Add<&Dir> for &Pos {
    type Output = Pos;

    fn add(self, _rhs: &Dir) -> Pos {
        Pos {
            x: self.x + _rhs.dx,
            y: self.y + _rhs.dy
        }
    }
}

impl ops::AddAssign<&Dir> for Pos {
    fn add_assign(&mut self, _rhs: &Dir) {
        self.x += _rhs.dx;
        self.y += _rhs.dy;
    }
}

impl ops::SubAssign<&Dir> for Pos {
    fn sub_assign(&mut self, _rhs: &Dir) {
        self.x -= _rhs.dx;
        self.y -= _rhs.dy;
    }
}

