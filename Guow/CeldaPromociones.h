//
//  CeldaPromociones.h
//  Guow
//
//  Created by Luis on 1/6/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CeldaPromocionProtocol <NSObject>
@required
-(void)abrirLugar:(NSString*)idlugar;

@end

@interface CeldaPromociones : UITableViewCell

-(void)sendData:(NSString*)url;
@property (nonatomic,assign) id<CeldaPromocionProtocol>delegate;

@end
