//
//  CTLoginInputFeildsManager.h
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString const *CTLoginFieldErrorDomainValidationFailed;

@interface CTLoginInputFeildsManager : NSObject <UITextFieldDelegate>

@property (nonatomic, copy) void(^LoginBlock)(BOOL success, NSError *error);

@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *password;

@property (nonatomic, weak) UITextField *userNameField;
@property (nonatomic, weak) UITextField *passwordField;

- (BOOL) validateUserName:(NSString *) userName andPassword:(NSString *) password;
- (void) login;//Validates the fields and calls the Login block

@end
