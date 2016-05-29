#import "IVQGameOverQuestionTableViewCell.h"

@interface IVQGameOverQuestionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

@end

@implementation IVQGameOverQuestionTableViewCell

#pragma mark - Accessors

- (void)setQuestionLabelText:(NSString *)questionLabelText {
    self.questionTitleLabel.text = questionLabelText;
}


@end
