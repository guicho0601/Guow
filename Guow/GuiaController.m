//
//  GuiaController.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "GuiaController.h"
#import "ImageSlideController.h"

@interface GuiaController ()<UIPageViewControllerDataSource>{
    NSArray *imagenes;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@end

@implementation GuiaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imagenes = [NSArray arrayWithObjects:
                @"ic20.png",
                @"menu_close.png",
                @"menu_open.png",
                @"Museos.png",
                nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ImageSlideController *initialViewController = (ImageSlideController*)[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ImageSlideController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = [(ImageSlideController *)viewController index];
    
    index++;
    
    if (index == imagenes.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ImageSlideController *childViewController = [[ImageSlideController alloc] initWithNibName:@"ImageSlideController" bundle:nil];
    childViewController.index = index;
    childViewController.imgname = [imagenes objectAtIndex:index];
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return imagenes.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
