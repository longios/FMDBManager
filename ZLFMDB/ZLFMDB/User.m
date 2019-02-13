//
//	User.m
//
//	Create by 子隆 翁 on 29/11/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "User.h"

NSString *const kUserAllowAllActMsg = @"allow_all_act_msg";
NSString *const kUserAllowAllComment = @"allow_all_comment";
NSString *const kUserAvatarLarge = @"avatar_large";
NSString *const kUserBiFollowersCount = @"bi_followers_count";
NSString *const kUserCity = @"city";
NSString *const kUserCreatedAt = @"created_at";
NSString *const kUserDescriptionField = @"description";
NSString *const kUserDomain = @"domain";
NSString *const kUserFavouritesCount = @"favourites_count";
NSString *const kUserFollowMe = @"follow_me";
NSString *const kUserFollowersCount = @"followers_count";
NSString *const kUserFollowing = @"following";
NSString *const kUserFriendsCount = @"friends_count";
NSString *const kUserGender = @"gender";
NSString *const kUserGeoEnabled = @"geo_enabled";
NSString *const kUserIdField = @"id";
NSString *const kUserLocation = @"location";
NSString *const kUserName = @"name";
NSString *const kUserOnlineStatus = @"online_status";
NSString *const kUserProfileImageUrl = @"profile_image_url";
NSString *const kUserProvince = @"province";
NSString *const kUserRemark = @"remark";
NSString *const kUserScreenName = @"screen_name";
NSString *const kUserStatusesCount = @"statuses_count";
NSString *const kUserUrl = @"url";
NSString *const kUserVerified = @"verified";
NSString *const kUserVerifiedReason = @"verified_reason";

@interface User ()
@end
@implementation User
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"allowAllActMsg": kUserAllowAllActMsg,
             @"allowAllComment":kUserAllowAllComment,
             @"biFollowersCount":kUserBiFollowersCount,
             @"followMe":kUserFollowMe,
             @"followersCount":kUserFollowersCount
             };
}


@end
