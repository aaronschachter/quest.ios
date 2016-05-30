#import "IVQGameQuestionTableViewCell.h"

@interface IVQGameQuestionTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

- (IBAction)noButtonTouchUpInside:(id)sender;
- (IBAction)yesButtonTouchUpInside:(id)sender;

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
    self.toolbarView.hidden = YES;
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

    [self.noButton setTitle:@"Don't know" forState:UIControlStateNormal];
    [self.yesButton setTitle:@"Answer" forState:UIControlStateNormal];
}

#pragma mark - UITableViewCell

- (void)resetToolbar {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.toolbarView.hidden = NO;
}

#pragma mark - IBActions

- (IBAction)noButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickNoButtonForCell:)]) {
        [self.delegate didClickNoButtonForCell:self];
    }
}

- (IBAction)yesButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickYesButtonForCell:)]) {
        [self.delegate didClickYesButtonForCell:self];
    }
}

@end
