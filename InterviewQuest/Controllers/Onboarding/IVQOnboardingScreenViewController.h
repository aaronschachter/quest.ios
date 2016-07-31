//
//  IVQOnboardingScreenViewController.h
//  InterviewQuest
//

#import <UIKit/UIKit.h>

@protocol IVQOnboardingScreenViewDelegate;

@interface IVQOnboardingScreenViewController : UIViewController

@property (weak, nonatomic) id<IVQOnboardingScreenViewDelegate> delegate;

@property (assign, nonatomic, readonly) NSInteger index;

- (instancetype)initWithIndex:(NSInteger )index title:(NSString *)title description:(NSString *)description;

@end


@protocol IVQOnboardingScreenViewDelegate <NSObject>

@optional
- (void)didTouchDoneButtonForViewController:(IVQOnboardingScreenViewController *)viewController;

@end
