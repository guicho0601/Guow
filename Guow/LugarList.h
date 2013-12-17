//
//  LugarList.h
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lugarProtocol <NSObject>

@required
-(void)allPlaces:(NSString*)idCat;
-(void)selectPlace:(NSString*)idPlace;

@end

@interface LugarList : UITableViewController
@property (nonatomic, assign) id<lugarProtocol> delegate;
-(void)categoriaSeleccionada:(NSString*)cate esp:(NSString*)tesp ing:(NSString*)ting;
-(void)cambioIdioma;
@end
