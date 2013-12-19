//
//  BusquedaController.h
//  Guow
//
//  Created by Luis on 12/18/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol busquedaProtocol <NSObject>

@required
-(void)cerrarBookmarks:(NSString*)lugar;

@end

@interface BusquedaController : UIViewController
@property (nonatomic,assign)id<busquedaProtocol> delegate;
@end
