//
//  Loading.h
//  newquizii
//
//  Created by apple on 2019/5/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Loading : NSObject

+ (void)showLoadingWithView:(UIView *)view message:(NSString *)message;
+ (void)hiddenLoadingWithView:(UIView *)view;
+ (void)showMessageWithView:(UIView *)view message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
