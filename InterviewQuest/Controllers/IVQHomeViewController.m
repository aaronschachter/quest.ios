//
//  IVQHomeViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/17/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQHomeViewController.h"
#import "IVQGameViewController.h"
#import "IVQQuestionsViewController.h"
#import <ionicons/IonIcons.h>

@interface IVQHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButtonTouchUpInside;

- (IBAction)settingsButtonTouchUpInside:(id)sender;
- (IBAction)startButtonTouchUpInside:(id)sender;

@end

@implementation IVQHomeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"InterviewQuest";
    self.headlineLabel.text = @"Practice job interview questions.";

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *gearImage = [IonIcons imageWithIcon:ion_ios_gear_outline size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearImage style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonTouchUpInside:)];
}

#pragma mark - IBActions

- (IBAction)settingsButtonTouchUpInside:(id)sender {
    IVQQuestionsViewController *viewController = [[IVQQuestionsViewController alloc] initWithNibName:@"IVQQuestionsView" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)startButtonTouchUpInside:(id)sender {
    IVQGameViewController *viewController = [[IVQGameViewController alloc] initWithNibName:@"IVQGameView" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

@end
