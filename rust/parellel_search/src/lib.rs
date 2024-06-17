use std::sync::{Arc, Mutex};
use std::thread;

fn search_in_chunk(text: &str, pattern: &str, start: usize, end: usize) -> Option<usize> {
    let chunk = &text[start..end];
    chunk.find(pattern).map(|index| start + index)
}

pub fn parallel_search(text: &str, pattern: &str, num_threads: usize) -> Option<usize> {
    let text_len = text.len();
    let pattern_len = pattern.len();
    if text_len < pattern_len {
        return None;
    }

    let chunk_size = (text_len + num_threads - 1) / num_threads; // Ceiling division
    let text = Arc::new(text.to_string());
    let pattern = Arc::new(pattern.to_string());
    let result = Arc::new(Mutex::new(None));

    let mut handles = vec![];

    for i in 0..num_threads {
        let text = Arc::clone(&text);
        let pattern = Arc::clone(&pattern);
        let result = Arc::clone(&result);
        let start = i * chunk_size;
        let mut end = usize::min((i + 1) * chunk_size + pattern_len - 1, text_len);

        if start + pattern_len > text_len {
            end = text_len;
        }

        let handle = thread::spawn(move || {
            if let Some(index) = search_in_chunk(&text, &pattern, start, end) {
                let mut result = result.lock().unwrap();
                if result.is_none() || index < result.unwrap() {
                    *result = Some(index);
                }
            }
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let result = result.lock().unwrap();
    *result
}

#[cfg(test)]
mod tests;
