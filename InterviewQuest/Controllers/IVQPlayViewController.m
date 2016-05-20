//
//  IVQPlayViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/18/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQPlayViewController.h"
#import "AppDelegate.h"
#import "IVQQuestion.h"

@interface IVQPlayViewController ()

@property (assign, nonatomic) BOOL gameCompleted;
@property (strong, nonatomic) NSArray *questions;
@property (assign, nonatomic) NSInteger currentQuestionNumber;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

- (IBAction)nextButtonTouchUpInside:(id)sender;

@end

@implementation IVQPlayViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.title = @"InterviewQuest";

    self.questions = appDelegate.questions;
    self.currentQuestionNumber = 0;
    self.gameCompleted = NO;
    [self loadCurrentQuestion];
    self.nextButton.hidden = YES;

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left");
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right");
    }
    [self nextButtonTouchUpInside:self.view];
}

#pragma mark - IBAction

- (IBAction)nextButtonTouchUpInside:(id)sender {
    if (self.gameCompleted) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.currentQuestionNumber++;
    if (self.currentQuestionNumber == self.questions.count - 1) {
        self.questionTitleLabel.text = @"Quest completed! You earned 10 coins.";
        self.questionTitleLabel.textColor = [UIColor greenColor];
        [self.nextButton setTitle:@"Done" forState:UIControlStateNormal];
        self.nextButton.hidden = NO;
        self.gameCompleted = YES;
        return;
    }
    [self loadCurrentQuestion];
    
}

#pragma mark - IVQPlayViewController

- (void)loadCurrentQuestion {
    if (self.questions.count > 0) {
        IVQQuestion *question = (IVQQuestion *)self.questions[self.currentQuestionNumber];
        self.questionTitleLabel.text = question.title;
    }
}

@end
