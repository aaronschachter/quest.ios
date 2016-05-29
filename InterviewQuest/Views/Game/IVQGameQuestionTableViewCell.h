#import <UIKit/UIKit.h>

@interface IVQGameQuestionTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL answer;
@property (strong, nonatomic) NSString *questionLabelText;

@property (weak, nonatomic) IBOutlet UITextView *answerTextView;

- (void)resetToolbar;

@end