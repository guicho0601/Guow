//
//  ModelConnection.m
//  Navegador
//
//  Created by Luis on 12/14/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "ModelConnection.h"
#define Pagina @"http://www.guowmaps.com/paginasguowapp/model.php?query="
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "Descargar_imagenes.h"

@implementation ModelConnection

-(void)descargarInfo:(NSString*)query Archivo: (NSString*)titulo{
    NSFileManager *mgfile = [NSFileManager defaultManager];
    NSString* file = [[self getDirectorio] stringByAppendingFormat:@"/%@.ant",titulo];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",Pagina,query];
    url = [self quitarEspacios:url];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *s = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
   
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
    }
    [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

-(NSMutableArray*)consulta:(NSString*)file{
    file = [[self getDirectorio] stringByAppendingFormat:@"/%@.ant",file];
    //NSLog(@"%@",file);
    NSError *error;
    NSData* data = [NSData dataWithContentsOfFile:file];
    NSMutableArray* adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return adat;
}

-(NSString*)quitarEspacios:(NSString *)original{
    return [original stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

-(NSString*)getDirectorio{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    return directorio;
}

-(BOOL)comprobarActualizaciones{
    if (![self conexion]) {
        return NO;
    }
    NSFileManager *mgfile = [NSFileManager defaultManager];
    NSString* file_propio = [[self getDirectorio] stringByAppendingFormat:@"/ultimaactualizacion.ant"];
    NSString *file = [[self getDirectorio] stringByAppendingString:@"/actualizacion.ant"];
    
    [self descargarInfo:@"select fecha from actualizacion where id=1" Archivo:@"actualizacion"];
    NSError *error;
    NSString *newDate = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@",newDate);
    
    if (![mgfile fileExistsAtPath:file_propio]) {
        [mgfile createFileAtPath:file_propio contents:nil attributes:nil];
        [newDate writeToFile:file_propio atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        return YES;
    }
    
    NSString *oldDate = [NSString stringWithContentsOfFile:file_propio encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@",oldDate);
    
    if (![newDate isEqualToString:oldDate]) {
        [newDate writeToFile:file_propio atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        return YES;
    }else{
        return NO;
    }
}

-(int)comprobarIdioma{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"idioma"];
}

-(BOOL)conexion{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == ReachableViaWWAN) {
        
        NSLog(@"Conexion Datos");
        return YES;
        
    } else if (networkStatus == ReachableViaWiFi) {
        
        NSLog(@"WiFi");
        return YES;
        
    } else if (networkStatus == NotReachable) {
        
        NSLog(@"No hay conexion");
    }
    return NO;
}

-(UIImage*)buscarImagen:(NSString*)nombre{
    NSString *path = [self getPathImagenes:nombre];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    return image;
}

-(NSString*)getPathImagenes:(NSString*)nombre{
    NSString *s = nombre;
    NSURL *url = [NSURL URLWithString:s];
    NSString *nombrearchivo = url.lastPathComponent;
    
    NSArray *array = [s  componentsSeparatedByString:@"/"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
    
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:fotointerna]){
        Descargar_imagenes *descarga = [[Descargar_imagenes alloc]init];
        [descarga descargarImagen:fotointerna];
        descarga = nil;
    }
    
    return fotointerna;
}

@end
