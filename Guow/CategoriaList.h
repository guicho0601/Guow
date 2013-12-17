//
//  CategoriaList.h
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LugarList.h"

@protocol categoriaProtocol <NSObject>

@required
-(void)allCategories:(NSString*)idcat;
-(void)sendLugar:(LugarList*)list;
@end

@interface CategoriaList : UITableViewController
-(void)servicioSeleccionado:(NSString*)ser esp:(NSString*)tesp ing:(NSString*)ting;
@property (nonatomic,assign) id<categoriaProtocol> delegate;
-(void)cambioIdioma;
@end
