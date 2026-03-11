use crossterm::{
    cursor::{Hide, MoveTo, Show},
    event::{poll, read, Event, KeyCode, KeyEvent, KeyModifiers},
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
        if poll(Duration::from_millis(500))? {
            // It's guaranteed that the `read()` won't block when the `poll()`
            // function returns `true`
            match read()? {
                // Event::FocusGained => println!("FocusGained"),
                // Event::FocusLost => println!("FocusLost"),
                Event::Key(event) => {
                    if handle_key_event(event) {
                        break;
                    }
                }

                _ => (),
                // Event::Mouse(event) => println!("{:?}", event),
                // Event::Paste(data) => println!("Pasted {:?}", data),
                // Event::Resize(width, height) => println!("New size {}x{}", width, height),
            }
        }
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

fn handle_key_event(event: KeyEvent) -> bool {
    if event.code == KeyCode::Char('q') {
        return true;
    }
    if event.code == KeyCode::Char('c') && event.modifiers == KeyModifiers::CONTROL {
        return true;
    }
    return false;
}
