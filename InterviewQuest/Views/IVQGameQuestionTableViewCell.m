#import "IVQGameQuestionTableViewCell.h"

@interface IVQGameQuestionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation IVQGameQuestionTableViewCell

#pragma mark - Accessors

- (void)setQuestionLabelText:(NSString *)questionLabelText {
    self.questionLabel.text = questionLabelText;
}

@end
