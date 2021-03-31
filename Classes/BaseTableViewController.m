#import "BaseTableViewController.h"
#import "BaseCell.h"

@interface BaseTableViewController ()
@end


@implementation BaseTableViewController

- (id)init {
    NSAssert(false, @"This in never used");
    self = [super init];
    return self;
}

- (void)loadView {
    [super loadView];
    self.tableView.delegate = self;
    for(Class clazz in self.cellClasses) {
        NSString* className = NSStringFromClass(clazz);
        NSString* path = [[NSBundle mainBundle] pathForResource:className ofType:@"xib"];
        if(path != nil) {
            UINib* nib = [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
            [self.tableView registerNib:nib forCellReuseIdentifier:className];
        } else {
            [self.tableView registerClass:clazz forCellReuseIdentifier:className];
        }
    }
}

- (NSArray*)cellClasses {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSArray*)domainObjectsForSection:(NSUInteger)section {
    return [self domainObjectArrays][section];
}

- (id)domainObjectForPath:(NSIndexPath*)path {
    return [self domainObjectsForSection:path.section][path.row];
}

- (void)didSelectDomainObject:(id)domainObject {
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return [self.cellClasses count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self domainObjectsForSection:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Class cellClass = (self.cellClasses)[indexPath.section];
    BaseCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    AssertNotNull(cell);
    cell.tableViewController = self;
    [self.dependencyInjector autowire:cell];
    [cell populateWith:[self domainObjectForPath:indexPath] indexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if([cell isKindOfClass:[BaseCell class]]) {
    return [(BaseCell*)cell height];
    } else {
        return 44.0;
    }
    
//	if([[self domainObjectForPath:indexPath] respondsToSelector:@selector(height)])
//	   return [[self domainObjectForPath:indexPath] height];
//	return [[self.cellClasses objectAtIndex:indexPath.section] height];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell didSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)path {
    return [(self.cellClasses)[path.section] selectable] ? path : nil;
}

@end
