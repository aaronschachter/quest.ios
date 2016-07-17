#import "IVQProfileViewController.h"
#import <ionicons/IonIcons.h>
#import "IVQGame.h"
#import "IVQGameQuestion.h"
#import "IVQGameAnswerTableViewCell.h"
@import Firebase;

@interface IVQProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *gamesRef;
@property (strong, nonatomic) NSMutableArray *games;
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
    self.games = [[NSMutableArray alloc] init];
    UIImage *menuImage = [IonIcons imageWithIcon:ion_ios_close_empty size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSString* cellIdentifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"answerCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSString *gamesPath = [NSString stringWithFormat:@"users/%@/games", self.uid];
    self.gamesRef = [[FIRDatabase database] referenceWithPath:gamesPath];
    [self.gamesRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        if (snapshot.hasChildren) {
            for (FIRDataSnapshot* child in snapshot.children) {
                IVQGame *game = [[IVQGame alloc] initWithFirebaseId:child.key];
                [self.games addObject:game];
                [self.tableView reloadData];
            }
        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
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
    NSLog(@"gameQuestions %@", game.gameQuestions);
    return game.gameQuestions.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %li", section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IVQGame *game = self.games[indexPath.section];
    IVQGameQuestion *gameQuestion = (IVQGameQuestion *)game.gameQuestions[indexPath.row];
    cell.questionLabelText = gameQuestion.question.title;
    cell.answerLabelText = gameQuestion.answer;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self signOut];
}

@end
