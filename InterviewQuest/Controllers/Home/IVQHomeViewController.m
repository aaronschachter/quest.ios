#import "IVQHomeViewController.h"
#import "IVQGameViewController.h"
#import "IVQQuestionsViewController.h"
#import "IVQProfileViewController.h"

#import <ionicons/IonIcons.h>
@import Firebase;
#import <GoogleSignIn/GoogleSignIn.h>

@interface IVQHomeViewController () <GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

- (IBAction)settingsButtonTouchUpInside:(id)sender;
- (IBAction)startButtonTouchUpInside:(id)sender;

@end

@implementation IVQHomeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headlineLabel.text = @"Practice for job interviews.";
    self.imageView.image = [UIImage imageNamed:@"Shield"];
    self.startButton.backgroundColor = [[UIColor alloc] initWithRed:(102.0/255.0) green:(204.0/255.0) blue:(255.0/255.0) alpha:1.0];
    self.startButton.tintColor = [UIColor whiteColor];
    self.startButton.layer.cornerRadius = 8.0;
    self.startButton.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
    

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    [[GIDSignIn sharedInstance] signInSilently];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (!currentUser) {
        self.signInButton.hidden = NO;
        self.profileButton.hidden = YES;
    }
    else {
        self.signInButton.hidden = YES;
        self.profileButton.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)settingsButtonTouchUpInside:(id)sender {
//    IVQQuestionsViewController *viewController = [[IVQQuestionsViewController alloc] initWithNibName:@"IVQQuestionsView" bundle:nil];
    IVQProfileViewController *viewController = [[IVQProfileViewController alloc] initWithNibName:@"IVQProfileView" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)startButtonTouchUpInside:(id)sender {
    IVQGameViewController *viewController = [[IVQGameViewController alloc] initWithNibName:@"IVQGameView" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.translucent = NO;
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

@end
