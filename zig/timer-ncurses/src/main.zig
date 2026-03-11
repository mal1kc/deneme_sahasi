const std = @import("std");
const ncurses = @cImport({
    @cInclude("ncurses.h");
});
const sTime = @import("sTime.zig").sTime;
const fmt = std.fmt;

const Ncolors: [11][3]c_short = .{
    .{ ncurses.COLOR_BLACK, ncurses.COLOR_WHITE, 0 }, .{ ncurses.COLOR_BLACK, ncurses.COLOR_WHITE, 0 }, // 00
    .{ ncurses.COLOR_GREEN, ncurses.COLOR_BLACK, 0 }, // h
    .{ ncurses.COLOR_WHITE, ncurses.COLOR_BLACK, 0 }, //
    .{ ncurses.COLOR_BLACK, ncurses.COLOR_WHITE, 0 }, .{ ncurses.COLOR_BLACK, ncurses.COLOR_WHITE, 0 }, // 00
    .{ ncurses.COLOR_CYAN, ncurses.COLOR_BLACK, 0 }, // m
    .{ ncurses.COLOR_WHITE, ncurses.COLOR_BLACK, 0 }, //
    .{ ncurses.COLOR_BLACK, ncurses.COLOR_WHITE, 0 }, .{ ncurses.COLOR_BLACK, ncurses.COLOR_WHITE, 0 }, // 00
    .{ ncurses.COLOR_YELLOW, ncurses.COLOR_BLACK, 0 }, // s
};

const coordinat = struct {
    x: c_int,
    y: c_int,
};

fn abs(num: isize) usize {
    if (num >= 0)
        return @intCast(num);
    return @intCast(-num);
}

pub fn main() !u8 {
    // i find argument parsing from https://ziggit.dev/t/read-command-line-arguments/220/7

    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        std.debug.print("not enought arguments, give one integer args to run timer", .{});
        return 1;
    }
    // ---

    const line = std.mem.trimRight(u8, args[1], "\r\n");
    const mins_for_target = fmt.parseUnsigned(u32, line, 10) catch
        {
            std.debug.print("can't parse input.\n", .{});
            return 1;
        };

    var time = sTime.now(3); // utc +3
    const timer_target = sTime.from_timestamp(time.timestamp + sTime.from_mins(mins_for_target, null).timestamp, 3);
    var remaining_time = sTime.from_timestamp(timer_target.timestamp - time.timestamp, 3);
    // initialize ncurses screen
    const screen = ncurses.initscr();
    defer _ = ncurses.endwin();
    _ = ncurses.noecho();
    _ = ncurses.curs_set(ncurses.FALSE);

    // set up color pairs
    _ = ncurses.start_color();

    // set up ncurses to not wait for input
    _ = ncurses.cbreak();
    _ = ncurses.nodelay(screen, true);

    var ch: c_int = undefined;
    var time_str: [11]u8 = .{ '0', '0', 'h', ' ', '0', '0', 'm', ' ', '0', '0', 's' };
    const sleep_time = std.time.ns_per_s / 10;
    var max_windows_size: coordinat = .{ .x = ncurses.getmaxx(ncurses.stdscr), .y = ncurses.getmaxy(ncurses.stdscr) };
    for (0..time_str.len) |i| {
        const temp_i: c_short = @intCast(i);
        _ = ncurses.init_pair(temp_i + 1, Ncolors[i][0], Ncolors[i][1]);
    }

    std.debug.print("Starting ncurses program...\n", .{});

    std.debug.print("timer_target time {d}\n", .{timer_target.timestamp});

    std.debug.print("time {d}\n", .{time.timestamp});

    std.debug.print("remaining_time time {d}\n", .{remaining_time.timestamp});

    while (remaining_time.timestamp > 0) {
        ch = ncurses.getch();

        if (ch != ncurses.ERR) {
            switch (ch) {
                'q' => {
                    _ = ncurses.clear();
                    _ = ncurses.move(@divFloor(max_windows_size.y, 2), @divFloor((max_windows_size.x - @as(c_int, time_str.len)), 2));
                    _ = ncurses.printw("presses q exiting ....\n");
                    _ = ncurses.refresh();
                    std.Thread.sleep(std.time.ns_per_ms * 500);
                    break;
                },
                else => continue,
            }
        }

        time.update(null);
        remaining_time.timestamp = timer_target.timestamp - time.timestamp;

        max_windows_size.x = ncurses.getmaxx(ncurses.stdscr);
        max_windows_size.y = ncurses.getmaxy(ncurses.stdscr);
        // issue is fmt puts + before all of numbers
        // solution is abs, prob i have better solution to this
        const seconds = abs(remaining_time.seconds());
        const mins = abs(remaining_time.minutes());
        const hours = abs(remaining_time.hours());

        _ = std.fmt.bufPrint(&time_str, "{:02}h {:02}m {:02}s", .{ hours, mins, seconds }) catch unreachable;

        std.debug.print("current time {s}\n", .{time_str});
        // clear the screen and print the time
        _ = ncurses.clear();
        _ = ncurses.move(@divFloor(max_windows_size.y, 2), @divFloor((max_windows_size.x - @as(c_int, time_str.len)), 2));
        for (time_str, 0..time_str.len) |c, i| {
            const temp_i: c_short = @intCast(i);
            _ = ncurses.attron(ncurses.COLOR_PAIR(temp_i + 1));
            _ = ncurses.addch(c);
            _ = ncurses.attroff(ncurses.COLOR_PAIR(temp_i + 1));
        }
        // _ = ncurses.mvprintw(@divFloor(max_windows_size.y, 2), @divFloor((max_windows_size.x - @as(c_int, time_str.len)), 2), "%s", &time_str);
        _ = ncurses.refresh();

        std.Thread.sleep(sleep_time);
    }

    return 0;
}
