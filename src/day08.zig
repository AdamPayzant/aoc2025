const std = @import("std");

const Junction = struct {
    x: f32,
    y: f32,
    z: f32,
    connect_count: usize,
    connections: [256]*Junction,
    circuit_id: ?usize,
};

const CONNECTION_COUNT: usize = 1000;

const CacheEntry = struct {
    distance: f32,
    j1: *Junction,
    j2: *Junction,
};

fn calc_distance(j1: *Junction, j2: *Junction) f32 {
    const dx = (j2.x - j1.x) * (j2.x - j1.x);
    const dy = (j2.y - j1.y) * (j2.y - j1.y);
    const dz = (j2.z - j1.z) * (j2.z - j1.z);

    return @sqrt(dx + dy + dz);
}

fn insert_to_cache(entry: CacheEntry, distance_cache: *[CONNECTION_COUNT]CacheEntry, cache_count: *usize) void {
    var i: usize = 0;
    while (i < cache_count.*) : (i += 1) {
        if (distance_cache[i].distance > entry.distance) {
            // TODO: push all entries back and insert
            if (cache_count.* < CONNECTION_COUNT) cache_count.* += 1;
            var j: usize = cache_count.* - 1;
            while (j > i) : (j -= 1) {
                distance_cache[j] = distance_cache[j - 1];
            }
            distance_cache[i] = entry;
            return;
        }
    }
    if (cache_count.* < CONNECTION_COUNT) {
        distance_cache[cache_count.*] = entry;
        cache_count.* += 1;
    }
}

pub fn run1(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var junctions: [1024]Junction = undefined;
    var idx: usize = 0;

    var distance_cache: [CONNECTION_COUNT]CacheEntry = undefined;
    var cache_count: usize = 0;

    var circuits = [_]?usize{null} ** 1024;

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;

        var line_split = std.mem.splitAny(u8, line, ",");

        junctions[idx] = Junction{
            .x = std.fmt.parseFloat(f32, line_split.next() orelse @panic("Failed to parse x")) catch @panic("Failed to convert to num"),
            .y = std.fmt.parseFloat(f32, line_split.next() orelse @panic("Failed to parse y")) catch @panic("Failed to convert to num"),
            .z = std.fmt.parseFloat(f32, line_split.next() orelse @panic("Failed to parse z")) catch @panic("Failed to convert to num"),
            .connect_count = 0,
            .connections = undefined,
            .circuit_id = null,
        };
        idx += 1;
    }

    const len = idx;

    var idx1: usize = 0;
    while (idx1 < len) : (idx1 += 1) {
        var idx2: usize = idx1 + 1;
        while (idx2 < len) : (idx2 += 1) {
            const distance = calc_distance(&junctions[idx1], &junctions[idx2]);
            insert_to_cache(.{ .distance = distance, .j1 = &junctions[idx1], .j2 = &junctions[idx2] }, &distance_cache, &cache_count);
        }
    }

    var i: usize = 0;
    while (i < CONNECTION_COUNT) : (i += 1) {
        var closet1 = distance_cache[i].j1;
        var closet2 = distance_cache[i].j2;

        if (closet1.circuit_id) |id1| {
            if (closet2.circuit_id) |id2| {
                if (id1 != id2) {
                    circuits[id1] = circuits[id1].? + circuits[id2].?;
                    circuits[id2] = null;

                    // Go through and move all junction's circuits to the combined circuit
                    for (&junctions) |*junction| {
                        if (junction.circuit_id) |id| {
                            if (id == id2) {
                                junction.circuit_id = id1;
                            }
                        }
                    }
                }
            } else {
                closet2.circuit_id = id1;
                circuits[id1] = circuits[id1].? + 1;
            }
        } else {
            if (closet2.circuit_id) |id| {
                closet1.circuit_id = id;
                circuits[id] = circuits[id].? + 1;
            } else {
                var id: usize = 0;
                while (id < circuits.len) : (id += 1) {
                    if (circuits[id]) |_| {} else {
                        closet1.circuit_id = id;
                        closet2.circuit_id = id;
                        circuits[id] = 2;
                        break;
                    }
                }
            }
        }
    }

    i = 0;
    var top3 = [3]usize{ 1, 1, 1 };
    while (i < circuits.len) : (i += 1) {
        if (circuits[i]) |count| {
            if (count > top3[0]) {
                top3[2] = top3[1];
                top3[1] = top3[0];
                top3[0] = count;
            } else if (count > top3[1]) {
                top3[2] = top3[1];
                top3[1] = count;
            } else if (count > top3[2]) {
                top3[2] = count;
            }
        }
    }

    return top3[0] * top3[1] * top3[2];
}

const MEGACACHE: usize = 10000;

fn insert_to_megacache(entry: CacheEntry, distance_cache: *[MEGACACHE]CacheEntry, cache_count: *usize) void {
    var i: usize = 0;
    while (i < cache_count.*) : (i += 1) {
        if (distance_cache[i].distance > entry.distance) {
            // TODO: push all entries back and insert
            if (cache_count.* < MEGACACHE) cache_count.* += 1;
            var j: usize = cache_count.* - 1;
            while (j > i) : (j -= 1) {
                distance_cache[j] = distance_cache[j - 1];
            }
            distance_cache[i] = entry;
            return;
        }
    }
    if (cache_count.* < MEGACACHE) {
        distance_cache[cache_count.*] = entry;
        cache_count.* += 1;
    }
}

pub fn run2(data: []const u8) usize {
    var it = std.mem.splitAny(u8, data, "\n");
    var junctions: [1024]Junction = undefined;
    var idx: usize = 0;

    var distance_cache: [MEGACACHE]CacheEntry = undefined;
    var cache_count: usize = 0;

    var circuits = [_]?usize{null} ** 1000;
    var circuit_count: usize = 0;

    while (it.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;

        var line_split = std.mem.splitAny(u8, line, ",");

        junctions[idx] = Junction{
            .x = std.fmt.parseFloat(f32, line_split.next() orelse @panic("Failed to parse x")) catch @panic("Failed to convert to num"),
            .y = std.fmt.parseFloat(f32, line_split.next() orelse @panic("Failed to parse y")) catch @panic("Failed to convert to num"),
            .z = std.fmt.parseFloat(f32, line_split.next() orelse @panic("Failed to parse z")) catch @panic("Failed to convert to num"),
            .connect_count = 0,
            .connections = undefined,
            .circuit_id = circuit_count,
        };
        circuits[circuit_count] = 1;
        circuit_count += 1;
        idx += 1;
    }

    const len = idx;

    var idx1: usize = 0;
    while (idx1 < len) : (idx1 += 1) {
        var idx2: usize = idx1 + 1;
        while (idx2 < len) : (idx2 += 1) {
            const distance = calc_distance(&junctions[idx1], &junctions[idx2]);
            insert_to_megacache(.{ .distance = distance, .j1 = &junctions[idx1], .j2 = &junctions[idx2] }, &distance_cache, &cache_count);
        }
    }

    var i: usize = 0;
    while (i < MEGACACHE and circuit_count > 1) : (i += 1) {
        const closet1 = distance_cache[i].j1;
        const closet2 = distance_cache[i].j2;

        if (closet1.circuit_id) |id1| {
            if (closet2.circuit_id) |id2| {
                if (id1 != id2) {
                    circuits[id1] = circuits[id1].? + circuits[id2].?;
                    circuits[id2] = null;
                    circuit_count -= 1;

                    // Go through and move all junction's circuits to the combined circuit
                    for (&junctions) |*junction| {
                        if (junction.circuit_id) |id| {
                            if (id == id2) {
                                junction.circuit_id = id1;
                            }
                        }
                    }
                }
            } else {
                @panic("null circuit slipped in");
            }
        } else {
            @panic("null circuit slipped in");
        }
    }

    if (circuit_count > 1) {
        @panic("Need to increase the megacache");
    }

    return @intFromFloat(distance_cache[i - 1].j1.x * distance_cache[i - 1].j2.x);
}
