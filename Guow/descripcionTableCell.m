//
//  descripcionTableCell.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "descripcionTableCell.h"

@interface descripcionTableCell(){
    NSString *esp,*ing,*web;
    
}
@property (weak, nonatomic) IBOutlet UILabel *conoceTitulo;
@property (weak, nonatomic) IBOutlet UITextView *conoceText;

@end

@implementation descripcionTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)valores:(NSDictionary *)dictionary{
    esp = [dictionary objectForKey:@"desesp"];
    ing = [dictionary objectForKey:@"desing"];
    web = [dictionary objectForKey:@"web"];
    [_conoceText setFont:[UIFont fontWithName:FUENTE size:11.5f]];
    //[_conoceTitulo setFont:[UIFont fontWithName:FUENTE size:11.5f]];
    [self cambioIdioma];
}

-(void)cambioIdioma{
    [_conoceText setScrollEnabled:YES];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def integerForKey:@"idioma"]==1) {
        _conoceTitulo.text = @"CONOCE MAS";
        /*
        _ubicacionTitulo.text = @"UBICACION";
        _tarifaTitulo.text = @"TARIFAS DE ENTRADA";
        _informacionTitulo.text = @"MAS INFORMACION";
         */
        _conoceText.text = esp;
    }else{
        _conoceTitulo.text = @"LEARN MORE";
        /*
        _ubicacionTitulo.text = @"UBICATION";
        _tarifaTitulo.text = @"TICKET PRICE";
        _informacionTitulo.text = @"MORE INFO";
         */
        _conoceText.text = ing;
    }
    [_conoceText sizeToFit];
    [_conoceText setScrollEnabled:NO];
}

@end
