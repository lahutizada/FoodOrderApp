import UIKit
import Lottie
import UniformTypeIdentifiers

class LoginController: UIViewController, RegisterDelegate {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var loginAnimation: LottieAnimationView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!

    let defaults = DataManager()
    var users = [RegisterData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
        loginAnimation.play()
        loginAnimation.loopMode = .autoReverse

        errorLabel.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataToFile()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        goToMain()
    }

    @IBAction func registrationButtonTapped(_ sender: Any) {
        let controller = storyboard?
            .instantiateViewController(
                withIdentifier: "\(RegisterController.self)"
            ) as! RegisterController

        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: LoginController Extension - (goToMain), (didRegister), (getFilePath), (loadDataToFile)
extension LoginController {

    func goToMain() {
        
        errorLabel.isHidden = true
        guard let email = emailTextField.text, !email.isEmpty else {
            showError("Email boş ola bilməz")
            return
        }

        guard Validator.isValidEmail(email) else {
            showError("Email formatı düzgün deyil")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showError("Şifrə boş ola bilməz")
            return
        }

        guard password.count >= 5 && password.count <= 10 else {
            showError("Şifrə 5–10 simvol olmalıdır")
            return
        }

        let isValidUser = users.contains {
            $0.email == email && $0.password == password
        }

        guard isValidUser else {
            showError("Email və ya şifrə yanlışdır")
            return
        }

        errorLabel.isHidden = false
        errorLabel.text = "Uğurlu giriş!"
        errorLabel.textColor = .systemGreen

        defaults.setData(value: true, key: .IsLoggedIn)
        defaults.setData(value: email, key: .currentUserEmail)

        let controller = storyboard?.instantiateViewController(withIdentifier:"\(MainController.self)") as! MainController

        navigationController?.pushViewController(controller, animated: true)
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
    
    func didRegister(email: String, password: String) {
        emailTextField.text = email
        passwordTextField.text = password
    }
    private func getFilePath() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[0].appendingPathComponent("Users", conformingTo: .json)
        print(url)
        return url
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
}
