const std = @import("std");

pub fn run1(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;
    }
    return 0;
}

pub fn run2(data: []const u8) usize {
    _ = data;
    return 0;
}
