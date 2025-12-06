const std = @import("std");

const day_runner = @import("day06.zig");
const data = @embedFile("data/day06");

// const std = @import("std");

// pub fn run1(data: []const u8) usize {
//     const it = std.mem.splitAny(u8, data, "\n");
//     _ = it;
//     return 0;
// }

// pub fn run2(data: []const u8) usize {
//     _ = data;
//     return 0;
// }

pub fn main() !void {
    const res = day_runner.run1(data);
    std.debug.print("Part 1: {any}\n", .{res});

    const res2 = day_runner.run2(data);
    std.debug.print("Part 2: {any}\n", .{res2});
}
