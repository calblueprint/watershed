//
//  WPSiteView.m
//  Watershed
//
//  Created by Andrew Millman on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteView.h"
#import "WPMiniSiteTableViewCell.h"

@interface WPSiteView () <UIScrollViewDelegate>


@property (nonatomic) UIImageView *navbarShadowOverlay;
@property (nonatomic) UIView *coverPhotoOverlay;
@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UIView *headingLineBreak;
@property (nonatomic) UIImageView *tableViewShadowOverlay;
@property (nonatomic) UIScrollView *siteScrollView;

@end

@implementation WPSiteView

static int COVER_PHOTO_TRANS = 0;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:NO];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

- (void)dealloc {
    [self.coverPhotoView cancelImageRequestOperation];
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
    _siteScrollView = [({
        UIScrollView *siteScrollView = [[UIScrollView alloc] init];
        siteScrollView.delegate = self;
        siteScrollView.alwaysBounceVertical = YES;
        siteScrollView;
    }) wp_addToSuperview:self];
    
    _miniSiteTableView = [({
        UITableView *miniSiteTableView = [[UITableView alloc] init];
        miniSiteTableView.backgroundColor = [UIColor whiteColor];
        [miniSiteTableView setSeparatorInset:UIEdgeInsetsZero];
        miniSiteTableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        miniSiteTableView.scrollEnabled = NO;
        miniSiteTableView;
    }) wp_addToSuperview:self.siteScrollView];
    
    _tableHeaderView = [({
        UIView *tableHeaderView = [[UIView alloc] init];
        tableHeaderView;
    }) wp_addToSuperview:self.siteScrollView];
    
    _titleLabel = [({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
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
        FAKFontAwesome *mapMarkerIcon = [FAKFontAwesome mapMarkerIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *mapMarkerImage = [mapMarkerIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *addressLabel = [[WPLabeledIcon alloc] initWithText:@"Street Address" icon:mapMarkerImage];
        addressLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _siteCountLabel = [({
        FAKFontAwesome *treeIcon = [FAKFontAwesome treeIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *treeImage = [treeIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *siteCountLabel = [[WPLabeledIcon alloc] initWithText:@"Site Count" icon:treeImage];
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
        UIImageView *coverPhotoView = [[UIImageView alloc] init];
        [coverPhotoView setContentMode:UIViewContentModeScaleAspectFill];
        [coverPhotoView setClipsToBounds:YES];
        coverPhotoView;
    }) wp_addToSuperview:self];
    
    _coverPhotoOverlay = [({
        UIView *overlay = [[UIView alloc] init];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.1;
        overlay;
    }) wp_addToSuperview:self];
    
    _navbarShadowOverlay = [({
        UIImageView *navbarShadowOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowOverlay"]];
        [navbarShadowOverlay setContentMode:UIViewContentModeScaleToFill];
        [navbarShadowOverlay setClipsToBounds:YES];
        navbarShadowOverlay;
    }) wp_addToSuperview:self];
    
    [self setNeedsUpdateConstraints];
}

- (void)setUpActions {
    [self addGestureRecognizer:self.siteScrollView.panGestureRecognizer];
}

- (void)updateConstraints {
    
    [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT - COVER_PHOTO_TRANS));
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.coverPhotoOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(self.coverPhotoView.mas_bottom);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.navbarShadowOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(topMargin));
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.siteScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(COVER_PHOTO_HEIGHT));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(self.tableViewShadowOverlay.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom)
            .with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.headingLineBreak mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom)
            .with.offset(standardMargin * 2);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
        make.height.equalTo(@1);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headingLineBreak.mas_bottom)
            .with.offset(standardMargin * 2);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.siteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom)
            .with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.tableViewShadowOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.top.equalTo(self.siteCountLabel.mas_bottom)
            .with.offset(standardMargin * 2);
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

- (void)configureWithSite:(WPSite *)site {
    [self.coverPhotoView setImageWithURL:[site.imageURLs firstObject]
                        placeholderImage:[UIImage imageNamed:@"WPBlue"]];
    self.originalCoverPhoto = self.coverPhotoView.image;
    self.titleLabel.text = site.name;
    self.descriptionLabel.text = site.info;
    self.addressLabel.label.text = [NSString stringWithFormat:@"%@, %@, %@ %@", site.street, site.city, site.state, site.zipCode];
    self.siteCountLabel.label.text = [[site.miniSitesCount stringValue] stringByAppendingString:@" mini sites"];
}

#pragma mark - ScrollView Delegate Method from ViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat trans = scrollView.contentOffset.y;
    COVER_PHOTO_TRANS = MIN(60, trans);
    self.coverPhotoOverlay.alpha = 0.3 + (COVER_PHOTO_TRANS + topMargin) / 600;
    
    [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT - COVER_PHOTO_TRANS));
    }];
    
    CGFloat titleAlpha = (trans - COVER_PHOTO_TRANS - 20) / 30;

    UINavigationBar *navBar = ((UIViewController *)[self nextResponder]).navigationController.navigationBar;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:titleAlpha]}];
}

@end

