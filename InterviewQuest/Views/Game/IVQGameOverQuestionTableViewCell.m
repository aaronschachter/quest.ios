#import "IVQGameOverQuestionTableViewCell.h"

@interface IVQGameOverQuestionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

@end

@implementation IVQGameOverQuestionTableViewCell

#pragma mark - Accessors

- (void)setAnswer:(BOOL)answer {
    UIColor *backgroundColor = [UIColor greenColor];
    if (!answer) {
        backgroundColor = [UIColor redColor];
    }
    self.contentView.backgroundColor = backgroundColor;
}

- (void)setQuestionLabelText:(NSString *)questionLabelText {
    self.questionTitleLabel.text = questionLabelText;
}


@end
