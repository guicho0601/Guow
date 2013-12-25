//
//  mapaTableCell.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "mapaTableCell.h"
#import <MapKit/MapKit.h>

@interface mapaTableCell()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tituloLocalizacion;
@property (weak, nonatomic) IBOutlet UILabel *localizacion;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation mapaTableCell

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

-(void)valores:(NSDictionary *)dict{
    
}

@end
