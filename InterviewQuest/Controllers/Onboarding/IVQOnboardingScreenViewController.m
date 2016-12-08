//
//  IVQOnboardingScreenViewController.m
//  InterviewQuest
//

#import "IVQOnboardingScreenViewController.h"

@interface IVQOnboardingScreenViewController ()

@property (assign, nonatomic, readwrite) NSInteger index;
@property (strong, nonatomic) NSString *descriptionLabelText;
@property (strong, nonatomic) NSString *titleLabelText;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)doneButtonTouchUpInside:(id)sender;

@end

@implementation IVQOnboardingScreenViewController

#pragma mark - NSObject

- (instancetype)initWithIndex:(NSInteger )index title:(NSString *)title description:(NSString *)description {
    self = [super initWithNibName:@"IVQOnboardingScreenView" bundle:nil];

    if (self) {
        _index = index;
        _descriptionLabelText = description;
        _titleLabelText = title;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descriptionLabel.text = self.descriptionLabelText;
    self.titleLabel.text = self.titleLabelText;
    if (self.index < 1) {
        self.doneButton.hidden = YES;
    }
    else {
        self.doneButton.hidden = NO;
        [self.doneButton setTitle:@"Get started".uppercaseString forState:UIControlStateNormal];
    }
}

- (IBAction)doneButtonTouchUpInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchDoneButtonForViewController:)]) {
        [self.delegate didTouchDoneButtonForViewController:self];
    }
}

@end
