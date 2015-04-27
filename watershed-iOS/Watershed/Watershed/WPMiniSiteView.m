//
//  WPMiniSiteView.m
//  Watershed
//
//  Created by Andrew Millman on 11/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteView.h"
#import "UIExtensions.h"
#import "WPFieldReportTableViewCell.h"

@interface WPMiniSiteView () <UIScrollViewDelegate>

@property (nonatomic) UIImageView *navbarShadowOverlay;
@property (nonatomic) UIView *coverPhotoOverlay;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UIView *headingLineBreak;
@property (nonatomic) UIImageView *tableViewShadowOverlay;

@end

@implementation WPMiniSiteView

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
    
    _miniSiteScrollView = [({
        UIScrollView *miniSiteScrollView = [[UIScrollView alloc] init];
        miniSiteScrollView.delegate = self;
        miniSiteScrollView.alwaysBounceVertical = YES;
        miniSiteScrollView;
    }) wp_addToSuperview:self];
    
    _fieldReportTableView = [({
        UITableView *miniSiteTableView = [[UITableView alloc] init];
        miniSiteTableView.backgroundColor = [UIColor whiteColor];
        [miniSiteTableView setSeparatorInset:UIEdgeInsetsZero];
        miniSiteTableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        miniSiteTableView.scrollEnabled = NO;
        miniSiteTableView;
    }) wp_addToSuperview:self.miniSiteScrollView];
    
    _indicatorView = [({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [view startAnimating];
        view;
    }) wp_addToSuperview:self];

    _tableHeaderView = [({
        UIView *tableHeaderView = [[UIView alloc] init];
        tableHeaderView;
    }) wp_addToSuperview:self.miniSiteScrollView];
    
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
        FAKIonIcons *mapMarkerIcon = [FAKIonIcons pinIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *mapMarkerImage = [mapMarkerIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *addressLabel = [[WPLabeledIcon alloc] initWithText:@"Street Addresss Label" icon:mapMarkerImage];
        addressLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _vegetationListLabel = [({
        FAKFontAwesome *treeIcon = [FAKFontAwesome treeIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *treeImage = [treeIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *vegetationListLabel = [[WPLabeledIcon alloc] initWithText:@"Vegetation List" icon:treeImage];
        vegetationListLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _currentTaskLabel = [({
        FAKIonIcons *checkIcon = [FAKIonIcons checkmarkCircledIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *currentTaskLabel = [[WPLabeledIcon alloc] initWithText:@"Current Task" icon:checkImage];
        currentTaskLabel;
    }) wp_addToSuperview:self.tableHeaderView];
    
    _fieldReportCountLabel = [({
        FAKIonIcons *clipboardIcon = [FAKIonIcons clipboardIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *clipboardImage = [clipboardIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *fieldReportCountLabel = [[WPLabeledIcon alloc] initWithText:@"Field Report Count" icon:clipboardImage];
        fieldReportCountLabel;
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
    [self addGestureRecognizer:self.miniSiteScrollView.panGestureRecognizer];
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
    
    [self.miniSiteScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.trailing.equalTo(@(standardMargin));
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
    
    [self.vegetationListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom)
            .with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(standardMargin));
    }];
    
    [self.currentTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vegetationListLabel.mas_bottom)
            .with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.fieldReportCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentTaskLabel.mas_bottom)
            .with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.tableViewShadowOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.top.equalTo(self.fieldReportCountLabel.mas_bottom)
            .with.offset(standardMargin * 2);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.fieldReportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableHeaderView.mas_bottom);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldReportTableView.mas_top).with.offset(2 * standardMargin);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [super updateConstraints];
}

#pragma mark - Public Methods

- (void)updateTableViewHeight:(NSInteger)cellCount {
    [self.fieldReportTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([WPFieldReportTableViewCell cellHeight] * cellCount));
    }];
}

- (void)configureWithMiniSite:(WPMiniSite *)miniSite {
    [self.coverPhotoView setImageWithURL:[miniSite.imageURLs firstObject]
                        placeholderImage:[UIImage imageNamed:@"WPBlue"]];
    self.originalCoverPhoto = self.coverPhotoView.image;
    self.titleLabel.text = miniSite.name;
    self.descriptionLabel.text = miniSite.info;
    self.addressLabel.label.text = [NSString stringWithFormat:@"%@, %@, %@ %@", miniSite.street, miniSite.city, miniSite.state, miniSite.zipCode];
    //self.vegetationListLabel.text = miniSite.vegetations;
    self.currentTaskLabel.label.text = [NSString stringWithFormat:@"%@ tasks", miniSite.taskCount];
    self.fieldReportCountLabel.label.text = [[miniSite.fieldReportCount stringValue] stringByAppendingString:@" field reports"];
}

- (void)stopIndicator {
    [self.indicatorView stopAnimating];
    self.indicatorView.alpha = 0;
}

#pragma mark - ScrollView Delegate Method from ViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat trans = scrollView.contentOffset.y;
    COVER_PHOTO_TRANS = MIN(60, trans);
    self.coverPhotoOverlay.alpha = 0.3 + (COVER_PHOTO_TRANS + topMargin) / 600;
    self.coverPhotoView.alpha = 1 + (trans + topMargin) / 70;
    
    [self.coverPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(COVER_PHOTO_HEIGHT - COVER_PHOTO_TRANS));
    }];
    
    CGFloat titleAlpha = (trans - COVER_PHOTO_TRANS - 20) / 30;
    
    UINavigationBar *navBar = ((UIViewController *)[self nextResponder]).navigationController.navigationBar;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:titleAlpha]}];
}

@end