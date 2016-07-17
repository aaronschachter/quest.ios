#import "IVQProfileViewController.h"
#import <ionicons/IonIcons.h>
#import "IVQGame.h"
#import "IVQGameQuestion.h"
#import "IVQGameAnswerTableViewCell.h"
#import "AppDelegate.h"
@import Firebase;
#import <NSDate+Helper.h>

@interface IVQProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *gamesRef;
@property (strong, nonatomic) NSArray *games;
@property (strong, nonatomic) NSString *uid;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FIRUser *currentUser = [FIRAuth auth].currentUser;
    self.uid = currentUser.uid;

    if (currentUser != nil) {
        for (id<FIRUserInfo> profile in currentUser.providerData) {
            self.title = profile.displayName;
        }
    }
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.games = appDelegate.games;

    UIImage *menuImage = [IonIcons imageWithIcon:ion_close size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSString* cellIdentifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"answerCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)signOut {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        [self dismiss];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.games.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    IVQGame *game = self.games[section];

    return game.gameQuestions.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    IVQGame *game = self.games[section];
    return [NSDate stringForDisplayFromDate:game.date prefixed:NO alwaysDisplayTime:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IVQGame *game = self.games[indexPath.section];
    IVQGameQuestion *gameQuestion = (IVQGameQuestion *)game.gameQuestions[indexPath.row];
    cell.questionLabelText = gameQuestion.question.title;
    if (gameQuestion.answered) {
        cell.answerLabelText = gameQuestion.content;
    }
    else {
        cell.answerLabelText = nil;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self signOut];
}

@end
