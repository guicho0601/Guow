//
//  LugarList.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "LugarList.h"
#import "Lugar.h"
#import "ModelConnection.h"
#define TABLA @"lugar"

@interface LugarList (){
    ModelConnection *model;
    NSMutableArray *lugarArray;
    NSString *idCategoria;
    NSString *nesp,*ning;
}

@end

@implementation LugarList

-(void)cargarDatos{
    if (lugarArray != nil) [lugarArray removeAllObjects];
    else lugarArray = [[NSMutableArray alloc]init];
    
    model = [[ModelConnection alloc]init];
    NSMutableArray *adat = [model consulta:TABLA];
    Lugar *aux = [[Lugar alloc]init];
    if([model comprobarIdioma]==1)aux.nombre = @"Mostrar todos";
    else aux.nombre = @"Show all";
    [lugarArray addObject:aux];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *info = [adat objectAtIndex:i];
        if ([[info objectForKey:@"categoria"]isEqualToString:idCategoria]) {
            aux = [[Lugar alloc]init];
            aux.idlocal = [[info objectForKey:@"idlugar"]intValue];
            aux.nombre = [info objectForKey:@"nombre"];
            aux.logo = [info objectForKey:@"logo"];
            aux.idservicio = [[info objectForKey:@"servicio"]intValue];
            [lugarArray addObject:aux];
        }
    }
}

-(void)categoriaSeleccionada:(NSString*)cate esp:(NSString *)tesp ing:(NSString *)ting{
    idCategoria = cate;
    nesp = tesp;
    ning = ting;
}

-(void)cambioIdioma{
    [self establecerTitulo];
    [self cargarDatos];
    [self.tableView reloadData];
}

-(void)establecerTitulo{
    if ([model comprobarIdioma]==1) self.title = nesp;
    else self.title = ning;
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
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *but = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic22.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backMenu)];
    [but setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:but];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

-(void)backMenu{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [lugarArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Lugar *aux = [lugarArray objectAtIndex:indexPath.row];
    cell.textLabel.text = aux.nombre;
    if (indexPath.row > 0) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([def boolForKey:@"isTurismo"]) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",AMARILLO,aux.logo]];
            [def setObject:aux.logo forKey:@"logoTurismo"];
        }
    }
    cell.textLabel.text = [cell.textLabel.text uppercaseString];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:FUENTE size:12.0f];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.textLabel.numberOfLines = 2;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Lugar *lug = [lugarArray objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        [_delegate allPlaces:idCategoria];
    }else{
        [_delegate selectPlace:[NSString stringWithFormat:@"%d",lug.idlocal]];
    }
}


@end
