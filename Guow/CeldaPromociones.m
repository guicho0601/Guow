//
//  CeldaPromociones.m
//  Guow
//
//  Created by Luis on 1/6/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "CeldaPromociones.h"
#import "Lugar.h"

@interface CeldaPromociones(){
    NSOperationQueue *operationQueue;
    NSString *urlimage;
    NSString *idLugar;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NamePlace;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CeldaPromociones

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

-(void)sendData:(Lugar*)aux{
    UIImage *pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aux.imagen]]];
    [self.imageView setImage:pImage];
    urlimage = aux.imagen;
    self.NamePlace.title = aux.nombre;
    idLugar = [NSString stringWithFormat:@"%d",aux.idlocal];
    //[self.imageView setHighlightedImage:pImage];
}

- (IBAction)goPlace:(id)sender {
    [_delegate abrirLugar:idLugar];
}

- (IBAction)FBButton:(id)sender {
    
}

- (IBAction)TWButton:(id)sender {
    
}

@end
