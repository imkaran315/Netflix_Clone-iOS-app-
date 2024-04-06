
import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidSelect(with title: String, viewModel: TitlePreviewVM)
}

class CollectionViewTableViewCell: UITableViewCell{
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Public Methods
    
    func configure(with titles: [Movie]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func saveTitleAt(indexPath :IndexPath){
        
        DataPersistenceManager.shared.saveTitleinLibrary(model: titles[indexPath.row]) { result in
            switch result{
            case.success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case.failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
     private func playTitleAt(indexPath: IndexPath){
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? title.original_name ?? ""

        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let ytTitle):
                
                let viewModel = TitlePreviewVM(Video: ytTitle, title: titleName, titleOverview: title.overview)
                self.delegate?.collectionViewTableViewCellDidSelect(with: titleName, viewModel: viewModel)
            case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
extension CollectionViewTableViewCell :  UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return titles.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
                return UICollectionViewCell()
            }

            guard let posterPath = titles[indexPath.row].poster_path else {
                return UICollectionViewCell()
            }

            cell.configure(with: posterPath)
            return cell
        }
            
            // on selecting the title
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.playTitleAt(indexPath: indexPath)
        }
        
            // on tapping and holding the tile, the menu opens
        func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
            
            let config = UIContextMenuConfiguration( identifier: nil, previewProvider: nil) { _ in
                
                let playButton = UIAction(title: "Play"){ _ in
                    self.playTitleAt(indexPath: indexPaths[0])
                }
                
                let saveButton = UIAction(title: "Save") { _ in
                    self.saveTitleAt(indexPath: indexPaths[0])
                }
                
                
                return UIMenu(children: [playButton, saveButton])
                
            }
            return config
        }
    }
    
    
extension CollectionViewTableViewCell: TitlePreviewVCDelegate{
    func TitlePreviewSaveToLibrary(model: Movie) {
//        saveTitleAt(indexPath: Mo)
    }
    
    
}
    
