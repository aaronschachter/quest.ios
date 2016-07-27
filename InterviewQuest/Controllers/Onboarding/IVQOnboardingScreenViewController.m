//
//  IVQOnboardingScreenViewController.m
//  InterviewQuest
//

#import "IVQOnboardingScreenViewController.h"

@interface IVQOnboardingScreenViewController ()

@property (assign, nonatomic, readwrite) NSInteger index;
@property (strong, nonatomic) NSString *descriptionLabelText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation IVQOnboardingScreenViewController

#pragma mark - NSObject

- (instancetype)initWithIndex:(NSInteger )index description:(NSString *)description {
    self = [super initWithNibName:@"IVQOnboardingScreenView" bundle:nil];

    if (self) {
        _index = index;
        _descriptionLabelText = description;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descriptionLabel.text = self.descriptionLabelText;
}

@end
