//
//  imageSlideTableCell.h
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imageSlideTableCellProtocol <NSObject>

@optional
-(void)abrirImagenSeleccionada:(NSString*)imagen;

@end

@interface imageSlideTableCell : UITableViewCell
-(void)imagenes:(NSMutableArray*)imagenes;
@property (nonatomic,assign) id<imageSlideTableCellProtocol> delegate;
@end
