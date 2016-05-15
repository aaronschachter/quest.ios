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

@property (strong, nonatomic) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *questionsTableView;
@property (strong, nonatomic) Firebase *questionsRef;

@end

@implementation IVQQuestionsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.questions = [[NSMutableArray alloc] init];
    self.questionsTableView.delegate = self;
    self.questionsTableView.dataSource = self;
    NSString* cellIdentifier = @"questionCell";
    [self.questionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.questionsRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-7380.firebaseio.com/questions"];
    [self.questionsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *questions = (NSDictionary *)snapshot.value;
        NSLog(@"%@", questions);
        [questions enumerateKeysAndObjectsUsingBlock:^(id key, id questionDict, BOOL *stop) {
            NSDictionary *question = (NSDictionary *)questionDict;
            [self.questions addObject:question[@"title"]];
        }];
        [self.questionsTableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark - IVQQuestionListViewController

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
    cell.textLabel.text = self.questions[indexPath.row];
    return cell;
}

@end
