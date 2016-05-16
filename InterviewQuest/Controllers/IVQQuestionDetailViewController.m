//
//  IVQQuestionDetailViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQQuestionDetailViewController.h"
#import "IVQQuestionsViewController.h"

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

#pragma mark - IVQQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionTitleTextView.text = self.question.title;
    self.questionTitleTextView.delegate = self;

    if (self.question.questionId) {
        self.title = @"Edit";
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)doneButtonTapped:(id)sender {
    if (self.question.questionId) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textChanged:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue senderd:(id)sender {
    if (sender != self.addQuestionBarButtonItem) {
        return;
    }
    IVQQuestionsViewController *destVC = (IVQQuestionsViewController *)segue.destinationViewController;
    [destVC addNewQuestionWithTitle:self.questionTitleTextView.text];
}

- (void)textViewDidChange:(UITextView *)textView {
    BOOL doneButtonEnabled = NO;
    if (![self.questionTitleTextView.text isEqualToString:self.question.title]) {
        doneButtonEnabled = YES;
    }
    self.navigationItem.rightBarButtonItem.enabled = doneButtonEnabled;
}

@end
