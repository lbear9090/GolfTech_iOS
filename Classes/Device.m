#import "Device.h"

@implementation Device {
}

- (BOOL)isLongphone {
    return UIScreen.mainScreen.bounds.size.height > 480.0;
}

@end