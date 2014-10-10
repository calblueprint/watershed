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

@interface WPSiteView () <UIScrollViewDelegate>

@property (nonatomic) UIImageView *coverPhotoView;
@property (nonatomic) UIImage *originalCoverPhoto;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UIScrollView *taskScrollView;
@property (nonatomic) UITableView *taskTableView;

@property (nonatomic) NSMutableArray *coverPhotoArray;
@property (nonatomic) NSInteger blurRadius;

@end

@implementation WPSiteView

static const int COVER_PHOTO_HEIGHT = 184;
static const int SITE_TITLE_HEIGHT = 30;
static int COVER_PHOTO_TRANS = 0;
static int SCROLL_OFFSET = 0;

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
    
    UIScrollView *taskScrollView = [[UIScrollView alloc] init];
    taskScrollView.delegate = self;
    _taskScrollView = taskScrollView;
    [self addSubview:taskScrollView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Watershed";
    titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    _titleLabel = titleLabel;
    [self.taskScrollView addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = @"Cal Blueprint is a student-run UC Berkeley organization devoted to matching the skills of its members to our desire to see social good enacted in our community. Each semester, teams of 4-5 students work closely with a non-profit to bring technological solutions to the problems they face every day.";
    descriptionLabel.font = [UIFont systemFontOfSize:14.0];
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.numberOfLines = 0;
    _descriptionLabel = descriptionLabel;
    [self.taskScrollView addSubview:descriptionLabel];
    
    UITableView *taskTableView = [[UITableView alloc] init];
    ((UIScrollView *)taskTableView).delegate = self;
    _taskTableView = taskTableView;
    [self.taskScrollView addSubview:taskTableView];
    
    UIImage *coverPhoto = [UIImage imageNamed:@"SampleCoverPhoto"];
    _originalCoverPhoto = coverPhoto;
    
    UIImageView *coverPhotoView = [[UIImageView alloc] initWithImage:coverPhoto];
    [coverPhotoView setContentMode:UIViewContentModeScaleAspectFill];
    [coverPhotoView setClipsToBounds:YES];
    _coverPhotoView = coverPhotoView;
    [self generateBlurredPhotos];
    [self addSubview:coverPhotoView];
}

- (void)setUpActions {
    [self addGestureRecognizer:self.taskTableView.panGestureRecognizer];
}

- (void)updateConstraints {
    
    [self.coverPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT));
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.taskScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(COVER_PHOTO_HEIGHT + 10));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(COVER_PHOTO_HEIGHT + SITE_TITLE_HEIGHT + 20));
        make.centerX.equalTo(self.mas_centerX);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
    }];
    
    [self.taskTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue]);
        make.height.equalTo(@1000);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

#pragma mark - Blurred Photo Generation

- (void)generateBlurredPhotos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int i = 0; i <= 20; i+= 2) {
            UIImage *image = self.originalCoverPhoto;
            image = [image applyBlurWithRadius:i
                                     tintColor:[UIColor colorWithRed:0
                                                               green:0
                                                                blue:0
                                                               alpha:(i * 0.15 / 20)]
                         saturationDeltaFactor:1
                                     maskImage:nil];
            
            [self.coverPhotoArray addObject:image];
            [self.coverPhotoArray addObject:image];
            NSLog(@"%d", i);
        }
    });
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)coverPhotoArray
{
    if (!_coverPhotoArray) {
        _coverPhotoArray = [[NSMutableArray alloc] init];
    }
    return _coverPhotoArray;
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint trans = scrollView.contentOffset;
    
    COVER_PHOTO_TRANS = trans.y;
    SCROLL_OFFSET = -trans.y;
    if (COVER_PHOTO_TRANS < 0) {COVER_PHOTO_TRANS = 0;}
    if (COVER_PHOTO_TRANS > 120) {COVER_PHOTO_TRANS = 120;}
    self.blurRadius = (NSInteger) COVER_PHOTO_TRANS / 6;
    
    [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT - COVER_PHOTO_TRANS));
    }];
    [super updateConstraints];
    
    [self.coverPhotoView setImage:self.coverPhotoArray[self.blurRadius]];
}

@end

