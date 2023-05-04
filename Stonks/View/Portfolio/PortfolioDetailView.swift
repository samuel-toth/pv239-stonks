//
//  PortfolioDetailView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI
import CoreData

struct PortfolioDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var asset: PortfolioAsset
    
    @State private var valueToAdd: Double = 1
    @State private var newName: String = ""
    @State private var showIncreaseAlert = false
    @State private var showDecreaseAlert = false
    @State private var isHistoryExpanded: Bool = false
    @State private var showHistorySheet = false
    @State private var showDeleteAlert = false
    @State private var showRenameAlert = false


    
    private var historyRecords: [PortfolioAssetHistoryRecord]
    
    init(asset: PortfolioAsset) {
        self.asset = asset
        
        let request: NSFetchRequest<PortfolioAssetHistoryRecord> = PortfolioAssetHistoryRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PortfolioAssetHistoryRecord.createdAt, ascending: false)]
        request.predicate = NSPredicate(format: "asset == %@", asset)
        
        historyRecords = try! PersistenceController.shared.container.viewContext.fetch(request)
    }
    
    var body: some View {
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
                Text(asset.amount.formatted())
                    .font(.system(size:40))
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
            .padding([.bottom, .horizontal], 30)
            
            HStack {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    self.showIncreaseAlert = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 80))
                        .foregroundColor(Color("lightGreen"))
                }
                .padding([.leading], 40)
                .alert("Increase amount", isPresented: $showIncreaseAlert) {
                    TextField("Increase amount", value: $valueToAdd, format: .number)
                    Button("Add", action: {
                        PortfolioManager.shared.updateAssetAmount(asset: asset, value: valueToAdd)
                    })
                    Button("Cancel", role: .cancel, action: {})
                } message: {
                    Text("Please enter value to add.")
                }
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    self.showDecreaseAlert = true
                }) {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 80))
                        .foregroundColor(Color("lightRed"))

                }
                .padding([.trailing], 40)
                .alert("Decrease amount", isPresented: $showDecreaseAlert) {
                    TextField("Decrease amount", value: $valueToAdd, format: .number)
                    Button("Substract", action: {
                        PortfolioManager.shared.updateAssetAmount(asset: asset, value: -valueToAdd)
                    })
                    Button("Cancel", role: .cancel, action: {})
                } message: {
                    Text("Please enter value to substract.")
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
            .alert("Rename asset", isPresented: $showRenameAlert) {
                TextField("New name", text: $newName)
                Button("Confirm", action: {
                    PortfolioManager.shared.updateAssetName(asset: asset, name: newName)
                })
                Button("Cancel", role: .cancel, action: {})
            } message: {
                Text("Please enter new name for asset.")
            }
        }
        .alert(isPresented: $showDeleteAlert) {
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
                        showRenameAlert.toggle()
                    }) {
                        Label("Rename asset", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: {
                        showDeleteAlert.toggle()
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            label: {
                Label("More", systemImage: "ellipsis.circle")
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
