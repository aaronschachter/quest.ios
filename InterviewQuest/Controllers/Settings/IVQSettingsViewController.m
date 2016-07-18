#import "IVQSettingsViewController.h"
@import Firebase;

@interface IVQSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation IVQSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Settings";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    FIRUser *currentUser = [FIRAuth auth].currentUser;
    for (id<FIRUserInfo> profile in currentUser.providerData) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Account";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
    
//    if (indexPath.section == 0) {
//        NSString *label;
//        switch (indexPath.row) {
//            case 0:
//                label = @"General";
//                break;
//            case 1:
//                label = @"iOS";
//                break;
//            case 2:
//                label = @"Databases";
//                break;
//        }
//        cell.textLabel.text = label;
//    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *text = [NSString stringWithFormat:@"Logged in as %@", self.email];
            cell.textLabel.text = text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else {
            cell.textLabel.text = @"Sign out";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self handleSignoutTap];
    }
}

@end
