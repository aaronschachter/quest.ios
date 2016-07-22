#import "IVQHomeViewController.h"
#import "IVQGameViewController.h"
#import "IVQQuestionsViewController.h"
#import "IVQProfileViewController.h"
#import "IVQSettingsViewController.h"

#import <ionicons/IonIcons.h>
@import Firebase;
#import <GoogleSignIn/GoogleSignIn.h>

@interface IVQHomeViewController () <GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

- (IBAction)historyButtonTouchUpInside:(id)sender;
- (IBAction)settingsButtonTouchUpInside:(id)sender;
- (IBAction)startButtonTouchUpInside:(id)sender;

@end

@implementation IVQHomeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headlineLabel.text = @"Practice for job interviews.";
    self.imageView.image = [UIImage imageNamed:@"Shield"];
    self.startButton.backgroundColor = self.navigationController.navigationBar.tintColor;
    self.startButton.tintColor = [UIColor whiteColor];
    self.startButton.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
    self.signInButton.style = kGIDSignInButtonStyleWide;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [GIDSignIn sharedInstance].uiDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveToggleAuthUINotification:) name:@"ToggleAuthUINotification" object:nil];
    [self styleView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self toggleAuthUI];
}

#pragma mark - IVQHomeViewController

- (void)styleView {
    UIColor *lightGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    self.historyButton.backgroundColor = lightGrayColor;
    self.historyButton.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
    self.settingsButton.backgroundColor = lightGrayColor;
    self.settingsButton.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
    self.startButton.backgroundColor = self.navigationController.navigationBar.tintColor;
    self.startButton.tintColor = [UIColor whiteColor];
    self.startButton.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
}

- (void)receiveToggleAuthUINotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"]) {
        [self toggleAuthUI];
    }
}

- (void)toggleAuthUI {
    if ([FIRAuth auth].currentUser == nil) {
        self.signInButton.hidden = NO;
        self.historyButton.hidden = YES;
        self.settingsButton.hidden = YES;
    }
    else {
        self.startButton.hidden = NO;
        self.signInButton.hidden = YES;
        self.historyButton.hidden = NO;
        self.settingsButton.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)historyButtonTouchUpInside:(id)sender {
    IVQProfileViewController *viewController = [[IVQProfileViewController alloc] initWithNibName:@"IVQProfileView" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)settingsButtonTouchUpInside:(id)sender {
//    IVQQuestionsViewController *viewController = [[IVQQuestionsViewController alloc] initWithNibName:@"IVQQuestionsView" bundle:nil];
    IVQSettingsViewController *viewController = [[IVQSettingsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)startButtonTouchUpInside:(id)sender {
    IVQGameViewController *viewController = [[IVQGameViewController alloc] initWithNibName:@"IVQGameView" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBar.translucent = NO;
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

@end
