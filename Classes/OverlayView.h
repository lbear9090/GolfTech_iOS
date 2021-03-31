//
//  OverlayView.h
//  Golf
//
//  Created by Thomas Söderberg on 3/17/14.
//
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView
@property(nonatomic, strong) NSMutableArray* overlayObjects;
- (void)undoLatest;
- (void)eraseAll;
@property(nonatomic) BOOL dualMode;
@end
