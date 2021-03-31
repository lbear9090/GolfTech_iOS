#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell {
}
@property(nonatomic, weak) id tableViewController;
@property(nonatomic, strong) id domainObject;

+ (BOOL)selectable;
- (CGFloat)height;

- (id)init;
- (void)wasPopulatedWithDomainObject:(id)object;

- (void)populateWith:(id)object indexPath:(NSIndexPath*)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end
