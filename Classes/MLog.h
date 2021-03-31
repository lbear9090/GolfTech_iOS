#import <Foundation/Foundation.h>

// see http://www.borkware.com/rants/agentm/mlog/

@interface MLogger : NSObject {
}
+ (void)logFile:(char*)sourceFile lineNumber:(int)lineNo selector:(SEL)selector format:(NSString*)format, ...;
+ (void)timeFile:(char*)sourceFile lineNumber:(int)lineNo selector:(SEL)selector msg:(NSString*)msg;
+ (void)setLogOn:(BOOL)logOn;
+ (void)resetTimer;
@end

#ifdef DEBUG
#define Trace() \
[MLogger logFile:__FILE__ lineNumber:__LINE__ selector:_cmd format:(@"trace"),nil]
#else
#define Trace()
#endif

#ifdef DEBUG
#define MLog(s,...) \
[MLogger logFile:__FILE__ lineNumber:__LINE__ selector:_cmd format:(s),##__VA_ARGS__]
#else
#define MLog(s,...) while(NO) {}
#endif

#ifdef DEBUG
#define MCLog(s,...) \
[MLogger logFile:__FILE__ lineNumber:__LINE__ selector:nil format:(s),##__VA_ARGS__]
#else
#define MCLog(s,...)
#endif

#ifdef DEBUG
#define Time(s) \
[MLogger timeFile:__FILE__ lineNumber:__LINE__ selector:_cmd msg:(s)]
#else
#define Time(s)
#endif

#ifdef DEBUG
#define ResetTimer(s) \
[MLogger resetTimer]
#else
#define ResetTimer(s)
#endif

#ifdef DEBUG
#define CTime(s) \
[MLogger timeFile:__FILE__ lineNumber:__LINE__ selector:nil msg:(s)]
#else
#define CTime(s)
#endif

#define LogException(e) [MLogger logFile:__FILE__ lineNumber:__LINE__ selector:_cmd format:@"\n=== Exception\n%@\n%@\n% @\n\n",[e name], [e reason], [[e userInfo] description]]

#define LogError(s,...) [MLogger logFile:__FILE__ lineNumber:__LINE__ selector:_cmd format:@"\n==== Error\n" s,##__VA_ARGS__]

#define CLogError(s,...) [MLogger logFile:__FILE__ lineNumber:__LINE__ selector:nil format:@"\n==== Error\n" s,##__VA_ARGS__]