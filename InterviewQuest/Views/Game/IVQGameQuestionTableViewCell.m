#import "IVQGameQuestionTableViewCell.h"

@interface IVQGameQuestionTableViewCell() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation IVQGameQuestionTableViewCell

#pragma mark - Accessors

- (void)setQuestionLabelText:(NSString *)questionLabelText {
    self.questionLabel.text = questionLabelText;
}

#pragma mark - UITableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.questionView.layer.masksToBounds = YES;
    self.questionView.layer.cornerRadius = 8.0;
    self.helpTextLabel.text = @"Type your answer, or tap \"I don't know\"";
}

@end
