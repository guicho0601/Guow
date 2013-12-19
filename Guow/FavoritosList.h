//
//  FavoritosList.h
//  Guow
//
//  Created by Luis on 12/18/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol favoritosListProtocol <NSObject>

@required
-(void)cerrarBookmarks:(NSString*)lugar;

@end

@interface FavoritosList : UITableViewController
@property (nonatomic,assign) id<favoritosListProtocol> delegate;
@end
