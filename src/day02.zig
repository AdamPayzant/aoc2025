const std = @import("std");

pub fn run1(data: []const u8) usize {
    var res: usize = 0;
    var it = std.mem.splitAny(u8, data, ",\n");
    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var it2 = std.mem.splitAny(u8, line, "-");
        const id1_str = it2.next() orelse @panic("Failed to find first ID");
        const id2_str = it2.next() orelse @panic("Failed to find second ID");

        var cur_id = std.fmt.parseInt(usize, id1_str, 10) catch @panic("Failed to parse id1");
        const end_id = std.fmt.parseInt(usize, id2_str, 10) catch @panic("Failed to parse id2");

        while (cur_id <= end_id) : (cur_id += 1) {
            // var digits = std.mem.zeroes([10]u8);
            // var temp: usize = cur_id;
            // while (temp != 0) : (temp /= 10) {
            //     digits[temp % 10] += 1;
            // }

            // std.debug.print("{any}\n", .{digits});
            // for (digits) |digit| {
            //     if (digit == 1 or digit > 2) {
            //         continue :inner;
            //     }
            // }
            // res += 1;

            var str_bufer = std.mem.zeroes([64]u8);
            const cur_str = std.fmt.bufPrint(&str_bufer, "{}", .{cur_id}) catch @panic("Failed to convert back to string");

            if (cur_str.len % 2 == 1) {
                continue;
            }
            if (std.mem.eql(u8, cur_str[0 .. cur_str.len / 2], cur_str[cur_str.len / 2 .. cur_str.len])) {
                res += cur_id;
            }
        }
    }
    return res;
}

pub fn run2(data: []const u8) usize {
    var res: usize = 0;
    var it = std.mem.splitAny(u8, data, ",\n");
    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var it2 = std.mem.splitAny(u8, line, "-");
        const id1_str = it2.next() orelse @panic("Failed to find first ID");
        const id2_str = it2.next() orelse @panic("Failed to find second ID");

        var cur_id = std.fmt.parseInt(usize, id1_str, 10) catch @panic("Failed to parse id1");
        const end_id = std.fmt.parseInt(usize, id2_str, 10) catch @panic("Failed to parse id2");

        loop2: while (cur_id <= end_id) : (cur_id += 1) {
            var str_bufer = std.mem.zeroes([64]u8);
            const cur_str = std.fmt.bufPrint(&str_bufer, "{}", .{cur_id}) catch @panic("Failed to convert back to string");

            var cur_split = cur_str.len / 2;
            loop3: while (cur_split != 0) : (cur_split -= 1) {
                if (cur_str.len % cur_split != 0) {
                    continue;
                }

                var i: usize = 1;
                while (i < cur_str.len / cur_split) : (i += 1) {
                    if (!std.mem.eql(u8, cur_str[0..cur_split], cur_str[(cur_split * i)..(cur_split * (i + 1))])) {
                        continue :loop3;
                    }
                }
                res += cur_id;
                continue :loop2;
            }
        }
    }
    return res;
}
