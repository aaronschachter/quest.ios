#import "IVQGameOverViewController.h"
#import "AppDelegate.h"
#import "IVQGame.h"
#import "IVQGameQuestion.h"
#import "IVQGameAnswerTableViewCell.h"
@import Firebase;

@interface IVQGameOverViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IVQGame *game;
@property (strong, nonatomic) NSArray *questions;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameOverViewController

#pragma mark - NSObject

- (instancetype)initWithGame:(IVQGame *)game {
    self = [super initWithNibName:@"IVQGameOverView" bundle:nil];
    
    if (self) {
        _game = game;
    }
    
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Interview complete";

    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"answerCell"];
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    NSLog(@"currentUser.id %@", currentUser.uid);
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.game.gameQuestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IVQGameQuestion *gameQuestion = (IVQGameQuestion *)self.game.gameQuestions[indexPath.row];
    cell.questionLabelText = gameQuestion.question.title;
    cell.answerLabelText = gameQuestion.answer;
    return cell;
}

@end
