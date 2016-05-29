#import "IVQGameOverViewController.h"
#import "AppDelegate.h"
#import "IVQQuestion.h"
#import "IVQGameOverQuestionTableViewCell.h"

@interface IVQGameOverViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *questions;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.title = @"Quest complete";

    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameOverQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionCell"];
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.questions = appDelegate.questions;
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameOverQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IVQQuestion *question = (IVQQuestion *)self.questions[indexPath.row];
    cell.questionLabelText = question.title;
    return cell;
}

@end
