const std = @import("std");

pub fn run1(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var res: usize = 0;

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            continue;
        }
        var high1: u8 = line[0];
        var high2: u8 = 0;

        var i: usize = 1;
        while (i < line.len) : (i += 1) {
            if (high2 > high1) {
                high1 = high2;
                high2 = line[i];
            }
            if (line[i] > high2) {
                high2 = line[i];
            }
        }
        res += std.fmt.parseInt(usize, &[_]u8{ high1, high2 }, 10) catch @panic("Failed to convert result into number");
    }
    return res;
}

fn walkback(arr: *[12]u8, start: usize, end: u8) void {
    var j = start;
    while (j < arr.len - 1) : (j += 1) {
        arr[j] = arr[j + 1];
    }
    arr[j] = end;
}

pub fn run2(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var res: usize = 0;

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            continue;
        }
        var highs = std.mem.zeroes([12]u8);
        var i: usize = 0;
        while (i < 12) : (i += 1) {
            highs[i] = line[i];
        }
        while (i < line.len) : (i += 1) {
            var j: usize = 1;
            while (j < highs.len) : (j += 1) {
                if (highs[j] > highs[j - 1]) {
                    walkback(&highs, j - 1, line[i]);
                    break;
                }
            }
            if (line[i] > highs[11]) {
                highs[11] = line[i];
            }
        }
        // std.debug.print("{s}\n", .{highs});
        res += std.fmt.parseInt(usize, &highs, 10) catch @panic("Failed to convert result into number");
    }
    return res;
}
