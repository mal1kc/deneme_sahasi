use std::time::{SystemTime, UNIX_EPOCH};

pub struct STime {
    pub timestamp: i64,
    tzdiff: Option<i16>,
}

impl STime {
    pub fn update(&mut self, tzdiff: Option<i8>) {
        if let Some(tzdiff) = tzdiff {
            self.tzdiff = Some(tzdiff as i16);
            self.update(None);
        } else if let Some(tzdiff) = self.tzdiff {
            self.timestamp = Self::now(tzdiff as i8).timestamp;
        } else {
            self.timestamp = Self::utcnow().timestamp;
        }
    }

    pub fn utcnow() -> Self {
        Self {
            timestamp: SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("Failed to get system time")
                .as_secs() as i64,
            tzdiff: None,
        }
    }

    pub fn now(tzdiff: i8) -> Self {
        Self {
            timestamp: SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("Failed to get system time")
                .as_secs() as i64
                + tzdiff as i64 * 3600,
            tzdiff: Some(tzdiff as i16),
        }
    }

    pub fn from_timestamp(timestamp: i64, tzdiff: Option<i16>) -> Self {
        Self { timestamp, tzdiff }
    }

    pub fn from_mins(mins: i64, tzdiff: Option<i16>) -> Self {
        Self {
            timestamp: mins * 60,
            tzdiff,
        }
    }

    pub fn hours(&self) -> i64 {
        (self.timestamp / 3600) % 24
    }

    pub fn minutes(&self) -> i64 {
        (self.timestamp / 60) % 60
    }

    pub fn seconds(&self) -> i64 {
        self.timestamp % 60
    }
}
