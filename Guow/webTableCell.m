//
//  webTableCell.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "webTableCell.h"

@interface webTableCell()
@property (weak, nonatomic) IBOutlet UILabel *infoTitulo;
@property (weak, nonatomic) IBOutlet UILabel *infoTexto;

@end

@implementation webTableCell

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
    _infoTexto.text = [dict objectForKey:@"web"];
    [_infoTexto setFont:[UIFont fontWithName:FUENTE size:11.5f]];
    if (![[dict objectForKey:@"web"]isEqualToString:@""]) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visitar)];
        [_infoTexto addGestureRecognizer:tap];
    }
}

-(void)visitar{
    NSLog(@"Hola");
}

@end
