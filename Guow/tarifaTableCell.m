//
//  tarifaTableCell.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "tarifaTableCell.h"

@interface tarifaTableCell(){
    NSString *tarifaesp,*tarifaing;
}
@property (weak, nonatomic) IBOutlet UILabel *tarifaTitulo;
@property (weak, nonatomic) IBOutlet UITextView *tarifaTexto;

@end

@implementation tarifaTableCell

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

-(void)setData:(NSDictionary *)dict{
    tarifaesp = [dict objectForKey:@"tarifaesp"];
    tarifaing = [dict objectForKey:@"tarifaing"];
    [_tarifaTexto setFont:[UIFont fontWithName:FUENTE size:11.5f]];
    [self cambiarIdioma];
}

-(void)cambiarIdioma{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def integerForKey:@"idioma"]==1) {
        _tarifaTexto.text = tarifaesp;
    }else{
        _tarifaTexto.text = tarifaing;
    }
    [_tarifaTexto sizeToFit];
    [_tarifaTexto setScrollEnabled:NO];
}

@end
