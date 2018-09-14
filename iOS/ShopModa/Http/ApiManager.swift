
import Foundation

class ApiManager {
    
    class func post(params: [String: String]?, completion: @escaping ((Bool, Any?) -> ())) {
        
        HttpManager.post(url: Constants.ServerUrl, params: params) { result, data in
            if result, let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    completion(true, json)
                    return
                } catch {}
            }
            completion(false, nil)
        }
    }
}
