//
//  IVQOnboardingViewController.m
//  InterviewQuest
//

#import "IVQOnboardingViewController.h"
#import "IVQOnboardingScreenViewController.h"

@interface IVQOnboardingViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, IVQOnboardingScreenViewDelegate>

@property (strong, nonatomic) NSArray *screenContent;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation IVQOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view = [[UIView alloc] init];
    NSDictionary *firstScreen = @{
                                  @"title": @"Welcome to InterviewQuest!",
                                  @"description": @"Train for your next job interview\nfrom your phone."
                                  };
    NSDictionary *secondScreen = @{
                                  @"title": @"We ask questions,\nyou answer",
                                  @"description": @"A round of InterviewQuest\nis 3 questions."
                                  };
    NSDictionary *lastScreen = @{
                                   @"title": @"Track your progress",
                                   @"description": @"Sign in with your Google account to save your answers and review past rounds of InterviewQuest."
                                   };
    self.screenContent = @[firstScreen, secondScreen, lastScreen];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.view.frame = self.view.bounds;
    IVQOnboardingScreenViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.pageViewController willMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self styleView];
}

#pragma mark - IVQOnboardingViewController 

- (void)styleView {
    self.pageViewController.view.backgroundColor = UIColor.whiteColor;
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
    pageControl.currentPageIndicatorTintColor = self.view.tintColor;
}

- (IVQOnboardingScreenViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.screenContent.count) {
        return nil;
    }
    NSDictionary *content = (NSDictionary *)self.screenContent[index];
    IVQOnboardingScreenViewController *viewController = [[IVQOnboardingScreenViewController alloc] initWithIndex:index title:content[@"title"] description:content[@"description"]];
    viewController.delegate = self;
    return viewController;
}

#pragma mark - UIPageViewControllerDataSource


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(IVQOnboardingScreenViewController *)viewController index];
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(IVQOnboardingScreenViewController *)viewController index];
    index++;
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.screenContent.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - IVQOnboardingScreenViewDelegate

- (void)didTouchDoneButtonForViewController:(IVQOnboardingScreenViewController *)viewController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasCompletedOnboarding"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
