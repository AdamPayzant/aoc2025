const std = @import("std");

pub fn run1(data: []const u8) u32 {
    var it = std.mem.splitAny(u8, data, "\n");
    var res: u32 = 0;
    var dial: isize = 50;

    while (it.next()) |x| {
        if (std.mem.eql(u8, x, "")) {
            break;
        }

        const val = std.fmt.parseInt(isize, x[1..x.len], 10) catch @panic("Failed to parse int");
        switch (x[0]) {
            'L' => {
                dial -= val;
                while (dial < 0) {
                    dial += 100;
                }
            },
            'R' => {
                dial += val;
                while (dial > 99) {
                    dial -= 100;
                }
            },
            else => {
                @panic("Invalid first character detected");
            },
        }

        if (dial == 0) {
            res += 1;
        }
    }

    return res;
}

pub fn run2(data: []const u8) u32 {
    var it = std.mem.splitAny(u8, data, "\n");
    var res: u32 = 0;
    var dial: isize = 50;

    while (it.next()) |x| {
        if (std.mem.eql(u8, x, "")) {
            break;
        }

        const val = std.fmt.parseInt(isize, x[1..x.len], 10) catch @panic("Failed to parse int");
        var dir: isize = 0;
        switch (x[0]) {
            'L' => {
                dir = -1;
            },
            'R' => {
                dir = 1;
            },
            else => {
                @panic("Invalid first character detected");
            },
        }

        var i: usize = 0;
        while (i < val) : (i += 1) {
            dial += dir;

            if (dial == -1) {
                dial = 99;
            }
            if (dial == 100) {
                dial = 0;
            }

            if (dial == 0) {
                res += 1;
            }
        }
    }

    return res;
}
