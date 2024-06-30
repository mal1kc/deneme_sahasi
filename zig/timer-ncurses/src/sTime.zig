const std_time = @import("std").time;

pub const sTime = struct {
    timestamp: i64,
    tzdiff: ?i16,

    pub fn update(self: *sTime, tzdiff: ?i8) void {
        if (self.tzdiff == null and tzdiff != null) {
            self.tzdiff = @as(i16, tzdiff.?);
            return self.update(null);
        } else if (self.tzdiff != null) {
            self.timestamp = std_time.timestamp() + self.tzdiff.? * std_time.s_per_hour;
            return;
        }
        self.timestamp = std_time.timestamp();
        return;
    }

    pub fn utcnow() sTime {
        return sTime{ .timestamp = std_time.timestamp() };
    }
    pub fn now(tzdiff: i8) sTime {
        return sTime{ .timestamp = std_time.timestamp() + @as(i16, tzdiff) * std_time.s_per_hour, .tzdiff = tzdiff };
    }

    pub fn from_timestamp(timestamp: i64, tzdiff: ?i16) sTime {
        return sTime{ .timestamp = timestamp, .tzdiff = tzdiff };
    }

    pub fn from_mins(mins: i64, tzdiff: ?i16) sTime {
        return sTime{ .timestamp = mins * std_time.s_per_min, .tzdiff = tzdiff };
    }

    pub fn hours(self: *sTime) i64 {
        // integer part of division is the hours
        return @mod(@divTrunc(self.timestamp, std_time.s_per_hour), 24);
    }

    pub fn minutes(self: *sTime) i64 {
        return @mod(@divTrunc(self.timestamp, std_time.s_per_min), 60);
    }

    pub fn seconds(self: *sTime) i64 {
        return @mod(self.timestamp, 60);
    }
};
