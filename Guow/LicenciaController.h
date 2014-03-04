//
//  LicenciaController.h
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LicenciaControllerProtocol <NSObject>
@required
-(void)cerrarContrato;
@end

@interface LicenciaController : UIViewController
@property (nonatomic,assign) id<LicenciaControllerProtocol>delegate;
@end
