
import Foundation

extension String {
    
    func base64Encode() -> String? {
        let data = self.data(using: Constants.StringEncoding)
        return data?.base64EncodedString()
    }
    
    func base64Decode() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: Constants.StringEncoding)
        }
        return nil
    }
}
