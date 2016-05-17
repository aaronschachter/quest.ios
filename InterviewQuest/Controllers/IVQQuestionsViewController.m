//
//  ViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQQuestionsViewController.h"
#import "IVQQuestion.h"
#import "IVQQuestionDetailViewController.h"
#import <Firebase/Firebase.h>

@interface IVQQuestionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *questionsTableView;
@property (strong, nonatomic) Firebase *questionsRef;

@end

@implementation IVQQuestionsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.questions = [[NSArray alloc] init];
    self.questionsTableView.delegate = self;
    self.questionsTableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    NSString* cellIdentifier = @"questionCell";
    [self.questionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.questionsRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-7380.firebaseio.com/questions"];
    [self.questionsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *questions = (NSDictionary *)snapshot.value;
        [self loadQuestionsFromDictionary:questions];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark - IVQQuestionListViewController

- (void)addButtonTapped:(id)sender {
    IVQQuestion *question = [[IVQQuestion alloc] init];
    IVQQuestionDetailViewController *destVC = [[IVQQuestionDetailViewController alloc] initWithQuestion:question];
    UINavigationController *navDestVC = [[UINavigationController alloc] initWithRootViewController:destVC];
    [self.navigationController presentViewController:navDestVC animated:YES completion:nil];
}

- (void)loadQuestionsFromDictionary:(NSDictionary *)questionsDict {
    self.questions = [[NSArray alloc] init];
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    [questionsDict enumerateKeysAndObjectsUsingBlock:^(id key, id questionDict, BOOL *stop) {
        IVQQuestion *question = [[IVQQuestion alloc] init];
        question.questionId = key;
        question.title = questionDict[@"title"];
        question.createdAt = questionDict[@"created_at"];
        [questions addObject:question];
    }];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.questions = [questions sortedArrayUsingDescriptors:sortDescriptors];
    [self.questionsTableView reloadData];
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
