//
//  IVQQuestionDetailViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQQuestionDetailViewController.h"
#import "IVQQuestionsViewController.h"
#import <Firebase/Firebase.h>

@interface IVQQuestionDetailViewController () <UITextViewDelegate>

@property (strong, nonatomic) IVQQuestion *question;

// @todo DRY with IVQAPI singleton class.
@property (strong, nonatomic) Firebase *questionsRef;

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
    self.questionsRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-7380.firebaseio.com/questions"];

    if (self.question.questionId) {
        NSLog(@"%@", self.question.questionId);
        self.title = @"Edit Question";
    }
    else {
        self.title = @"Add Question";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - IVQQuestionDetailViewController

- (void)cancelButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped:(id)sender {
    NSString *currentTimestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970] * 1000];
    NSString *questionTitle = self.questionTitleTextView.text;
    if (self.question.questionId) {
        Firebase *questionRef = [self.questionsRef childByAppendingPath:self.question.questionId];
        Firebase *titleRef = [questionRef childByAppendingPath:@"title"];
        [titleRef setValue:questionTitle withCompletionBlock:^(NSError *error, Firebase *ref) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        NSDictionary *newQuestion = @{
                                      @"created_at": currentTimestamp,
                                      @"title": questionTitle,
                                      };
        Firebase *newQuestionRef = [self.questionsRef childByAutoId];
        [newQuestionRef setValue:newQuestion withCompletionBlock:^(NSError *error, Firebase *ref) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
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
