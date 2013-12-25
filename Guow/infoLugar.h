//
//  infoLugar.h
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapaViewController.h"

@protocol infoLugarProtocol <NSObject>

@required
-(void)cerrarInfoPanel;

@end

@interface infoLugar : UIViewController
@property (nonatomic, assign) id<infoLugarProtocol> delegate;
-(void)reciveMapView:(MapaViewController*)map;
-(void)cambiarLugar:(NSString*)lug;
@end
