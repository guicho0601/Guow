//
//  CategoriaList.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "CategoriaList.h"
#import "Categoria.h"
#import "ModelConnection.h"
#define TABLA @"categoria"

@interface CategoriaList (){
    ModelConnection *model;
    NSMutableArray *categoriaArray;
    NSString *servicio;
    NSString *nesp,*ning;
}

@end

@implementation CategoriaList

-(void)cargarDatos{
    if (categoriaArray != nil) {
        [categoriaArray removeAllObjects];
    }else{
        categoriaArray = [[NSMutableArray alloc]init];
    }
    model = [[ModelConnection alloc]init];
    NSMutableArray *array = [model consulta:TABLA];
    
    Categoria *aux = [[Categoria alloc]init];
    aux.categoriaesp = @"Mostrar todos";
    aux.categoriaing = @"Show all";
    [categoriaArray addObject:aux];
    for (int i=0; i<array.count; i++) {
        NSDictionary *info = [array objectAtIndex:i];
        if ([[info objectForKey:@"servicio"] isEqualToString:servicio]) {
            aux = [[Categoria alloc]init];
            aux.idcategoria = [[info objectForKey:@"idcategoria"]intValue];
            aux.categoriaesp = [info objectForKey:@"nomesp"];
            aux.categoriaing = [info objectForKey:@"noming"];
            aux.icono = [info objectForKey:@"icono"];
            aux.idservicio = [[info objectForKey:@"servicio"]intValue];
            [categoriaArray addObject:aux];
        }
    }
    
}

-(void)servicioSeleccionado:(NSString*)ser esp:(NSString *)tesp ing:(NSString *)ting{
    servicio = ser;
    nesp = tesp;
    ning = ting;
}

-(void)cambioIdioma{
    [self establecerTitulo];
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
    return [categoriaArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Categoria *aux = [categoriaArray objectAtIndex:indexPath.row];
    if ([model comprobarIdioma]== 1) cell.textLabel.text = aux.categoriaesp;
    else cell.textLabel.text = aux.categoriaing;
    if(aux.icono != nil) cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",AMARILLO,aux.icono]];
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
    Categoria *aux = [categoriaArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [_delegate allCategories:servicio];
    }else{
        NSUserDefaults *def = [ NSUserDefaults standardUserDefaults];
        if ([servicio isEqualToString:@"1"]) {
            [def setObject:[NSNumber numberWithBool:YES] forKey:@"isTurismo"];
        }else{
            [def setObject:[NSNumber numberWithBool:NO] forKey:@"isTurismo"];
        }
        [def synchronize];
        
        LugarList *lugar = [[LugarList alloc]initWithStyle:UITableViewStyleGrouped];
        [lugar categoriaSeleccionada:[NSString stringWithFormat:@"%d",aux.idcategoria] esp:aux.categoriaesp ing:aux.categoriaing];
        [_delegate sendLugar:lugar];
        [self.navigationController pushViewController:lugar animated:YES];
    }
}



@end
