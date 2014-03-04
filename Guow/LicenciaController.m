//
//  LicenciaController.m
//  Guow
//
//  Created by Luis on 1/9/14.
//  Copyright (c) 2014 Luis. All rights reserved.
//

#import "LicenciaController.h"

@interface LicenciaController ()
@property (weak, nonatomic) IBOutlet UISwitch *acceptSwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation LicenciaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[_acceptSwitch setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acceptContrato:(id)sender {
    if (_acceptSwitch.on) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setBool:YES forKey:@"aceptado"];
        [def synchronize];
        [_delegate cerrarContrato];
    }
}
@end
