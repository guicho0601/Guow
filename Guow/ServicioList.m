//
//  ServicioList.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "ServicioList.h"
#import "Servicio.h"
#import "ModelConnection.h"
#import "FavoritosList.h"
#define TABLA @"servicio"
#define color_base [UIColor colorWithRed:(254/255.0) green:(194/255.0) blue:(15/255.0) alpha:1]

@interface ServicioList ()<favoritosListProtocol>{
    NSMutableArray *serviciosArray;
    ModelConnection *model;
}

@end

@implementation ServicioList

-(void)cargarDatos{
    if (serviciosArray != nil) {
        [serviciosArray removeAllObjects];
    }else {
        serviciosArray = [[NSMutableArray alloc]init];
    }
    
    model = [[ModelConnection alloc]init];
    NSMutableArray *adat = [model consulta:TABLA];
    
    Servicio *aux = [[Servicio alloc]init];
    aux.servicioesp = @"Mostrar todos";
    aux.servicioing = @"Show all";
    aux.icono = @"ic13.png";
    [serviciosArray addObject:aux];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *info = [adat objectAtIndex:i];
        aux = [[Servicio alloc]init];
        aux.idservicio = [[info objectForKey:@"idservicio"]intValue];
        aux.servicioesp = [info objectForKey:@"nomesp"];
        aux.servicioing = [info objectForKey:@"noming"];
        aux.icono = [info objectForKey:@"icono"];
        [serviciosArray addObject:aux];
    }
    
    aux = [[Servicio alloc]init];
    aux.servicioesp = @"Informacion general";
    aux.servicioing = @"General Info";
    aux.icono = @"ic14.png";
    [serviciosArray addObject:aux];
    
    aux = [[Servicio alloc]init];
    aux.servicioesp = @"Favoritos";
    aux.servicioing = @"Favorites";
    aux.icono = @"ic16.png";
    [serviciosArray addObject:aux];
    
    aux = [[Servicio alloc]init];
    aux.servicioesp = @"Promociones";
    aux.servicioing = @"Promotions";
    aux.icono = @"ic15.png";
    [serviciosArray addObject:aux];
    
    aux = [[Servicio alloc]init];
    aux.servicioesp = @"Conocenos";
    aux.servicioing = @"About us";
    aux.icono = @"ic14.png";
    [serviciosArray addObject:aux];
}

-(void)cambioIdioma{
    [self establecerTitulo];
    [self.tableView reloadData];
}

-(void)establecerTitulo{
    if ([model comprobarIdioma]==1) self.title = @"Servicios";
    else self.title = @"Services";
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [self cargarDatos];
    [self establecerTitulo];
    //[self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [serviciosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Servicio *aux = [serviciosArray objectAtIndex:indexPath.row];
    if ([model comprobarIdioma]==1) cell.textLabel.text = aux.servicioesp;
    else cell.textLabel.text = aux.servicioing;
    if(aux.icono != nil) cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",AMARILLO,aux.icono]];
    cell.textLabel.text = [cell.textLabel.text uppercaseString];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic19.png"]];
    cell.textLabel.font = [UIFont fontWithName:FUENTE size:12.0f];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [_delegate allServices];
    }else if (indexPath.row==2){
        
    }else if (indexPath.row==3){
        FavoritosList *fav = [[FavoritosList alloc]init];
        [fav setDelegate:self];
        [self.navigationController pushViewController:fav animated:YES];
        //[self presentViewController:fav animated:YES completion:nil];
    }else if (indexPath.row==4){
        [_delegate abrirPromociones];
    }
    else if(indexPath.row == 5){
        [_delegate abrirAbout];
    }
    else{
        CategoriaList *catList = [[CategoriaList alloc]initWithStyle:UITableViewStyleGrouped];
        [_delegate sendCategoria:catList];
        Servicio *aux = [serviciosArray objectAtIndex:indexPath.row];
        [catList servicioSeleccionado:[NSString stringWithFormat:@"%d",aux.idservicio] esp:aux.servicioesp ing:aux.servicioing];
        [self.navigationController pushViewController:catList animated:YES];
    }
}

-(void)cerrarBookmarks:(NSString *)lugar{
    [_delegate abrirFavorito:lugar];
}

@end
