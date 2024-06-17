#[cfg(test)]
mod tests {
    use crate::parallel_search;

    #[test]
    fn test_best_case() {
        let text = "abcdefghij";
        let pattern = "abc";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), Some(0));
    }

    #[test]
    fn test_worst_case() {
        let text = "abcdefghij";
        let pattern = "hij";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), Some(7));
    }

    #[test]
    fn test_no_match_case() {
        let text = "abcdefghij";
        let pattern = "xyz";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), None);
    }

    #[test]
    fn test_pattern_longer_than_text() {
        let text = "abc";
        let pattern = "abcdef";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), None);
    }

    #[test]
    fn test_empty_pattern() {
        let text = "abcdefghij";
        let pattern = "";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), Some(0));
    }

    #[test]
    fn test_empty_text() {
        let text = "";
        let pattern = "abc";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), None);
    }

    #[test]
    fn test_pattern_in_middle() {
        let text = "abcdefghij";
        let pattern = "def";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), Some(3));
    }

    #[test]
    fn test_overlapping_pattern() {
        let text = "abcabcabc";
        let pattern = "cab";
        let num_threads = 4;
        assert_eq!(parallel_search(text, pattern, num_threads), Some(2));
    }
}
