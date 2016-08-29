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
@property (strong, nonatomic) NSString *categoryName;

@property (strong, nonatomic) UIButton *dontKnowButton;
@property (nonatomic, strong) UIButton *sendAnswerButton;
@property (nonatomic, strong) UIToolbar *keyboardToolbar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameViewController

#pragma mark - NSObject

- (instancetype)initWithCategoryName:(NSString *)categoryName {
    self = [super initWithNibName:@"IVQGameView" bundle:nil];
    
    if (self) {
        _categoryName = categoryName;
    }
    
    return self;
}

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

    NSNumber *categoryId = [NSNumber numberWithInt:1];
    if ([self.categoryName isEqualToString:@"iOS"]) {
        categoryId = [NSNumber numberWithInt:2];
    }
    else if ([self.categoryName isEqualToString:@"Databases"]) {
        categoryId = [NSNumber numberWithInt:3];
    }
    else if ([self.categoryName isEqualToString:@"Programming"]) {
        categoryId = [NSNumber numberWithInt:4];
    }
    NSArray *categoryQuestions = (NSArray *)appDelegate.categoriesDict[categoryId];
    
    NSMutableArray *mutableQuestions = [NSMutableArray arrayWithArray:categoryQuestions];
    NSUInteger count = [mutableQuestions count];
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableQuestions exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    NSArray *questions = [[NSArray alloc] initWithObjects:mutableQuestions[0], mutableQuestions[1], mutableQuestions[2], nil];
    self.game = [[IVQGame alloc] initWithQuestions:questions];
    self.currentQuestionNumber = 0;

    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    self.keyboardToolbar.barStyle = UIBarStyleDefault;
    CGFloat buttonWidth = (self.view.frame.size.width / 2) - 136;
    CGFloat buttonHeight = 40;

    self.dontKnowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dontKnowButton setTitle:@"I don't know" forState:UIControlStateNormal];
    self.dontKnowButton.layer.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    self.dontKnowButton.layer.cornerRadius = 4.0;
    self.dontKnowButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [self.dontKnowButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [self.dontKnowButton addTarget:self action:@selector(keyboardDontKnowButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *dontKnowBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dontKnowButton];

    self.sendAnswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendAnswerButton setTitle:@"Send answer" forState:UIControlStateNormal];
    self.sendAnswerButton.layer.cornerRadius = 4.0;
    self.sendAnswerButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    self.sendAnswerButton.layer.borderColor = [UIColor colorWithWhite:0.80 alpha:1].CGColor;
    [self.sendAnswerButton addTarget:self action:@selector(keyboardAnswerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.sendAnswerButton setTitleColor:[UIColor colorWithWhite:0.80 alpha:1] forState:UIControlStateDisabled];
    [self.sendAnswerButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *sendAnswerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sendAnswerButton];

    self.keyboardToolbar.items = @[dontKnowBarButtonItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL], sendAnswerBarButtonItem];
    [self answerButtonEnabled:NO];
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

- (void)answerButtonEnabled:(BOOL)enabled {
    if (enabled) {
        self.sendAnswerButton.enabled = YES;
        self.sendAnswerButton.backgroundColor = self.navigationController.navigationBar.tintColor;
        self.sendAnswerButton.layer.borderWidth = 0.0;
    }
    else {
        self.sendAnswerButton.enabled = NO;
        self.sendAnswerButton.backgroundColor = [UIColor whiteColor];
        self.sendAnswerButton.layer.borderWidth = 1.0;
    }
}

- (void)answerQuestionCell:(IVQGameQuestionTableViewCell *)cell answer:(BOOL)answer {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    IVQGameQuestion *gameQuestion = self.game.gameQuestions[indexPath.row];
    if (answer) {
        gameQuestion.answered = YES;
        gameQuestion.answer = cell.answerTextView.text;
    }
    else {
        gameQuestion.answered = NO;
        gameQuestion.answer = nil;
    }
    if (indexPath.row == [self numberOfQuestionsInGame] - 1) {
        [self postGame];
        IVQGameOverViewController *viewController = [[IVQGameOverViewController alloc] initWithGame:self.game];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [self scrollToNextQuestionFromIndexPath:indexPath];
        [self answerButtonEnabled:NO];
    }
}

- (void)postGame {
    NSString *uid = [FIRAuth auth].currentUser.uid;
    if (!uid) {
        return;
    }
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
            NSString *answer = gameQuestion.answer;
            if (!gameQuestion.answered) {
                answer = @"";
            }
            [newGameQuestionRef setValue:@{@"answered": [NSNumber numberWithBool:gameQuestion.answered], @"content": answer, @"question": gameQuestion.question.questionId, @"game": gameId, @"user": uid}];
            NSString *gameAnswerURL = [NSString stringWithFormat:@"%@/game-questions/%@", gameId, newGameQuestionRef.key];
            FIRDatabaseReference *newGameAnswerRef = [gamesRef child:gameAnswerURL];
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
    NSInteger numberLeft = self.numberOfQuestionsInGame - self.currentQuestionNumber;
    NSString *questionsLeftMessage = [NSString stringWithFormat:@"There's only %li questions left!", numberLeft];
    NSString *loseAnswersMessage = @"\n\nYou will lose your answers from this round if you end the interview early.";
    if (numberLeft == 1) {
        questionsLeftMessage = @"This is the last question!";
    }
    else if (numberLeft == self.numberOfQuestionsInGame) {
        loseAnswersMessage = @"";
    }
    [self.view endEditing:YES];

    NSString *alertMessage = [NSString stringWithFormat:@"%@%@", questionsLeftMessage, loseAnswersMessage];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *endGameAction = [UIAlertAction actionWithTitle:@"End it"style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self dismiss];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Keep going" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        IVQGameQuestionTableViewCell *cell = [self currentQuestionCell];
        [cell.answerTextView becomeFirstResponder];
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
        [self answerButtonEnabled:YES];
    }
    else {
        [self answerButtonEnabled:NO];
    }
}

@end
