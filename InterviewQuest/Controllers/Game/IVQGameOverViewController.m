//
//  IVQGameOverViewController.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/27/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQGameOverViewController.h"

@interface IVQGameOverViewController ()

@end

@implementation IVQGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
