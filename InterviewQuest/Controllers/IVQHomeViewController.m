//
//  IVQHomeViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/17/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQHomeViewController.h"
#import "IVQQuestionsViewController.h"

@interface IVQHomeViewController ()

- (IBAction)settingsButtonTouchUpInside:(id)sender;

@end

@implementation IVQHomeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - IBActions

- (IBAction)settingsButtonTouchUpInside:(id)sender {
    IVQQuestionsViewController *viewController = [[IVQQuestionsViewController alloc] initWithNibName:@"IVQQuestionsView" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
