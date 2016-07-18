#import "IVQGameViewController.h"
#import "AppDelegate.h"
#import "IVQGameQuestionTableViewCell.h"
#import "IVQGameOverViewController.h"
#import "IVQGame.h"
#import "IVQGameQuestion.h"
#import <ionicons/IonIcons.h>
@import Firebase;

@interface IVQGameViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong, nonatomic) IVQGame *game;
@property (assign, nonatomic) NSInteger currentQuestionNumber;
@property (nonatomic, strong) UIBarButtonItem *sendAnswerButton;
@property (nonatomic, strong) UIToolbar *keyboardToolbar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameViewController

#pragma mark - Mutators

- (void)setCurrentQuestionNumber:(NSInteger)currentQuestionNumber {
    _currentQuestionNumber = currentQuestionNumber;
    self.title = [NSString stringWithFormat:@"Question #%li", self.currentQuestionNumber + 1];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIImage *menuImage = [IonIcons imageWithIcon:ion_close size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonTapped:)];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    NSMutableArray *mutableQuestions = [NSMutableArray arrayWithArray:appDelegate.questions];
    NSUInteger count = [mutableQuestions count];
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableQuestions exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    NSArray *questions = [[NSArray alloc] initWithObjects:mutableQuestions[0], mutableQuestions[1], mutableQuestions[2], nil];
    self.game = [[IVQGame alloc] initWithQuestions:questions];
    self.currentQuestionNumber = 0;

    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.keyboardToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *dontKnowButton = [[UIBarButtonItem alloc] initWithTitle:@"I don't know" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDontKnowButtonPressed)];
    [dontKnowButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.sendAnswerButton = [[UIBarButtonItem alloc] initWithTitle:@"Send answer" style:UIBarButtonItemStyleDone target:self action:@selector(keyboardAnswerButtonPressed)];
    self.keyboardToolbar.items = @[dontKnowButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL], self.sendAnswerButton];
    self.sendAnswerButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    IVQGameQuestionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.answerTextView becomeFirstResponder];
}

#pragma mark - IVQGameViewController

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)answerQuestionCell:(IVQGameQuestionTableViewCell *)cell answer:(BOOL)answer {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    IVQGameQuestion *gameQuestion = self.game.gameQuestions[indexPath.row];
    if (answer) {
        gameQuestion.answer = cell.answerTextView.text;
    }
    else {
        gameQuestion.answer = nil;
    }
    cell.answer = answer;
    if (indexPath.row == [self numberOfQuestionsInGame] - 1) {
        [self postGame];
        IVQGameOverViewController *viewController = [[IVQGameOverViewController alloc] initWithGame:self.game];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [self scrollToNextQuestionFromIndexPath:indexPath];
        self.sendAnswerButton.enabled = NO;
    }
}

- (void)postGame {
    NSString *uid = [FIRAuth auth].currentUser.uid;
    NSString *currentTimestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970] * 1000];
    NSDictionary *newGame = @{@"created_at": currentTimestamp, @"user": uid};
    FIRDatabaseReference *gamesRef = [[FIRDatabase database] referenceWithPath:@"games"];
    FIRDatabaseReference *gameQuestionsRef = [[FIRDatabase database] referenceWithPath:@"game-questions"];
    FIRDatabaseReference *newGameRef = [gamesRef childByAutoId];
    NSString *gameId = newGameRef.key;

    [newGameRef setValue:newGame withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
        NSString *userGamePath = [NSString stringWithFormat:@"users/%@/games/%@", uid, gameId];;
        FIRDatabaseReference *userGameRef = [[FIRDatabase database] referenceWithPath:userGamePath];
        [userGameRef setValue:@YES];
        for (IVQGameQuestion *gameQuestion in self.game.gameQuestions) {
            FIRDatabaseReference *newGameQuestionRef = [gameQuestionsRef childByAutoId];
            BOOL didAnswer = YES;
            NSString *answer = gameQuestion.answer;
            if (!answer) {
                didAnswer = NO;
                answer = @"";
            }
            [newGameQuestionRef setValue:@{@"answered": [NSNumber numberWithBool:didAnswer], @"content": answer, @"question": gameQuestion.question.questionId, @"game": gameId, @"user": uid}];
            NSString *gameAnswerURL = [NSString stringWithFormat:@"%@/game-questions/%@", gameId, newGameQuestionRef.key];
            FIRDatabaseReference *newGameAnswerRef = [gamesRef child:gameAnswerURL];;
            [newGameAnswerRef setValue:@YES];
        }
    }];
}

- (NSInteger)numberOfQuestionsInGame {
    return self.game.gameQuestions.count;
}

- (void)keyboardDontKnowButtonPressed {
    [self answerQuestionCell:[self currentQuestionCell] answer:NO];
}

- (void)keyboardAnswerButtonPressed {
    [self answerQuestionCell:[self currentQuestionCell] answer:YES];
}

- (IVQGameQuestionTableViewCell *)currentQuestionCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentQuestionNumber inSection:0];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)scrollToNextQuestionFromIndexPath:(NSIndexPath *)indexPath {
    self.currentQuestionNumber++;
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    IVQGameQuestionTableViewCell *cell = [self currentQuestionCell];
    [cell.answerTextView becomeFirstResponder];
}

#pragma mark - IBAction

- (IBAction)pauseButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Interview paused" message:nil preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *endGameAction = [UIAlertAction actionWithTitle:@"End interview"style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self dismiss];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:endGameAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // GameOverCell:
    if (indexPath.row == [self numberOfQuestionsInGame] - 1) {
        return tableView.bounds.size.height;
    }
    // This is bizarre, but if you return height without offset, scrolling to the next cell the firstResponder won't fire (no cursor blinking).
    return tableView.bounds.size.height - 22;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameQuestionTableViewCell *questionCell = (IVQGameQuestionTableViewCell *)cell;
    [questionCell resetToolbar];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameQuestionTableViewCell *questionCell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    IVQGameQuestion *gameQuestion = self.game.gameQuestions[indexPath.row];
    questionCell.questionLabelText = gameQuestion.question.title;
    questionCell.answerTextView.delegate = self;
    questionCell.answerTextView.inputAccessoryView = self.keyboardToolbar;
    questionCell.answerTextView.userInteractionEnabled = YES;
    questionCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return questionCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfQuestionsInGame];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.sendAnswerButton.enabled = YES;
    }
}

@end
