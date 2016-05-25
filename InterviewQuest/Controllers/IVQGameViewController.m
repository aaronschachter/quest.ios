#import "IVQGameViewController.h"
#import "AppDelegate.h"
#import "IVQQuestion.h"
#import <Toast/UIView+Toast.h>
#import <ionicons/IonIcons.h>

@interface IVQGameViewController () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) BOOL gameCompleted;
@property (strong, nonatomic) NSArray *questions;
@property (assign, nonatomic) NSInteger currentQuestionNumber;
@property (assign, nonatomic) NSInteger countNo;
@property (assign, nonatomic) NSInteger countYes;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.title = @"InterviewQuest";
    UIImage *gearImage = [IonIcons imageWithIcon:ion_ios_pause_outline size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearImage style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonTapped:)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"questionCell"];
    self.tableView.scrollEnabled = NO;
    
    self.questions = appDelegate.questions;
    self.currentQuestionNumber = 0;
    self.countYes = 0;
    self.countNo = 0;
    self.gameCompleted = NO;
}

#pragma mark - IBAction

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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height - 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.questions.count) {
        return;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    if (indexPath.row == self.questions.count) {
        cell.textLabel.text = @"Done";
    }
    else {
        IVQQuestion *question = (IVQQuestion *)self.questions[indexPath.row];
        cell.textLabel.text = question.title;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Add 1 for our GameOver cell.
    return self.questions.count + 1;
}

@end
