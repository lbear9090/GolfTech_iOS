#import "EnterScoreController.h"
#import "UILabelAdditions.h"
#import "UIViewAdditions.h"

@interface EnterScoreController ()
@property(nonatomic, strong) UIPickerView* picker;
@property(nonatomic, assign) NSUInteger newScore;
@end


@implementation EnterScoreController

- (id)init {
    self = [super init];
    return self;
}

- (void)loadView {
    [super loadView];
    AssertNotNull(self.exercise.title);
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];

    self.navigationItem.title = NSLocalizedString(@"Nytt resultat", nil);

    UILabel* title = [UILabel labelWithBoldText:self.exercise.title fontSize:20 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] toView:self.view];

    UILabel* instruction = [UILabel labelWithBoldText:NSLocalizedString(@"Ange ditt senaste resultat på övningen", nil) fontSize:14 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] toView:self.view];

    self.picker = ([[UIPickerView class] new]);
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = YES;
    [self.picker sizeToFit];
    self.picker.bounds = CGRectMake(0, 0, 80, self.picker.bounds.size.height);
    [self.view addSubview:_picker];

    StackVerticallyCentered(self.view, 10, 10, title, instruction, _picker, nil);
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 19;
}

#pragma mark UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [NSString stringWithFormat:row < 10 ? @" %d" : @"%d", row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

    return attString;
}

- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component {
    return 40;
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.newScore = row;
}

#pragma mark actions

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)save {
    [self.exercise addScore:self.newScore];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    [self.delegate didEnterScoreForExercise:self.exercise];
}

@end

