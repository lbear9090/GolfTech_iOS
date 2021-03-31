#import "VideoCell.h"
#import "UIImageAdditions.h"
#import "NSObject+NSObjectGPSObservation.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation VideoCell {
    id _previousDomainObject;
}

- (CGFloat)height {return [self contentHeight] + [self rowSpacing];}

- (float)rowSpacing {
    return 8.0;
}

- (float)contentHeight {
    return 74.0;
}

+ (BOOL)selectable {return NO;}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.backgroundColor = UIColor.greenColor;

    UIImageView* bg = [UIImageView checkedImageViewNamed:@"bakgrund teknik"];
    [self.contentView addSubview:bg];
    [self.contentView sendSubviewToBack:bg];

    self.imagePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imagePlayButton addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.imagePlayButton];

    self.play = [UIImageView checkedImageViewNamed:@"knapp spela video cirkel"];
    self.play.contentMode = UIViewContentModeCenter;
    self.play.alpha = 0.5;
    [self.imagePlayButton addSubview:self.play];

    self.summaryText = [[UITextView alloc] initWithFrame:CGRectZero];
    self.summaryText.contentInset = UIEdgeInsetsMake(3, -8, 0, -8);
    self.summaryText.opaque = NO;
    self.summaryText.userInteractionEnabled = NO;
    self.summaryText.backgroundColor = [UIColor clearColor];
    self.summaryText.font = [UIFont boldSystemFontOfSize:13];
    self.summaryText.scrollEnabled = NO;
    self.summaryText.editable = NO;

    [self.contentView addSubview:self.summaryText];

     self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage checkedImageNamed:@"knapp hogerpil"] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(disclosurePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton sizeToFit];
     self.selectButton.frame = CGRectInset(self.selectButton.frame, -6, -4);
    if(!IPAD) {
        [self.contentView addSubview:self.selectButton];
    }
    UIView* touchArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 74)];
    [self.contentView addSubview:touchArea];
    [touchArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPressed:)]];

    self.backgroundView = [UIView new];

    return self;
}

- (void)dealloc {
    [self unregisterFromAllObservations];
}

- (Technique*)videoItem {
    return self.domainObject;
}

- (void)wasPopulatedWithDomainObject:(id)aTechnique {
    NSAssert(aTechnique == self.domainObject, @"Internal errror");

    [self.imagePlayButton setBackgroundImage:self.videoItem.image forState:UIControlStateNormal];

    NSString* yourString = [NSString stringWithFormat:@"%@ – %@", self.videoItem.title, self.videoItem.summary];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:yourString];
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, yourString.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, self.videoItem.title.length)];
    [attrString endEditing];
    self.summaryText.attributedText = attrString;

    [self unregisterAsObserverOf:_previousDomainObject];
    _previousDomainObject = aTechnique;
    [self registerAsObserverOf:aTechnique forKeyPath:@"state" options:(NSKeyValueObservingOptions) 0];
    [self update];
}

- (void)playPressed:(id)sender {
    if(IPAD) {
        for (UITableViewCell *cell in [self.tableViewController tableView].visibleCells) {
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
        [self setHighlighted:true];
    }
    [self.tableViewController playVideo:self.videoItem];
}

- (void)disclosurePressed:(id)sender {
    [self.tableViewController showVideoPage:self.videoItem];
}

- (void)update {
    [self.play removeFromSuperview];
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    self.play = @[[UIImageView checkedImageViewNamed:@"knapp ladda ner"], spinner, [UIImageView checkedImageViewNamed:@"knapp spela video cirkel"]][self.state];
    self.play.contentMode = UIViewContentModeCenter;
    self.play.alpha = 0.7;
    self.play.frame = [self playButtonFrame];
    [self.imagePlayButton addSubview:self.play];
}

- (CGRect)playButtonFrame {
    return self.imagePlayButton.bounds;
}

- (TechniqueState)state {
    return [(Technique*) self.domainObject state];
}

- (void)notifyState:(NSDictionary*)change __unused {
    [self update];
}

@end
