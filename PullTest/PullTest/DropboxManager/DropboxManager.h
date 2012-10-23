
#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol DropboxManagerDelegate <NSObject>

@required

@optional
- (void)uploadProgress:(CGFloat)progress // float 0~100
                  from:(NSString *)srcPath
                toUser:(NSString *)
              uploaded:(NSInteger)uploadedSize
                 total:(NSInteger)totalSize;
- (void)uploadedFile:(NSString *)srcPath toUser:(NSString *)user;
- (void)uploadFileFailedWithError:(NSError *)error;

- (void)downloadProgress:(CGFloat)progress // float 0~100
                 forFile:(NSString *)destPath
                fromUser:(NSString *)user
              downloaded:(NSInteger)downloadedSize
                   total:(NSInteger)totalSize;
- (void)downloadedFile:(NSString *)destPath fromUser:(NSString *)user;
- (void)downloadFileFailedWithError:(NSError *)error;

//- (void)queriedIncomingFile:(NSArray *)files forUser:(NSString *)user;
//- (void)queryIncomingFileFailedWithError:(NSError *)error;
@end


@interface DropboxManager : NSObject <DBSessionDelegate, DBRestClientDelegate, DBNetworkRequestDelegate>
{
    DBSession *dbSession;
    DBRestClient *restClient;
    id<DropboxManagerDelegate> delegate;
}
@property (strong, nonatomic) DBSession *dbSession;
@property (strong, nonatomic) DBRestClient *restClient;
@property (weak, nonatomic) id<DropboxManagerDelegate> delegate;

- (DropboxManager *)initWithAppKey:(NSString *)key
                         appSecret:(NSString *)secret
                            myName:(NSString *)myName
                      downloadPath:(NSString *)path;

- (void)uploadFile:(NSString *)srcPath toUser:(NSString *)user;
//- (void)downloadFile:(NSString *)dropboxPath forUser:(NSString *)user;
//- (void)queryIncomingFileFor:(NSString *)user;
- (NSDictionary *)friendList;
- (void)setFriendList:(NSDictionary *)newFriends;


@end
