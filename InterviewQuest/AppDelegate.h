//
//  AppDelegate.h
//  InterviewQuest
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

