//
//  CTLoginInputFeildsManager.m
//  CodingTest
//
//  Created by Akshay on 30/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginInputFeildsManager.h"
#import "CTLoginFeildTableViewCell.h"

NSString const *CTLoginFieldErrorDomainValidationFailed = @"CTLoginFieldErrorDomainValidationFailed";

@interface CTLoginInputFeildsManager()

@property (nonatomic, strong, readwrite) NSString *userName;
@property (nonatomic, strong, readwrite) NSString *password;

@end

@implementation CTLoginInputFeildsManager

#pragma mark -
#pragma mark - Setters

- (void) setUserNameField:(UITextField *)userNameField
{
    _userNameField = userNameField;
    _userNameField.delegate = self;
}

- (void) setPasswordField:(UITextField *)passwordField
{
    _passwordField = passwordField;
    _passwordField.delegate = self;
}

#pragma mark -
#pragma mark - Validate Feilds

- (BOOL) validateUserName:(NSString *) userName andPassword:(NSString *) password
{
    BOOL isValid = NO;
    isValid = (userName.length > 0 && password.length > 0);
    return isValid;
}

- (void) login
{
    if ([self validateUserName:_userName andPassword:_password]) {
        if (_LoginBlock) {
            _LoginBlock(YES,nil);
        }
    }
    else {
        if (_LoginBlock) {
            _LoginBlock(NO, [NSError errorWithDomain:[NSString stringWithFormat:@"%@",CTLoginFieldErrorDomainValidationFailed] code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Please Enter your User Name and Password to continue"}]);
        }
    }
}

#pragma mark -
#pragma mark - UITextFeild Delegates

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *currentText = [NSMutableString stringWithString:textField.text];
    [currentText replaceCharactersInRange:range withString:string];
    
    if (textField.tag == CTLoginfieldTypeUserName) {
        _userName = currentText;
    }
    else {
        _password = currentText;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag == CTLoginfieldTypeUserName) {
        _userName = nil;;
    }
    else {
        _password = nil;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == CTLoginfieldTypeUserName) {
        //Go to password
        [textField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }
    else if (textField.tag ==  CTLoginfieldTypePassword) {
        [self login];
    }
    
    return YES;
}


@end
