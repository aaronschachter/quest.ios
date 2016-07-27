//
//  IVQOnboardingScreenViewController.h
//  InterviewQuest
//

#import <UIKit/UIKit.h>

@interface IVQOnboardingScreenViewController : UIViewController

@property (assign, nonatomic, readonly) NSInteger index;

- (instancetype)initWithIndex:(NSInteger )index description:(NSString *)description;

@end
