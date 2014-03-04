//
//  BrujulaController.m
//  Guow
//
//  Created by Luis on 1/10/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "BrujulaController.h"
#import <CoreLocation/CoreLocation.h>

@interface BrujulaController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@end

@implementation BrujulaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if( [CLLocationManager locationServicesEnabled]
       &&  [CLLocationManager headingAvailable]) {
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
    } else {
        NSLog(@"Can't report heading");
    }
}

- (void)locationManager:(CLLocationManager*)manager
       didUpdateHeading:(CLHeading*)newHeading {
    
    if (newHeading.headingAccuracy > 0) {
        //float magneticHeading = newHeading.magneticHeading;
        //float trueHeading = newHeading.trueHeading;
        
        //magneticHeadingLabel.text = [NSString stringWithFormat:@"%f", magneticHeading];
        //trueHeadingLabel.text = [NSString stringWithFormat:@"%f", trueHeading];
        
        float heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
        _arrowView.transform = CGAffineTransformMakeRotation(heading);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
