//
//  CTLoginViewController.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CTLoginFeildTableViewCell.h"
#import "CTLoginInfoTextTableViewCell.h"
#import "CTLoginButtonTableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "CTDocumentCollectionViewController.h"
#import "CTLoginInputFeildsManager.h"

#define kCTLoginTextFeildCellID @"CTLoginTextFieldCellID"
#define kCTLoginInfoFeildCellID @"CTLoginInfoCellID"
#define kCTLoginButtonCellID @"CTLoginButtonCellID"

#define INFO_TEXT @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum"

@interface CTLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong) CTLoginInfoTextTableViewCell *prototypeLoginInfoTextCell;
@property (nonatomic, strong) CTLoginInputFeildsManager *loginFieldsManager;

@end

@implementation CTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    _loginFieldsManager = [[CTLoginInputFeildsManager alloc] init];
    [_loginFieldsManager setLoginBlock:^(BOOL success, NSError *error) {
        if (success) {
            CTDocumentCollectionViewController *documentCollectionVC = [CTDocumentCollectionViewController loadFromStoryBoard];
            [weakSelf.navigationController pushViewController:documentCollectionVC animated:YES];
        }
        else {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeGradient];
        }
    }];
    
    _prototypeLoginInfoTextCell = [CTLoginInfoTextTableViewCell loadFromNib];
    _prototypeLoginInfoTextCell.textLabel.text = INFO_TEXT;
    [_tableVIew registerNib:[CTLoginInfoTextTableViewCell nib] forCellReuseIdentifier:kCTLoginInfoFeildCellID];
    
    
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor clearColor];
    _tableVIew.tableFooterView = emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    UIEdgeInsets inset = _tableVIew.contentInset;
    CGFloat deltaSpace = CGRectGetHeight(self.view.frame) - [[self topLayoutGuide] length] - _tableVIew.contentSize.height;
    if (deltaSpace > 0) {
        inset.top = deltaSpace/2 + [[self topLayoutGuide] length];
    }
    else {
        inset.top = [[self topLayoutGuide] length];
    }
    _tableVIew.contentInset = inset;

}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        [_loginFieldsManager login];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSOurce

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 20.0;
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *emptyView = [[UIView alloc] init];
    [emptyView setHidden:YES];
    return emptyView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0;
    if (indexPath.section == 2) {
        
        [_prototypeLoginInfoTextCell setNeedsUpdateConstraints];
        [_prototypeLoginInfoTextCell setNeedsLayout];
        
        height = [_prototypeLoginInfoTextCell sizeThatFits:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX)].height;
    }
    
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CTLoginFeildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCTLoginTextFeildCellID forIndexPath:indexPath];
            [cell customizeForType:CTLoginfieldTypeUserName];
            _loginFieldsManager.userNameField = cell.textField;
            return cell;
            break;
        }
        case 1:
        {
            CTLoginFeildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCTLoginTextFeildCellID forIndexPath:indexPath];
            cell.textField.delegate = self;
            [cell customizeForType:CTLoginfieldTypePassword];
            _loginFieldsManager.passwordField = cell.textField;
            return cell;
            break;
        }
        case 2:
        {
            CTLoginInfoTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCTLoginInfoFeildCellID forIndexPath:indexPath];
            cell.textLabel.text = INFO_TEXT;
            return cell;
            break;
        }
        case 3:
        {
            CTLoginButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCTLoginButtonCellID forIndexPath:indexPath];
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (void)dealloc
{
    _tableVIew.delegate = nil;
    _tableVIew.dataSource = nil;
}

@end
