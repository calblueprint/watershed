//
//  WPSiteView.m
//  Watershed
//
//  Created by Andrew on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteView.h"
#import "Masonry.h"
#import "UIColor+WPColors.h"
#import "UIView+WPExtensions.h"
#import "UIImage+ImageEffects.h"

@interface WPSiteView ()

@property (nonatomic) UIImageView *coverPhotoView;
@property (nonatomic) UIImage *originalCoverPhoto;
@property (nonatomic) NSMutableArray *coverPhotoArray;
@property (nonatomic) NSInteger blurRadius;

@end

@implementation WPSiteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {

    UIImage *coverPhoto = [UIImage imageNamed:@"SampleCoverPhoto"];
    _originalCoverPhoto = coverPhoto;
    
    UIImageView *coverPhotoView = [[UIImageView alloc] initWithImage:coverPhoto];
    [coverPhotoView setContentMode:UIViewContentModeScaleAspectFill];
    [coverPhotoView setClipsToBounds:YES];
    _coverPhotoView = coverPhotoView;
    [self addSubview:coverPhotoView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int i = 0; i <= 40; i++) {
            UIImage *image = self.originalCoverPhoto;
            image = [image applyBlurWithRadius:i
                                     tintColor:[UIColor colorWithRed:0
                                                               green:0
                                                                blue:0
                                                               alpha:(i * 0.15 / 40)]
                         saturationDeltaFactor:1
                                     maskImage:nil];
            [self.coverPhotoArray addObject:image];
            NSLog(@"%d", i);
        }
    });
    
    
}

- (void)setUpActions {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)updateConstraints {
    
    [self.coverPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@184);
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [super updateConstraints];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {
        CGPoint trans = [sender translationInView:self];
        
        self.blurRadius -= trans.y;
        if (self.blurRadius < 0) {self.blurRadius = 0;}
        if (self.blurRadius > 40) {self.blurRadius = 40;}
        
        [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([[NSNumber alloc] initWithFloat:184.0 - self.blurRadius * 3 ]);
        }];
        
        [super updateConstraints];
        
        [self.coverPhotoView setImage:self.coverPhotoArray[self.blurRadius]];
        [sender setTranslation:CGPointZero inView:self];
    }
}

- (NSMutableArray *)coverPhotoArray
{
    if (!_coverPhotoArray) {
        _coverPhotoArray = [[NSMutableArray alloc] init];
    }
    return _coverPhotoArray;
}

@end

