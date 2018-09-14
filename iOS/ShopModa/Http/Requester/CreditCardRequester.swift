
import Foundation

struct CreditCardData {
    let number: String
    let expire: String
    let cvc: String
    let name: String
    
    init(data: Dictionary<String, Any>) {
        self.number = data["number"] as? String ?? ""
        self.expire = data["expire"] as? String ?? ""
        self.cvc = data["cvc"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
    }
    
    init(number: String, expire: String, cvc: String, name: String) {
        self.number = number
        self.expire = expire
        self.cvc = cvc
        self.name = name
    }
}

class CreditCardRequester {
    
    class func fetch(userId: String, completion: @escaping ((Bool, CreditCardData?) -> ())) {
        
        let params = [
            "command": "getCreditCard",
            "userId": userId
        ]
        ApiManager.post(params: params) { (result, data) in
            if result, let data = data as? Dictionary<String, Any> {
                completion(true, CreditCardData(data: data))
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func set(userId: String, creditCardData: CreditCardData, completion: @escaping ((Bool) -> ())) {
        
        let params = [
            "command": "setCreditCard",
            "userId": userId,
            "number": creditCardData.number,
            "expire": creditCardData.expire,
            "cvc": creditCardData.cvc,
            "name": creditCardData.name
        ]
        ApiManager.post(params: params) { (result, data) in
            if result, let data = data as? Dictionary<String, Any> {
                if (data["result"] as? String) == "0" {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
}
