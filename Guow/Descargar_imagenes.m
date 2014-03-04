//
//  Descargar_imagenes.h
//  Navegador
//
//  Created by Luis on 12/14/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "Descargar_imagenes.h"
#import "ModelConnection.h"


@implementation Descargar_imagenes{
    NSMutableArray *images;
    int cont;
    ModelConnection *model;
}

-(void)obtenerURL{
    images = [[NSMutableArray alloc]init];
    NSMutableArray *adat = [model consulta:@"lugar"];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        [images addObject:[info objectForKey:@"imgesp"]];
        if (![[info objectForKey:@"servicio"]isEqualToString:@"1"]) {
             [images addObject:[info objectForKey:@"logo"]];
        }
    }
    adat = [model consulta:@"imagenes"];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *info = [adat objectAtIndex:i];
        [images addObject:[info objectForKey:@"imagen"]];
    }
}

-(void)descargarImagen:(NSString*)nombre{
    NSURL *url = [NSURL URLWithString:nombre];
    NSString *nombrearchivo = url.lastPathComponent;
    
    NSArray *array = [nombre  componentsSeparatedByString:@"/"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
    
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:carpeta]) {
        [fm createDirectoryAtPath:carpeta withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:nombre]];
        [data3 writeToFile:fotointerna atomically:YES];
        cont++;
    }
}

-(void)descargar{
    model = [[ModelConnection alloc]init];
    [self obtenerURL];
    for (int i = 0; i<[images count]; i++) {
        [self descargarImagen:[images objectAtIndex:i]];
    }
    NSLog(@"Se descargaron %d imagenes",cont);
}

-(void)iniciar_descarga{
    cont = 0;
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(descargar)
                                                                              object:nil];
    
    [queue addOperation:operation];
}

@end
