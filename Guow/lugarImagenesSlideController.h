//
//  lugarImagenesSlideController.h
//  Guow
//
//  Created by Luis on 1/10/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lugarImagenesSlideControllerProtocol <NSObject>

@required
-(void)cerrarSlideImages;

@end

@interface lugarImagenesSlideController : UIViewController
@property (nonatomic,assign)NSArray *imagenesArray;
@property (nonatomic,assign)id<lugarImagenesSlideControllerProtocol>delegate;
@end
