use parellel_search::parallel_search;

fn main() {
    let num_threads = 4;

    // Best case: pattern is at the beginning
    let text = "abcdefghij";
    let pattern = "abc";
    match parallel_search(text, pattern, num_threads) {
        Some(index) => println!("Best case: Found pattern at index {}", index),
        None => println!("Best case: Pattern not found"),
    }

    // Worst case: pattern is at the end
    let text = "abcdefghij";
    let pattern = "hij";
    match parallel_search(text, pattern, num_threads) {
        Some(index) => println!("Worst case: Found pattern at index {}", index),
        None => println!("Worst case: Pattern not found"),
    }

    // No match case
    let text = "abcdefghij";
    let pattern = "xyz";
    match parallel_search(text, pattern, num_threads) {
        Some(index) => println!("No match case: Found pattern at index {}", index),
        None => println!("No match case: Pattern not found"),
    }
}
