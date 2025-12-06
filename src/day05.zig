const std = @import("std");

const Range = struct {
    start: usize,
    end: usize,
};

pub fn run1(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var ranges = std.mem.zeroes([256]Range);
    var res: usize = 0;

    var i: usize = 0;
    while (it.next()) |line| : (i += 1) {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var spliter = std.mem.splitAny(u8, line, "-");

        ranges[i].start = std.fmt.parseInt(usize, spliter.next() orelse @panic("Invalid range start"), 10) catch @panic("Failed to parse range start");
        ranges[i].end = std.fmt.parseInt(usize, spliter.next() orelse @panic("Invalid range end"), 10) catch @panic("Failed to parse range end");
    }

    const max_i = i;
    outer: while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            continue;
        }
        const val = std.fmt.parseInt(usize, line, 10) catch @panic("Failed to parse value");

        i = 0;
        while (i < max_i) : (i += 1) {
            if (val >= ranges[i].start and val <= ranges[i].end) {
                res += 1;
                continue :outer;
            }
        }
    }
    res += 0;
    return res;
}

pub fn run2(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var ranges = std.mem.zeroes([256]Range);
    var res: usize = 0;

    var i: usize = 0;
    while (it.next()) |line| : (i += 1) {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var spliter = std.mem.splitAny(u8, line, "-");

        ranges[i].start = std.fmt.parseInt(usize, spliter.next() orelse @panic("Invalid range start"), 10) catch @panic("Failed to parse range start");
        ranges[i].end = std.fmt.parseInt(usize, spliter.next() orelse @panic("Invalid range end"), 10) catch @panic("Failed to parse range end");
    }

    const max_i = i;
    i = 0;
    while (i < max_i) : (i += 1) {
        if (ranges[i].start == 0 and ranges[i].end == 0) continue;

        var j: usize = 0;
        while (j < max_i) : (j += 1) {
            if (j == i) {
                continue;
            }

            if (ranges[i].start <= ranges[j].start and ranges[i].end >= ranges[j].start) {
                if (ranges[i].end < ranges[j].end) {
                    ranges[i].end = ranges[j].end;
                }
                ranges[j].start = 0;
                ranges[j].end = 0;
            }
            if (ranges[j].start <= ranges[i].start and ranges[j].end >= ranges[i].start) {
                if (ranges[j].end < ranges[i].end) {
                    ranges[j].end = ranges[i].end;
                }
                ranges[i].start = 0;
                ranges[i].end = 0;
            }
        }
    }

    i = 0;
    while (i < max_i) : (i += 1) {
        if (ranges[i].start == 0 and ranges[i].end == 0) continue;

        res += ranges[i].end - ranges[i].start + 1;
    }

    return res;
}
