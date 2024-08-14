#import "NSDate+RFC1123.h"

@implementation NSDate (NSDateRFC1123)

+ (nullable NSDate*) dateFromRFC1123:(nonnull NSString*)value {
    NSDate* date = nil;
    
    // setup date formatters
    static NSDateFormatter *rfc1123 = nil;
    static dispatch_once_t rfc1123_token;
    dispatch_once(&rfc1123_token, ^{
        rfc1123 = NSDateFormatter.new;
        rfc1123.locale = [NSLocale.alloc initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    });
    
    static NSDateFormatter *rfc850 = nil;
    static dispatch_once_t rfc850_token;
    dispatch_once(&rfc850_token, ^{
        rfc850 = NSDateFormatter.new;
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    });

    static NSDateFormatter *asctime = nil;
    static dispatch_once_t asctime_token;
    dispatch_once(&asctime_token, ^{
        asctime = NSDateFormatter.new;
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    });

    // try rfc1123, rfc850 and asctime formats in that order
    date = [rfc1123 dateFromString:value];
    
    if (!date) {
        date = [rfc850 dateFromString:value];
    }
    
    if (!date) {
        date = [asctime dateFromString:value];
    }
    
    return date;
}

-(nullable NSString*)rfc1123String {
    static NSDateFormatter *rfc1123 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rfc1123 = NSDateFormatter.new;
        rfc1123.locale = [NSLocale.alloc initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    });

    return [rfc1123 stringFromDate:self];
}

@end
