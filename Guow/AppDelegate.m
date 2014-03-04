//
//  AppDelegate.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "AppDelegate.h"
#import "ModelConnection.h"
#import "Descargar_imagenes.h"

@implementation AppDelegate

-(void)descargarInfo{
    ModelConnection *model = [[ModelConnection alloc]init];
    if ([model comprobarActualizaciones]) {
        NSLog(@"Si hay actualizaciones");
        NSLog(@"Descargando...");
        [model descargarInfo:@"select * from servicio" Archivo:@"servicio"];
        [model descargarInfo:@"select * from categoria" Archivo:@"categoria"];
        [model descargarInfo:@"select * from lugar where habilitado=1" Archivo:@"lugar"];
        [model descargarInfo:@"select * from img_turismo" Archivo:@"imagenes"];
        NSLog(@"Terminando Descarga...");
    }
    model = nil;
    Descargar_imagenes *descarga = [[Descargar_imagenes alloc]init];
    [descarga iniciar_descarga];
}

-(void)ver_fuentes{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[self ver_fuentes];
    
    //NSThread *myThread = [[NSThread alloc]initWithTarget:self selector:@selector(descargarInfo) object:nil];
    //[myThread start];
    [self descargarInfo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[UINavigationBar appearance] setBarTintColor:COLOR_BASE];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:FUENTE size:19.0], NSFontAttributeName, nil]];
    
    if (![defaults boolForKey:@"ValoresGuardados"])
    {
        NSMutableArray *favoritos = [[NSMutableArray alloc]init];
        NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
        int o=2;
        if ([preferredLang isEqualToString:@"es"]) {
            o=1;
        }
        NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:o],@"idioma",
                                       [NSNumber numberWithBool:NO],@"aceptado",
                                       [NSNumber numberWithBool:YES], @"descargas",
                                       [NSNumber numberWithBool:NO],@"isTurismo",
                                       favoritos,@"favoritos",
                                       
                                       //[NSNumber numberWithBool:YES], @"kMostrarMensaje",
                                       //@"ThXou", @"kMiNombre",
                                       //nil, @"kUltimaVisita",
                                       [NSNumber numberWithBool:YES], @"kValoresGuardados",
                                       nil];
        
        [defaults registerDefaults:defaultValues];

    }
    //[defaults setBool:NO forKey:@"aceptado"];
    [defaults setObject:@"Turismo.png" forKey:@"logoTurismo"];
    [defaults synchronize];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
