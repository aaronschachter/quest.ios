#import "IVQGameViewController.h"
#import "AppDelegate.h"
#import "IVQQuestion.h"
#import <Toast/UIView+Toast.h>
#import <ionicons/IonIcons.h>

@interface IVQGameViewController ()

@property (assign, nonatomic) BOOL gameCompleted;
@property (strong, nonatomic) NSArray *questions;
@property (assign, nonatomic) NSInteger currentQuestionNumber;
@property (assign, nonatomic) NSInteger countNo;
@property (assign, nonatomic) NSInteger countYes;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

- (IBAction)nextButtonTouchUpInside:(id)sender;

@end

@implementation IVQGameViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.title = @"InterviewQuest";
    UIImage *gearImage = [IonIcons imageWithIcon:ion_ios_pause_outline size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearImage style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonTapped:)];
    
    self.questions = appDelegate.questions;
    self.currentQuestionNumber = 0;
    self.countYes = 0;
    self.countNo = 0;
    self.gameCompleted = NO;
    [self loadCurrentQuestion];
    self.nextButton.hidden = YES;

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    NSString *message;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        message = @"No, I don't have a good answer.";
        self.countNo++;

    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        message = @"Yes, I can answer!";
        self.countYes++;
    }
    [self.view makeToast:message duration:0.5 position:CSToastPositionBottom];
    [self nextButtonTouchUpInside:self.view];
}

#pragma mark - IBAction

- (IBAction)nextButtonTouchUpInside:(id)sender {
    if (self.gameCompleted) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    self.currentQuestionNumber++;
    if (self.currentQuestionNumber == self.questions.count - 1) {
        NSString *gameOverText = [NSString stringWithFormat:@"Quest complete!\nYes: %li\nNo: %li", self.countYes, self.countNo];
        [self animateQuestionLabelText:gameOverText];
        self.nextButton.hidden = NO;
        self.gameCompleted = YES;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    [self loadCurrentQuestion];
    
}

- (IBAction)pauseButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Quest paused" message:@"Continue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *endGameAction = [UIAlertAction actionWithTitle:@"End quest"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK action");
    }];
    [alertController addAction:endGameAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - IVQPlayViewController

- (void)loadCurrentQuestion {
    if (self.questions.count > 0) {

        IVQQuestion *question = (IVQQuestion *)self.questions[self.currentQuestionNumber];
        [self animateQuestionLabelText:question.title];
    }
}

- (void)animateQuestionLabelText:(NSString *)text {
    // http://stackoverflow.com/a/16367409/1470725
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.25;
    [self.questionTitleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    self.questionTitleLabel.text = text;
}

@end
