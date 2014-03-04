//
//  imageSlideTableCell.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "imageSlideTableCell.h"
#import "ImageSlideController.h"

@interface imageSlideTableCell()<UIPageViewControllerDataSource>{
    NSArray *imagenesArray;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation imageSlideTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    if (index == imagenesArray.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ImageSlideController *childViewController = [[ImageSlideController alloc] initWithNibName:@"ImageSlideController" bundle:nil];
    childViewController.index = index;
    childViewController.imgname = [imagenesArray objectAtIndex:index];
    childViewController.isPlace = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
    tap.numberOfTapsRequired = 1;
    [childViewController.view addGestureRecognizer:tap];
    childViewController.view.tag = index;
    return childViewController;
    
}

-(void)imageTouch:(id)sender{
    ImageSlideController *img = (ImageSlideController*)sender;
    //NSLog(@"Tag: %d",img.view.tag);
    [_delegate abrirImagenSeleccionada:[NSString stringWithFormat:@"%d",img.view.tag]];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return imagenesArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

-(void)imagenes:(NSMutableArray *)imagenes{
    imagenesArray = imagenes;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    [[self.pageController view] setFrame:self.contentView.bounds];
    
    ImageSlideController *initialViewController = (ImageSlideController*)[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.contentView addSubview:[self.pageController view]];
}

@end
