
import Foundation

struct UserInformationData {
    let name: String
    let kana: String
    let postCode: String
    let address: String
    let phoneNumber: String
    
    init(data: Dictionary<String, Any>) {
        self.name = (data["name"] as? String ?? "").base64Decode() ?? ""
        self.kana = (data["kana"] as? String ?? "").base64Decode() ?? ""
        self.postCode = data["postCode"] as? String ?? ""
        self.address = (data["address"] as? String ?? "").base64Decode() ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
    }
    
    init(name: String, kana: String, postCode: String, address: String, phoneNumber: String) {
        self.name = name
        self.kana = kana
        self.postCode = postCode
        self.address = address
        self.phoneNumber = phoneNumber
    }
}

class UserInformationRequester {
    
    class func fetch(userId: String, completion: @escaping ((Bool, UserInformationData?) -> ())) {
        
        let params = [
            "command": "getUserInformation",
            "userId": userId
        ]
        ApiManager.post(params: params) { (result, data) in
            if result, let data = data as? Dictionary<String, Any> {
                completion(true, UserInformationData(data: data))
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func set(userId: String, userInformationData: UserInformationData, completion: @escaping ((Bool) -> ())) {
        
        let params = [
            "command": "setUserInformation",
            "userId": userId,
            "name": userInformationData.name.base64Encode() ?? "",
            "kana": userInformationData.kana.base64Encode() ?? "",
            "postCode": userInformationData.postCode,
            "address": userInformationData.address.base64Encode() ?? "",
            "phoneNumber": userInformationData.phoneNumber
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
