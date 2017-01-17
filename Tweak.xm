
#import "Tweak.h"
#import "PHPreferences.h"
#import "UIImage+PHExtensions.h"

#import <substrate.h>
#import "PLPhotoLibrary.h"
#import "PLManagedAlbum.h"
#import "PLManagedAsset.h"

static PLManagedAsset * firstNonHiddenPhotoInAssets(NSOrderedSet *assets) {
    for (PLManagedAsset *asset_photo in assets.reverseObjectEnumerator.allObjects) {
        if (asset_photo.isPhoto && !asset_photo.hidden) {
            return asset_photo;
        }
    }
    
    return nil;
}

static UIImage * getRecentImage() {
    PLPhotoLibrary *library = [PLPhotoLibrary sharedPhotoLibrary];
    PLManagedAlbum *album;
    
    PHLog(@"[Photicon]: Searching for albums...");
    
    NSString *albumName = PHAlbumName();
    for (PLManagedAlbum *album_filtering in library.albums) {
        if ([album_filtering.localizedTitle isEqualToString:albumName]) {
            album = album_filtering;
            break;
        }
    }
    
    PHLog(@"[Photicon]: Album search result: %@", album);
    
    if (!album) {
        album = library.albums.firstObject;
    }
    
    PLManagedAsset *photo = firstNonHiddenPhotoInAssets(album.assets);
    
    if (!photo) {
        album = library.albums.firstObject;
        photo = firstNonHiddenPhotoInAssets(album.assets);
    }
    
    PHLog(@"[Photicon]: Verify that image is here: %@", photo.mainFileURL);
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:photo.mainFileURL]];
}

static void reloadPhotosIcon() {
    PHLog(@"[Photicon]: Will reload icon...");
    
    SBIconController *controller = [%c(SBIconController) sharedInstance];
    SBIcon *icon = [controller.model expectedIconForDisplayIdentifier:@"com.apple.mobileslideshow"];
    SBIconView *iconView = [controller.homescreenIconViewMap mappedIconViewForIcon:icon];
    SBIconImageView *imageView = MSHookIvar<SBIconImageView *>(iconView, "_iconImageView");
    
    [imageView updateImageAnimated:YES];
}

%group defaults

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
    %orig(arg1, arg2);
    if (PHEnabled()) {
        reloadPhotosIcon();
    }
}


%end


%hook SBUIController

- (BOOL)clickedMenuButton {
    if (PHEnabled()) {
        reloadPhotosIcon();
    }
    return %orig();
}

%end

%hook SBIconImageView

- (id)contentsImage {
    if (PHEnabled() && [self.icon.applicationBundleID isEqualToString:@"com.apple.mobileslideshow"]) {
        
        UIImage *overlayMask = [[self _currentOverlayImage] resizedToSize:CGSizeMake(256, 256)];
        UIImage *recentImage = getRecentImage();
        UIImage *finalImage  = recentImage;
        
        if ([PHImageEffect() isEqualToString:@"none"]) {
            //            finalImage = [recentImage maskedToImage:overlayMask];
        } else if ([PHImageEffect() isEqualToString:@"lightblur"]) {
            finalImage = [[recentImage blurred:PHBlurAmount()] maskedToImage:overlayMask];
        } else if ([PHImageEffect() isEqualToString:@"darkblur"]) {
            finalImage = [[recentImage blurred:PHBlurAmount()] maskedToImage:overlayMask];
            finalImage = [finalImage tintedToColor:[UIColor.blackColor colorWithAlphaComponent:0.3]];
        }
        
        return finalImage;
    }
    
    return %orig();
}

%end

%end


%ctor {
    %init(defaults);
}
