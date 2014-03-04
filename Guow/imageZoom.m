//
//  imageZoom.m
//  Guow
//
//  Created by Luis on 12/18/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "imageZoom.h"
#import "ModelConnection.h"

@interface imageZoom ()<UIScrollViewDelegate>{
    UIImage *imagen;
    float puntox, puntoy;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation imageZoom

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
    self.scrollView.delegate = self;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.scrollView addGestureRecognizer:doubleTap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageView.image = imagen;
    //[self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self ajustarImagen];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    else
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    
}

-(void)ajustarImagen{
    CGSize tam = self.imageView.image.size;
    float ancho,alto,px,py;
    CGSize completo = self.scrollView.frame.size;
    
    if (tam.width > completo.width) {
        float cd = tam.width/completo.width;
        ancho = completo.width;
        alto = tam.height/cd;
        px = 0;
        py = (completo.height - alto)/2;
    }else{
        ancho = tam.width;
        alto = tam.height;
        px = (completo.width - ancho)/2;
        py = (completo.height - alto)/2;
    }
    
    self.imageView.frame = CGRectMake(px, py, ancho, alto);
    puntox = px;
    puntoy = py;
    //[self.scrollView setContentSize:tam];
    [self.scrollView setContentSize:self.view.frame.size];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    imagen = nil;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if (self.scrollView.zoomScale == 1.0) {
        self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }else{
        self.imageView.frame = CGRectMake(puntox, puntoy/self.scrollView.zoomScale, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (self.scrollView.zoomScale == 1.0) {
        self.imageView.frame = CGRectMake(puntox, puntoy, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }else{
        self.imageView.frame = CGRectMake(puntox, puntoy/self.scrollView.zoomScale, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
}

- (IBAction)actionBackButton:(id)sender {
    [self.delegate exitModal];
}

-(void)envioImagen:(NSString*)nombre{
    ModelConnection *model = [[ModelConnection alloc]init];
    imagen = [model buscarImagen:nombre];
}

@end
