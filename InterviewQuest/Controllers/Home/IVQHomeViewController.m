#import "IVQHomeViewController.h"
#import "IVQGameViewController.h"
#import "IVQQuestionsViewController.h"
#import "IVQProfileViewController.h"
#import "IVQSettingsViewController.h"
#import "IVQOnboardingViewController.h"
#import <ionicons/IonIcons.h>
@import Firebase;
#import <GoogleSignIn/GoogleSignIn.h>
#import <DownPicker/DownPicker.h>

@interface IVQHomeViewController () <GIDSignInUIDelegate>

@property (assign, nonatomic) BOOL completedOnboarding;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) DownPicker *downPicker;

- (IBAction)historyButtonTouchUpInside:(id)sender;
- (IBAction)settingsButtonTouchUpInside:(id)sender;
- (IBAction)startButtonTouchUpInside:(id)sender;

@end

@implementation IVQHomeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.completedOnboarding = NO;
    
    self.headlineLabel.text = @"Train for your next job interview.";
    self.imageView.image = [UIImage imageNamed:@"Shield"];
    self.startButton.backgroundColor = self.navigationController.navigationBar.tintColor;
    self.startButton.tintColor = [UIColor whiteColor];
    self.startButton.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
    self.signInButton.style = kGIDSignInButtonStyleWide;

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [GIDSignIn sharedInstance].uiDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveToggleAuthUINotification:) name:@"ToggleAuthUINotification" object:nil];
    [self styleView];
    
    NSArray *categories = @[@"General", @"iOS", @"Databases", @"Programming"];
    self.downPicker = [[DownPicker alloc] initWithTextField:self.categoryTextField      withData:categories];
    self.downPicker.text = categories[0];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self toggleAuthUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCompletedOnboarding"]) {
        IVQOnboardingViewController *onboardingViewController = [[IVQOnboardingViewController alloc] init];
        [self presentViewController:onboardingViewController animated:YES completion:nil];
    }
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
        self.signInLabel.hidden = NO;
        self.historyButton.hidden = YES;
        self.settingsButton.hidden = YES;
        self.signInLabel.hidden = NO;
    }
    else {
        self.startButton.hidden = NO;
        self.signInButton.hidden = YES;
        self.signInLabel.hidden = YES;
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
