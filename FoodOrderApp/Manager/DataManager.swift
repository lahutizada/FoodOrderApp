import Foundation

class DataManager {
    enum DataManagerType: String, CaseIterable {
        case name
        case surname
        case email
        case phone
        case birth
        case password
        case IsLoggedIn
        case currentUserEmail
    }
    
    func setData(value: Any, key: DataManagerType) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getData(key: DataManagerType) -> Any? {
        UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
}
