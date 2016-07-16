#import "IVQGameAnswerTableViewCell.h"

@interface IVQGameAnswerTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UIView *answerView;

@end

@implementation IVQGameAnswerTableViewCell

#pragma mark - Accessors

- (void)setAnswer:(BOOL)answer {
    UIColor *backgroundColor = [UIColor greenColor];
    if (!answer) {
        backgroundColor = [UIColor redColor];
    }
    self.contentView.backgroundColor = backgroundColor;
}

- (void)setAnswerLabelText:(NSString *)answerLabelText {
    if (answerLabelText) {
        self.answerLabel.text = answerLabelText;
    }
    else {
        self.answerLabel.text = @"I don't know";
        self.answerView.backgroundColor = [UIColor redColor];
    }
    
}

- (void)setQuestionLabelText:(NSString *)questionLabelText {
    self.questionTitleLabel.text = questionLabelText;
}


#pragma mark - UITableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.answerView.layer.masksToBounds = YES;
    self.answerView.layer.cornerRadius = 8.0;
    self.questionView.layer.masksToBounds = YES;
    self.questionView.layer.cornerRadius = 8.0;
}

@end
