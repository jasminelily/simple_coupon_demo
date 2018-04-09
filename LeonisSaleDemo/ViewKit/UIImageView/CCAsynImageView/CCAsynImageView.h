//
//  CCSpinnerWebImageView.h
//
//  Created by leo-mobile-lily on 2/7/13.
//  Copyright (c) 2013 Leonis All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@protocol CCAsynImageViewDelegate <NSObject>

@optional
-(void)didLoadImage:(UIImage*)loadedImage;

@end

typedef void (^CCAsynImageDownloadedBlock)(void);

@interface CCAsynImageView : UIImageView<SDWebImageManagerDelegate>

@property (nonatomic) BOOL isWithSpinner;
@property (nonatomic,weak) id<CCAsynImageViewDelegate> delegete;
@property (nonatomic,strong) NSURL * imageUrl;

- (void)setImageWithURL:(NSString *)url;
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSString *)url size:(CGSize)size;
- (void)setImageWithURL:(NSString *)url complation:(CCAsynImageDownloadedBlock)block;

- (void)cancelCurrentImageLoad;

@end
