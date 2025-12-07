const std = @import("std");

pub fn run1(data: []const u8) usize {
    var res: usize = 0;
    var rows = std.mem.zeroes([4][1024]usize);
    var x: usize = 0;
    var y: usize = 0;

    var it = std.mem.splitAny(u8, data, "\n");

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;
        if (line[0] == '*' or line[0] == '+') {
            x = 0;
            const max_y = y;

            var operit = std.mem.splitAny(u8, line, " ");
            while (operit.next()) |oper| {
                if (oper.len == 0 or (oper[0] != '*' and oper[0] != '+')) continue;
                y = 1;
                var amt: usize = rows[0][x];
                while (y < max_y) : (y += 1) {
                    if (oper[0] == '*') {
                        amt *= rows[y][x];
                    } else {
                        amt += rows[y][x];
                    }
                }
                res += amt;
                x += 1;
            }
        } else {
            x = 0;
            var lineit = std.mem.splitAny(u8, line, " ");
            while (lineit.next()) |num| {
                if (std.mem.eql(u8, num, "")) continue;

                rows[y][x] = std.fmt.parseInt(usize, num, 10) catch @panic("Failed to parse number");
                x += 1;
            }

            y += 1;
        }
    }
    res += 0;
    return res;
}

fn get_next(line: []const u8, cur: usize) usize {
    var next: usize = cur;

    var end = false;
    while (next < line.len) : (next += 1) {
        if (line[next] == ' ') {
            end = true;
        } else if (end) {
            break;
        }
    }
    return next;
}

pub fn run2(data: []const u8) usize {
    var res: usize = 0;
    var lines = std.mem.zeroes([5][8192]u8);
    var y: usize = 0;
    var y_max: usize = 0;

    var it = std.mem.splitAny(u8, data, "\n");

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;
        if (line[0] == '*' or line[0] == '+') {
            y_max = y;
            var last_oper = line[0];

            var x: usize = 0;
            var prod: usize = 0;
            while (x < line.len) : (x += 1) {
                if (line[x] != ' ') {
                    res += prod;
                    prod = 0;
                    last_oper = line[x];
                }

                var num: usize = 0;
                y = 0;
                while (y < y_max) : (y += 1) {
                    if (lines[y][x] != ' ') {
                        if (num != 0) {
                            num *= 10;
                        }
                        num += lines[y][x] - '0';
                    }
                }

                if (last_oper == '*') {
                    if (prod == 0) {
                        prod = num;
                    } else if (num != 0) {
                        prod *= num;
                    }
                } else {
                    prod += num;
                }
            }

            res += prod;
        } else {
            @memcpy(lines[y][0..line.len], line);
            y += 1;
        }
    }
    res += 0;
    return res;
}
