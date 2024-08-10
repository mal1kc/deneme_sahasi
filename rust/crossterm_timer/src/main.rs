use crossterm::{
    cursor::{Hide, MoveTo, Show},
    execute,
    style::{Print, ResetColor},
    terminal::{
        disable_raw_mode, enable_raw_mode, size, Clear, ClearType, EnterAlternateScreen,
        LeaveAlternateScreen,
    },
};
use std::{env, process, thread, time::Duration};

fn main() -> Result<(), std::io::Error> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        println!("Usage: {} <duration in seconds>", args[0]);
        process::exit(1);
    }

    let duration_secs = args[1]
        .parse::<u64>()
        .expect("Invalid duration, please provide a number");
    let duration = Duration::from_secs(duration_secs);

    enable_raw_mode()?;
    execute!(std::io::stdout(), EnterAlternateScreen)?;

    let start_time = std::time::Instant::now();
    let end_time = start_time + duration;

    loop {
        let (width, height) = size()?;
        let now = std::time::Instant::now();
        let remaining_time = end_time - now;

        if remaining_time <= Duration::from_secs(0) {
            execute!(
                std::io::stdout(),
                Clear(ClearType::All),
                MoveTo(width / 2, height / 2),
                Hide,
                Print("Time's up!"),
            )?;
            break;
        }

        let remaining_secs = remaining_time.as_secs();
        let remaining_mins = remaining_secs / 60;
        let remaining_secs = remaining_secs % 60;

        let time_str = format!("{:02}:{:02}", remaining_mins, remaining_secs);
        execute!(
            std::io::stdout(),
            Clear(ClearType::All),
            MoveTo(width / 2, height / 2),
            Hide,
            Print(time_str)
        )?;

        thread::sleep(Duration::from_millis(100));
    }

    execute!(std::io::stdout(), LeaveAlternateScreen, ResetColor)?;
    execute!(std::io::stdout(), Show)?;
    disable_raw_mode()?;

    Ok(())
}
