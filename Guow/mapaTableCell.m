//
//  mapaTableCell.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "mapaTableCell.h"
#import <MapKit/MapKit.h>
#define METERS_PER_MILE 1609.344

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
    NSString *l = [dict objectForKey:@"latitud"];
    NSString *o = [dict objectForKey:@"longitud"];
    double latitud = l.doubleValue;
    double longitud = o.doubleValue;
    if (latitud == 0 && longitud == 0) {
        latitud = 14.562288625731474;
        longitud = -90.73315286623256;
    }
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitud;
    zoomLocation.longitude = longitud;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
    //MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    //[self.mapView setRegion:adjustedRegion animated:YES];
    [_mapView setRegion:viewRegion animated:YES];
    [_mapView regionThatFits:viewRegion];
    //[_mapView setCenterCoordinate:zoomLocation animated:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    [point setCoordinate:CLLocationCoordinate2DMake(latitud, longitud)];
    //point.title = @"Where am I?";
    //point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

@end
