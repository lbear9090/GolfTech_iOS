#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DependencyInjector.h"

@interface BaseTableViewController : UITableViewController {
}
@property(nonatomic, weak) DependencyInjector* dependencyInjector;
@property(nonatomic, strong) NSArray* domainObjectArrays;
- (NSArray*)domainObjectsForSection:(NSUInteger)section;
- (id)domainObjectForPath:(NSIndexPath*)path;
- (NSArray*)cellClasses;

- (void)didSelectDomainObject:(id)domainObject;
@end
