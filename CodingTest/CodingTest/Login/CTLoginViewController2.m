//
//  CTLoginViewController2.m
//  CodingTest
//
//  Created by Akshay on 29/07/15.
//  Copyright (c) 2015 Akshay Hegde. All rights reserved.
//

#import "CTLoginViewController2.h"
#import "CTLoginFeildTableViewCell.h"
#import "CTLoginInfoTextTableViewCell.h"
#import "CTLoginButtonTableViewCell.h"

#import "CTDocumentCollectionViewController.h"

#define kCTLoginTextFeildCellID @"CTLoginTextFieldCellID"
#define kCTLoginInfoFeildCellID @"CTLoginInfoCellID"
#define kCTLoginButtonCellID @"CTLoginButtonCellID"

@interface CTLoginViewController2 () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong) CTLoginInfoTextTableViewCell *prototypeLoginInfoTextCell;

@end

@implementation CTLoginViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _prototypeLoginInfoTextCell = [CTLoginInfoTextTableViewCell loadFromNib];
    _prototypeLoginInfoTextCell.textLabel.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum";
    [_tableVIew registerNib:[CTLoginInfoTextTableViewCell nib] forCellReuseIdentifier:kCTLoginInfoFeildCellID];
    
    
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor clearColor];
    _tableVIew.tableFooterView = emptyView;
    
    [_tableVIew addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark -
#pragma mark - KVo

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
    
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
        
        UIEdgeInsets inset = _tableVIew.contentInset;
        CGFloat deltaSpace = CGRectGetHeight(self.view.frame) - [[self topLayoutGuide] length] - _tableVIew.contentSize.height;
        if (deltaSpace > 0) {
            inset.top = deltaSpace/2;
        }
        else {
            inset.top = [[self topLayoutGuide] length];
        }
        _tableVIew.contentInset = inset;
        
        [_tableVIew layoutIfNeeded];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        CTDocumentCollectionViewController *collectionVC = [CTDocumentCollectionViewController loadFromStoryBoard];
        [self.navigationController pushViewController:collectionVC animated:YES];
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
            return cell;
            break;
        }
        case 1:
        {
            CTLoginFeildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCTLoginTextFeildCellID forIndexPath:indexPath];
            [cell customizeForType:CTLoginfieldTypePassword];
            return cell;
            break;
        }
        case 2:
        {
            CTLoginInfoTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCTLoginInfoFeildCellID forIndexPath:indexPath];
            cell.textLabel.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum";
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
    [_tableVIew removeObserver:self forKeyPath:@"contentSize"];
}

@end
