//
//  tituloTableCell.h
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tituloTableCellProtocol <NSObject>

@optional
-(void)facebookOpen;
-(void)twitterOpen;

@end

@interface tituloTableCell : UITableViewCell
-(void)nombre:(NSDictionary*)dictionary;
-(void)cambiarIdioma;
@property (nonatomic,assign)id<tituloTableCellProtocol>delegate;
@end
