//
//  infoLugarView.h
//  Guow
//
//  Created by Luis on 12/16/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapaViewController.h"

@protocol infoLugarProtocol <NSObject>

@required
-(void)cerrarInfoPanel;

@end

@interface infoLugarView : UIViewController
@property (nonatomic, assign) id<infoLugarProtocol> delegate;
-(void)reciveMapView:(MapaViewController*)map;
-(void)cambiarLugar:(NSString*)lug;
@end
