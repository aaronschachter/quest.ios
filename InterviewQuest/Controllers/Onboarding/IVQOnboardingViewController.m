//
//  IVQOnboardingViewController.m
//  InterviewQuest
//

#import "IVQOnboardingViewController.h"
#import "IVQOnboardingScreenViewController.h"

@interface IVQOnboardingViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation IVQOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view = [[UIView alloc] init];

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
    NSString *description = @"Welcome to InterviewQuest!";
    if (index < 0 || index >= 2) {
        return nil;
    }
    if (index == 1) {
        description = @"Sign in with your Google account to store your answers and track your progress.";
    }
    IVQOnboardingScreenViewController *viewController = [[IVQOnboardingScreenViewController alloc] initWithIndex:index description:description];
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
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
