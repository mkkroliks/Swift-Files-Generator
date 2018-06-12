import Foundation
import Files

extension String {
    func lowercasignFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    mutating func lowerCaseFirstLetter() {
        self = self.lowercasignFirstLetter()
    }
}

struct FilesGenerator {

    let name, nameView, nameViewModel, nameViewController, nameFlowController: String
    var lowerCaseName: String

    let folder: Folder
    let vmFile, vcFile, vFile, fcFile: File

    init(screenName: String) throws {
        name = screenName
//        lowerCaseName = screenName.prefix(1).lowercased() + screenName.dropFirst()
        lowerCaseName = screenName
        lowerCaseName.lowerCaseFirstLetter()
        nameView = name + "MainView"
        nameViewModel = name + "MainViewModel"
        nameViewController = name + "ViewController"
        nameFlowController = name + "Flow"

        folder = try FileSystem().currentFolder.createSubfolder(named: name)
        vmFile = try folder.createFile(named: nameViewModel + ".swift")
        vcFile = try folder.createFile(named: nameViewController + ".swift")
        vFile = try folder.createFile(named: nameView + ".swift")
        fcFile = try folder.createFile(named: nameFlowController + ".swift")
    }

    func generate() throws {
        try createView()
        try createViewModel()
        try createViewController()
        try createFlowController()
    }

    private func createView() throws {
        try vFile.write(string: """
            \(header(for: nameView))

            import UIKit
            import Cartography
            import Stevia

            class \(nameView): BaseView {

                let viewModel: \(nameViewModel)

                init(viewModel: \(nameViewModel)) {
                    self.viewModel = viewModel
                    super.init(frame: .zero)

                    setupViews()
                    setupRx()
                }

                func setupViews() {

                }

                func setupRx() {

                }

                required init?(coder aDecoder: NSCoder) { return nil}
            }
            """)
    }

    private func createViewModel() throws {
        try vmFile.write(string: """
            \(header(for: nameViewModel))

            import Foundation
            import RxSwift
            import RxFlow

            class \(nameViewModel): BaseViewModel, Stepper {

                typealias Services = HasAPIService

                private let services: Services

                init(services: Services) {
                    self.services = services


                }
            }
            """)
    }

    private func createViewController() throws  {

        try vcFile.write(string: """
            \(header(for: nameViewController))

            import UIKit
            import RxSwift

            class \(nameViewController): GenericViewController<\(nameViewModel), \(nameView)>  {

                override func loadView() {
                    mainView = \(nameView)(viewModel: viewModel)
                    view = mainView
                }

                override func viewDidLoad() {
                    super.viewDidLoad()
                }
            }
            """)
    }

    private func createFlowController() throws  {
        try fcFile.write(string: """
            \(header(for: nameFlowController))

            import Foundation
            import RxFlow

            class \(nameFlowController): Flow {

                var root: Presentable {
                    return rootViewController
                }

                private var rootViewController: UINavigationController = UINavigationController()

                private let services: AppServices

                init(withServices services: AppServices) {
                    self.services = services
                }

                func navigate(to step: Step) -> NextFlowItems {

                    guard let step = step as? DemoStep else { return NextFlowItems.none }

                    switch step {
                    case .\(lowerCaseName):
                        return navigationTo\(name)()
                    default:
                        return NextFlowItems.none
                    }
                }

                func navigationTo\(name)() -> NextFlowItems {
                    let vm = \(nameViewModel)(services: services)
                    let vc = \(nameViewController)(viewModel: vm)
                    self.rootViewController.pushViewController(vc, animated: true)
                    return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: vc, nextStepper: vm))
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


let screenName = CommandLine.arguments[1]

let fileGenerator = try FilesGenerator(screenName: screenName)
//let fileGenerator = try FilesGenerator(screenName: "ClubSubscription")
try fileGenerator.generate()
