#import "IVQProfileViewController.h"
#import <ionicons/IonIcons.h>
@import Firebase;

@interface IVQProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

- (IBAction)signoutButtonTouchUpInside:(id)sender;

@end

@implementation IVQProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (currentUser != nil) {
        for (id<FIRUserInfo> profile in currentUser.providerData) {
            self.title = profile.displayName;
        }
    }
    UIImage *menuImage = [IonIcons imageWithIcon:ion_ios_close_empty size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
}

- (IBAction)signoutButtonTouchUpInside:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"signout");
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
