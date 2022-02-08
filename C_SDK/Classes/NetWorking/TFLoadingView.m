//
//  TFLoadingView.m
//  TreeFishProject
//
//  Created by 李洞洞 on 2019/10/17.
//  Copyright © 2019 李洞洞. All rights reserved.
//

#import "TFLoadingView.h"

@interface TFLoadingView ()
@property(nonatomic,strong)UIImageView * topImageView;
@property(nonatomic,strong)UILabel     * descLabel;
@property(nonatomic,strong)UIButton    * settingBtn;
@property(nonatomic,strong)UIButton    * reloadBtn;
@property(nonatomic,strong)UIButton    * backBtn;
@property(nonatomic,strong)UIActivityIndicatorView * activityIndicator;
@end

@implementation TFLoadingView
SingleM(LoadingView)
- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    }
    return _activityIndicator;
}
- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"网络异常图片"];
    }
    return _topImageView;
}
- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        NSString * str = @"网络异常\n世界上最遥远的距离就是没有网络，\n 快去检查一下吧～";
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#BDBDBD"],NSFontAttributeName:[UIFont fontWithName:@"Source Han Sans CN" size: 10]}];
        NSRange range = [str rangeOfString:@"网络异常"];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#949494"] range:range];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Source Han Sans CN" size: 20] range:range];
        NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
        [descStyle setLineSpacing:10];//行间距
        [attr addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, attr.length)];
        
        _descLabel.attributedText = attr;
        _descLabel.textAlignment = YES;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
- (UIButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [[UIButton alloc]init];
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"设置网络"] forState:UIControlStateNormal];
        [_settingBtn setTitle:@"设置网络" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[UIColor colorWithHexString:@"#131313"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}
- (UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [[UIButton alloc]init];
        [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
        [_reloadBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:[UIColor colorWithHexString:@"#131313"] forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"icon顶部导航"] forState:UIControlStateNormal];
        [_backBtn addTarget:self.class action:@selector(hiddle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.activityIndicator];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.width.and.height.mas_equalTo(200);
    }];
    self.activityIndicator.transform = CGAffineTransformMakeScale(2,2);

}
- (void)setUpUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(240);
        make.centerX.mas_offset(0);
        make.top.mas_offset(100);
    }];
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom).mas_offset(13);
        make.centerX.mas_offset(0);
    }];
    //self.descLabel.backgroundColor = UIColor.cyanColor;
    [self addSubview:self.settingBtn];
    [self addSubview:self.reloadBtn];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(49);
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(32);
    }];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.and.centerX.mas_equalTo(self.settingBtn);
        make.top.mas_equalTo(self.settingBtn.mas_bottom).mas_offset(24);
    }];
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(32);
        make.left.mas_offset(10);
    }];
    
}
+ (void)show
{
    TFLoadingView * loading = [TFLoadingView shareLoadingView];
    [loading.activityIndicator removeFromSuperview];
    [loading setUpUI];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:loading];
}
+ (void)hiddle
{
    TFLoadingView * loading = [TFLoadingView shareLoadingView];
    [loading.activityIndicator stopAnimating];
    [loading removeFromSuperview];
}
+ (void)showFromView:(UIView *)view
{
    TFLoadingView * loading = [TFLoadingView shareLoadingView];
    for (UIView * subView in loading.subviews) {
        if (![subView isKindOfClass:[UIActivityIndicatorView class]]) {
            [subView removeFromSuperview];
        }
    }
    [loading.activityIndicator startAnimating];
    [view addSubview:loading];
    
}
+ (void)hiddleForView:(UIView *)view
{
    [self hiddle];
}
- (void)settingBtnClick
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];   
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL: url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL: url];
        }
    }
}
- (void)reloadBtnClick
{
    if (self.reloadClick) {
        self.reloadClick();
    }
    //[TFLoadingView hiddle];
    for (UIView * subView in self.subviews) {
        if (![subView isKindOfClass:[UIActivityIndicatorView class]]) {
            [subView removeFromSuperview];
        }
    }
    [self layoutIfNeeded];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
