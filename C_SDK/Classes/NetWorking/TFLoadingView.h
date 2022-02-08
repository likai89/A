//
//  TFLoadingView.h
//  TreeFishProject
//
//  Created by 李洞洞 on 2019/10/17.
//  Copyright © 2019 李洞洞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Single.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^reloadBlock)(void);
@interface TFLoadingView : UIView
SingleH(LoadingView)
@property(nonatomic,copy)reloadBlock  reloadClick;
+ (void)show;
+ (void)hiddle;
+ (void)showFromView:(UIView*)view;
+ (void)hiddleForView:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
