use ratatui::{
    backend::CrosstermBackend,
    layout::{Alignment, Constraint, Layout, Rect},
    style::{Color, Style},
    widgets::{Block, BorderType, Borders, Paragraph},
    Terminal,
};

use std::{env, process, thread, time::Duration};

fn main() -> Result<(), std::io::Error> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        println!("not enough arguments, give one integer argument to run timer");
        process::exit(1);
    }
    let duration_sec = args[1].parse::<u64>().unwrap_or_else(|_| {
        println!("can't parse input.");
        process::exit(1);
    });

    let timer_duration = Duration::from_secs(duration_sec);

    let mut terminal = Terminal::new(CrosstermBackend::new(std::io::stdout()))?;
    terminal.hide_cursor()?;

    let mut time_str = String::new();
    let start_time = std::time::Instant::now();
    let end_time = start_time + timer_duration;
    let sleep_time = Duration::from_millis(100);

    _ = terminal.clear();
    loop {
        let now = std::time::Instant::now();
        let remaining_time = end_time - now;
        if remaining_time <= Duration::from_secs(0) {
            break;
        }

        let seconds = remaining_time.as_secs();
        let mins = seconds / 60;
        let hours = mins / 60;

        time_str.clear();
        let time_str = format!("{:02}h {:02}m {:02}s", hours, mins, seconds);

        terminal.draw(|f| {
            let areas: [Rect; 2] =
                Layout::vertical([Constraint::Percentage(50), Constraint::Percentage(50)])
                    .areas(f.area());
            f.render_widget(
                Paragraph::new("").block(
                    Block::new()
                        .border_type(BorderType::Rounded)
                        .borders(Borders::LEFT | Borders::RIGHT | Borders::TOP),
                ),
                areas[0],
            );
            f.render_widget(
                Paragraph::new(time_str.as_str())
                    .style(Style::default().fg(Color::Reset))
                    .alignment(Alignment::Center)
                    .block(
                        Block::new()
                            .border_type(BorderType::Rounded)
                            .borders(Borders::LEFT | Borders::RIGHT | Borders::BOTTOM),
                    ),
                areas[1],
            );
        })?;

        thread::sleep(sleep_time);

        let _ = terminal.clear();
    }
    disable_raw_mode()?;
    let _ = terminal.clear();
    let _ = terminal.set_cursor_position((0, 0));
    Ok(())
}
