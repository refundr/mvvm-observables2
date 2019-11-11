import UIKit

class TaxReturnViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    let dataSource = TaxReturnDataSource()
    
    lazy var viewModel : TaxReturnViewModel = {
        return TaxReturnViewModel(service: TaxReturnService.shared, dataSource: dataSource)
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Tax Returns"
        
        configureTableView()
        viewModel.fetchTaxReturns()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Your Tax Returns ...")
        refreshControl.addTarget(self, action: #selector(ellaMethod(_:)), for: .valueChanged)
        
    }
    
    @objc func ellaMethod(_ sender: Any) {
       viewModel.fetchTaxReturns()
        self.refreshControl.endRefreshing()
    }
    
    func configureTableView() {
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        view.addSubview(tableView)
        tableView.pin(to: view)
        
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 44;
        tableView.rowHeight = 50
        tableView.register(TaxReturnCell.self, forCellReuseIdentifier: "TaxReturnCell")
        return tableView
    }()
}


