//
//  infoLugar.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "infoLugar.h"
#import "tituloTableCell.h"
#import "descripcionTableCell.h"
#import "mapaTableCell.h"
#import "ModelConnection.h"
#import "imageZoom.h"
#import "ubicacionTableCell.h"
#import "tarifaTableCell.h"
#import "webTableCell.h"
#import "imageSlideTableCell.h"
#import "lugarImagenesSlideController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>

@interface infoLugar ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,imageSlideTableCellProtocol,imageZoomProtocol,imageZoomProtocol,tituloTableCellProtocol,lugarImagenesSlideControllerProtocol,MFMailComposeViewControllerDelegate>{
    MapaViewController *viewMap;
    NSString *idLugar;
    NSString *desing,*desesp;
    ModelConnection *model;
    NSMutableArray *listadoImagenes;
    NSDictionary *titulos,*descripcion,*mapa;
    tituloTableCell *CellTitulos;
    descripcionTableCell *CellDescripcion;
    mapaTableCell *CellMapa;
    ubicacionTableCell *CellUbicacion;
    tarifaTableCell *CellTarifa;
    webTableCell *CellWeb;
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
                       [dict objectForKey:@"logo"],@"logo",
                       [dict objectForKey:@"idlugar"],@"id",
                       [dict objectForKey:@"horario_esp"],@"horarioesp",
                       [dict objectForKey:@"horario_ing"],@"horarioing",
                       [dict objectForKey:@"servicio"],@"servicio",
                       nil];
            descripcion = [[NSDictionary alloc]initWithObjectsAndKeys:
                           [dict objectForKey:@"desing"],@"desing",
                           [dict objectForKey:@"desesp"],@"desesp",
                           [dict objectForKey:@"web"],@"web",
                           [dict objectForKey:@"direccion"],@"direccion",
                           [dict objectForKey:@"tarifa_esp"],@"tarifaesp",
                           [dict objectForKey:@"tarifa_ing"],@"tarifaing",
                           nil];
            mapa = [[NSDictionary alloc]initWithObjectsAndKeys:
                    [dict objectForKey:@"latitud"],@"latitud",
                    [dict objectForKey:@"longitud"],@"longitud",
                    nil];
            //[listadoImagenes addObject:[dict objectForKey:@"imgesp"]];
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
    _barraTitulo.title = [titulos objectForKey:@"nombre"];
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
    return 7;
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
            imageSlideTableCell *cell = [[imageSlideTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (imageSlideTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"imageSlideTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setDelegate:self];
            [cell imagenes:listadoImagenes];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
            ubicacionTableCell *cell = [[ubicacionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (ubicacionTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ubicacionTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setData:descripcion];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellUbicacion = cell;
            return cell;
            break;
        }
        case 4:{
            tarifaTableCell *cell = [[tarifaTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (tarifaTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tarifaTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setData:descripcion];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellTarifa = cell;
            return cell;
            break;
        }
        case 5:{
            webTableCell *cell = [[webTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (webTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"webTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setData:descripcion];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CellWeb = cell;
            return cell;
            break;
        }
        case 6:{
            mapaTableCell *cell = [[mapaTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = (mapaTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mapaTableCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell valores:mapa];
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
    /*
    switch (indexPath.row) {
        case 0:
            return 207;
            break;
        case 1:
            return 148;
            break;
        case 2:{
            UITableViewCell *cell = [self tableView:tableView
                              cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
         //   return 505;
            break;
        case 3:
            return 200;
            break;
        default:
            return 44;
            break;
    }
     */
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    [CellTarifa cambiarIdioma];
}

-(void)abrirImagenSeleccionada:(NSString *)imagen{
    /*
    imageZoom *zooming = [[imageZoom alloc]init];
    zooming.modalPresentationStyle = UIModalPresentationFormSheet;
    zooming.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [zooming setDelegate:self];
    [zooming envioImagen:[listadoImagenes objectAtIndex:[imagen intValue]]];
    [self presentViewController:zooming animated:YES completion:nil];
     */
    lugarImagenesSlideController *lug = [[lugarImagenesSlideController alloc]initWithNibName:@"lugarImageSlideController" bundle:nil];
    [lug setModalPresentationStyle:UIModalPresentationFormSheet];
    [lug setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [lug setDelegate:self];
    [lug setImagenesArray:listadoImagenes];
    [self presentViewController:lug animated:YES completion:nil];
}

-(void)exitModal{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)facebookOpen{
    NSLog(@"Facebook Open");
    /*
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"First post from my iPhone app"];
        [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
        [controller addImage:[model buscarImagen:[listadoImagenes objectAtIndex:0]]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   [listadoImagenes objectAtIndex:0], @"picture",
                                   nil];
    
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)twitterOpen{
    NSLog(@"Twitter Open");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
        [tweetSheet addImage:[model buscarImagen:[listadoImagenes objectAtIndex:0]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(void)mailOpen{
    NSLog(@"Email Open");
    NSString *emailTitle = @"Great Photo and Doc";
    NSString *messageBody = @"Hey, check this out!";
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    for (NSString *s in listadoImagenes) {
        NSString *img = [model getPathImagenes:s];
    
        // Determine the file name and extension
        NSArray *filepart = [img componentsSeparatedByString:@"/"];
        NSString *filename = [filepart objectAtIndex:filepart.count-1];
    
        filepart = [filename componentsSeparatedByString:@"."];
        filename = [filepart objectAtIndex:filepart.count-2];
        NSString *extension = [filepart objectAtIndex:filepart.count-1];
    
        NSData *fileData = [NSData dataWithContentsOfFile:img];
    
        NSString *mimeType;
        if ([extension isEqualToString:@"jpg"]) {
            mimeType = @"image/jpeg";
        } else if ([extension isEqualToString:@"png"]) {
            mimeType = @"image/png";
        } else if ([extension isEqualToString:@"doc"]) {
            mimeType = @"application/msword";
        } else if ([extension isEqualToString:@"ppt"]) {
            mimeType = @"application/vnd.ms-powerpoint";
        } else if ([extension isEqualToString:@"html"]) {
            mimeType = @"text/html";
        } else if ([extension isEqualToString:@"pdf"]) {
            mimeType = @"application/pdf";
        }
    
        [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    }
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)cerrarSlideImages{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
