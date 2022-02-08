//
//  Loading.m
//  newquizii
//
//  Created by apple on 2019/5/29.
//

#import "Loading.h"
#import <MBProgressHUD.h>

@implementation Loading

+ (void)showLoadingWithView:(UIView *)view message:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    UIImage *image = [UIImage imageNamed:@"jiazai"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    hud.customView = imageView;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.contentColor = [UIColor colorWithHexString:kcolor_666666];
    hud.label.numberOfLines = 0;
    hud.label.font = kfont_16;
    hud.bezelView.alpha = 1.0;
    NSString *string = [NSString stringWithFormat:@"\n%@",message];
    hud.label.text = NSLocalizedString(string, @"HUD completed title");
//    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    layer.toValue = @(2 * M_PI);
//    layer.duration = 1.25;
//    layer.removedOnCompletion = false;
//    layer.repeatCount = MAXFLOAT;
//    [imageView.layer addAnimation:layer forKey:nil];
    
}

+ (void)hiddenLoadingWithView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    [hud hideAnimated:YES];
    //[hud hideAnimated:YES afterDelay:0.1];
}

+ (void)showMessageWithView:(UIView *)view message:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(message, @"HUD message title");
    hud.label.numberOfLines = 0;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.minSize = CGSizeMake(120, 35);
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    [hud hideAnimated:YES afterDelay:1.5f];
}

@end
