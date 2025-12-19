import UIKit
import Lottie
import UniformTypeIdentifiers

class RegisterController: UIViewController {
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var registerAnimation: LottieAnimationView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let defaults = DataManager()
    var delegate: RegisterDelegate?
    var users = [RegisterData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Registration"
        
        registerAnimation.play()
        registerAnimation.loopMode = .autoReverse
        registerAnimation.backgroundColor = .systemGray
        stack.backgroundColor = .systemGray
        view.backgroundColor = .systemGray
        
        nameTextField.layer.cornerRadius = 10
        nameTextField.clipsToBounds = true
        surnameTextField.layer.cornerRadius = 10
        surnameTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 10
        emailTextField.clipsToBounds = true
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.clipsToBounds = true
        birthTextField.layer.cornerRadius = 10
        birthTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.clipsToBounds = true
        
        loadDataToFile()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        validateUser()
    }
}

//MARK: RegisterController Extension - (validateUser), (loadDataToFile), (saveDataToFile), (getFilePath)
extension RegisterController {
    
    func validateUser() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            showError("Ad boş ola bilməz")
            return
        }
        
        guard let surname = surnameTextField.text, !surname.isEmpty else {
            showError("Soyad boş ola bilməz")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showError("Email boş ola bilməz")
            return
        }
        
        guard Validator.isValidEmail(email) else {
            showError("Email formatı düzgün deyil")
            return
        }
        
        guard !users.contains(where: { $0.email == email }) else {
            showError("Bu email artıq mövcuddur")
            return
        }
        
        guard let phone = phoneTextField.text,
              phone.count == 10 else {
            showError("Telefon nömrəsi düzgün deyil")
            return
        }
        
        guard let birth = birthTextField.text, !birth.isEmpty else {
            showError("Doğum tarixi boş ola bilməz")
            return
        }
        
        guard Validator.isValidBirthDate(birth) else {
            showError("Doğum tarixi dd.MM.yyyy formatında olmalıdır")
            return
        }
        
        guard let password = passwordTextField.text,
              password.count >= 5 && password.count <= 10 else {
            showError("Şifrə 5–10 simvol olmalıdır")
            return
        }
        
        errorLabel.isHidden = true
        
        let userData = RegisterData(
            name: name,
            surname: surname,
            email: email,
            phone: phone,
            birth: birth,
            password: password
        )
        
        users.append(userData)
        saveDataToFile()
        
        delegate?.didRegister(email: email, password: password)
        
        defaults.setData(value: false, key: .IsLoggedIn)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = false

        errorLabel.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.errorLabel.alpha = 1
        }

        UINotificationFeedbackGenerator()
            .notificationOccurred(.error)
    }
    
    private func loadDataToFile() {
        let url = getFilePath()

        guard FileManager.default.fileExists(atPath: url.path) else {
            users = []
            return
        }

        do {
            let data = try Data(contentsOf: url)
            users = try JSONDecoder().decode([RegisterData].self, from: data)
        } catch {
            print(error.localizedDescription)
            users = []
        }
    }
    
    private func saveDataToFile() {
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: getFilePath())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getFilePath() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("Users", conformingTo: .json)
        print(url)
        return url
    }
}
