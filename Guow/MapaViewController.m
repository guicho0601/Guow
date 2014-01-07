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
#import "FavoritosList.h"
#import "BusquedaController.h"
#import "TablaPromociones.h"

#define COLOR_BASE [UIColor colorWithRed:254.0/255.0 green:194.0/255.0 blue:15.0/255.0 alpha:1.0];

@interface MapaViewController () <servicioProtocol,categoriaProtocol,lugarProtocol,UIActionSheetDelegate,UIScrollViewDelegate,favoritosListProtocol,busquedaProtocol,PromocionesProtocol>{
    CategoriaList *listCategoria;
    LugarList *listLugar;
    ModelConnection *model;
    ServicioList *listServicio;
    Lugar *lugares;
    int menuTouch;
    NSString *idBusqueda;
    float ultx, ulty;
    NSString *idLugar;
    UIActivityIndicatorView	*indicador;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *configButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *itemsNavegacion;


@end

@implementation MapaViewController

-(void)cargarDatos{
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
    UIImage *imagen;
    NSArray *stArray = [imgName componentsSeparatedByString:@"/"];
    if (stArray.count == 1) imagen = [UIImage imageNamed:imgName];
    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    idLugar = sender.titleLabel.text;
    self.configButton.enabled = NO;
    [_actionDelagate lugarSeleccionado:idLugar];
    [_actionDelagate movePanelRight];
    
    //infoLugar *info = [[infoLugar alloc]init];
    //[self presentViewController:info animated:YES completion:nil];
}

-(NSString*)idInfolugar{
    return idLugar;
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
    self.view.backgroundColor = COLOR_BASE;
    UIImage *image = [UIImage imageNamed:@"Mapa_Sample_50.jpg"];
    [self.imageView setImage:image];
    [self.imageView sizeToFit];
    self.scrollView.delegate = self;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    menuTouch = 2;
    idBusqueda = @"1";
    //UIBarButtonItem *btnBookmark = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(openBookMarks)];
    //[self.itemsNavegacion setRightBarButtonItems:[NSArray arrayWithObjects:self.configButton,btnBookmark, nil]];
    UIBarButtonItem *busquedaButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lup.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(openSearch)];
    [self.itemsNavegacion setLeftBarButtonItems:[NSArray arrayWithObjects:self.MenuButton,busquedaButton, nil]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    [self cargarDatos];
    //[self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ABRIR FAVORITOS
-(void)openBookMarks{
    FavoritosList *fav = [[FavoritosList alloc]initWithStyle:UITableViewStylePlain];
    [fav setDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:fav];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)openSearch{
    BusquedaController *bus = [[BusquedaController alloc]init];
    [bus setDelegate:self];
    bus.modalPresentationStyle = UIModalPresentationFormSheet;
    bus.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:bus animated:YES completion:nil];
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

-(void)cerrarInfoPanel{
    self.configButton.enabled = YES;
    [_actionDelagate movePanelToOriginalPosition];
}

-(void)cerrarBookmarks:(NSString *)lugar{
    if (![lugar isEqualToString:@""]) {
        menuTouch = 4;
        idBusqueda = lugar;
        [self cargarDatos];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)abrirFavorito:(NSString *)lugar{
    menuTouch = 4;
    idBusqueda = lugar;
    [self cargarDatos];
    [_actionDelagate movePanelToOriginalPosition];
}

-(void)abrirPromociones{
    [_actionDelagate movePanelToOriginalPosition];
    
    indicador = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicador setHidesWhenStopped:YES];
    [indicador setCenter:self.view.center];
    [self.view addSubview:indicador];
    [indicador startAnimating];
    
    TablaPromociones *tabla = [[TablaPromociones alloc]initWithStyle:UITableViewStyleGrouped];
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabla];
    tabla.modalPresentationStyle = UIModalPresentationFormSheet;
    tabla.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [tabla setDelegate:self];
    [self presentViewController:tabla animated:YES completion:nil];
 
}

-(void)cerrarPromocion{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)terminaCargaPromocion{
    [indicador stopAnimating];
}

-(void)abrirLugarPromocion:(NSString *)idlugar{
    [self dismissViewControllerAnimated:YES completion:nil];
    menuTouch = 4;
    idBusqueda = idlugar;
    [self cargarDatos];
}

@end
