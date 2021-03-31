#import "ViewBuilder.h"
#import "AbstractRecordingsController.h"
#import "Recording.h"
#import "RecordingCell.h"
#import "UILabelAdditions.h"
#import "UIImageAdditions.h"
#import "ProVideo.h"
static const float ImageSide = 110.0;
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface RecordingCell () <UITextViewDelegate>
@end

@implementation RecordingCell {
    UIImageView* _backGround;
    
}

+ (BOOL)selectable {return NO;}

- (CGFloat)height {return ImageSide + 8.0f;}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];

    _backGround = [UIImageView checkedImageViewNamed:@"bakgrund teknik"];
   // [self.contentView addSubview:_backGround];
   // [self.contentView sendSubviewToBack:_backGround];

    [self createPlayButton];
    [self createSelectButton];
  
    self.titleLabel = [UILabel labelWithText:@"X" fontSize:15 textColor:UIColor.blackColor backgroundColor:UIColor.clearColor toView:self.contentView];
    self.titleLabel.highlightedTextColor = UIColor.whiteColor;
    self.titleLabel.text = @"X";
    self.titleLabel.backgroundColor = [UIColor clearColor];

    self.summaryText = [[UITextView alloc] initWithFrame:CGRectZero];
    self.summaryText.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8);
    if([self.summaryText respondsToSelector:@selector(setTextContainerInset:)])
        self.summaryText.textContainerInset = UIEdgeInsetsMake(4, 3, 0, 0);
    self.summaryText.opaque = NO;
    self.summaryText.backgroundColor = [UIColor clearColor];
    self.summaryText.font = [UIFont boldSystemFontOfSize:15];
    self.summaryText.scrollEnabled = NO;
    self.summaryText.delegate = self;
    self.summaryText.editable = NO;
    [self.contentView addSubview:self.summaryText];

    self.backgroundView = [UIView new];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPressed:)]];
    


    return self;
}

- (void)textViewDidEndEditing:(UITextView*)textView {
    self.videoItem.summary = self.summaryText.text;
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    bool result = [super pointInside:point withEvent:event];
    if(!result)
        [self.summaryText resignFirstResponder];
    return result;
}

- (void)playPressed:(id)sender {
    if(IPAD) {
    for (UITableViewCell *cell in [self.tableViewController tableView].visibleCells) {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
     [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
    }
    [self.tableViewController playPressed:self.domainObject];
}

- (void)createSelectButton {
    if(!self.isMyRecording)
        return;
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage checkedImageNamed:@"knapp action"] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton sizeToFit];
    self.selectButton.frame = CGRectInset(self.selectButton.frame, -6, -20);
    [self.contentView addSubview:self.selectButton];
}

- (void)createPlayButton {
    self.imagePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [(id) self.imagePlayButton addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.imagePlayButton];
}

- (void)setPreviewImage:(UIImage*)image {
    [(id) self.imagePlayButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)sharePressed:(id)sender {
    
    NSArray *dataToShare = @[[NSString stringWithFormat:NSLocalizedString(@"Dela email", nil), self.videoItem.title, self.videoItem.summary], [NSURL fileURLWithPath:self.videoItem.videoPath]];

    if(IPAD) {
            [self.tableViewController sharePressed:self.videoItem];
     
    } else {
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeMessage];

    [self.tableViewController presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect slice, remainder;
    CGRectDivide(self.contentView.bounds, &slice, &remainder, _backGround.bounds.size.height - 5, CGRectMaxYEdge);
    _backGround.frame = slice;

    ViewBuilder* builder = nil;
    if(IPAD) {
        builder = [ViewBuilder horizontalBuilderForFrame:CGRectMake(0, 0, 290, ImageSide)];
    } else {
        builder = [ViewBuilder horizontalBuilderForFrame:CGRectMake(0, 0, 320, ImageSide)];
    }
   
    [builder addSpace:ImageSide];
    [builder addSpace:8];
    [builder addFlexibleSpaceWithFactor:1];
    [builder addSpace:8];
    if(!self.selectButton.hidden) {
        [builder addCenteredView:self.selectButton];
        [builder addSpace:8];
    }
    ViewBuilderResult* result = [builder build];
    self.imagePlayButton.frame = [result frameAtIndex:0];
    CGRect textFrame = [result frameAtIndex:2];
    if(!self.selectButton.hidden)
        self.selectButton.frame = [result frameAtIndex:4];

    ViewBuilder* textFrameBuilder = [ViewBuilder verticalBuilderForFrame:textFrame];
    [textFrameBuilder addSpace:22];
    [textFrameBuilder addSpace:self.titleLabel.frame.size.height];
    [textFrameBuilder addSpace:8];
    [textFrameBuilder addFlexibleSpaceWithFactor:1];
    [textFrameBuilder addSpace:22];
    ViewBuilderResult* textFrameResults = [textFrameBuilder build];
    self.titleLabel.frame = [textFrameResults frameAtIndex:1];
    self.summaryText.frame = [textFrameResults frameAtIndex:3];
}

- (id <VideoItem>)videoItem {
    return self.domainObject;
}

- (NSOperationQueue *)drawThumbnailsQueue {
    static NSOperationQueue *queue = nil;
    if(queue != nil)
        return queue;
    queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1;
    return queue;
}

- (void)wasPopulatedWithDomainObject:(id)object {
    RecordingCell __weak* weakSelf = self;
    [self.drawThumbnailsQueue addOperationWithBlock:^{
        UIImage* __block image = weakSelf.videoItem.image;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakSelf.previewImage = image;
        }];
    }];

    self.titleLabel.text = self.videoItem.title;
    self.summaryText.text = self.videoItem.summary;
    
    self.selectButton.hidden = !self.isMyRecording;
    self.summaryText.editable = self.isMyRecording;
    self.summaryText.userInteractionEnabled = self.isMyRecording;
}

- (BOOL)isMyRecording {
    return ![self.videoItem isMemberOfClass:ProVideo.class];
}

@end