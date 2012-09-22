//
//  AvatarMenuViewController.m
//  PullTest
//
//  Created by Ace Wu on 12/9/22.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "AvatarMenuViewController.h"

@interface AvatarMenuViewController ()
{
    NSArray *items;
}
@end

@implementation AvatarMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        items = [[NSArray alloc] initWithObjects:@"Share Desktop",@"Chat",nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    /*
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addFriendButton.frame = CGRectMake(150.0f, 5.0f, 75.0f, 30.0f);
    [addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
    [cell addSubview:addFriendButton];
    [addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
