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
#import "WPMiniSiteTableViewCell.h"
#import "WPLabeledIcon.h"

@interface WPSiteView () <UIScrollViewDelegate>

@property (nonatomic) UIImageView *coverPhotoView;
@property (nonatomic) UIImage *originalCoverPhoto;
@property (nonatomic) UIImageView *navbarShadowOverlay;
@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UIView *headingLineBreak;
@property (nonatomic) WPLabeledIcon *addressLabel;
@property (nonatomic) WPLabeledIcon *siteCountLabel;
@property (nonatomic) UIImageView *tableViewShadowOverlay;
@property (nonatomic) UIScrollView *miniSiteScrollView;

@property (nonatomic) NSMutableArray *coverPhotoArray;
@property (nonatomic) NSInteger blurRadius;

@end

@implementation WPSiteView

static const int COVER_PHOTO_HEIGHT = 184;
static int COVER_PHOTO_TRANS = 0;

- (id)initWithFrame:(CGRect)frame {
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
    
    _miniSiteScrollView = [({
        UIScrollView *miniSiteScrollView = [[UIScrollView alloc] init];
        miniSiteScrollView.delegate = self;
        miniSiteScrollView;
    }) wp_addToSuperview:self];
    
    _miniSiteTableView = [({
        UITableView *miniSiteTableView = [[UITableView alloc] init];
        miniSiteTableView.backgroundColor = [UIColor whiteColor];
        [miniSiteTableView setSeparatorInset:UIEdgeInsetsZero];
        miniSiteTableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        miniSiteTableView.scrollEnabled = NO;
        miniSiteTableView;
    }) wp_addToSuperview:self.miniSiteScrollView];
    
    _tableHeaderView = [({
        UIView *tableHeaderView = [[UIView alloc] init];
        tableHeaderView;
    }) wp_addToSuperview:self.miniSiteScrollView];
    
    _titleLabel = [({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"Watershed";
        titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"Cal Blueprint is a student-run UC Berkeley organization devoted to matching the skills of its members to our desire to see social good enacted in our community. Each semester, teams of 4-5 students work closely with a non-profit to bring technological solutions to the problems they face every day.";
        descriptionLabel.font = [UIFont systemFontOfSize:14.0];
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _headingLineBreak = [({
        UIView *headingLineBreak = [[UIView alloc] init];
        headingLineBreak.backgroundColor = [UIColor blackColor];
        headingLineBreak.alpha = 0.2;
        headingLineBreak;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _addressLabel = [({
        WPLabeledIcon *addressLabel = [[WPLabeledIcon alloc] initWithText:@"123 Mark Miyashita Drive, Berkeley, CA 94720" icon:[UIImage imageNamed:@"MapMarkerIcon"]];
        addressLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _siteCountLabel = [({
        WPLabeledIcon *siteCountLabel = [[WPLabeledIcon alloc] initWithText:@"10 mini sites" icon:[UIImage imageNamed:@"TreeIcon"]];
        siteCountLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _tableViewShadowOverlay = [({
        UIImageView *tableViewShadowOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowOverlay"]];
        [tableViewShadowOverlay setContentMode:UIViewContentModeScaleToFill];
        [tableViewShadowOverlay setClipsToBounds:YES];
        tableViewShadowOverlay.alpha = 0.25;
        tableViewShadowOverlay;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _coverPhotoView = [({
        UIImage *coverPhoto = [UIImage imageNamed:@"SampleCoverPhoto2"];
        _originalCoverPhoto = coverPhoto;
        UIImageView *coverPhotoView = [[UIImageView alloc] initWithImage:coverPhoto];
        [coverPhotoView setContentMode:UIViewContentModeScaleAspectFill];
        [coverPhotoView setClipsToBounds:YES];
        coverPhotoView;
    }) wp_addToSuperview:self];
    
    [self generateBlurredPhotos];
    
    _navbarShadowOverlay = [({
        UIImageView *navbarShadowOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowOverlay"]];
        [navbarShadowOverlay setContentMode:UIViewContentModeScaleToFill];
        [navbarShadowOverlay setClipsToBounds:YES];
        navbarShadowOverlay;
    }) wp_addToSuperview:self];
    
    [self setNeedsUpdateConstraints];
}

- (void)setUpActions {
    [self addGestureRecognizer:self.miniSiteScrollView.panGestureRecognizer];
}

- (void)updateConstraints {
    
    [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT));
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.navbarShadowOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(64));
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.miniSiteScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(COVER_PHOTO_HEIGHT - 64));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(self.tableViewShadowOverlay.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue]);
        make.centerX.equalTo(self.mas_centerX);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
    }];
    
    [self.headingLineBreak mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue] * 2);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
        make.height.equalTo(@1);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headingLineBreak.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue] * 2);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
    }];
    
    [self.siteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue] / 2);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
    }];
    
    [self.tableViewShadowOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.top.equalTo(self.siteCountLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue] * 2);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];

    [self.miniSiteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableHeaderView.mas_bottom);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

    [super updateConstraints];
}

- (void)updateTableViewHeight:(NSInteger)cellCount {
    [self.miniSiteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([WPMiniSiteTableViewCell cellHeight] * cellCount));
    }];
}

#pragma mark - Blurred Photo Generation

- (void)generateBlurredPhotos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int i = 0; i <= 20; i+= 2) {
            UIImage *image = self.originalCoverPhoto;
            image = [image applyBlurWithRadius:i
                                     tintColor:[UIColor clearColor]
                         saturationDeltaFactor:1
                                     maskImage:nil];
            
            [self.coverPhotoArray addObject:image];
            [self.coverPhotoArray addObject:image];
        }
    });
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)coverPhotoArray {
    if (!_coverPhotoArray) {
        _coverPhotoArray = [[NSMutableArray alloc] init];
    }
    return _coverPhotoArray;
}

#pragma mark - ScrollView Delegate Method from ViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat trans = scrollView.contentOffset.y + 64.0;
    COVER_PHOTO_TRANS = trans;
    if (COVER_PHOTO_TRANS > 120) COVER_PHOTO_TRANS = 120;
    self.blurRadius = MIN(ABS(COVER_PHOTO_TRANS / 6), 20);
    
    [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT - COVER_PHOTO_TRANS));
    }];
    
    if (self.coverPhotoArray.count > self.blurRadius) {
        [self.coverPhotoView setImage:self.coverPhotoArray[self.blurRadius]];
    }
    
    CGFloat titleAlpha = (trans - COVER_PHOTO_TRANS - 20)/40;
    
    UINavigationBar *navBar = ((UIViewController *)[self nextResponder]).navigationController.navigationBar;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:titleAlpha]}];
}

@end

