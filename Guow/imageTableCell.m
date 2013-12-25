//
//  imageTableCell.m
//  Guow
//
//  Created by Luis on 12/25/13.
//  Copyright (c) 2013 Luis. All rights reserved.
//

#import "imageTableCell.h"
#import "ModelConnection.h"

@interface imageTableCell() <UIScrollViewDelegate>{
    NSMutableArray *listadoImagenes;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation imageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)imagenes:(NSMutableArray *)imagenes{
    listadoImagenes = imagenes;
    _scrollView.delegate = self;
    [_pageControl setNumberOfPages:[imagenes count]];
    for (int i=0; i<imagenes.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        ModelConnection *model = [[ModelConnection alloc]init];
         UIImageView *imgView = [[UIImageView alloc]initWithImage:[model buscarImagen:[imagenes objectAtIndex:i]]];
        [imgView setFrame:frame];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        imgView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTouch:)];
        tap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:tap];
        [imgView setUserInteractionEnabled:YES];
        [self.scrollView addSubview:imgView];
    }
    
      _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [imagenes count], _scrollView.frame.size.height);
}

-(void)imageTouch:(id)sender{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [_delegate abrirImagenSeleccionada:[NSString stringWithFormat:@"%d",page]];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


@end
