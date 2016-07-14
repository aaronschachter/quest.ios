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
#import "AppDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate () <GIDSignInDelegate>

@property (strong, nonatomic, readwrite) NSArray *questions;
@property (strong, nonatomic, readwrite) FIRDatabaseReference *questionsRef;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;

    [FIRDatabase database].persistenceEnabled = YES;
    self.questionsRef = [[FIRDatabase database] referenceWithPath:@"questions"];
    [self.questionsRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
            FIRUser *firUser = [FIRAuth auth].currentUser;
            NSLog(@"uid %@", firUser.uid);
            if (firUser != nil) {
                for (id<FIRUserInfo> profile in firUser.providerData) {
                    NSString *providerID = profile.providerID;
                    NSLog(@"provider %@", providerID);
                    NSString *uid = profile.uid;  // Provider-specific UID
                    NSLog(@"uid %@", uid);
                    NSString *name = profile.displayName;
                    NSLog(@"name %@", name);
                    NSString *email = profile.email;
                    NSLog(@"email %@", email);
                    NSURL *photoURL = profile.photoURL;
                    NSLog(@"photo %@", photoURL);
                }
            }
            else {
            }
            NSLog(@"error %@", error);
        }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
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
