const std = @import("std");

pub fn run1(data: []const u8) usize {
    var res: usize = 0;
    var it = std.mem.splitAny(u8, data, "\n");

    var beams: [256]?usize = undefined;
    var beam_count: usize = 0;

    outer: while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;
        if (beam_count == 0) {
            var i: usize = 0;
            while (i < line.len) : (i += 1) {
                if (line[i] == 'S') {
                    beams[0] = i;
                    beam_count += 1;
                    continue :outer;
                }
            }
        }
        // std.debug.print("beams = {any}\n", .{beams[0..beam_count]});
        // std.debug.print("line = {s}\n", .{line});

        var new_beams: [256]?usize = undefined;
        var new_beam_count: usize = 0;
        var i: usize = 0;
        beam_loop: while (i < beam_count) : (i += 1) {
            if (beams[i]) |beam| {
                if (line[beam] == '^') {
                    res += 1;

                    var j: usize = 0;
                    var foundr = false;
                    var foundl = false;
                    while (j < new_beam_count) : (j += 1) {
                        if (new_beams[j].? == beam - 1) {
                            foundl = true;
                        }
                        if (new_beams[j].? == beam + 1) {
                            foundr = true;
                        }
                    }
                    if (!foundl) {
                        new_beams[new_beam_count] = beam - 1;
                        new_beam_count += 1;
                    }
                    if (!foundr) {
                        new_beams[new_beam_count] = beam + 1;
                        new_beam_count += 1;
                    }
                } else {
                    var j: usize = 0;
                    while (j < new_beam_count) : (j += 1) {
                        if (new_beams[j].? == beam) continue :beam_loop;
                    }
                    new_beams[new_beam_count] = beam;
                    new_beam_count += 1;
                }
            }
        }
        beams = new_beams;
        beam_count = new_beam_count;
    }

    return res;
}

var CACHE = std.mem.zeroes([30000]usize);

var _width: usize = 0;
fn find_width(grid: []const u8) usize {
    if (_width != 0) return _width;

    var width: usize = 0;
    while (width < grid.len) : (width += 1) {
        if (grid[width] == '\n') {
            _width = width + 1;
            return _width;
        }
    }
    return _width;
}

fn recursive_walk(grid: []const u8, y_start: usize, beam_idx: usize) usize {
    const width = find_width(grid);
    var timelines: usize = 0;
    var y = y_start;

    if (CACHE[width * y_start + beam_idx] != 0) {
        return CACHE[width * y_start + beam_idx];
    }

    while (width * y + beam_idx < grid.len) : (y += 1) {
        // std.debug.print("At y = {d}, idx = {d}, grid = {c}\n", .{ y, beam_idx, grid[(width * y) + beam_idx] });
        if (grid[(width * y) + beam_idx] == '^') {
            // std.debug.print("Split at y = {d}, idx = {d}\n", .{ y, beam_idx });
            timelines += recursive_walk(grid, y + 1, beam_idx - 1);
            timelines += recursive_walk(grid, y + 1, beam_idx + 1);
            break;
        }
    }
    if (timelines == 0) {
        CACHE[width * y_start + beam_idx] = 1;
        return 1;
    } else {
        CACHE[width * y_start + beam_idx] = timelines;
        return timelines;
    }
}

pub fn run2(data: []const u8) usize {
    var i: usize = 0;
    while (i < data.len) : (i += 1) {
        if (data[i] == 'S') {
            return recursive_walk(data, 1, i);
        }
    }
    return 0;
}

// const ARR_SIZE: usize = 500000;

// pub fn run2(data: []const u8) usize {
//     // var res: usize = 0;
//     var it = std.mem.splitAny(u8, data, "\n");

//     var beams: [ARR_SIZE]?usize = undefined;
//     var beam_count: usize = 0;

//     outer: while (it.next()) |line| {
//         if (std.mem.eql(u8, line, "")) continue;
//         if (beam_count == 0) {
//             var i: usize = 0;
//             while (i < line.len) : (i += 1) {
//                 if (line[i] == 'S') {
//                     beams[0] = i;
//                     beam_count += 1;
//                     continue :outer;
//                 }
//             }
//         }
//         // std.debug.print("beams = {any}\n", .{beams[0..beam_count]});
//         // std.debug.print("line = {s}\n", .{line});

//         var new_beams: [ARR_SIZE]?usize = undefined;
//         var new_beam_count: usize = 0;
//         var i: usize = 0;
//         while (i < beam_count) : (i += 1) {
//             if (beams[i]) |beam| {
//                 if (line[beam] == '^') {
//                     new_beams[new_beam_count] = beam - 1;
//                     new_beam_count += 1;
//                     new_beams[new_beam_count] = beam + 1;
//                     new_beam_count += 1;
//                 } else {
//                     new_beams[new_beam_count] = beam;
//                     new_beam_count += 1;
//                 }
//             }
//         }
//         beams = new_beams;
//         beam_count = new_beam_count;
//     }

//     return beam_count;
// }
