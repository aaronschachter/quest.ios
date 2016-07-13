#import "IVQQuestionDetailViewController.h"
#import "IVQQuestionsViewController.h"
#import "AppDelegate.h"

@interface IVQQuestionDetailViewController () <UITextViewDelegate>

@property (strong, nonatomic) IVQQuestion *question;

@property (weak, nonatomic) IBOutlet UITextView *questionTitleTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addQuestionBarButtonItem;

@end

@implementation IVQQuestionDetailViewController

#pragma mark - NSObject

- (instancetype)initWithQuestion:(IVQQuestion *)question {
    self = [super initWithNibName:@"IVQQuestionDetailView" bundle:nil];
    
    if (self) {
        _question = question;
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionTitleTextView.text = self.question.title;
    self.questionTitleTextView.delegate = self;

    if (self.question.questionId) {
        NSLog(@"%@", self.question.questionId);
        self.title = @"Edit Question";
        self.navigationController.toolbarHidden = NO;
        UIBarButtonItem *trashBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonTapped:)];
        NSArray *items = [NSArray arrayWithObjects:trashBarButtonItem, nil];
        self.toolbarItems = items;
    }
    else {
        self.title = @"Add Question";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - IBAction

- (IBAction)cancelButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(id)sender {
    NSString *currentTimestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970] * 1000];
    NSString *questionTitle = self.questionTitleTextView.text;
    if (self.question.questionId) {
        FIRDatabaseReference *questionRef = [[self questionsRef] child:self.question.questionId];
        FIRDatabaseReference *titleRef = [questionRef child:@"title"];
        [titleRef setValue:questionTitle withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        NSDictionary *newQuestion = @{@"created_at": currentTimestamp, @"title": questionTitle};
        FIRDatabaseReference *newQuestionRef = [[self questionsRef] childByAutoId];
        [newQuestionRef setValue:newQuestion withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)trashButtonTapped:(id)sender {
    UIAlertController *confirmDeleteAlertController = [UIAlertController alertControllerWithTitle:@"Delete Question?" message:@"This cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        FIRDatabaseReference *questionRef = [self.questionsRef child:self.question.questionId];
        [questionRef removeValueWithCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [confirmDeleteAlertController addAction:deleteAction];
    [confirmDeleteAlertController addAction:cancelAction];
    [self presentViewController:confirmDeleteAlertController animated:YES completion:nil];
}

#pragma mark - IVQQuestionDetailViewController

- (FIRDatabaseReference *)questionsRef {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).questionsRef;
}
         
- (void)textChanged:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    BOOL doneButtonEnabled = NO;
    if (![self.questionTitleTextView.text isEqualToString:self.question.title]) {
        doneButtonEnabled = YES;
    }
    self.navigationItem.rightBarButtonItem.enabled = doneButtonEnabled;
}

@end
