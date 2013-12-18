//
//  MapaViewController.h
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServicioList.h"

@protocol MapaActionsDelegate <NSObject>

@optional
-(void)movePanelLeft;
-(void)movePanelRight;
-(void)lugarSeleccionado:(NSString*)idLugar;

@required
-(void)movePanelToOriginalPosition;

@end


@interface MapaViewController : UIViewController
@property (nonatomic, assign) id<MapaActionsDelegate> actionDelagate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MenuButton;
-(void)sendServicio:(ServicioList*)list;
-(void)cerrarInfoPanel;
-(NSString*)idInfolugar;
@end
