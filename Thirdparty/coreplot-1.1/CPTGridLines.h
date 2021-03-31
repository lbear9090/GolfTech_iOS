#import "CPTLayer.h"
#import <Foundation/Foundation.h>

@class CPTAxis;

@interface CPTGridLines : CPTLayer {
    @private
    __cpt_weak CPTAxis *axis;
    BOOL major;
}

@property (nonatomic, readwrite, assign)  CPTAxis *axis;
@property (nonatomic, readwrite) BOOL major;

@end
