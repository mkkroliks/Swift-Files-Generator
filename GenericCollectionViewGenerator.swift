import Foundation
import Files

struct FilesGenerator {
    
    let name, nameCollectionView, nameCollectionViewModel, nameCollectionCellViewModel, nameCollectionViewCell: String
    
    let modelName: String
    
    let folder: Folder
    let collectionViewFile, collectionViewModelFile, collectionCellViewModelFile, collectionCellFile: File
    
    init(screenNameSingularForm: String, modelName: String) throws {
        
        self.modelName = modelName
        
        name = screenNameSingularForm
        nameCollectionView = name + "s" + "CollectionView"
        nameCollectionViewModel = name + "s" + "CollectionViewModel"
        nameCollectionCellViewModel = name + "CellViewModel"
        nameCollectionViewCell = name + "CollectionViewCell"
        
        folder = try FileSystem().currentFolder.createSubfolder(named: name + "s" + "CollectionView")
        collectionViewFile = try folder.createFile(named: nameCollectionView + ".swift")
        collectionViewModelFile = try folder.createFile(named: nameCollectionViewModel + ".swift")
        collectionCellViewModelFile = try folder.createFile(named: nameCollectionCellViewModel + ".swift")
        collectionCellFile = try folder.createFile(named: nameCollectionViewCell + ".swift")
    }
    
    func generate() throws {
        try createCollectionView()
        try createCollectionViewModel()
        try createCollectionCellViewModel()
        try createCollectionCellView()
    }
    
    private func createCollectionView() throws {
        try collectionViewFile.write(string: """
            \(header(for: nameCollectionView))
            
            import UIKit
            import RxSwift
            
            class \(nameCollectionView): GenericCollectionView<\(nameCollectionViewModel), \(nameCollectionViewCell)> {
            
            }
            """)
    }
    
    private func createCollectionViewModel() throws {
        try collectionViewModelFile.write(string: """
            \(header(for: nameCollectionViewModel))
            
            import UIKit
            import RxSwift
            
            class \(nameCollectionViewModel): GenericTableViewModel<\(nameCollectionCellViewModel)> {
            
                override func getItems() -> Observable<[\(modelName)]> {
                    return Observable.just(Mocks.awardsAchieved())
                }
            
                override func mapToItemViewModel(_ item: \(modelName)) -> \(nameCollectionCellViewModel) {
                    return \(nameCollectionCellViewModel)(model: item)
                }
            }
            """)
    }
    
    private func createCollectionCellViewModel() throws  {
        
        try collectionCellViewModelFile.write(string: """
            \(header(for: nameCollectionCellViewModel))
            
            import UIKit
            import RxSwift
            import Stevia
            
            class \(nameCollectionCellViewModel): GenericCellViewModelType {
            
                typealias ItemType = \(modelName)
            
                var model: \(modelName)
            
                init(model: \(modelName)) {
                    self.model = model
                }
            }
            """)
    }
    
    private func createCollectionCellView() throws  {
        try collectionCellFile.write(string: """
            \(header(for: nameCollectionViewCell))
            
            import Foundation
            import RxFlow
            
            class \(nameCollectionViewCell): UICollectionViewCell {
            
                override init(frame: CGRect) {
                    super.init(frame: frame)

                }
            
                required init?(coder aDecoder: NSCoder) { return nil }
            }
            
            extension \(nameCollectionViewCell): Configurable {
            
                func configure(with viewModel: AnyObject) {
                    guard let viewModel = viewModel as? \(nameCollectionCellViewModel) else { return }
            
                }
            }
            """)
    }
    
    private func header(for fileName: String) -> String {
        return  """
        //
        //  \(fileName).swift
        //  DogWalkTrophy
        //
        //  Created by Maciej Krolikowski on 23/04/2018.
        //  Copyright © 2018 Maciej Krolikowski. All rights reserved.
        //
        """
    }
}

let fileGenerator = try FilesGenerator(screenNameSingularForm: "Advertisement", modelName: "Advertisement")
try fileGenerator.generate()


