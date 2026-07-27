import UIKit
import Network

class HackMenuViewController: UIViewController {
    
    // State
    var ghostOn = false
    var teleOn = false
    var allOn = false
    var isConnected = false
    
    // UI Elements
    let titleLabel = UILabel()
    let statusLabel = UILabel()
    let connectLabel = UILabel()
    let ipLabel = UILabel()
    let portLabel = UILabel()
    
    let ghostSwitch = UISwitch()
    let teleSwitch = UISwitch()
    let allSwitch = UISwitch()
    let ghostLabel = UILabel()
    let teleLabel = UILabel()
    let allLabel = UILabel()
    
    let copyButton = UIButton(type: .system)
    let refreshButton = UIButton(type: .system)
    
    var serverIP = "0.0.0.0"
    let serverPort = 8080
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getLocalIP()
        startHeartbeat()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.02, green: 0.02, blue: 0.08, alpha: 1)
        
        // Gradient background
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1).cgColor,
            UIColor(red: 0.1, green: 0.0, blue: 0.1, alpha: 1).cgColor
        ]
        view.layer.insertSublayer(gradient, at: 0)
        
        // Title
        titleLabel.text = "FF HACK MENU"
        titleLabel.textColor = .systemCyan
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Connect Status
        connectLabel.text = "[!] Connecting to server..."
        connectLabel.textColor = .systemRed
        connectLabel.font = UIFont.systemFont(ofSize: 14)
        connectLabel.textAlignment = .center
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectLabel)
        
        // Hack Status
        statusLabel.text = "[-] NORMAL"
        statusLabel.textColor = .systemYellow
        statusLabel.font = UIFont.boldSystemFont(ofSize: 20)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // IP
        ipLabel.text = "IP: Getting..."
        ipLabel.textColor = UIColor(red: 0, green: 1, blue: 0.5, alpha: 1)
        ipLabel.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .bold)
        ipLabel.textAlignment = .center
        ipLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ipLabel)
        
        // Port
        portLabel.text = "Port: 8080"
        portLabel.textColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1)
        portLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .bold)
        portLabel.textAlignment = .center
        portLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(portLabel)
        
        // Buttons
        copyButton.setTitle("COPY IP", for: .normal)
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        copyButton.layer.cornerRadius = 8
        copyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.addTarget(self, action: #selector(copyIP), for: .touchUpInside)
        view.addSubview(copyButton)
        
        refreshButton.setTitle("REFRESH", for: .normal)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.1, alpha: 1)
        refreshButton.layer.cornerRadius = 8
        refreshButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.addTarget(self, action: #selector(refreshIP), for: .touchUpInside)
        view.addSubview(refreshButton)
        
        // Switches
        ghostLabel.text = "GHOST (Invisible)"
        ghostLabel.textColor = UIColor(red: 0, green: 0.8, blue: 1, alpha: 1)
        ghostLabel.font = UIFont.boldSystemFont(ofSize: 20)
        ghostLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ghostLabel)
        
        ghostSwitch.onTintColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 1)
        ghostSwitch.translatesAutoresizingMaskIntoConstraints = false
        ghostSwitch.addTarget(self, action: #selector(ghostToggled), for: .valueChanged)
        view.addSubview(ghostSwitch)
        
        teleLabel.text = "TELE (Teleport)"
        teleLabel.textColor = UIColor(red: 0.8, green: 0.5, blue: 1, alpha: 1)
        teleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        teleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(teleLabel)
        
        teleSwitch.onTintColor = UIColor(red: 0.6, green: 0.2, blue: 1, alpha: 1)
        teleSwitch.translatesAutoresizingMaskIntoConstraints = false
        teleSwitch.addTarget(self, action: #selector(teleToggled), for: .valueChanged)
        view.addSubview(teleSwitch)
        
        allLabel.text = "ALL (Both)"
        allLabel.textColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 1)
        allLabel.font = UIFont.boldSystemFont(ofSize: 20)
        allLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(allLabel)
        
        allSwitch.onTintColor = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1)
        allSwitch.translatesAutoresizingMaskIntoConstraints = false
        allSwitch.addTarget(self, action: #selector(allToggled), for: .valueChanged)
        view.addSubview(allSwitch)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            connectLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            connectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: connectLabel.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ipLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 15),
            ipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            portLabel.topAnchor.constraint(equalTo: ipLabel.bottomAnchor, constant: 4),
            portLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            copyButton.topAnchor.constraint(equalTo: portLabel.bottomAnchor, constant: 10),
            copyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            copyButton.widthAnchor.constraint(equalToConstant: 110),
            copyButton.heightAnchor.constraint(equalToConstant: 40),
            
            refreshButton.topAnchor.constraint(equalTo: portLabel.bottomAnchor, constant: 10),
            refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            refreshButton.widthAnchor.constraint(equalToConstant: 110),
            refreshButton.heightAnchor.constraint(equalToConstant: 40),
            
            ghostLabel.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 30),
            ghostLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            ghostSwitch.centerYAnchor.constraint(equalTo: ghostLabel.centerYAnchor),
            ghostSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            teleLabel.topAnchor.constraint(equalTo: ghostLabel.bottomAnchor, constant: 35),
            teleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            teleSwitch.centerYAnchor.constraint(equalTo: teleLabel.centerYAnchor),
            teleSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            allLabel.topAnchor.constraint(equalTo: teleLabel.bottomAnchor, constant: 35),
            allLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            allSwitch.centerYAnchor.constraint(equalTo: allLabel.centerYAnchor),
            allSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func getLocalIP() {
        var address = "0.0.0.0"
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return }
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) {
                let name = String(cString: (interface?.ifa_name)!)
                if name == "en0" || name == "en1" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        serverIP = address
        ipLabel.text = "IP: " + address
        checkServer()
    }
    
    @objc func refreshIP() {
        getLocalIP()
        let alert = UIAlertController(title: "Refreshed", message: "IP updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func copyIP() {
        UIPasteboard.general.string = serverIP
        let alert = UIAlertController(title: "Copied", message: "IP: " + serverIP, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func checkServer() {
        guard let url = URL(string: "http://" + serverIP + ":" + String(serverPort)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 3
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if error == nil && response != nil {
                    self.isConnected = true
                    self.connectLabel.text = "[OK] Connected to server"
                    self.connectLabel.textColor = .systemGreen
                } else {
                    self.isConnected = false
                    self.connectLabel.text = "[X] Server not found"
                    self.connectLabel.textColor = .systemRed
                }
            }
        }
        task.resume()
    }
    
    func startHeartbeat() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.checkServer()
            if self.isConnected {
                self.sendCommand()
            }
        }
    }
    
    @objc func ghostToggled() {
        ghostOn = ghostSwitch.isOn
        if ghostOn { teleSwitch.setOn(false, animated: true); teleOn = false }
        updateStatus()
        sendCommand()
    }
    
    @objc func teleToggled() {
        teleOn = teleSwitch.isOn
        if teleOn { ghostSwitch.setOn(false, animated: true); ghostOn = false }
        updateStatus()
        sendCommand()
    }
    
    @objc func allToggled() {
        allOn = allSwitch.isOn
        if allOn {
            ghostSwitch.setOn(true, animated
