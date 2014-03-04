//
//  NosotrosController.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "NosotrosController.h"
#import "CreditosController.h"
#import "GuiaController.h"

@interface NosotrosController ()<UITabBarDelegate>{
    CreditosController *creditos;
    GuiaController *guia;
}
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *contenidoView;

@end

@implementation NosotrosController

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
    [_tabBar setDelegate:self];
    creditos = [[CreditosController alloc]init];
    guia = [[GuiaController alloc]init];
    [guia.view setFrame:CGRectMake(0, 0, _contenidoView.frame.size.width, _contenidoView.frame.size.height)];
    [_contenidoView addSubview:guia.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(id)sender {
    [_delegate cerrarAbout];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    for (UIView *v in _contenidoView.subviews) {
        [v removeFromSuperview];
    }
    if (item.tag == 0) {
        //fav = [[FavoritosList alloc]init];
        [guia.view setFrame:CGRectMake(0, 0, _contenidoView.frame.size.width, _contenidoView.frame.size.height)];
        [_contenidoView addSubview:guia.view];
    }else{
        [creditos.view setFrame:CGRectMake(0, 0, _contenidoView.frame.size.width, _contenidoView.frame.size.height)];
        [_contenidoView addSubview:creditos.view];
    }
}

@end
