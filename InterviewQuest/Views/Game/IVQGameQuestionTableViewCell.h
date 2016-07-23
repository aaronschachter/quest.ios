#import <UIKit/UIKit.h>

@interface IVQGameQuestionTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *questionLabelText;

@property (weak, nonatomic) IBOutlet UITextView *answerTextView;

@end
