use std::time::{SystemTime, UNIX_EPOCH};
fn main() {
    // 2d const array of strings

    // const RUNTIME_LIMIT: u8 = 10;
    // let mut counter = 0;

    const SLEEP_DURATION: u8 = 1;
    let mut now = SystemTime::now();

    const DIGITS: [[&str; 10]; 7] = [
        [
            "┏━┓ ",
            "  ╻  ",
            " ┏━┓ ",
            " ┏━┓ ",
            " ╻ ╻ ",
            " ┏━┓ ",
            " ┏   ",
            " ┏━┓ ",
            " ┏━┓ ",
            " ┏━┓ ",
        ],
        [
            "┃ ┃ ",
            "  ┃  ",
            "   ┃ ",
            "   ┃ ",
            " ┃ ┃ ",
            " ┃   ",
            " ┃   ",
            "   ┃ ",
            " ┃ ┃ ",
            " ┃ ┃ ",
        ],
        [
            "┃ ┃ ",
            "  ┃  ",
            "   ┃ ",
            "   ┃ ",
            " ┃ ┃ ",
            " ┃   ",
            " ┃   ",
            "   ┃ ",
            " ┃ ┃ ",
            " ┃ ┃ ",
        ],
        [
            "┃ ┃ ",
            "  ┃  ",
            " ┏━┛ ",
            " ┣━┫ ",
            " ┗━┫ ",
            " ┗━┓ ",
            " ┣━┓ ",
            "   ┃ ",
            " ┣━┫ ",
            " ┗━┫ ",
        ],
        [
            "┃ ┃ ",
            "  ┃  ",
            " ┃   ",
            "   ┃ ",
            "   ┃ ",
            "   ┃ ",
            " ┃ ┃ ",
            "   ┃ ",
            " ┃ ┃ ",
            "   ┃ ",
        ],
        [
            "┃ ┃ ",
            "  ┃  ",
            " ┃   ",
            "   ┃ ",
            "   ┃ ",
            "   ┃ ",
            " ┃ ┃ ",
            "   ┃ ",
            " ┃ ┃ ",
            "   ┃ ",
        ],
        [
            "┗━┛ ",
            "  ╹  ",
            " ┗━━ ",
            " ┗━┛ ",
            "   ╹ ",
            " ┗━┛ ",
            " ┗━┛ ",
            "   ╹ ",
            " ┗━┛ ",
            " ┗━┛ ",
        ],
    ];

    let mut output_buff: [[&str; 8]; 7] = [
        ["┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ "],
        ["┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ "],
        ["┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "],
        ["┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "],
        ["┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ "],
        ["┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "],
        ["┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ "],
    ];

    // for i in 0..output_buff.len() {
    //     for j in 0..output_buff[i].len() {
    //         print!("{}", output_buff[i][j]);
    //     }
    //     println!("");
    // }

    // while counter <= RUNTIME_LIMIT {
    loop {
        now = SystemTime::now();
        let hour = get_hour(now, 3); // utc + 3
        let minute = get_minute(now);
        let second = now.duration_since(UNIX_EPOCH).expect("REASON").as_secs() as usize % 60;

        for i in 0..output_buff.len() {
            output_buff[i][0] = DIGITS[i][hour / 10];
            output_buff[i][1] = DIGITS[i][hour % 10];
            output_buff[i][3] = DIGITS[i][minute / 10];
            output_buff[i][4] = DIGITS[i][minute % 10];
            output_buff[i][6] = DIGITS[i][second / 10];
            output_buff[i][7] = DIGITS[i][second % 10];
        }

        for i in 0..output_buff.len() {
            for j in 0..output_buff[i].len() {
                print!("{}", output_buff[i][j]);
            }
            println!("");
        }
        // counter += SLEEP_DURATION;

        for _i in 0..output_buff.len() {
            // print!("\x1b[{}A", output_buff.len());
            print!("\x1b[{}A", 1);
        }
        std::thread::sleep(std::time::Duration::from_secs(SLEEP_DURATION as u64));
    }
}

fn get_hour(now: SystemTime, tz_diff: i8) -> usize {
    let hour = ((now.duration_since(UNIX_EPOCH).expect("REASON").as_secs() / 3600)
        .wrapping_add_signed(tz_diff.into()))
        % 24;
    return hour as usize;
}

fn get_minute(now: SystemTime) -> usize {
    let minute = now.duration_since(UNIX_EPOCH).expect("REASON").as_secs() / 60 % 60;
    return minute as usize;
}
