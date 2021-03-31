#import <Foundation/Foundation.h>

#define AssertNotNull(ma_expr) NSAssert(ma_expr != nil, ([NSString stringWithFormat:@"%s can't be nil",#ma_expr]))

#define MINVALUE(x, y) (^{ \
__typeof__(x) my_localx = (x); \
__typeof__(y) my_localy = (y); \
return my_localx < my_localy ? (my_localx) : (my_localy); \
}())

// Decode a string that has been encoded with the following ruby command
// Prevents easy discovery by crackers of passwords etc
// "somesecret".unpack('c*').map{|c| c+3}.pack('c*')
static inline NSString *decode(char *cstring) {
    NSMutableString *result = [NSMutableString string];
    int pos = 0;
    char c;
    while((c = cstring[pos++]) != 0) {
        [result appendString:[NSString stringWithFormat:@"%c", c - 3]];
    }
    return result;
}

static inline BOOL fequal(double a, double b) {
    return fabs(a - b) < DBL_EPSILON;
}

static inline BOOL __unused fequalf(float a, float b) {
    return fabsf(a - b) < FLT_EPSILON;
}

static inline BOOL __unused fequalzero(double a) {
    return fabs(a) < DBL_EPSILON;
}

static inline BOOL __unused fequalzerof(float a) {
    return fabsf(a) < FLT_EPSILON;
}

static const int BrandedHexColor = 0x437300;
static const int LightBrandedHexColor = 0x73c600;

static inline BOOL IsAppstore() {
#ifdef APPSTORE
    return YES;
#else
    return NO;
#endif
}