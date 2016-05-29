#import "IVQGameQuestionTableViewCell.h"

@interface IVQGameQuestionTableViewCell() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation IVQGameQuestionTableViewCell

#pragma mark - Accessors

- (void)setAnswer:(BOOL)answer {
    if (answer) {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    else {
        self.contentView.backgroundColor = [UIColor redColor];
    }
}

- (void)setQuestionLabelText:(NSString *)questionLabelText {
    self.questionLabel.text = questionLabelText;
}

#pragma mark - UITableViewCell

-(void)prepareForReuse{
    [super prepareForReuse];
    
    [self resetToolbar];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.questionView.layer.masksToBounds = YES;
    self.questionView.layer.cornerRadius = 8.0;
}

#pragma mark - UITableViewCell

- (void)resetToolbar {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
