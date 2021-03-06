//
//  AppDelegate.m
//  InterviewQuest
//

#import "AppDelegate.h"
#import "IVQOnboardingViewController.h"
#import "IVQHomeViewController.h"
#import "IVQGame.h"
#import "IVQQuestion.h"
#import "AppDelegate.h"
#import "IVQAPI.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate () <GIDSignInDelegate>

@property (assign, nonatomic, readwrite) bool networkConnected;
@property (strong, nonatomic, readwrite) FIRDatabaseReference *questionsRef;
@property (strong, nonatomic, readwrite) NSArray *games;
@property (strong, nonatomic, readwrite) NSArray *questions;
@property (strong, nonatomic, readwrite) NSDictionary *categoriesDict;
@property (strong, nonatomic, readwrite) NSDictionary *questionsDict;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *keysDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"]];
    [Fabric with:@[[Crashlytics startWithAPIKey:keysDict[@"fabricApiKey"]]]];
    
    [IVQAPI sharedInstance];
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;
    
    if ([FIRAuth auth].currentUser) {
        [[IVQAPI sharedInstance] loadGames];
    }

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
        [SVProgressHUD show];
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
        NSString *fullName = user.profile.name;
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
            FIRUser *firUser = [FIRAuth auth].currentUser;
            NSLog(@"uid %@", firUser.uid);
            if (firUser != nil) {
                NSDictionary *statusText = @{@"statusText": [NSString stringWithFormat:@"Signed in user: %@", fullName]};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification" object:nil userInfo:statusText];
                [[IVQAPI sharedInstance] loadGames];
                [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification" object:nil userInfo:statusText];
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
