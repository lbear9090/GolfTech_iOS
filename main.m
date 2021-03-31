#import "AppDelegate.h"

int main(int argc, char* argv[]) {
    ResetTimer();
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
        return retVal;
    }
}
