//
//  infoLugar.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "infoLugar.h"
#import "tituloTableCell.h"
#import "imageTableCell.h"
#import "descripcionTableCell.h"
#import "mapaTableCell.h"
#import "ModelConnection.h"
#import "imageZoom.h"
#import <Social/Social.h>

#define COLOR_BASE [UIColor colorWithRed:254.0/255.0 green:194.0/255.0 blue:15.0/255.0 alpha:1.0];

@interface infoLugar ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,imageTableCellProtocol,imageZoomProtocol,imageZoomProtocol,tituloTableCellProtocol>{
    MapaViewController *viewMap;
    NSString *idLugar;
    NSString *desing,*desesp;
    ModelConnection *model;
    NSMutableArray *listadoImagenes;
    NSDictionary *titulos,*descripcion,*mapa;
    tituloTableCell *CellTitulos;
    descripcionTableCell *CellDescripcion;
    mapaTableCell *CellMapa;
    imageTableCell *CellImage;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarra;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonBarBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonBarConfig;
@property (weak, nonatomic) IBOutlet UINavigationItem *barraTitulo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation infoLugar

-(void)cargarDatos{
    
    model = [[ModelConnection alloc]init];
    listadoImagenes = [[NSMutableArray alloc]init];
    NSMutableArray *adat = [model consulta:@"lugar"];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *dict = [adat objectAtIndex:i];
        if ([[dict objectForKey:@"idlugar"]isEqualToString:idLugar]) {
            titulos = [[NSDictionary alloc]initWithObjectsAndKeys:
                       [dict objectForKey:@"nombre"],@"nombre",
                       @"",@"horario",
                       @"",@"horarioing",
                       [dict objectForKey:@"logo"],@"logo",
                       [dict objectForKey:@"idlugar"],@"id",
                       [dict objectForKey:@"imgesp"],@"imagen",
                       nil];
            descripcion = [[NSDictionary alloc]initWithObjectsAndKeys:
                           [dict objectForKey:@"desing"],@"desing",
                           [dict objectForKey:@"desesp"],@"desesp",
                           [dict objectForKey:@"web"],@"web",
                           nil];
           
            [listadoImagenes addObject:[dict objectForKey:@"imgesp"]];
        }
    }
    adat = [model consulta:@"imagenes"];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *dict = [adat objectAtIndex:i];
        if ([[dict objectForKey:@"lugar"]isEqualToString:idLugar]) {
            [listadoImagenes addObject:[dict objectForKey:@"imagen"]];
        }
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritos = [def objectForKey:@"favoritos"];
    for (NSString *linea in favoritos) {
        if ([linea isEqualToString:idLugar]) {
            //self.bookmarkButton.tag=1;
            //self.bookmarkButton.tintColor = [UIColor redColor];
            break;
        }else{
            //self.bookmarkButton.tintColor = originalColor;
            //self.bookmarkButton.tag = 0;
        }
    }
    [_tableView reloadData];
}

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
    self.navigationBarra.barTintColor = COLOR_BASE;
    self.navigationBarra.tintColor = [UIColor whiteColor];
    self.buttonBarBack.tintColor = [UIColor whiteColor];
    self.buttonBarConfig.tintColor = [UIColor whiteColor];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Hola";
     */
    
    switch (indexPath.row) {
        case 0:{
            imageTableCell *cell = [[imageTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (imageTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"imageTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setDelegate:self];
            [cell imagenes:listadoImagenes];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellImage = cell;
            return cell;
            break;
        }
        case 1:{
            tituloTableCell *cell = (tituloTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tituloTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell nombre:titulos];
            [cell setDelegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellTitulos = cell;
            return cell;
            break;
        }
        case 2:{
            descripcionTableCell *cell = [[descripcionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (descripcionTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"descripcionTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell valores:descripcion];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellDescripcion = cell;
            return cell;
            break;
        }
        case 3:{
            mapaTableCell *cell = [[mapaTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (mapaTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mapaTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellMapa = cell;
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 207;
            break;
        case 1:
            return 148;
            break;
        case 2:
            return 505;
            break;
        case 3:
            return 200;
            break;
        default:
            return 44;
            break;
    }
}

-(void)reciveMapView:(MapaViewController *)map{
    viewMap = map;
    [self cambiarLugar:[viewMap idInfolugar]];
}

-(void)cambiarLugar:(NSString *)lug{
    idLugar = lug;
    [self cargarDatos];
}

- (IBAction)volverAtras:(id)sender {
    [viewMap cerrarInfoPanel];
}

- (IBAction)configButtonAction:(id)sender {
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
    [CellTitulos cambiarIdioma];
    [CellDescripcion cambioIdioma];
}

-(void)abrirImagenSeleccionada:(NSString *)imagen{
    imageZoom *zooming = [[imageZoom alloc]init];
    zooming.modalPresentationStyle = UIModalPresentationFormSheet;
    zooming.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [zooming setDelegate:self];
    [zooming envioImagen:[listadoImagenes objectAtIndex:[imagen intValue]]];
    [self presentViewController:zooming animated:YES completion:nil];
}

-(void)exitModal{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)facebookOpen{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"First post from my iPhone app"];
        [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
        [controller addImage:[model buscarImagen:[listadoImagenes objectAtIndex:0]]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

-(void)twitterOpen{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
        [tweetSheet addImage:[model buscarImagen:[listadoImagenes objectAtIndex:0]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

@end
