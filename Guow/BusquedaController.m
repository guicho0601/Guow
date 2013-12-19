//
//  BusquedaController.m
//  Guow
//
//  Created by Luis on 12/18/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "BusquedaController.h"
#import "ModelConnection.h"
#import "Lugar.h"

@interface BusquedaController () <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>{
    ModelConnection *model;
    NSMutableArray *listaBusqueda;
    NSArray *resultadosBusqueda;
    NSMutableArray *nombresLugares;
}
@property (weak, nonatomic) IBOutlet UISearchBar *barraBuscadora;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *itemsNavigation;
@end

@implementation BusquedaController

-(void)cargarDatos{
    model = [[ModelConnection alloc]init];
    listaBusqueda = [[NSMutableArray alloc]init];
    nombresLugares = [[NSMutableArray alloc]init];
    
    NSMutableArray *adat = [model consulta:@"lugar"];
    
    for (int i=0; i<adat.count; i++) {
        NSDictionary *dict = [adat objectAtIndex:i];
        Lugar *aux = [[Lugar alloc]init];
        aux.idlocal = [[dict objectForKey:@"idlugar"]intValue];
        aux.nombre = [dict objectForKey:@"nombre"];
        aux.logo = [dict objectForKey:@"logo"];
        [nombresLugares addObject:[dict objectForKey:@"nombre"]];
        [listaBusqueda addObject:aux];
    }
    [self.tableView reloadData];
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
    [self cargarDatos];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    //self.itemsNavigation.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [resultadosBusqueda count];
    }else{
        return [nombresLugares count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [resultadosBusqueda objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [nombresLugares objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    resultadosBusqueda = [nombresLugares filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int n = indexPath.row;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        for (int i=0; i<nombresLugares.count; i++) {
            if ([[resultadosBusqueda objectAtIndex:indexPath.row]isEqualToString:[nombresLugares objectAtIndex:i]]) {
                n = i;
                break;
            }
        }
    }
    Lugar *aux = [listaBusqueda objectAtIndex:n];
    [self.delegate cerrarBookmarks:[NSString stringWithFormat:@"%d",aux.idlocal]];
}

- (IBAction)backButtonAction:(id)sender {
    [self.delegate cerrarBookmarks:@""];
}
@end
