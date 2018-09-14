
import Foundation

struct HistoryItemData {
    
    let itemId: String
    let number: Int
    
    init?(data: Dictionary<String, Any>) {
        
        guard let itemId = data["itemId"] as? String else {
            return nil
        }
        self.itemId = itemId
        
        self.number = Int(data["number"] as? String ?? "") ?? 0
    }
}

struct HistoryData {
    
    let id: String
    let items: [HistoryItemData]
    
    init?(data: Dictionary<String, Any>) {
        
        guard let id = data["id"] as? String else {
            return nil
        }
        self.id = id
        
        guard let items = data["items"] as? [Dictionary<String, Any>] else {
            return nil
        }
        self.items = items.flatMap { HistoryItemData(data: $0) }
    }
}

class HistoryRequester {
    
    class func fetch(userId: String, completion: @escaping ((Bool, [HistoryData]?) -> ())) {
        
        let params = [
            "command": "getHistory",
            "userId": userId
        ]
        ApiManager.post(params: params) { result, data in
            if let json = data as? Array<Any> {
                var dataList = [HistoryData]()
                json.flatMap { $0 as? Dictionary<String, Any> }.forEach {
                    if let historyData = HistoryData(data: $0) {
                        dataList.append(historyData)
                    }
                }
                completion(true, dataList)
                return
            }
            completion(false, nil)
        }
    }
}
