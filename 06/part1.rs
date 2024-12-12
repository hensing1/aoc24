use std::fs;
use std::ops;

fn get_input (path: &str) -> Vec<Vec<char>> {
    fs::read_to_string(path)
        .expect(&format!("Expected file {path} to open"))
        .lines()
        .map(|s| s.chars().collect())
        .collect()
}



fn print_type<T>(_: &T) { 
    println!("{:?}", std::any::type_name::<T>());
}


struct Pos {
    x: i16,
    y: i16,
}

struct Dir {
    dx: i16,
    dy: i16,
}

impl ops::Add<Dir> for Pos {
    type Output = Pos;

    fn add(self, _rhs: Dir) -> Pos {
        Pos {
            x: self.x + _rhs.dx,
            y: self.y + _rhs.dy
        }
    }
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

fn get_cell(grid: &Vec<Vec<char>>, pos: &Pos) -> char {
    if in_range(&pos) {
        grid[pos.y as usize][pos.x as usize]
    }
    else {
        '.'
    }
}

fn set_cell(mut grid: &Vec<Vec<char>>, pos: &Pos, c: char) {
    grid[pos.y as uszie][pos.x as usize] = c;
}

fn can_move(grid: &Vec<Vec<char>>, pos: &Pos, size_x: &usize, size_y: &usize) {

}

fn in_range(pos: &Pos, size_x: &usize, size_y: &usize) -> bool {
    pos.x >= 0 && (pos.x as usize) < size_x &&
        pos.y >= 0 && (pos.y as usize) < size_y
}

fn main() {
    let mut d = 0;
    let dirs: [Dir; 4] = [
        Dir {dx: 0,  dy: -1},
        Dir {dx: 1,  dy: 0},
        Dir {dx: 0,  dy: 1},
        Dir {dx: -1, dy: 0},
    ];

    let mut grid = get_input("test");
    let mut pos = find_agent(&grid);
    set_cell(&grid, &pos, '.');

    let size_x = grid[0].len();
    let size_y = grid.len();

    let mut result = 0;
    while in_range(&pos, &size_x, &size_y) {
        if get_cell(&grid, &pos) == '.' {
            set_cell(&grid, &pos, 'X');
            result += 1;
        }
        if get_cell(&grid, &(pos + dirs[d])) == '#' {
            d = (d+1) % 4;
        }
        else {
            pos = pos + dirs[d];
        }
    }
    //let mut pos: (usize, usize) = (0, 0);
    //pos + directions[0];
}
