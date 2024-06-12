const std = @import("std");
const ncurses = @import("ncurses.zig");

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

fn abs(num: isize) usize {
    if (num >= 0)
        return @intCast(num);
    return @intCast(num * -1);
}

const coordinat = struct {
    x: c_int,
    y: c_int,
};

fn ncurses_write_char_with_cpair(c: c_uint, c_pair: c_int) void {
    _ = ncurses.attrset(c_pair);
    _ = ncurses.addch(c);
    _ = ncurses.attrset(ncurses.A_NORMAL);
}

pub fn main() anyerror!void {
    std.debug.print("Starting ncurses program...\n", .{});
    // initialize ncurses
    const screen = ncurses.initscr();
    defer ncurses.endwin();
    // _ = ncurses.noecho();
    _ = ncurses.curs_set(ncurses.FALSE);

    // set up color pairs
    _ = ncurses.start_color();
    _ = ncurses.init_pair(1, ncurses.COLOR_RED, ncurses.COLOR_BLACK);
    _ = ncurses.init_pair(2, ncurses.COLOR_GREEN, ncurses.COLOR_BLACK);

    // set up ncurses to not wait for input
    _ = ncurses.cbreak();
    _ = ncurses.nodelay(screen, true);

    var time = sTime.now(3); // utc +3
    var time_str: [8]u8 = .{ '0', '0', ':', '0', '0', ':', '0', '0' };
    const sleep_time = std.time.ns_per_s / 10;
    var max_windows_size: coordinat = .{ .x = ncurses.getmaxx(ncurses.stdscr), .y = ncurses.getmaxy(ncurses.stdscr) };
    var color_pair: c_int = 1;

    while (true) {
        time.update(null);

        max_windows_size.x = ncurses.getmaxx(ncurses.stdscr);
        max_windows_size.y = ncurses.getmaxy(ncurses.stdscr);
        // issue is fmt puts + before all of numbers
        // solution is abs, prob i have better solution to this
        const seconds = abs(time.seconds());
        const mins = abs(time.minutes());
        const hours = abs(time.hours());

        _ = std.fmt.bufPrint(&time_str, "{:02}:{:02}:{:02}", .{ hours, mins, seconds }) catch unreachable;

        std.debug.print("current time {s}\n", .{time_str});
        // clear the screen and print the time
        _ = ncurses.clear();
        _ = ncurses.move(@divFloor(max_windows_size.y, 2), @divFloor((max_windows_size.x - @as(c_int, time_str.len)), 2));
        for (time_str) |c| {
            ncurses_write_char_with_cpair(c, color_pair);
            color_pair = 3 - color_pair;
        }
        // _ = ncurses.mvprintw(@divFloor(max_windows_size.y, 2), @divFloor((max_windows_size.x - @as(c_int, time_str.len)), 2), "%s", &time_str);
        _ = ncurses.refresh();

        std.time.sleep(sleep_time);
    }
}
