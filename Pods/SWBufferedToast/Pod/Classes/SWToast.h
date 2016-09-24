//
//  SWToast.h
//  LoginTest
//
//  Created by Stephen Walsh on 30/03/2015.
//  Copyright (c) 2015 Stephen Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWPlainToastDelegate <NSObject>

- (void)actionButtonTapped;

@end

@protocol SWLoginToastDelegate <NSObject>

- (void)loginButtonTappedWithUsername:(NSString*)username
                          andPassword:(NSString*)password;
- (void)registerButtonTappedWithUsername:(NSString*)username
                                Password:(NSString*)password
                            andFirstName:(NSString *)firstName;
- (void)registerButtonTapped;
- (void)backButtonTapped;
- (void)continueButtonTapped;



@end

typedef NS_ENUM(NSInteger, SWBufferedToastType) {
    SWBufferedToastTypePlain,
    SWBufferedToastTypeLogin,
    SWBufferedToastTypeRegister,
    SWBufferedToastTypeNotice
};

@interface SWToast : UIView <UITextFieldDelegate>

@property (nonatomic, assign) SWBufferedToastType toastType;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, readonly) BOOL loadingBlocksDismiss;
@property (nonatomic, weak) id <SWPlainToastDelegate> plainToastDelegate;
@property (nonatomic, weak) id <SWLoginToastDelegate> loginToastDelegate;
@property (nonatomic, weak) id <SWLoginToastDelegate> registerToastDelegate;


- (instancetype)initPlainToastWithColour:(UIColor*)color
                                   title:(NSString*)title
                                subtitle:(NSString*)subtitle
                             actionTitle:(NSString*)actionTitle
                     animationImageNames:(NSArray*)animationImageNames
                           plainDelegate:(id)delegate
                               andParent:(UIView*)parentView;

- (instancetype)initLoginToastWithColour:(UIColor*)color
                                   title:(NSString*)title
                           usernameTitle:(NSString*)usernameTitle
                           passwordTitle:(NSString*)passwordTitle
                               doneTitle:(NSString*)doneTitle
                    differentActionTitle:(NSString *)differentActionTitle
                        thirdActionTitle:(NSString *)thirdActionTitle
                     animationImageNames:(NSArray*)animationImageNames
                           loginDelegate:(id)loginDelegate
                               andParent:(UIView*)parentView;

- (instancetype)initRegisterToastWithColour:(UIColor*)color
                                      title:(NSString*)title
                              usernameTitle:(NSString*)usernameTitle
                              passwordTitle:(NSString*)passwordTitle
                             firstNameTitle:(NSString*)firstNameTitle
                                  doneTitle:(NSString*)doneTitle
                       differentActionTitle:(NSString *)differentActionTitle
                        animationImageNames:(NSArray*)animationImageNames
                           registerDelegate:(id)registerDelegate
                                  andParent:(UIView*)parentView;


- (instancetype)initNoticeToastWithColour:(UIColor*)color
                                    title:(NSString*)title
                                 subtitle:(NSString*)subtitle
                      animationImageNames:(NSArray*)animationImageNames
                                andParent:(UIView*)parentView;

- (void)appear;
- (void)disappear;
- (void)showBuffer;
- (void)hideBuffer;

@end
