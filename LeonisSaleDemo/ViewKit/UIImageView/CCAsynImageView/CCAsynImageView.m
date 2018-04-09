//
//  CCSpinnerWebImageView.m
//
//  Created by leo-mobile-lily on 2/7/13.
//  Copyright (c) 2013 Leonis All rights reserved.
//

#import "CCAsynImageView.h"


@interface CCAsynImageView()

@property (nonatomic, strong) UIActivityIndicatorView	*loadingSpinner;
@property (nonatomic) CGSize imageSize;
@property (nonatomic,strong) CCAsynImageDownloadedBlock afterDownlaodBlock;

@end

@implementation CCAsynImageView

#pragma mark -
#pragma init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initImageView];
    }
    return self;
}

-(void)initImageView{
    
    [self setContentMode:UIViewContentModeScaleToFill];
  
}

#pragma mark -
#pragma method
- (void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

-(void)setImageWithURL:(NSString *)url complation:(CCAsynImageDownloadedBlock)block{
    
    self.afterDownlaodBlock = block;
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        self.imageUrl = [NSURL URLWithString:url];
        [manager downloadWithURL:self.imageUrl delegate:self];
    }
}

- (void)setImageWithURL:(NSString *)url size:(CGSize)size
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    
    [self.delegete didLoadImage:self.image];
    
    if (self.afterDownlaodBlock) {
        self.afterDownlaodBlock();
    }
}

@end
