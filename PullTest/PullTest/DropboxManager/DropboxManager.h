#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@class SKViewController;

@protocol DropboxManagerDelegate <NSObject>

@required

@optional
- (void)uploadProgress:(CGFloat)progress // float 0~100
               forFile:(NSString *)fileName
                toUser:(NSString *)user
              uploaded:(long long)uploadedSize
                 total:(long long)totalSize
                fileId:(NSString *)fileId;
- (void)uploadedFile:(NSString *)fileName
              toUser:(NSString *)toUser
              fileId:(NSString *)fileId;
- (void)uploadFileFailedWithError:(NSError *)error;

- (void)downloadStartForFile:(NSString *)fileName
                      toPath:(NSString *)localFile
                    fromUser:(NSString *)fromUser
                      fileId:(NSString *)fileId;
- (void)downloadProgress:(CGFloat)progress // float 0~100
                 forFile:(NSString *)fileName
                fromUser:(NSString *)fromUser
              downloaded:(long long)downloadedSize
                   total:(long long)totalSize
                  fileId:(NSString *)fileId;
- (void)downloadedFile:(NSString *)fileName
              fromUser:(NSString *)fromUser
                fileId:(NSString *)fileId;
- (void)downloadFileFailedWithError:(NSError *)error;

//- (void)queriedIncomingFile:(NSArray *)files forUser:(NSString *)user;
//- (void)queryIncomingFileFailedWithError:(NSError *)error;
@end


@interface DropboxManager : NSObject <DBRestClientDelegate>

@property (strong, nonatomic) DBSession *dbSession;
@property (strong, nonatomic) DBRestClient *restClient;
@property (weak,   nonatomic) id<DropboxManagerDelegate> delegate;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) NSString *downloadPath;
@property (weak,   nonatomic) SKViewController *mainController;

- (DBRestClient *)restClient;

- (DropboxManager *)initWithAppKey:(NSString *)key
                         appSecret:(NSString *)secret
                          userName:(NSString *)userName
                      downloadPath:(NSString *)path;

- (void)linkFromController:(UIViewController *)mainController;
- (BOOL)isLinked;

- (NSString *)uploadFile:(NSString *)srcPath toUser:(NSString *)user;
//- (void)downloadFile:(NSString *)dropboxPath forUser:(NSString *)user;
//- (void)queryIncomingFileFor:(NSString *)user;
- (NSDictionary *)friendList;
- (void)setFriendList:(NSDictionary *)newFriends;


@end
