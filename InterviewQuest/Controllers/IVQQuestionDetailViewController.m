//
//  IVQQuestionDetailViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQQuestionDetailViewController.h"
#import "IVQQuestionsViewController.h"

@interface IVQQuestionDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *questionTitleTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addQuestionBarButtonItem;

@end

@implementation IVQQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.addQuestionBarButtonItem) {
        return;
    }
    IVQQuestionsViewController *destVC = (IVQQuestionsViewController *)segue.destinationViewController;
    [destVC addNewQuestionWithTitle:self.questionTitleTextView.text];
}

@end
