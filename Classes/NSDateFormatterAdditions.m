#import "NSDateFormatterAdditions.h"

@implementation NSDateFormatter (NSDateFormatterAdditions)

+ (NSDateFormatter*)monthDayFormatter {
    NSDateFormatter* result = [[NSDateFormatter class] new];
    [result setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"Md" options:0 locale:[NSLocale currentLocale]]];
    return result;
}

@end
