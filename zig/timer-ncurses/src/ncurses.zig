const c = @cImport({
    @cInclude("ncurses.h");
});
pub usingnamespace c;

pub const Ncolors: [11][3]c_short = .{
    .{ c.COLOR_BLACK, c.COLOR_WHITE, 0 }, .{ c.COLOR_BLACK, c.COLOR_WHITE, 0 }, // 00
    .{ c.COLOR_GREEN, c.COLOR_BLACK, 0 }, // h
    .{ c.COLOR_WHITE, c.COLOR_BLACK, 0 }, //
    .{ c.COLOR_BLACK, c.COLOR_WHITE, 0 }, .{ c.COLOR_BLACK, c.COLOR_WHITE, 0 }, // 00
    .{ c.COLOR_CYAN, c.COLOR_BLACK, 0 }, // m
    .{ c.COLOR_WHITE, c.COLOR_BLACK, 0 }, //
    .{ c.COLOR_BLACK, c.COLOR_WHITE, 0 }, .{ c.COLOR_BLACK, c.COLOR_WHITE, 0 }, // 00
    .{ c.COLOR_YELLOW, c.COLOR_BLACK, 0 }, // s
};
