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

fn readIntUntilNewLine(reader: std.fs.File.Reader, writer: anytype) anyerror!usize {
    var write_cnt: usize = 0;
    while (true) {
        const byte: u8 = try reader.readByte();
        if (byte == '\n') return write_cnt;

        for ('0'..'9' + 1) |int_as_chr| {
            if (int_as_chr == byte) {
                const val = byte - '0';
                try writer.writeByte(val);
            }
        }
        write_cnt = write_cnt + 1;
    }
}

pub fn main() !void {
    const rand_seed = std.time.timestamp();
    const rand_num = gen_random_num(rand_seed, 0, 255);
    var input: [10]u8 = undefined;
    var fixed_buffer_stream = std.io.fixedBufferStream(&input);
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var input_int: u64 = 0;
    const user_try_limit = 5;
    var user_try_cnt: u8 = 1;
    while (user_try_cnt <= user_try_limit) {

        // reset input buffer reading at end of block
        defer fixed_buffer_stream.reset();
        defer input_int = 0;
        defer input = undefined;

        defer user_try_cnt = user_try_cnt + 1;

        try stdout.print("please enter a number for guess (0-255): ", .{});
        const number_len = readIntUntilNewLine(stdin, fixed_buffer_stream.writer()) catch {
            try stdout.print("\ngiven input is too big\n", .{});
            try stdin.skipUntilDelimiterOrEof('\n');
            break;
        };

        if (number_len == 0) {
            continue;
        }

        for (0..number_len) |value| {
            // 123 = 1 * (10 ^ 2) + 2 * ( 10 ^ 1) + 3 * (10 ^ 0)
            // 92 = 9 * (10 ^ 1) + 2 * ( 10 ^ 0)

            input_int = input_int + input[value] * (std.math.pow(usize, 10, (number_len - value - 1)));
        }

        try stdout.print("\n", .{});

        const user_vs_rand_diff = @abs(@as(i128, input_int) - @abs(rand_num));

        if (user_vs_rand_diff == 0) {
            try stdout.print("Congratulations user, you at least try {d} times to found {d} \n", .{ user_try_cnt, input_int });
            break;
        } else {
            try stdout.print("try count {d} user entered: {d}\n", .{ user_try_cnt, input_int });

            if (user_vs_rand_diff < 10) {
                try stdout.print("hint : {s}\n", .{distance_hints[2]});
            } else if (user_vs_rand_diff < 50) {
                try stdout.print("hint : {s}\n", .{distance_hints[1]});
            } else {
                try stdout.print("hint : {s}\n", .{distance_hints[0]});
            }
        }
    }
    try stdout.print("rand number: {d}\n", .{rand_num});
}
