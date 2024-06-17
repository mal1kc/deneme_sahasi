use std::thread;
use std::time::{Duration, Instant};

fn cpu_stress(duration: Duration) {
    let now = Instant::now();
    while now.elapsed() < duration {
        // Perform a CPU-intensive task
        let mut x = 0;
        for _ in 0..1_000_000 {
            x = (x + 1) % 1000;
        }
    }
}

fn main() {
    let num_threads = std::thread::available_parallelism().unwrap().get();
    let duration = Duration::new(10 * 60, 0); // 10 minutes

    println!(
        "Spawning {} threads for a duration of {:?}",
        num_threads, duration
    );

    let mut handles = vec![];

    for _ in 0..num_threads {
        let handle = thread::spawn(move || {
            cpu_stress(duration);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!(
        "Completed CPU stress test for {} minutes",
        duration.as_secs() / 60
    );
}
