#import "BaseCell.h"
#import "BaseTableViewController.h"

@implementation BaseCell

- (CGFloat)height {return 44;}

+ (BOOL)selectable {return YES;}

- (void)dealloc {
    self.tableViewController = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = [[self class] selectable] ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)wasPopulatedWithDomainObject:(id)object {
}

- (void)populateWith:(id)object indexPath:(NSIndexPath*)indexPath {
    self.domainObject = object;
    [self wasPopulatedWithDomainObject:object];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.tableViewController didSelectDomainObject:self.domainObject];
}

@end
