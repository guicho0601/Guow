//
//  ServicioList.h
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriaList.h"

@protocol servicioProtocol <NSObject>

@required
-(void)allServices;
-(void)sendCategoria:(CategoriaList*)list;
-(void)abrirFavorito:(NSString*)lugar;
-(void)abrirPromociones;
@end

@interface ServicioList : UITableViewController

@property (nonatomic, assign) id<servicioProtocol> delegate;
-(void)cambioIdioma;
@end
