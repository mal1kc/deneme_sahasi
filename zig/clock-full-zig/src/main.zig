const std = @import("std");
const expect = @import("std").testing.expect;

pub const sTime = struct {
    timestamp: i64,
    tzdiff: ?i16,

    pub fn update(self: *sTime, tzdiff: ?i8) void {
        if (self.tzdiff == null and tzdiff != null) {
            self.tzdiff = @as(i16, tzdiff.?);
            return self.update(null);
        } else if (self.tzdiff != null) {
            self.timestamp = std.time.timestamp() + self.tzdiff.? * std.time.s_per_hour;
            return;
        }
        self.timestamp = std.time.timestamp();
        return;
    }

    pub fn utcnow() sTime {
        return sTime{ .timestamp = std.time.timestamp() };
    }
    pub fn now(tzdiff: i8) sTime {
        return sTime{ .timestamp = std.time.timestamp() + @as(i16, tzdiff) * std.time.s_per_hour, .tzdiff = tzdiff };
    }

    pub fn hours(self: *sTime) i64 {
        // integer part of division is the hours
        return @mod(@divTrunc(self.timestamp, std.time.s_per_hour), 24);
    }

    pub fn minutes(self: *sTime) i64 {
        return @mod(@divTrunc(self.timestamp, std.time.s_per_min), 60);
    }

    pub fn seconds(self: *sTime) i64 {
        return @mod(self.timestamp, 60);
    }
};

test "test hours" {
    var currentTime = sTime{ .timestamp = 0 };
    const hours = currentTime.hours();
    try expect(hours == 0);
}

test "test minutes" {
    var currentTime = sTime{ .timestamp = 0 };
    const minutes = currentTime.minutes();
    try expect(minutes == 0);
}

test "test seconds" {
    var currentTime = sTime{ .timestamp = 0 };
    const seconds = currentTime.seconds();
    try expect(seconds == 0);
}

test "test hours 1" {
    var currentTime = sTime{ .timestamp = std.time.s_per_hour };
    const hours = currentTime.hours();
    try expect(hours == 1);
}

test "test minutes 1" {
    var currentTime = sTime{ .timestamp = std.time.s_per_min };
    const minutes = currentTime.minutes();
    try expect(minutes == 1);
}

test "test seconds 1" {
    var currentTime = sTime{ .timestamp = 1 };
    const seconds = currentTime.seconds();
    try expect(seconds == 1);
}

test "test hours 24" {
    var currentTime = sTime{ .timestamp = std.time.s_per_hour * 24 };
    const hours = currentTime.hours();
    try expect(hours == 0);
}

test "test minutes 60" {
    var currentTime = sTime{ .timestamp = std.time.s_per_min * 60 };
    const minutes = currentTime.minutes();
    try expect(minutes == 0);
}

test "test seconds 60" {
    var currentTime = sTime{ .timestamp = 60 };
    const seconds = currentTime.seconds();
    try expect(seconds == 0);
}

test "test tzdiff" {
    var utcTime = sTime.utcnow();
    var utc3Time = sTime.now(3);
    try expect(utcTime.hours() + 3 == utc3Time.hours());
}

fn abs(num: isize) usize {
    if (num >= 0)
        return @intCast(num);
    return @intCast(num * -1);
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // const runtime_sec = 300; // limit the runtime to 30 seconds
    // var counter: i32 = 0;

    const sleep_time = std.time.ns_per_s / 10;

    // FIXME: 1 sn sleep cause broken printing (like mostly nothing prints hanging)
    // -- Solution is divide by ten

    const tzdiff = 3; // in Türkiye , UTC + 3

    var current_time = sTime.now(tzdiff);

    const digits = [_][10][]const u8{
        .{ "┏━┓ ", "  ╻  ", " ┏━┓ ", " ┏━┓ ", " ╻ ╻ ", " ┏━┓ ", " ┏   ", " ┏━┓ ", " ┏━┓ ", " ┏━┓ " }, // "   " },
        .{ "┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ " }, // " ╻ " },
        .{ "┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ " }, // "   " },
        .{ "┃ ┃ ", "  ┃  ", " ┏━┛ ", " ┣━┫ ", " ┗━┫ ", " ┗━┓ ", " ┣━┓ ", "   ┃ ", " ┣━┫ ", " ┗━┫ " }, // "   " },
        .{ "┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ " }, // "   " },
        .{ "┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ " }, // " ╹ " },
        .{ "┗━┛ ", "  ╹  ", " ┗━━ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ " }, // "   " },
    };

    var output_buffer = [_][8][]const u8{
        .{ "┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ " },
        .{ "┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ " },
        .{ "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ " },
        .{ "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ " },
        .{ "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ " },
        .{ "┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ " },
        .{ "┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ " },
    };

    // loop through each digit in the line
    // while (runtime_sec > counter) {

    while (true) {
        current_time = sTime.now(tzdiff);

        for (0..output_buffer.len) |row_i| {
            // output_buffer[row_i][0] = digits[row_i][current_time.hours() / 10];
            // output_buffer[row_i][1] = digits[row_i][current_time.hours() % 10];

            // output_buffer[row_i][3] = digits[row_i][current_time.minutes() / 10];
            // output_buffer[row_i][4] = digits[row_i][current_time.minutes() % 10];

            // output_buffer[row_i][6] = digits[row_i][current_time.seconds() / 10];
            // output_buffer[row_i][7] = digits[row_i][current_time.seconds() % 10];

            output_buffer[row_i][0] = digits[row_i][abs(@divTrunc(current_time.hours(), 10))];
            output_buffer[row_i][1] = digits[row_i][abs(@mod(current_time.hours(), 10))];

            output_buffer[row_i][3] = digits[row_i][abs(@divTrunc(current_time.minutes(), 10))];
            output_buffer[row_i][4] = digits[row_i][abs(@mod(current_time.minutes(), 10))];

            output_buffer[row_i][6] = digits[row_i][abs(@divTrunc(current_time.seconds(), 10))];
            output_buffer[row_i][7] = digits[row_i][abs(@mod(current_time.seconds(), 10))];
        }

        for (output_buffer) |row| {
            // loop through each element of the row
            for (row) |element| {
                try stdout.print("{s}", .{element});
            }
            try stdout.print("\n", .{});
        }

        // counter += 1;

        // clear the terminal
        for (0..output_buffer.len) |row_i| {
            _ = row_i;
            // top of the terminal
            // try stdout.print("\x1B[{d}A", .{output_buffer.len});
            try stdout.print("\x1B[{d}A", .{1}); // current line
        }
        // sleep 1/5 second
        std.time.sleep(sleep_time);
    }

    try bw.flush(); // don't forget to flush!
}

fn eql(comptime T: type, a: []const T, b: []const T) bool {
    if (a.len != b.len) return false;
    if (a.ptr == b.ptr) return true;
    for (a, b) |a_elem, b_elem| {
        if (a_elem != b_elem) return false;
    }
    return true;
}

test "test slice" {
    const digits = [_][11][]const u8{
        .{ "┏━┓ ", "  ╻  ", " ┏━┓ ", " ┏━┓ ", " ╻ ╻ ", " ┏━┓ ", " ┏   ", " ┏━┓ ", " ┏━┓ ", " ┏━┓ ", "   " },
        .{ "┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ ", " ╻ " },
        .{ "┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ ", "   " },
        .{ "┃ ┃ ", "  ┃  ", " ┏━┛ ", " ┣━┫ ", " ┗━┫ ", " ┗━┓ ", " ┣━┓ ", "   ┃ ", " ┣━┫ ", " ┗━┫ ", "   " },
        .{ "┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", "   " },
        .{ "┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ╹ " },
        .{ "┗━┛ ", "  ╹  ", " ┗━━ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   " },
    };

    try expect(eql(u8, digits[0][1], "  ╻  "));
    // std.log.warn("digit 0,1 : {s}", .{digits[0][1]});
    try expect(eql(u8, digits[1][1], "  ┃  "));
    // std.log.warn("digit 1,1 : {s}", .{digits[1][1]});
    try expect(eql(u8, digits[2][1], "  ┃  "));
    try expect(eql(u8, digits[3][1], "  ┃  "));
    try expect(eql(u8, digits[4][1], "  ┃  "));
    try expect(eql(u8, digits[5][1], "  ┃  "));
    try expect(eql(u8, digits[6][1], "  ╹  "));
}

test "test is time updating" {
    var currentTime = sTime.utcnow();
    var lastTime = sTime.utcnow();

    try expect(currentTime.hours() == lastTime.hours());
}
