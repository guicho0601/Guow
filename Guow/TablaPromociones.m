//
//  TablaPromociones.m
//  Guow
//
//  Created by Luis on 1/6/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "TablaPromociones.h"
#import "CeldaPromociones.h"
#import "Lugar.h"

@interface TablaPromociones ()<CeldaPromocionProtocol>{
    NSMutableArray *promociones;
    NSDictionary *d;
}
@end

@implementation TablaPromociones

-(void)cargarDatos{
    promociones = [[NSMutableArray alloc]init];
    Lugar *aux = [[Lugar alloc]init];
    [aux setIdlocal:1];
    [aux setNombre:@"Catedral San Jose"];
    [aux setImagen:@"http://retico.gt/wp-content/uploads/2013/12/android2.jpg"];
    [promociones addObject:aux];
    
    aux = [[Lugar alloc]init];
    [aux setIdlocal:2];
    [aux setNombre:@"Museo de Antigua"];
    [aux setImagen:@"http://2.bp.blogspot.com/-M5nYTvwMgvU/Ubmk11btJEI/AAAAAAAAEdY/YZVM9cVw0c0/s1600/ios-7-apple.jpg"];
    [promociones addObject:aux];
    
    aux = [[Lugar alloc]init];
    [aux setIdlocal:3];
    [aux setNombre:@"Palacio de los Capitanes"];
    [aux setImagen:@"http://media.tecnoalt.com/wp-content/uploads/2013/10/windows-phone-8-logo1.png"];
    [promociones addObject:aux];
    
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
    [self cargarDatos];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"f1.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
        self.navigationItem.leftBarButtonItem = backButton;
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)close{
    [_delegate cerrarPromocion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return promociones.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:@"f1.png"];
        cell.backgroundColor = color_base;
        return cell;
    }else{
    
        CeldaPromociones *cell = [[CeldaPromociones alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = (CeldaPromociones*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CeldaPromociones" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell sendData:[promociones objectAtIndex:indexPath.row-1]];
        [cell setDelegate:self];
        if (indexPath.row == promociones.count) {
            [_delegate terminaCargaPromocion];
        }
        cell.backgroundColor = color_base;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 40;
    }
    return 230;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self close];
    }else{
        
    }
}

-(void)abrirLugar:(NSString *)idlugar{
    [_delegate abrirLugarPromocion:idlugar];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
