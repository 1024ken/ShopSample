
import Foundation

struct NewsData {
    
    let id: String
    let title: String
    let body: String
    let image: String
    let presenter: String
    let date: Date?
    
    init?(data: Dictionary<String, Any>) {
        
        guard let id = data["id"] as? String else {
            return nil
        }
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.body = data["body"] as? String ?? ""
        self.image = data["image"] as? String ?? ""
        self.presenter = data["presenter"] as? String ?? ""
        self.date = (data["time"] as? String ?? "").toDate()
    }
}

class NewsRequester {
    
    static let shared = NewsRequester()
    
    var dataList = [NewsData]()
    
    func fetch(completion: @escaping ((Bool) -> ())) {
        
        self.dataList.removeAll()
        
        let params = [
            "command": "getNews"
        ]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Array<Any> {
                json.flatMap { $0 as? Dictionary<String, Any> }.forEach {
                    if let newsData = NewsData(data: $0) {
                        self.dataList.append(newsData)
                    }
                }
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    func filter(newsId: String) -> NewsData? {
        return self.dataList.filter { $0.id == newsId }.first
    }
    
    func unreadCount() -> Int {
        return self.dataList.filter { !SaveData.shared.readNewsIds.contains($0.id) }.count
    }
}
