//
//  AppDelegate.h
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic, readonly) FIRDatabaseReference *questionsRef;
@property (strong, nonatomic, readonly) NSArray *games;
@property (strong, nonatomic, readonly) NSArray *questions;
@property (strong, nonatomic, readonly) NSDictionary *questionsDict;
@property (strong, nonatomic) UIWindow *window;


@end

