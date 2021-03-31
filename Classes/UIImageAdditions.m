#import "UIImageAdditions.h"

@implementation UIImage (UIImageAdditions)

+ (UIImage*)checkedImageNamed:(NSString*)name {
    UIImage* result = [UIImage compatibleImageNamed:name];
    NSAssert1(result != nil, @"Couldn't load image '%@'", name);
    return result;
}

+ (UIImage*)compatibleImageNamed:(NSString*)name {
    if([[UIScreen mainScreen] bounds].size.height == 568.0) {
        NSString* extension = [name pathExtension];
        NSString* iPhone5Name = [[name stringByDeletingPathExtension] stringByAppendingString:@"-568h"];
        if(extension.length != 0)
            iPhone5Name = [iPhone5Name stringByAppendingPathExtension:extension];
        UIImage* image = [UIImage imageNamed:iPhone5Name];
        if(image)
            return image;
    }
    return [UIImage imageNamed:name];
}

@end

@implementation UIImageView (UIImageViewAdditions)

+ (UIImageView*)checkedImageViewNamed:(NSString*)name {
    return [[UIImageView alloc] initWithImage:[UIImage checkedImageNamed:name]];
}

@end
