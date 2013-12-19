//
//  AppDelegate.m
//  Guow
//
//  Created by Luis on 12/15/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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
