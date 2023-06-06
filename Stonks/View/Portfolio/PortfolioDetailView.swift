//
//  PortfolioDetailView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers


struct PortfolioDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var asset: PortfolioAsset
    
    @State private var valueToAdd: Double = 1
    @State private var newName: String = ""
    @State private var newWalletString: String = ""
    @State private var isIncreaseDialogPresented = false
    @State private var isDecreaseDialogPresented = false
    @State private var isHistoryExpanded: Bool = false
    @State private var isImportPresented = false
    @State private var isImportAlertPresented = false
    @State private var isImportInfoPresented = false
    @State private var isHistoryPresented = false
    @State private var isDeletePresented = false
    @State private var isRenamePresented = false
    @State private var isCopiedPresented = false
    @State private var isChangeWalletPresented = false
    @AppStorage("currency") private var currency = "eur"
    
    
    private var historyRecords: [PortfolioAssetHistoryRecord]
    
    init(asset: PortfolioAsset) {
        self.asset = asset
        
        let request: NSFetchRequest<PortfolioAssetHistoryRecord> = PortfolioAssetHistoryRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PortfolioAssetHistoryRecord.createdAt, ascending: false)]
        request.predicate = NSPredicate(format: "asset == %@", asset)
        
        historyRecords = try! PersistenceController.shared.container.viewContext.fetch(request)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    Spacer()
                    Text("Amount")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.callout)
                }
                .padding([.top, .horizontal], 30)
                
                HStack {
                    Spacer()
                    Text(asset.amount.formatted())
                        .font(.system(size:60))
                        .fontWeight(Font.Weight.bold)
                }
                .padding([.horizontal], 30)
                HStack {
                    Spacer()
                    Text("Worth")
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .font(.callout)
                }
                .padding([.horizontal], 30)
                
                HStack {
                    Spacer()
                    Text(Double(asset.amount * asset.latestPrice).formatted(.currency(code: currency)))
                        .font(.system(size:40))
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                }
                .padding([.horizontal], 30)
                
                
                if asset.hasWalletString {
                    HStack {
                        Text(asset.walletString!.prefix(5) + "....." + asset.walletString!.suffix(5))
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            
                        Button {
                            UIPasteboard.general.setValue(asset.walletString!, forPasteboardType: UTType.plainText.identifier)
                            
                            isCopiedPresented.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isCopiedPresented.toggle()
                            }
                            
                        } label: {
                            Image(systemName: "clipboard")
                                .fontWeight(.bold)
                        }
                    }
                    .textSelection(.enabled)
                    .padding([.top], 1)
                    .padding([.horizontal], 30)
                    .padding([.bottom], 15)
                }

                HStack {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        self.isIncreaseDialogPresented = true
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 80))
                            .foregroundColor(Color("lightGreen"))
                    }
                    .padding([.leading], 40)
                    .alert("Increase amount", isPresented: $isIncreaseDialogPresented) {
                        TextField("Increase amount", value: $valueToAdd, format: .number)
                        Button("Add", action: {
                            PortfolioManager.shared.updateAssetAmount(asset: asset, value: valueToAdd, date: nil)
                        })
                        Button("Cancel", role: .cancel, action: {})
                    } message: {
                        Text("Please enter value to add.")
                    }
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        self.isDecreaseDialogPresented = true
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 80))
                            .foregroundColor(Color("lightRed"))
                        
                    }
                    .padding([.trailing], 40)
                    .alert("Decrease amount", isPresented: $isDecreaseDialogPresented) {
                        TextField("Decrease amount", value: $valueToAdd, format: .number)
                        Button("Subtract", action: {
                            PortfolioManager.shared.updateAssetAmount(asset: asset, value: -abs(valueToAdd), date: nil)
                        })
                        Button("Cancel", role: .cancel, action: {})
                    } message: {
                        Text("Please enter value to subtract.")
                    }
                }
                .padding([.bottom], 15)
                
                Divider()
                
                DisclosureGroup("History", isExpanded: $isHistoryExpanded.animation()) {
                    VStack {
                        if historyRecords.count == 0 {
                            Text("No records")
                        }
                        ForEach(historyRecords) { record in
                            HStack {
                                Text(record.createdAt?.dateToFormattedDatetime() ?? "" )
                                Spacer()
                                Text(record.value > 0 ? "+\(record.value, specifier: "%.2f")" : "\(record.value, specifier: "%.2f")")
                                    .foregroundColor(record.value > 0 ? .green : .red)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding([.trailing,.leading], 20)
                .alert("Rename asset", isPresented: $isRenamePresented) {
                    TextField("New name", text: $newName)
                    Button("Confirm", action: {
                        PortfolioManager.shared.updateAssetName(asset: asset, name: newName)
                    })
                    Button("Cancel", role: .cancel, action: {})
                } message: {
                    Text("Please enter new name for asset.")
                }
            }
            .alert(isPresented: $isDeletePresented) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("This action will delete \(asset.name ?? "")."),
                    primaryButton: .default(
                        Text("Cancel")
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            viewContext.delete(asset)
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                )
            }
            .alert("Change wallet", isPresented: $isChangeWalletPresented) {
                TextField("Wallet", text: $newWalletString)
                Button("Confirm", action: {
                    if (newWalletString.count >= 32 && newWalletString.count <= 64) {
                        PortfolioManager.shared.updateAssetWallet(asset: asset, walletString: newWalletString)
                    }
                })
                Button("Cancel", role: .cancel, action: {})
            } message: {
                Text("Please enter new wallet for the asset. The wallet must be between 32 and 64 characters.")
            }
            .alert("Warning", isPresented: $isImportInfoPresented, actions: {
                Button("Cancel", role: .cancel, action: {})
                Button("Continue", action: {
                    isImportPresented.toggle()
                })
            }, message: {
                Text("Importing an asset that is already in portfolio will result in overwritting that asset.")
            })
            .alert("Error occured", isPresented: $isImportAlertPresented, actions: {
            }, message: {
                Text("The chosen file could not be parsed. Please, check if the file is in correct format.")
            })
            .fileImporter(isPresented: $isImportPresented, allowedContentTypes: [.commaSeparatedText]) { result in
                switch result {
                case .success(let file):
                    do {
                        let records = try CSVImporter.importHistoryRecords(url: URL(string: file.absoluteString)!)
                        
                        PortfolioManager.shared.writePortfolioAssetHistoryRecordsFromTuples(asset: asset, records: records)
                    } catch _ {
                        isImportAlertPresented.toggle()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(asset.name!)
                        .font(.system(size: 25))
                        .fontWeight(Font.Weight.semibold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        PortfolioManager.shared.toggleFavourite(asset: asset)
                    }) {
                        Image(systemName: asset.isFavourite ? "heart.fill" : "heart")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            isRenamePresented.toggle()
                        }) {
                            Label("Rename asset", systemImage: "pencil")
                        }
                        Button(action: {
                            isImportInfoPresented.toggle()
                        }) {
                            Label("Import from file", systemImage: "tray.and.arrow.down")
                        }
                        Button(action: {
                            isChangeWalletPresented.toggle()
                        }) {
                            Label("Change wallet", systemImage: "wallet.pass")
                        }
                        Divider()
                        Button(role: .destructive, action: {
                            isDeletePresented.toggle()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
            
            if isCopiedPresented {
                VStack {
                    Spacer()
                    Label("Copied to clipboard", systemImage: "clipboard.fill")
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

struct PortfolioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = PortfolioManager.shared.createTestData()
        NavigationView {
            PortfolioDetailView(asset: asset)
        }
    }
}
