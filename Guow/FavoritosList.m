//
//  FavoritosList.m
//  Guow
//
//  Created by Luis on 12/18/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "FavoritosList.h"
#import "ModelConnection.h"
#import "Lugar.h"
#define TABLA @"lugar"

@interface FavoritosList (){
    NSMutableArray *lugares;
     ModelConnection *model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritosList

-(void)cargarDatos{
    lugares = [[NSMutableArray alloc]init];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritos = [def objectForKey:@"favoritos"];
    
    model = [[ModelConnection alloc]init];
    NSMutableArray *adat = [model consulta:TABLA];
    
    for(NSString *linea in favoritos){
        for (int i=0; i<adat.count; i++) {
            NSDictionary *dict = [adat objectAtIndex:i];
            if ([linea isEqualToString:[dict objectForKey:@"idlugar"]]) {
                Lugar *aux = [[Lugar alloc]init];
                aux.idlocal = [[dict objectForKey:@"idlugar"]intValue];
                aux.nombre = [dict objectForKey:@"nombre"];
                aux.logo = [dict objectForKey:@"logo"];
                [lugares addObject:aux];
            }
        }
    }
    
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
    [self cargarDatos];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"f1.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(closeBookmarks)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)closeBookmarks{
    [_delegate cerrarBookmarks:@""];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self.tableView setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40)];
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
    return [lugares count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        Lugar *aux = [lugares objectAtIndex:indexPath.row];
        cell.textLabel.text = aux.nombre;
        cell.imageView.image = [UIImage imageNamed:aux.logo];
    return cell;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Lugar *aux = [lugares objectAtIndex:indexPath.row];
        NSString *n =[NSString stringWithFormat:@"%d",aux.idlocal];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSMutableArray *favoritos = [def objectForKey:@"favoritos"];
        for (int i = 0; i<favoritos.count; i++) {
            if ([n isEqualToString:[favoritos objectAtIndex:i]]) {
                [favoritos removeObjectAtIndex:i];
                break;
            }
        }
        [def setObject:favoritos forKey:@"favoritos"];
        [def synchronize];
        [lugares removeObjectAtIndex:indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    /*
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
     */
    [self.tableView reloadData];
}


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
    Lugar *aux = [lugares objectAtIndex:indexPath.row];
    [self.delegate cerrarBookmarks:[NSString stringWithFormat:@"%d",aux.idlocal]];
}
 


@end
