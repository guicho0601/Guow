//
//  imageZoom.h
//  Guow
//
//  Created by Luis on 12/18/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imageZoomProtocol <NSObject>

@required
-(void)exitModal;

@end

@interface imageZoom : UIViewController
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) id<imageZoomProtocol> delegate;
-(void)envioImagen:(NSString*)nombre;
@end
