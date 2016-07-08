#import <UIKit/UIKit.h>

@interface IVQGameOverQuestionTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL answer;

@property (strong, nonatomic) NSString *answerLabelText;
@property (strong, nonatomic) NSString *questionLabelText;

@end
