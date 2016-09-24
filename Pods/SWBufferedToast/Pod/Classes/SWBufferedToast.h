//
//  SWBufferedToast.h
//  LoginTest
//
//  Created by Stephen Walsh on 30/03/2015.
//  Copyright (c) 2015 Stephen Walsh. All rights reserved.
//

@class SWBufferedToast;

@protocol SWBufferedToastDelegate <NSObject>

- (void)didTapActionButtonWithToast:(SWBufferedToast*)toast;
- (void)didAttemptLoginWithUsername:(NSString*)username
                        andPassword:(NSString*)password
                          withToast:(SWBufferedToast*)toast;
- (void)didAttemptCreateWithUsername:(NSString*)username
                            Password:(NSString*)password
                        andFirstName:(NSString *)firstName
                           withToast:(SWBufferedToast*)toast;
-(void)didBeginRegistration:(SWBufferedToast*)toast;
- (void)didDismissToastView:(SWBufferedToast*)toast;
- (void)didBeginBack:(SWBufferedToast*)toast;
- (void)didBeginContinue:(SWBufferedToast*)toast;


@end

#import <UIKit/UIKit.h>
#import "SWToast.h"

@interface SWBufferedToast : UIView <SWPlainToastDelegate>

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, weak) id <SWBufferedToastDelegate> delegate;

- (instancetype)initPlainToastWithTitle:(NSString*)title
                               subtitle:(NSString*)subtitle
                       actionButtonText:(NSString*)dismissButtonText
                        backgroundColor:(UIColor*)backgroundColor
                             toastColor:(UIColor*)toastColor
                    animationImageNames:(NSArray*)animationImageNames
                            andDelegate:(id)delegate
                                 onView:(UIView*)parentView;

- (instancetype)initLoginToastWithTitle:(NSString*)title
                          usernameTitle:(NSString*)usernameTitle
                          passwordTitle:(NSString*)passwordTitle
                              doneTitle:(NSString*)doneTitle
                   differentActionTitle:(NSString *)differentActionTitle
                       thirdActionTitle:(NSString *)thirdActionTitle
                       backgroundColour:(UIColor*)backgroundColor
                             toastColor:(UIColor*)toastColor
                    animationImageNames:(NSArray*)animationImageNames
                            andDelegate:(id)delegate
                                 onView:(UIView*)parentView;

- (instancetype)initRegisterToastWithTitle:(NSString*)title
                             usernameTitle:(NSString*)usernameTitle
                             passwordTitle:(NSString*)passwordTitle
                            firstNameTitle:(NSString*)firstNameTitle
                                 doneTitle:(NSString*)doneTitle
                      differentActionTitle:(NSString *)differentActionTitle
                          backgroundColour:(UIColor*)backgroundColor
                                toastColor:(UIColor*)toastColor
                       animationImageNames:(NSArray*)animationImageNames
                               andDelegate:(id)delegate
                                    onView:(UIView*)parentView;

- (instancetype)initNoticeToastWithTitle:(NSString*)title
                                subtitle:(NSString*)subtitle
                           timeToDisplay:(NSInteger)timeToDisplay
                        backgroundColour:(UIColor*)backgroundColor
                              toastColor:(UIColor*)toastColor
                     animationImageNames:(NSArray*)animationImageNames
                                  onView:(UIView*)parentView;

- (void)appear;
- (void)dismiss;
- (void)beginLoading;
- (void)endLoading;

@end
