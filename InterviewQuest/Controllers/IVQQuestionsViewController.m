//
//  ViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQQuestionsViewController.h"
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

- (void)loadQuestionsFromDictionary:(NSDictionary *)questionsDict {
    self.questions = [[NSArray alloc] init];
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    [questionsDict enumerateKeysAndObjectsUsingBlock:^(id key, id questionDict, BOOL *stop) {
        NSMutableDictionary *question = (NSMutableDictionary *)questionDict;
        question[@"id"] = key;
        [questions addObject:question];
    }];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.questions = [questions sortedArrayUsingDescriptors:sortDescriptors];
    [self.questionsTableView reloadData];
}

- (void)addNewQuestionWithTitle:(NSString *)questionTitle {
    NSString *currentTimestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970] * 1000];
    NSDictionary *newQuestion = @{
                            @"created_at": currentTimestamp,
                            @"title": questionTitle,
                            };
    Firebase *newQuestionRef = [self.questionsRef childByAutoId];
    [newQuestionRef setValue: newQuestion];
}

#pragma mark - IBActions

- (IBAction)dismissModal:(UIStoryboardSegue *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    NSDictionary *question = (NSDictionary *)self.questions[indexPath.row];
    cell.textLabel.text = question[@"title"];
    return cell;
}

@end
