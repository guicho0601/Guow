//
//  NosotrosController.h
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NosotrosControllerProtocol <NSObject>
@required
-(void)cerrarAbout;
@end

@interface NosotrosController : UIViewController
@property (nonatomic,assign)id<NosotrosControllerProtocol>delegate;
@end
