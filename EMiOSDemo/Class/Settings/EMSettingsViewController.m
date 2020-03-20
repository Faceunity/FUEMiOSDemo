//
//  EMSettingsViewController.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2018/12/24.
//  Copyright © 2018 XieYajie. All rights reserved.
//

#import "EMSettingsViewController.h"

#import "EMAvatarNameCell.h"

#import "EMAccountViewController.h"
#import "EMBlacklistViewController.h"
#import "EMDevicesViewController.h"
#import "EMGeneralViewController.h"
#import "EMPrivacyViewController.h"
#import "EMCallSettingsViewController.h"

@interface EMSettingsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EMAvatarNameCell *userCell;

@end

@implementation EMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"应用设置";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(EMVIEWTOPMARGIN + 15);
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@60);
    }];
    
    self.userCell = [[EMAvatarNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EMAvatarNameCell"];
    self.userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.userCell.nameLabel.font = [UIFont systemFontOfSize:18];
    self.userCell.detailLabel.font = [UIFont systemFontOfSize:15];
    self.userCell.detailLabel.textColor = [UIColor grayColor];
    self.userCell.avatarView.image = [UIImage imageNamed:@"user_avatar_me"];
    self.userCell.nameLabel.text = [EMClient sharedClient].currentUsername;
    self.userCell.detailLabel.text = [EMClient sharedClient].pushOptions.displayName;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
        case 3:
            count = 1;
            break;
        case 1:
        case 2:
            count = 2;
            break;
            
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        return self.userCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (section == 1) {
        if (row == 0) {
            cell.textLabel.text = @"黑名单";
        } else if (row == 1) {
            cell.textLabel.text = @"多端多设备管理";
        }
    } else if (section == 2) {
        if (row == 0) {
            cell.textLabel.text = @"通用";
        } else if (row == 1) {
            cell.textLabel.text = @"隐私";
        }
    } else if (section == 3) {
        if (row == 0) {
            cell.textLabel.text = @"实时音视频";
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 55;
    if (indexPath.section == 0 && indexPath.row == 0) {
        height = 70;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 20;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            EMAccountViewController *controller = [[EMAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            EMBlacklistViewController *controller = [[EMBlacklistViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (row == 1) {
            EMDevicesViewController *controller = [[EMDevicesViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (section == 2) {
        if (row == 0) {
            EMGeneralViewController *controller = [[EMGeneralViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (row == 1) {
            EMPrivacyViewController *pvController = [[EMPrivacyViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:pvController animated:YES];
        }
    } else if (section == 3) {
        if (row == 0) {
            EMCallSettingsViewController *controller = [[EMCallSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
