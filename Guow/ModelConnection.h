//
//  ModelConnection.h
//  Navegador
//
//  Created by Luis on 12/14/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelConnection : NSObject

-(void)descargarInfo:(NSString*)query Archivo: (NSString*)file;
-(NSMutableArray*)consulta:(NSString*)file;
-(BOOL)comprobarActualizaciones;
-(int)comprobarIdioma;

@end
