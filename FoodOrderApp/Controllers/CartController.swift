import UIKit
import Lottie

class CartController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyStackView: UIStackView!
    private var successAnimationView: LottieAnimationView?
    private var dimmingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()        
        setupBottomContainer()
        setupTotalLabel()
        setupCheckoutButton()
        setupEmptyState()
        adjustForSmallScreens()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCart()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        title = "Cart"
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.contentInset.bottom = 88
        table.verticalScrollIndicatorInsets.bottom = 88
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCart),
            name: Notification.Name("cartUpdated"),
            object: nil
        )
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
        ])
    }
}

//MARK: Functions
extension CartController {    
    private func updateTotal() {
        let total = CartManager.shared.totalPrice
        totalLabel.text = String(format: "Total: %.2f ₼", total)
        
        checkoutButton.isEnabled = total > 0
        checkoutButton.alpha = total > 0 ? 1.0 : 0.5
    }
    
    @objc private func updateCart() {
        let isEmpty = CartManager.shared.items.isEmpty
        
        emptyStackView.isHidden = !isEmpty
        table.isHidden = isEmpty
        bottomContainer.isHidden = isEmpty
        
        table.reloadData()
        updateTotal()
        
        if isEmpty {
            emptyStackView.alpha = 0
            emptyStackView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            UIView.animate(withDuration: 0.25) {
                self.emptyStackView.alpha = 1
                self.emptyStackView.transform = .identity
            }
        }
    }
    
    @objc private func checkoutTapped() {
        let total = CartManager.shared.totalPrice
        guard total > 0 else { return }
        
        checkoutButton.isEnabled = false
        
        showSuccessAnimation {
            let alert = UIAlertController(
                title: "Order placed 🎉",
                message: String(format: "Total: %.2f ₼", total),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                CartManager.shared.clearCurrentCart()
                self.checkoutButton.isEnabled = true
            })
            
            self.present(alert, animated: true)
        }
    }
}

//MARK: Config
extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CartManager.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CartCell",
            for: indexPath
        ) as! CartCell
        
        let item = CartManager.shared.items[indexPath.row]
        cell.configure(with: item)
        
        cell.onQuantityChanged = { quantity in
            CartManager.shared.updateQuantity(
                for: item.dish,
                quantity: quantity
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { _, _, completion in
            
            let item = CartManager.shared.items[indexPath.row]
            
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        cell.transform = CGAffineTransform(
                            translationX: -tableView.bounds.width,
                            y: 0
                        )
                        cell.alpha = 0
                    },
                    completion: { _ in
                        CartManager.shared.updateQuantity(
                            for: item.dish,
                            quantity: 0
                        )
                    }
                )
            }
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
}

//MARK: Setups and Success Animation
extension CartController {
    
    private func adjustForSmallScreens() {
        if view.bounds.height < 700 {
            totalLabel.font = .boldSystemFont(ofSize: 15)
            checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }
    }
    
    private func setupCheckoutButton() {
        
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.backgroundColor = .systemGreen
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 20
        checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        checkoutButton.addTarget(
            self,
            action: #selector(checkoutTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTotalLabel() {
        totalLabel.font = .boldSystemFont(ofSize: 16)
        totalLabel.textColor = .label
    }
    
    private func setupBottomContainer() {
        bottomContainer.backgroundColor = .systemBackground
        bottomContainer.layer.cornerRadius = 20
        bottomContainer.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        bottomContainer.clipsToBounds = false
        bottomContainer.layer.shadowColor = UIColor.black.cgColor
        bottomContainer.layer.shadowOpacity = 0.08
        bottomContainer.layer.shadowRadius = 12
        bottomContainer.layer.shadowOffset = CGSize(width: 0, height: -4)
        bottomContainer.layer.masksToBounds = false
    }
    
    private func setupEmptyState() {
        
        emptyStackView.axis = .vertical
        emptyStackView.alignment = .center
        emptyStackView.spacing = 16
        
        emptyImageView.image = UIImage(systemName: "cart")
        emptyImageView.tintColor = .systemGray
        
        emptyLabel.text = "Cart is empty"
        emptyLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.textAlignment = .center
        
        emptyStackView.isHidden = true
    }
    
    private func showSuccessAnimation(completion: @escaping () -> Void) {
        
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        dimmingView = dimView
        
        let animationView = LottieAnimationView(name: "successOrder")
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.alpha = 0
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 220),
            animationView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        UIView.animate(withDuration: 0.2) {
            animationView.alpha = 1
        }
        
        animationView.play { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                UIView.animate(withDuration: 0.2, animations: {
                    animationView.alpha = 0
                    dimView.alpha = 0
                }, completion: { _ in
                    animationView.removeFromSuperview()
                    dimView.removeFromSuperview()
                    
                    UINotificationFeedbackGenerator()
                        .notificationOccurred(.success)
                    
                    completion()
                })
            }
        }
    }
}
