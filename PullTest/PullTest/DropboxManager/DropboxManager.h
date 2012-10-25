#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol DropboxManagerDelegate <NSObject>

@required

@optional
- (void)uploadProgress:(CGFloat)progress // float 0~100
               forFile:(NSString *)fileName
                toUser:(NSString *)user
              uploaded:(long long)uploadedSize
                 total:(long long)totalSize;
- (void)uploadedFile:(NSString *)srcPath toUser:(NSString *)user;
- (void)uploadFileFailedWithError:(NSError *)error;

- (void)downloadProgress:(CGFloat)progress // float 0~100
                 forFile:(NSString *)fileName
                fromUser:(NSString *)user
              downloaded:(long long)downloadedSize
                   total:(long long)totalSize;
- (void)downloadedFile:(NSString *)destPath fromUser:(NSString *)user;
- (void)downloadFileFailedWithError:(NSError *)error;

//- (void)queriedIncomingFile:(NSArray *)files forUser:(NSString *)user;
//- (void)queryIncomingFileFailedWithError:(NSError *)error;
@end


@interface DropboxManager : NSObject <DBSessionDelegate, DBRestClientDelegate>
{
    DBSession *dbSession;
    DBRestClient *restClient;
    id<DropboxManagerDelegate> delegate;
    NSString *myName;
    NSString *downloadPath;
}
@property (strong, nonatomic) DBSession *dbSession;
@property (strong, nonatomic) DBRestClient *restClient;
@property (weak,   nonatomic) id<DropboxManagerDelegate> delegate;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) NSString *downloadPath;

- (DropboxManager *)initWithAppKey:(NSString *)key
                         appSecret:(NSString *)secret
                          userName:(NSString *)userName
                      downloadPath:(NSString *)path;

- (void)linkFromController:(UIViewController *)mainController;
- (BOOL)isLinked;

- (void)uploadFile:(NSString *)srcPath toUser:(NSString *)user;
//- (void)downloadFile:(NSString *)dropboxPath forUser:(NSString *)user;
//- (void)queryIncomingFileFor:(NSString *)user;
- (NSDictionary *)friendList;
- (void)setFriendList:(NSDictionary *)newFriends;


@end
