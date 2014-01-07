//
//  TablaPromociones.h
//  Guow
//
//  Created by Luis on 1/6/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PromocionesProtocol <NSObject>

@required
-(void)terminaCargaPromocion;
-(void)cerrarPromocion;
-(void)abrirLugarPromocion:(NSString*)idlugar;
@end

@interface TablaPromociones : UITableViewController
@property (nonatomic,assign) id<PromocionesProtocol>delegate;
@end
