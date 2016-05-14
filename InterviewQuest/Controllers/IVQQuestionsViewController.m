//
//  ViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQQuestionsViewController.h"
#import "IVQQuestionDetailViewController.h"

@interface IVQQuestionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *questionsTableView;

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
}

#pragma mark - IVQQuestionListViewController

- (void)addNewQuestionWithTitle:(NSString *)questionTitle {
    [self.questions addObject:questionTitle];
    [self.questionsTableView reloadData];
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
