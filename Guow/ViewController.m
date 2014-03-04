//
//  ViewController.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "ViewController.h"
#import "ModelConnection.h"
#import "MapaViewController.h"
#import "ServicioList.h"
#import "infoLugar.h"
#import "Descargar_imagenes.h"
#import <QuartzCore/QuartzCore.h>
#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface ViewController ()<MapaActionsDelegate>{
    ModelConnection *model;
}

@property (nonatomic, strong) MapaViewController *centerView;
@property (nonatomic, strong) UINavigationController *navigator;
@property (nonatomic, strong) ServicioList *menuView;
@property (nonatomic, strong) infoLugar *rightPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingRightPanel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//NSThread *myThread = [[NSThread alloc]initWithTarget:self selector:@selector(descargarInfo) object:nil];
    //[myThread start];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        self.centerView = [[MapaViewController alloc]initWithNibName:@"MapaViewController" bundle:[NSBundle mainBundle]];
    }else{
        self.centerView = [[MapaViewController alloc]initWithNibName:@"MapaiPadViewController" bundle:[NSBundle mainBundle]];
    }
    self.centerView.view.tag = CENTER_TAG;
    self.centerView.actionDelagate = self;
    [self.view addSubview:self.centerView.view];
    [self addChildViewController:_centerView];
    
    [_centerView didMoveToParentViewController:self];
}


- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value) {
        [_centerView.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerView.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerView.view.layer setShadowOpacity:0.8];
        [_centerView.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }else{
        [_centerView.view.layer setCornerRadius:0.0f];
        [_centerView.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)resetMainView
{
    if (_navigator != nil) {
        _centerView.MenuButton.tag = 0;
        _centerView.MenuButton.image = [UIImage imageNamed:@"menu_close.png"];
        self.showingLeftPanel = NO;
    }
    if (_rightPanelViewController != nil) {
        [self.rightPanelViewController.view removeFromSuperview];
        self.rightPanelViewController = nil;
        self.showingLeftPanel = NO;
    }
    
    [self showCenterViewWithShadow:NO withOffset:0];
}

- (UIView *)getLeftView
{
    if (_navigator == nil) {
        self.menuView = [[ServicioList alloc]initWithStyle:UITableViewStylePlain];
        self.navigator = [[UINavigationController alloc]initWithRootViewController:self.menuView];
        
        self.navigator.view.tag = LEFT_PANEL_TAG;
        /*
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain
                                                                         target:self action:@selector(seleccionarIdioma:)];
        self.menuView.navigationItem.leftBarButtonItems  = [NSArray arrayWithObjects:anotherButton, nil];
//        self.navigationItem.rightBarButtonItem = anotherButton;
         */
        [self.view addSubview:self.navigator.view];
        [_navigator didMoveToParentViewController:self];
        _navigator.view.frame = CGRectMake(0, 0, self.view.frame.size.width-PANEL_WIDTH, self.view.frame.size.height);
        
        [self.centerView sendServicio:self.menuView];
        
    }
    self.showingLeftPanel = YES;
    [self showCenterViewWithShadow:YES withOffset:-2];
    UIView *view = self.navigator.view;
    return view;
}

- (UIView *)getRightView
{
    if (_rightPanelViewController == nil) {
        self.rightPanelViewController = [[infoLugar alloc]initWithNibName:@"infoLugar" bundle:nil];
        self.rightPanelViewController.view.tag =RIGHT_PANEL_TAG;
        [self.rightPanelViewController reciveMapView:self.centerView];
        
        [self.view addSubview:self.rightPanelViewController.view];
        [self addChildViewController:self.rightPanelViewController];
        [self.view bringSubviewToFront:self.rightPanelViewController.view];
        [_rightPanelViewController didMoveToParentViewController:self];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _rightPanelViewController.view.frame = CGRectMake(self.view.frame.size.height-320, 0, 320, self.view.frame.size.width);
        }else{
            _rightPanelViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    self.showingRightPanel = YES;
    [self showCenterViewWithShadow:YES withOffset:2];
    UIView *view = self.rightPanelViewController.view;
    return view;
}

-(void)movePanelLeft{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerView.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        if (finished) {
            _centerView.MenuButton.tag = 1;
            _centerView.MenuButton.image = [UIImage imageNamed:@"menu_open.png"];
        }
    }];
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    [self.view sendSubviewToBack:[self getLeftView]];
    
    int tam;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //tam = -self.view.frame.size.width + PANEL_WIDTH;
        tam = -self.view.frame.size.width;
    }else{
        tam = -self.view.frame.size.width + self.view.frame.size.height - 320;
    }
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _centerView.view.frame = CGRectMake(tam, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        if (finished) {
            //_centerViewController.rightButton.tag = 0;
        }
    }];
}

-(void)movePanelToOriginalPosition{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            _centerView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        else
            _centerView.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }completion:^(BOOL finished){
        if (finished) {
            [self resetMainView];
        }
    }];
}

-(void)lugarSeleccionado:(NSString *)idLugar{
    [self.rightPanelViewController cambiarLugar:idLugar];
}

- (void)seleccionarIdioma:(id)sender{
    NSLog(@"Seleccionando");
}

-(void)descargarInfo{
    model = [[ModelConnection alloc]init];
    if (![model comprobarActualizaciones]) {
        NSLog(@"Si hay actualizaciones");
        NSLog(@"Descargando...");
        [model descargarInfo:@"select * from servicio" Archivo:@"servicio"];
        [model descargarInfo:@"select * from categoria" Archivo:@"categoria"];
        [model descargarInfo:@"select * from lugar" Archivo:@"lugar"];
        [model descargarInfo:@"select * from img_turismo" Archivo:@"imagenes"];
        NSLog(@"Terminando Descarga...");
    }
    model = nil;
    Descargar_imagenes *descarga = [[Descargar_imagenes alloc]init];
    [descarga iniciar_descarga];
}



@end
