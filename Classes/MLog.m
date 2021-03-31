const char* currentThreadName(void);
NSInteger currentThreadNumber(void);

static BOOL __MLogOn = NO;
static BOOL __MTimerOn = NO;
static NSTimeInterval startTime;
static NSTimeInterval lastTime;

@implementation MLogger
+ (void)initialize {
    startTime = [NSDate timeIntervalSinceReferenceDate];
    lastTime = [NSDate timeIntervalSinceReferenceDate];
#ifdef DEBUG
    __MLogOn = true;
#else
		__MLogOn = getenv("MLogOn") != nil;
	#endif
    __MTimerOn = getenv("MTimerOn") != nil;
}

+ (void)logFile:(char*)sourceFile lineNumber:(int)lineNo selector:(SEL)selector format:(NSString*)format, ... {
    va_list ap;
    if(!__MLogOn)
        return;
    va_start(ap, format);
    NSString* fileName = [[[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding] lastPathComponent];
    NSString* info = [[NSString alloc] initWithFormat:format arguments:ap];
    NSTimeInterval timeStamp = [NSDate timeIntervalSinceReferenceDate] - startTime;
    va_end(ap);
    // ignore synchronization issues for speed
    NSString* msg = [NSString stringWithFormat:@"[%s] %.4f %@:%d %@ %@\n", currentThreadName(), timeStamp, [fileName lastPathComponent], lineNo, selector == nil ? @"" : NSStringFromSelector(selector), info];
    printf("%s", [msg UTF8String]);
}

+ (void)resetTimer {
    lastTime = [NSDate timeIntervalSinceReferenceDate];
}

+ (void)timeFile:(char*)sourceFile lineNumber:(int)lineNo selector:(SEL)selector msg:(NSString*)msg {
    if(!__MTimerOn)
        return;
    NSTimeInterval timeStamp = [NSDate timeIntervalSinceReferenceDate] - startTime;
    NSString* line = [NSString stringWithFormat:@"[%s] %.4f %.4f ======== %@\n", currentThreadName(), timeStamp, [NSDate timeIntervalSinceReferenceDate] - lastTime, msg];
    printf("%s", [line UTF8String]);
    lastTime = [NSDate timeIntervalSinceReferenceDate];
}

+ (void)setLogOn:(BOOL)logOn {
    __MLogOn = logOn;
}

const char* currentThreadName(void) {
    if([[NSThread currentThread] name] == nil) {
        return [[NSString stringWithFormat:@"%d", currentThreadNumber()] UTF8String];
    }
    return [[[NSThread currentThread] name] UTF8String];
}

NSInteger currentThreadNumber(void) {
    NSString* threadString;
    NSRange numRange;
    NSUInteger numLength;

    // Somehow there doesn't seem to be an listOfArgumentsI call to return the
    // threadnumber only the name of the thread can be returned but this is NULL
    // if it is not set first!
    // Here is a bit of code to extract the thread number out of the string
    // an NSThread returns when you ask its description to be printed out
    // by NSLog. The format looks like:
    //     <NSThread: 0x10113a0>{name = (null), num = 1}
    // Basically I search for the "num = " substring, copy the remainder
    // excluding the '}' which gives me the threadnumber.
    threadString = [NSString stringWithFormat:@"%@", [NSThread currentThread]];

    numRange = [threadString rangeOfString:@"num = "];

    numLength = [threadString length] - numRange.location - numRange.length;
    numRange.location = numRange.location + numRange.length;
    numRange.length = numLength - 1;

    threadString = [threadString substringWithRange:numRange];
    return [threadString integerValue];
} /* end currentThreadNumber */
@end
