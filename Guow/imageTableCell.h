//
//  imageTableCell.h
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imageTableCellProtocol <NSObject>

@optional
-(void)abrirImagenSeleccionada:(NSString*)imagen;

@end

@interface imageTableCell : UITableViewCell
-(void)imagenes:(NSMutableArray*)imagenes;
@property (nonatomic,assign) id<imageTableCellProtocol> delegate;

@end
