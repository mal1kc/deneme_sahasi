const std = @import("std");

const rand_const_a = 922321;
const rand_const_c = 1234552;
const rand_const_m = 352521;

const distance_hints = .{
    "is too far",
    "mid range",
    "close enough",
};

fn lcg_rand(seed: i64) i64 {
    return @mod(((rand_const_a * seed) + rand_const_c), rand_const_m);
}

fn gen_random_num(seed: i64, min: comptime_float, max: comptime_float) i64 {
    const rand_init = lcg_rand(seed);
    return @as(i64, @intFromFloat((min + (@as(f64, @floatFromInt(rand_init)) / @as(f64, @floatFromInt(rand_const_m - 1)))) * (max - min)));
}

fn takeDelimHandle(reader: *std.io.Reader) ?[]u8 {
    const bare_line = reader.takeDelimiter('\n') catch |err| {
        std.log.err("{s}", .{@errorName(err)});
        return null;
    };

    return bare_line;
}

fn read_number(reader: *std.io.Reader) anyerror!usize {
    const bare_line = takeDelimHandle(reader) orelse return 0;
    const line = std.mem.trim(u8, bare_line, "\r");

    var indx: usize = 0;
    var number: usize = 0;
    while (indx < line.len) : (indx += 1) {
        if (line[indx] < '0' or line[indx] > '9') return number;
        for ('0'..'9' + 1) |int_as_chr| {
            if (int_as_chr == line[indx]) {
                const val = line[indx] - '0';
                number = val + number * 10;
            }
        }
    }
    return number;
}

pub fn main() !void {
    const rand_seed = std.time.timestamp();
    const rand_num = gen_random_num(rand_seed, 0, 255);

    var stdout_buf: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_writer.interface;

    var stdin_buf: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buf);
    const stdin = &stdin_reader.interface;

    const user_try_limit = 10;
    var user_try_cnt: u8 = 1;

    while (user_try_cnt <= user_try_limit) {
        // reset input buffer reading at end of block
        defer user_try_cnt = user_try_cnt + 1;

        try stdout.writeAll("please enter a number for guess (0-255): \n");

        try stdout.flush();
        const guess = read_number(stdin) catch |err| {
            std.log.err("{s}", .{@errorName(err)});
            try stdout.writeAll("\ngiven input is too big\n");
            try stdout.flush();
            continue;
        };

        try stdout.writeAll("\n");

        const user_vs_rand_diff = @abs(@as(i128, guess) - @abs(rand_num));

        if (user_vs_rand_diff == 0) {
            try stdout.print("Congratulations user, you at least try {d} times to found {d} \n", .{ user_try_cnt, guess });
            break;
        } else {
            try stdout.print("try count {d} user entered: {d}\n", .{ user_try_cnt, guess });

            if (user_vs_rand_diff < 10) {
                try stdout.print("hint : {s}\n", .{distance_hints[2]});
            } else if (user_vs_rand_diff < 50) {
                try stdout.print("hint : {s}\n", .{distance_hints[1]});
            } else {
                try stdout.print("hint : {s}\n", .{distance_hints[0]});
            }
        }

        try stdout.flush();
    }
    try stdout.print("rand number: {d}\n", .{rand_num});
    try stdout.flush();
}
