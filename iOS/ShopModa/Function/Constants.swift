
import Foundation

struct Constants {
    static let HttpTimeOutInterval = TimeInterval(10)
    static let ServerUrl = "https://leapfrog.sakura.ne.jp/samples/shop_moda/srv.php"
    static let StringEncoding = String.Encoding.utf8
    
    struct UserDefaultsKey {
        
        static let UserId = "UserId"
        static let favoriteItemIds = "FavoriteItemIds"
        static let favoriteNewsIds = "FavoriteNewsIds"
        static let readNewsIds = "ReadNewsIds"
    }
}
