const std = @import("std");

const Coord = struct {
    x: usize,
    y: usize,
};

pub fn run1(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");

    var coords: [512]Coord = undefined;
    var coord_size: usize = 0;

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;
        var split = std.mem.splitAny(u8, line, ",");

        coords[coord_size] = Coord{
            .x = std.fmt.parseInt(usize, split.next() orelse @panic("Failed to split coords"), 10) catch @panic("Failed to parse x"),
            .y = std.fmt.parseInt(usize, split.next() orelse @panic("Failed to split coords"), 10) catch @panic("Failed to parse y"),
        };
        coord_size += 1;
    }

    var largest_area: usize = 0;
    var i: usize = 0;
    while (i < coord_size) : (i += 1) {
        var j: usize = i + 1;
        while (j < coord_size) : (j += 1) {
            var height: usize = 0;
            var width: usize = 0;

            if (coords[i].x > coords[j].x) {
                width = coords[i].x - coords[j].x;
            } else {
                width = coords[j].x - coords[i].x;
            }
            if (coords[i].y > coords[j].y) {
                height = coords[i].y - coords[j].y;
            } else {
                height = coords[j].y - coords[i].y;
            }
            height += 1;
            width += 1;

            if (height * width > largest_area) {
                largest_area = height * width;
            }
        }
    }

    return largest_area;
}

const GreenSpan = struct {
    nodes: usize,
    vertices: [256]Coord,
};

pub fn run2(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");

    var coords: [512]Coord = undefined;
    var coord_size: usize = 0;

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;
        var split = std.mem.splitAny(u8, line, ",");

        coords[coord_size] = Coord{
            .x = std.fmt.parseInt(usize, split.next() orelse @panic("Failed to split coords"), 10) catch @panic("Failed to parse x"),
            .y = std.fmt.parseInt(usize, split.next() orelse @panic("Failed to split coords"), 10) catch @panic("Failed to parse y"),
        };
        coord_size += 1;
    }

    var largest_area: usize = 0;
    var i: usize = 0;
    while (i < coord_size) : (i += 1) {
        var j: usize = i + 1;
        while (j < coord_size) : (j += 1) {
            var height: usize = 0;
            var width: usize = 0;

            if (coords[i].x > coords[j].x) {
                width = coords[i].x - coords[j].x;
            } else {
                width = coords[j].x - coords[i].x;
            }
            if (coords[i].y > coords[j].y) {
                height = coords[i].y - coords[j].y;
            } else {
                height = coords[j].y - coords[i].y;
            }
            height += 1;
            width += 1;

            if (height * width > largest_area) {
                largest_area = height * width;
            }
        }
    }

    return largest_area;
}
