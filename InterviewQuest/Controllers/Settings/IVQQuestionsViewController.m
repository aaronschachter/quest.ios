#import "IVQQuestionsViewController.h"
#import "IVQQuestion.h"
#import "IVQQuestionDetailViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import <ionicons/IonIcons.h>


@interface IVQQuestionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *questions;

@property (weak, nonatomic) IBOutlet UITableView *questionsTableView;

@end

@implementation IVQQuestionsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.questions = [[NSArray alloc] init];
    self.questionsTableView.delegate = self;
    self.questionsTableView.dataSource = self;

    self.title = @"Questions";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    
    UIImage *menuImage = [IonIcons imageWithIcon:ion_ios_close_empty size:22.0f color:self.view.tintColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];

    NSString* cellIdentifier = @"questionCell";
    [self.questionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.questions = [[NSArray alloc] init];
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.questions = appDelegate.questions;
    [self.questionsTableView reloadData];
}

#pragma mark - IVQQuestionListViewController

- (void)addButtonTapped:(id)sender {
    IVQQuestion *question = [[IVQQuestion alloc] init];
    IVQQuestionDetailViewController *destVC = [[IVQQuestionDetailViewController alloc] initWithQuestion:question];
    UINavigationController *navDestVC = [[UINavigationController alloc] initWithRootViewController:destVC];
    [self.navigationController presentViewController:navDestVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    IVQQuestion *question = (IVQQuestion *)self.questions[indexPath.row];
    cell.textLabel.text = question.title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQQuestion *question = (IVQQuestion *)self.questions[indexPath.row];
    IVQQuestionDetailViewController *destVC = [[IVQQuestionDetailViewController alloc] initWithQuestion:question];
    [self.navigationController pushViewController:destVC animated:YES];
}

@end
