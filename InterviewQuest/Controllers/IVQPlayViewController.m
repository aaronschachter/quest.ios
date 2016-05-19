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

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

- (IBAction)nextButtonTouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation IVQPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.questions.count > 0) {
        IVQQuestion *question = (IVQQuestion *)appDelegate.questions[0];
        self.questionTitleLabel.text = question.title;
    }
}

- (IBAction)nextButtonTouchUpInside:(id)sender {
}
@end
