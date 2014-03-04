//
//  ImageSlideController.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "ImageSlideController.h"
#import "ModelConnection.h"

@interface ImageSlideController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageSlideController

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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    if (!_isPlace) {
        [_imageView setImage:[UIImage imageNamed:_imgname]];
    }else{
        ModelConnection *model = [[ModelConnection alloc]init];
        [_imageView setImage:[model buscarImagen:_imgname]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
