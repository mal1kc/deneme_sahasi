use ratatui::{
    backend::CrosstermBackend,
    crossterm::{
        event::{self, KeyCode, KeyEvent, KeyModifiers},
        terminal::{disable_raw_mode, enable_raw_mode},
    },
    layout::{Alignment, Constraint, Layout, Rect},
    style::{Color, Style},
    widgets::{Block, BorderType, Borders, Paragraph},
    Terminal,
};

use std::{
    thread,
    time::{Duration, SystemTime, UNIX_EPOCH},
};

fn get_time(now: SystemTime, tzdiff: i8) -> (u64, u64, u64) {
    let secs = now.duration_since(UNIX_EPOCH).expect("REASON").as_secs();
    let mins = secs / 60;
    let hours = (mins / 60).wrapping_add_signed(tzdiff.into()) % 24;
    (hours, mins % 60, secs % 60)
}

fn main() -> Result<(), std::io::Error> {
    enable_raw_mode()?;
    let mut terminal = Terminal::new(CrosstermBackend::new(std::io::stdout()))?;
    terminal.hide_cursor()?;

    let sleep_time = Duration::from_millis(1000);
    let poll_timeout = Duration::from_millis(100);
    _ = terminal.clear();
    let mut running = true;
    while running {
        let now = SystemTime::now();
        let (hours, minutes, seconds) = get_time(now, 3);

        let time_str = format!("{:02}h {:02}m {:02}s", hours, minutes, seconds);

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

        if event::poll(poll_timeout)? {
            if let Ok(event::Event::Key(KeyEvent {
                code: KeyCode::Char('q'),
                modifiers: KeyModifiers::NONE,
                ..
            })) = event::read()
            {
                running = false;
            }
        }
        if running {
            thread::sleep(sleep_time - poll_timeout);
            let _ = terminal.clear();
        }
    }

    disable_raw_mode()?;
    let _ = terminal.clear();
    let _ = terminal.set_cursor_position((0, 0));
    Ok(())
}
