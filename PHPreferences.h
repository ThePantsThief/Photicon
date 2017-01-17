//
//  PHPreferences.h
//  Photicon
//
//  Created by Tanner on 1/15/17.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

extern NSDictionary * PHPreferences();
extern NSDictionary * ALBUM_PHPreferences();
extern BOOL PHEnabled();
extern double PHBlurAmount();
extern NSString * PHImageEffect();
extern NSString * PHAlbumName();
extern void PHSetPreferenceValueForKey(id value, NSString *key);
extern void PHSetAlbumPreferenceValueForKey(id value, NSString *key);

#ifdef __cplusplus
}
#endif