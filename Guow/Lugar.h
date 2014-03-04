//
//  Lugar.h
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lugar : NSObject
@property(nonatomic)int idlocal;
@property(nonatomic,retain) NSString *nombre;
@property(nonatomic,retain) NSString *descripcionesp;
@property(nonatomic,retain) NSString *descripcioning;
@property(nonatomic,retain) NSString *paginaweb;
@property(nonatomic) int idservicio;
@property(nonatomic) int idcategoria;
@property(nonatomic,retain) NSString *imagen;
@property(nonatomic,retain) NSString *logo;
@property(nonatomic,retain) NSString *imagening;
@property(nonatomic) int tipo;
@property(nonatomic) int posx;
@property(nonatomic) int posy;
@property(nonatomic) int turismo;
@property(nonatomic) int anuncio;
@property(nonatomic,retain) NSString *horarioesp;
@property(nonatomic,retain) NSString *horarioing;
@property(nonatomic,retain) NSString *direccion;
@property(nonatomic,retain) NSString *tarifaesp;
@property(nonatomic,retain) NSString *tarifaing;
@property(nonatomic) double latitud;
@property(nonatomic) double longitud;
@end
