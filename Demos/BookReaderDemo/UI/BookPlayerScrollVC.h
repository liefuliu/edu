#import <UIKit/UIKit.h>
#import "BookPlayerPopupSubVC.h"

@interface BookPlayerScrollVC : UIViewController <UIScrollViewDelegate, BookPlayerPopupSubVCDelegate>

- (id) initWithBookKey:(NSString*) localBookKey;

- (void) viewDismissed:(BookPlayerPopupSubViewOperation) operationChoosed;

@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;

@property (weak, nonatomic) UIView* popupView;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end
