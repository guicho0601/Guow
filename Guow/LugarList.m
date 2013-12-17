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
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
