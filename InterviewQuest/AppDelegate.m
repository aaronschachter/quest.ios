//
//  AppDelegate.m
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/14/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "AppDelegate.h"
#import "IVQQuestionsViewController.h"
#import "IVQHomeViewController.h"
#import "IVQQuestion.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong, nonatomic, readwrite) NSArray *questions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Firebase defaultConfig].persistenceEnabled = YES;
    Firebase *questionsRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-7380.firebaseio.com/questions"];
    [questionsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *questionsDict = (NSDictionary *)snapshot.value;
        self.questions = [[NSArray alloc] init];
        NSMutableArray *questions = [[NSMutableArray alloc] init];
        [questionsDict enumerateKeysAndObjectsUsingBlock:^(id key, id questionDict, BOOL *stop) {
            IVQQuestion *question = [[IVQQuestion alloc] init];
            question.questionId = key;
            question.title = questionDict[@"title"];
            question.createdAt = questionDict[@"created_at"];
            [questions addObject:question];
        }];
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.questions = [questions sortedArrayUsingDescriptors:sortDescriptors];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    IVQHomeViewController *viewController = [[IVQHomeViewController alloc] initWithNibName:@"IVQHomeView" bundle:nil];
    UINavigationController *navigationContoller = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationContoller.navigationBar.translucent = NO;
    self.window.rootViewController = navigationContoller;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
