//
//  MapaViewController.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "MapaViewController.h"
#import "CategoriaList.h"
#import "Lugar.h"
#import "ModelConnection.h"
#import "Lugar.h"

@interface MapaViewController () <servicioProtocol,categoriaProtocol,lugarProtocol,UIActionSheetDelegate,UIScrollViewDelegate>{
    CategoriaList *listCategoria;
    LugarList *listLugar;
    ModelConnection *model;
    ServicioList *listServicio;
    NSMutableArray *locacionesArray;
    Lugar *lugares;
    int menuTouch;
    NSString *idBusqueda;
    float ultx, ulty;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;


@end

@implementation MapaViewController

-(void)cargarDatos{
    if (locacionesArray != nil) [locacionesArray removeAllObjects];
    else locacionesArray = [[NSMutableArray alloc]init];
    
    [self limpiarimagen];

    model = [[ModelConnection alloc]init];
    NSMutableArray *adat = [model consulta: @"lugar"];
    for (int i =0 ; i< adat.count; i++) {
        NSDictionary *info = [adat objectAtIndex:i];
        switch (menuTouch) {
            case 1:
                [self llenarLugaresArray:info];
                break;
            case 2:
                if ([[info objectForKey:@"servicio"] isEqualToString:idBusqueda]) {
                    [self llenarLugaresArray:info];
                }
                break;
            case 3:
                if ([[info objectForKey:@"categoria"]isEqualToString:idBusqueda]) {
                    [self llenarLugaresArray:info];
                }
                break;
            case 4:
                if ([[info objectForKey:@"idlugar"]isEqualToString:idBusqueda]) {
                    [self llenarLugaresArray:info];
                }
                break;
                
            default:
                break;
        }
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self.scrollView scrollRectToVisible:CGRectMake(ultx - (self.view.frame.size.height/2),ulty - (self.view.frame.size.width/2), self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(ultx - (self.view.frame.size.width/2),ulty - (self.view.frame.size.height/2), self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    }
    self.scrollView.contentSize = self.imageView.image.size;
    
}

-(void)llenarLugaresArray:(NSDictionary*)dict{
    Lugar *aux = [[Lugar alloc]init];
    aux.idlocal = [[dict objectForKey:@"idlugar"]intValue];
    aux.posx = [[dict objectForKey:@"posx"]intValue];
    aux.posy = [[dict objectForKey:@"posy"]intValue];
    aux.logo = [dict objectForKey:@"logo"];
    [self ubicarbotones:[NSString stringWithFormat:@"%d",aux.idlocal] imagen:aux.logo horizontal:aux.posx vertical:aux.posy];
}


-(void)ubicarbotones:(NSString*)titulo imagen:(NSString*)imgName horizontal:(float)x vertical:(float)y{
    //x = y = 1500;
    UIImage *imagen = [UIImage imageNamed:@"menu_close.png"];
    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDetail.frame = CGRectMake(x,y,imagen.size.width,imagen.size.height);
    [btnDetail addTarget:self action:@selector(abririnfo:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetail setTitle:titulo forState:UIControlStateNormal];
    [btnDetail setImage:imagen forState:UIControlStateNormal];
    [self.imageView addSubview:btnDetail];
    [self.imageView bringSubviewToFront:btnDetail];
    [self.imageView setUserInteractionEnabled:YES];
    ultx = x;
    ulty = y;
}

-(void)abririnfo:(UIButton *)sender{
    NSLog(@"Button Action %@",sender.titleLabel.text);
}

-(void)limpiarimagen{
    UIButton *btn = nil;
    NSArray *Array1 = [self.imageView subviews];
    for (btn in Array1){
        if ([btn isKindOfClass:[UIButton class]]){
            [btn removeFromSuperview];
        }
    }
    
}

-(void)posiciontoque:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.scrollView];
    NSLog(@"X = %f , Y = %f",point.x,point.y);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)sendServicio:(ServicioList*)list{
    listServicio = list;
    [listServicio setDelegate:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [[ModelConnection alloc]init];
    
    UIImage *image = [UIImage imageNamed:@"Mapa_Sample_50.jpg"];
    [self.imageView setImage:image];
    [self.imageView sizeToFit];
    self.scrollView.delegate = self;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(posiciontoque:)];
    tapgesture.numberOfTapsRequired = 1;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = self.imageView.image.size;
    [self.scrollView setUserInteractionEnabled:YES];
    [self.imageView setUserInteractionEnabled:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [_actionDelagate movePanelLeft];
        [_actionDelagate movePanelToOriginalPosition];
    }
    
    //[self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonAction:(id)sender {
    UIBarButtonItem *button = sender;
    switch (button.tag) {
        case 0:{
            [_actionDelagate movePanelLeft];
            break;
        }
        case 1:{
            [_actionDelagate movePanelToOriginalPosition];
            break;
        }
        default:
            break;
    }
    self.scrollView.contentSize = self.imageView.image.size;
}

- (IBAction)selectLanguage:(id)sender {
    NSString *mensaje,*cancelar;
    if ([model comprobarIdioma] == 2) {
        mensaje = @"Select the language of your choice";
        cancelar = @"Cancel";
    }else{
        mensaje = @"Seleccion el idioma de su preferencia";
        cancelar = @"Cancelar";
    }
    
    UIActionSheet *language = [[UIActionSheet alloc]initWithTitle:mensaje delegate:self cancelButtonTitle:cancelar destructiveButtonTitle:nil otherButtonTitles:@"English",@"Español", nil];
    [language setActionSheetStyle:UIActionSheetStyleDefault];
    [language showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex	{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 0:
            [defaults setObject:[NSNumber numberWithInt:2] forKey:@"idioma"];
            break;
        case 1:
            [defaults setObject:[NSNumber numberWithInt:1] forKey:@"idioma"];
            break;
        default:
            break;
    }
    [defaults synchronize];
    [listServicio cambioIdioma];
    if (listCategoria != nil) [listCategoria cambioIdioma];
    if (listLugar != nil) [listLugar cambioIdioma];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)centerScrollViewContents {
    CGPoint centerOffset = CGPointMake(self.imageView.center.x - (self.view.frame.size.width/2), self.imageView.center.y - (self.view.frame.size.height/2));
    [self.scrollView setContentOffset: centerOffset animated: YES];
}

-(void)sendLugar:(LugarList *)list{
    listLugar = list;
    [listLugar setDelegate:self];
}

-(void)sendCategoria:(CategoriaList*)list{
    listCategoria = list;
    [listCategoria setDelegate:self];
}

-(void)allServices{
    menuTouch = 1;
    [self cargarDatos];
    [_actionDelagate movePanelToOriginalPosition];
}

-(void)allCategories:(NSString *)idcat{
    menuTouch = 2;
    idBusqueda = idcat;
    [self cargarDatos];
    [_actionDelagate movePanelToOriginalPosition];
}

-(void)allPlaces:(NSString*)idCat{
    menuTouch = 3;
    idBusqueda = idCat;
    [self cargarDatos];
    [_actionDelagate movePanelToOriginalPosition];
}

-(void)selectPlace:(NSString*)idPlace{
    menuTouch = 4;
    idBusqueda = idPlace;
    [self cargarDatos];
    [_actionDelagate movePanelToOriginalPosition];
}

@end