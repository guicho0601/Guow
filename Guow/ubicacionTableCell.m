//
//  ubicacionTableCell.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "ubicacionTableCell.h"

@interface ubicacionTableCell()
@property (weak, nonatomic) IBOutlet UILabel *tituloLabel;
@property (weak, nonatomic) IBOutlet UILabel *textoLabel;

@end

@implementation ubicacionTableCell

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
    _textoLabel.text = [dict objectForKey:@"direccion"];
    [_textoLabel setFont:[UIFont fontWithName:FUENTE size:11.5f]];
}

@end
