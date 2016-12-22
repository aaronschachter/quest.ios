#import "IVQSettingsViewController.h"
@import Firebase;

@interface IVQSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRUser *currentUser;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation IVQSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Interviewbud";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.currentUser = [FIRAuth auth].currentUser;
    for (id<FIRUserInfo> profile in self.currentUser.providerData) {
        self.email = profile.email;
    }
}

- (void)handleSignoutTap {
    UIAlertController *logoutAlertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sign out?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirmLogoutAction = [UIAlertAction actionWithTitle:@"Sign out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [logoutAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [logoutAlertController addAction:confirmLogoutAction];
    [logoutAlertController addAction:cancelAction];
    [self presentViewController:logoutAlertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }

    if (self.currentUser) {
        return 2;
    }

    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"About";
    }

    return @"Account";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (!self.currentUser) {
            cell.textLabel.text = @"You're not signed in.\n\nTo save your Interviewbud interviews, sign into your Google account on the previous screen.";
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;

            return cell;
        }

        if (indexPath.row == 0) {
            NSString *text = [NSString stringWithFormat:@"Signed in as %@", self.email];
            cell.textLabel.text = text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else {
            cell.textLabel.text = @"Sign out";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
            cell.detailTextLabel.text = @"Rate in App Store";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Terms of Service";
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Privacy Policy";
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self handleSignoutTap];
        return;
    }

    if (indexPath.section == 1) {
        NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1133808097";
        if (indexPath.row == 1) {
            url = @"http://interviewbud.com/terms";
        }
        else if (indexPath.row == 2) {
            url = @"http://interviewbud.com/privacy";;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
}

@end
