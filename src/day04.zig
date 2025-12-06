const std = @import("std");

pub fn run1(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var res: usize = 0;

    var grid = std.mem.zeroes([256][256]bool);
    var max_x: usize = 0;
    var max_y: usize = 0;

    var y: usize = 1;
    while (it.next()) |line| : (y += 1) {
        if (std.mem.eql(u8, line, "")) {
            continue;
        }
        max_x = line.len + 1;

        var x: usize = 0;
        while (x < line.len) : (x += 1) {
            grid[y][x + 1] = if (line[x] == '@') true else false;
        }
    }
    max_y = y;

    y = 1;
    while (y < max_y) : (y += 1) {
        var x: usize = 1;
        while (x < max_x) : (x += 1) {
            if (!grid[y][x]) {
                continue;
            }

            var count: usize = 0;
            if (grid[y][x - 1]) count += 1;
            if (grid[y][x + 1]) count += 1;
            if (grid[y - 1][x]) count += 1;
            if (grid[y + 1][x]) count += 1;
            if (grid[y - 1][x - 1]) count += 1;
            if (grid[y - 1][x + 1]) count += 1;
            if (grid[y + 1][x - 1]) count += 1;
            if (grid[y + 1][x + 1]) count += 1;

            if (count < 4) {
                res += 1;
            }
        }
    }

    return res;
}

pub fn run2(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var res: usize = 0;

    var grid = std.mem.zeroes([256][256]bool);
    var max_x: usize = 0;
    var max_y: usize = 0;

    var y: usize = 1;
    while (it.next()) |line| : (y += 1) {
        if (std.mem.eql(u8, line, "")) {
            continue;
        }
        max_x = line.len + 1;

        var x: usize = 0;
        while (x < line.len) : (x += 1) {
            grid[y][x + 1] = if (line[x] == '@') true else false;
        }
    }
    max_y = y;

    var did_count_increase: bool = true;

    while (did_count_increase) {
        did_count_increase = false;

        y = 1;
        while (y < max_y) : (y += 1) {
            var x: usize = 1;
            while (x < max_x) : (x += 1) {
                if (!grid[y][x]) {
                    continue;
                }

                var count: usize = 0;
                if (grid[y][x - 1]) count += 1;
                if (grid[y][x + 1]) count += 1;
                if (grid[y - 1][x]) count += 1;
                if (grid[y + 1][x]) count += 1;
                if (grid[y - 1][x - 1]) count += 1;
                if (grid[y - 1][x + 1]) count += 1;
                if (grid[y + 1][x - 1]) count += 1;
                if (grid[y + 1][x + 1]) count += 1;

                if (count < 4) {
                    grid[y][x] = false;
                    did_count_increase = true;
                    res += 1;
                }
            }
        }
    }

    return res;
}
