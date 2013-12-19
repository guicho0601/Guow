//
//  infoLugarView.m
//  Guow
//
//  Created by Luis on 12/16/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "infoLugarView.h"
#import "ModelConnection.h"
#import "imageZoom.h"
#import <Social/Social.h>

@interface infoLugarView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,imageZoomProtocol,UIActionSheetDelegate>{
    MapaViewController *viewMap;
    NSString *idLugar;
    NSString *desing,*desesp;
    ModelConnection *model;
    NSMutableArray *listadoImagenes;
    float widthCell, heightCell;
    CGFloat scale;
    UIColor *originalColor;
}
@property (weak, nonatomic) IBOutlet UILabel *nombreLugar;
@property (weak, nonatomic) IBOutlet UITextView *descripcionLugar;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *configButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarkButton;

@end

@implementation infoLugarView

-(void)cargarDatos{
    widthCell = self.imageCollection.frame.size.height;
    heightCell = widthCell/2;
    if (widthCell >= self.imageCollection.frame.size.width) {
        widthCell = self.imageCollection.frame.size.width *.9;
    }
    
    model = [[ModelConnection alloc]init];
    listadoImagenes = [[NSMutableArray alloc]init];
    NSMutableArray *adat = [model consulta:@"lugar"];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *dict = [adat objectAtIndex:i];
        if ([[dict objectForKey:@"idlugar"]isEqualToString:idLugar]) {
            self.nombreLugar.text = [dict objectForKey:@"nombre"];
            desing = [dict objectForKey:@"desing"];
            desesp = [dict objectForKey:@"desesp"];
            [listadoImagenes addObject:[dict objectForKey:@"imgesp"]];
            [self cambiarIdioma];
        }
    }
    adat = [model consulta:@"imagenes"];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *dict = [adat objectAtIndex:i];
        if ([[dict objectForKey:@"lugar"]isEqualToString:idLugar]) {
            [listadoImagenes addObject:[dict objectForKey:@"imagen"]];
        }
    }
    [self.imageCollection reloadData];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritos = [def objectForKey:@"favoritos"];
    for (NSString *linea in favoritos) {
        if ([linea isEqualToString:idLugar]) {
            self.bookmarkButton.tag=1;
            self.bookmarkButton.tintColor = [UIColor redColor];
            break;
        }else{
            self.bookmarkButton.tintColor = originalColor;
            self.bookmarkButton.tag = 0;
        }
    }
}

-(void)cambiarIdioma{
    if ([model comprobarIdioma]==1) {
        self.webButton.titleLabel.text = @"Sitio Web";
        self.descripcionLugar.text = desesp;
    }else{
        self.webButton.titleLabel.text = @"Web Site";
        self.descripcionLugar.text = desing;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageCollection setDataSource:self];
    [self.imageCollection setDelegate:self];
    [self.imageCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    originalColor = self.bookmarkButton.tintColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [listadoImagenes count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor blueColor];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[model buscarImagen:[listadoImagenes objectAtIndex:indexPath.row]]];
    [imgView setFrame:CGRectMake(0, 0, widthCell, heightCell)];
    [cell addSubview:imgView];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(widthCell, heightCell);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    imageZoom *zooming = [[imageZoom alloc]init];
    zooming.modalPresentationStyle = UIModalPresentationFormSheet;
    zooming.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [zooming setDelegate:self];
    [zooming envioImagen:[listadoImagenes objectAtIndex:indexPath.row]];
    [self presentViewController:zooming animated:YES completion:nil];
}


-(void)reciveMapView:(MapaViewController *)map{
    viewMap = map;
    [self cambiarLugar:[viewMap idInfolugar]];
}

-(void)cambiarLugar:(NSString *)lug{
    idLugar = lug;
    [self cargarDatos];
}

- (IBAction)abrirSitioWeb:(id)sender {
    
}

- (IBAction)volverAtras:(id)sender {
    [viewMap cerrarInfoPanel];
}

-(void)exitModal{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonFaceBook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"First post from my iPhone app"];
        [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
        [controller addImage:[model buscarImagen:[listadoImagenes objectAtIndex:0]]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

- (IBAction)buttonTwitterAction:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
        [tweetSheet addImage:[model buscarImagen:[listadoImagenes objectAtIndex:0]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)buttonConfigAction:(id)sender {
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
    [self cambiarIdioma];
}

- (IBAction)buttonBookMarkAction:(id)sender {
    UIBarButtonItem *button = sender;
    NSString *mensaje,*titulo;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritos = [[def objectForKey:@"favoritos"]mutableCopy];
    if (!favoritos) {
        favoritos =[[NSMutableArray alloc]init];
    }
    if (button.tag == 0) {
        originalColor = button.tintColor;
        button.tintColor = [UIColor redColor];
        button.tag = 1;
        [favoritos addObject:idLugar];
        if ([model comprobarIdioma]==1) {
            titulo = @"Favoritos";
            mensaje = @"Lugar agregado a favoritos";
        }else{
            titulo = @"Bookmarks";
            mensaje = @"Place added to bookmarks";
        }
    }else{
        button.tintColor = originalColor;
        button.tag = 0;
        for (int i=0; i<favoritos.count; i++) {
            NSString *linea = [favoritos objectAtIndex:i];
            if ([idLugar isEqualToString:linea]) {
                [favoritos removeObjectAtIndex:i];
                break;
            }
        }
        if ([model comprobarIdioma]==1) {
            titulo = @"Favoritos";
            mensaje = @"Lugar eliminado de favoritos";
        }else{
            titulo = @"Bookmarks";
            mensaje = @"Place remove from bookmarks";
        }
    }
    [def setObject:favoritos forKey:@"favoritos"];
    [def synchronize];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titulo message:mensaje delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
