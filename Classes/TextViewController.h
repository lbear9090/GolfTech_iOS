#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController <UIWebViewDelegate> {
//- (void)  setaFileName:(NSString *)afileName;

 NSString* fileName;

}

- (void)reloadWebView;
+ (id)textViewWith:(NSString*)aFileName title:(NSString*)title inverted:(BOOL)inverted;
@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, assign) BOOL inverted;
@property(nonatomic, copy) NSString* fileName;
@property NSString *lastName;

@end
