use std::fs;
use std::ops;

fn main() {
    let mut d = 0;
    let dirs: [Dir; 4] = [
        Dir {dx: 0,  dy: -1},
        Dir {dx: 1,  dy: 0},
        Dir {dx: 0,  dy: 1},
        Dir {dx: -1, dy: 0},
    ];

    let mut grid = get_input("input");
    let mut pos = find_agent(&grid);
    set_cell(&mut grid, &pos, '.');

    let size_x = grid[0].len();
    let size_y = grid.len();

    let mut result = 0;
    while in_range(&pos, &size_x, &size_y) {
        if get_cell(&grid, &pos, &size_x, &size_y) == '.' {
            set_cell(&mut grid, &pos, 'X');
            result += 1;
        }
        if get_cell(&grid, &(&pos + &dirs[d]), &size_x, &size_y) == '#' {
            d = (d+1) % 4;
        }
        else {
            pos += &dirs[d];
        }
    }
    println!("{}", result)
}

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

fn get_cell(grid: &Vec<Vec<char>>, pos: &Pos, size_x: &usize, size_y: &usize) -> char {
    if in_range(&pos, &size_x, &size_y) {
        grid[pos.y as usize][pos.x as usize]
    }
    else {
        '.'
    }
}

fn set_cell(grid: &mut Vec<Vec<char>>, pos: &Pos, c: char) {
    grid[pos.y as usize][pos.x as usize] = c;
}


fn in_range(pos: &Pos, size_x: &usize, size_y: &usize) -> bool {
    pos.x >= 0 && (pos.x as usize) < *size_x &&
        pos.y >= 0 && (pos.y as usize) < *size_y
}
