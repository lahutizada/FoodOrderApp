import UIKit
import UniformTypeIdentifiers

class ProfileController: UIViewController {
    
    let defaults = DataManager()
    var users = [RegisterData]()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        loadDataToFile()
        loadUserData()
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        goToLogin()
    }
}

//MARK: ProfileController Extension - (loadUserData), (goToLogin), (getFilePath), (loadDataToFile)
extension ProfileController {
    
    private func loadUserData() {
        guard
            let currentEmail = defaults.getData(key: .currentUserEmail) as? String,
            let user = users.first(where: { $0.email == currentEmail })
        else {
            clearLabels()
            return
        }
        
        nameLabel.text = "Name: \(user.name ?? "")"
        surnameLabel.text = "Surname: \(user.surname ?? "")"
        emailLabel.text = "Email: \(user.email ?? "")"
        phoneLabel.text = "Phone: \(user.phone ?? "")"
        birthLabel.text = "Birth date: \(user.birth ?? "")"
    }
    
    private func clearLabels() {
        nameLabel.text = "Name:"
        surnameLabel.text = "Surname:"
        emailLabel.text = "Email:"
        phoneLabel.text = "Phone:"
        birthLabel.text = "Birth date:"
    }
    
    func goToLogin() {
        defaults.setData(value: false, key: .IsLoggedIn)
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginController") as? LoginController
        navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    private func getFilePath() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("Users", conformingTo: .json)
        print(url)
        return url
    }
    
    private func loadDataToFile() {
        do {
            let data = try Data(contentsOf: getFilePath())
            users = try JSONDecoder().decode([RegisterData].self, from: data)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
