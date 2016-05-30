#import "IVQGameViewController.h"
#import "AppDelegate.h"
#import "IVQGameQuestionTableViewCell.h"
#import "IVQGameOverViewController.h"
#import "IVQGame.h"
#import "IVQGameQuestion.h"
#import <ionicons/IonIcons.h>

@interface IVQGameViewController () <UITableViewDelegate, UITableViewDataSource, IVQGameQuestionTableViewCellDelegate>

@property (strong, nonatomic) IVQGame *game;
@property (assign, nonatomic) NSInteger currentQuestionNumber;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.title = @"InterviewQuest";
    UIImage *menuImage = [IonIcons imageWithIcon:ion_ios_more size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonTapped:)];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    // Hardcode to first few questions for now.
    NSArray *questions = [[NSArray alloc] initWithObjects:appDelegate.questions[0], appDelegate.questions[1], appDelegate.questions[2], nil];
    self.game = [[IVQGame alloc] initWithQuestions:questions];
    self.currentQuestionNumber = 0;
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)answerQuestionCell:(IVQGameQuestionTableViewCell *)cell answer:(BOOL)answer {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    IVQGameQuestion *gameQuestion = self.game.gameQuestions[indexPath.row];
    gameQuestion.answer = answer;
    if (answer) {
        [cell setYes];
    }
    else {
        [cell setNo];
    }

    if (indexPath.row == [self numberOfQuestionsInGame] - 1) {
        IVQGameOverViewController *viewController = [[IVQGameOverViewController alloc] initWithGame:self.game];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [self scrollToNextQuestionFromIndexPath:indexPath];
    }
}

- (NSInteger)numberOfQuestionsInGame {
    return self.game.gameQuestions.count;
}

#pragma mark - IBAction

- (IBAction)pauseButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Quest paused" message:@"Continue?" preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *endGameAction = [UIAlertAction actionWithTitle:@"End quest"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self dismiss];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK action");
    }];
    [alertController addAction:endGameAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)scrollToNextQuestionFromIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // @todo Last cell has some weird sizing issues.
    if (indexPath.row == [self numberOfQuestionsInGame] - 1) {
        // This gets rid of the previous cell appearing at the top of the last cell.. but the toolbar placement is still not consistent.
        return tableView.bounds.size.height;
    }
    return tableView.bounds.size.height - 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(IVQGameQuestionTableViewCell *)cell resetToolbar];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IVQGameQuestion *gameQuestion = self.game.gameQuestions[indexPath.row];
    cell.questionLabelText = gameQuestion.question.title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfQuestionsInGame];
}

#pragma mark - IVQGameQuestionTableViewCellDelegate

- (void)didClickNoButtonForCell:(IVQGameQuestionTableViewCell *)cell {
    [self answerQuestionCell:cell answer:NO];
}

- (void)didClickYesButtonForCell:(IVQGameQuestionTableViewCell *)cell {
    [self answerQuestionCell:cell answer:YES];
}

@end
