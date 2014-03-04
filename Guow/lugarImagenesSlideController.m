//
//  lugarImagenesSlideController.m
//  Guow
//
//  Created by Luis on 1/10/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "lugarImagenesSlideController.h"
#import "imageZoom.h"

@interface lugarImagenesSlideController ()<UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) UIPageViewController *pageController;
@end

@implementation lugarImagenesSlideController

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
	[_closeButton setTintColor:[UIColor blackColor]];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    imageZoom *initialViewController = (imageZoom*)[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.closeButton];
    //[self.view addSubview:self.closeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(imageZoom *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(imageZoom *)viewController index];
    
    index++;
    
    if (index == _imagenesArray.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    imageZoom *childViewController = [[imageZoom alloc] initWithNibName:@"imageZoom" bundle:nil];
    childViewController.index = index;
    [childViewController envioImagen:[_imagenesArray objectAtIndex:index]];
    return childViewController;
    
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return _imagenesArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (IBAction)closeButtonAction:(id)sender {
    [_delegate cerrarSlideImages];
}
@end
