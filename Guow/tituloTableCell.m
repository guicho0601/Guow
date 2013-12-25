//
//  tituloTableCell.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "tituloTableCell.h"
#import "ModelConnection.h"
#define COLOR_BASE [UIColor colorWithRed:254.0/255.0 green:194.0/255.0 blue:15.0/255.0 alpha:1.0];

@interface tituloTableCell(){
    NSString *idLugar;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nombreLabel;
@property (weak, nonatomic) IBOutlet UILabel *horarioTitulo;
@property (weak, nonatomic) IBOutlet UILabel *horarioText;
@property (weak, nonatomic) IBOutlet UILabel *comparteTitulo;
@property (weak, nonatomic) IBOutlet UIButton *bookMarkButton;

@end

@implementation tituloTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)facebookButton:(id)sender {
    [_delegate facebookOpen];
}

- (IBAction)twitterButton:(id)sender {
    [_delegate twitterOpen];
}

-(void)nombre:(NSDictionary *)dictionary{
    _nombreLabel.text = [dictionary objectForKey:@"nombre"];
    _logoImage.image = [UIImage imageNamed:[dictionary objectForKey:@"logo"]];
    _bookMarkButton.tintColor = COLOR_BASE;
    [self cambiarIdioma];
    idLugar = [dictionary objectForKey:@"id"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritos = [def objectForKey:@"favoritos"];
    for (NSString *linea in favoritos) {
        if ([linea isEqualToString:idLugar]) {
            self.bookMarkButton.tag=1;
            self.bookMarkButton.tintColor = [UIColor redColor];
            break;
        }else{
            self.bookMarkButton.tintColor = COLOR_BASE;
            self.bookMarkButton.tag = 0;
        }
    }
}

-(void)cambiarIdioma{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def integerForKey:@"idioma"]==1) {
        _horarioTitulo.text = @"HORARIO";
        _comparteTitulo.text = @"COMPARTE";
    }else{
        _horarioTitulo.text = @"SCHEDULE";
        _comparteTitulo.text = @"SHARED";
    }
}

- (IBAction)bookmarkButtonAction:(id)sender {
    ModelConnection *model = [[ModelConnection alloc]init];
    UIBarButtonItem *button = sender;
    NSString *mensaje,*titulo;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritos = [[def objectForKey:@"favoritos"]mutableCopy];
    if (!favoritos) {
        favoritos =[[NSMutableArray alloc]init];
    }
    if (button.tag == 0) {
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
        button.tintColor = COLOR_BASE;
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
