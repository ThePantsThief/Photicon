//
//  PHPAlbumPickerViewController.m
//  Photicon
//
//  Created by c0ldra1n on 1/14/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "../PLPhotoLibrary.h"
#import "../PLManagedAlbum.h"
#import "../PLManagedAsset.h"
#import "../PHPreferences.h"

#import "PHPAlbumPickerViewController.h"

@interface PHPAlbumPickerViewController ()
@property (nonatomic) NSArray<PLManagedAlbum*> *albums;
@property (nonatomic) NSIndexPath *selectedIndex;
@end

@implementation PHPAlbumPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44.f;
    
    NSMutableArray *albums_unfiltered = [[PLPhotoLibrary sharedPhotoLibrary] albums].mutableCopy;
    [albums_unfiltered removeObjectAtIndex:0];  //  Camera Roll Duplicate Fix
    
    // Remove empty and hidden albums
    NSInteger i = 0;
    NSString *currentAlbumName = PHAlbumName();
    NSMutableArray *filteredAlbums = [NSMutableArray array];
    for (PLManagedAlbum *album in albums_unfiltered) {
        if (album.photosCount && ![album.localizedTitle isEqualToString:@"Hidden"]) {
            [filteredAlbums addObject:album];
            
            // Set self.selectedIndex
            if ([album.localizedTitle isEqualToString:currentAlbumName]) {
                self.selectedIndex = [NSIndexPath indexPathForRow:i inSection:0];
            }
            i++;
        }
    }
    
    self.albums = filteredAlbums;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.title = @"Select Album";
    
    [self.tableView reloadData];    //   When everything is done
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    PLManagedAlbum *album = self.albums[indexPath.row];
    
    cell.textLabel.text = album.localizedTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%llu Photos", album.photosCount];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    // self.selectedIndex is initialized in viewDidLoad
    if ([self.selectedIndex isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[tableView cellForRowAtIndexPath:self.selectedIndex] setAccessoryType:UITableViewCellAccessoryNone];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.selectedIndex = indexPath;
}

- (void)done {
    PHSetAlbumPreferenceValueForKey(self.albums[self.selectedIndex.row].localizedTitle, @"PHAlbumName");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
