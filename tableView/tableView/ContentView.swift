//
//  ContentView.swift
//  tableView
//
//  Created by Alex Wzorek on 27/01/2020.
//  Copyright © 2020 Alex Wzorek. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData

struct ShowActivitiesOnMain: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    //@FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    @FetchRequest(
        entity: Activities.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Activities.activityDate, ascending: true)],
        predicate: NSPredicate(format: "oldDate == %@", NSNumber(value: false))
    ) var notOldDate: FetchedResults<Activities>
    //var activity: Activities
    var body: some View {
        HStack() {
            ScrollView {
                ForEach(notOldDate) { activity in
                    ActivityRow(activity: activity)
                }
            }.frame(alignment: .top)
        }
    }
}

struct ActivityRow: View {
    
    var activity: Activities
    var screenWidth = UIScreen.main.bounds.width
    @State private var draggedOffset: CGSize = .zero
    @State private var ToggleDelete: Bool = false

    var body: some View {
        HStack() {
            if(ToggleDelete == false) {
                ZStack() {
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 1, green: 0.4854032368, blue: 0.3797028929, alpha: 1)))
                        .cornerRadius(8)
                        .frame(width: UIScreen.main.bounds.width-45)
                    HStack() {
                        VStack() {
                            Text("\(getDateString())")
                            .foregroundColor(Color.white)
                            .font(Font.custom("", size: 14))
                            .frame(width: screenWidth-140, alignment: .leading)
                            .padding(.top, 15)
                            Text(activity.activity ?? "No task description given.")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: screenWidth-140, alignment: .leading)
                                .padding(.bottom, 15)
                                .lineLimit(nil)
                        }
                        // Display how many hours the activity is for!
                        Text("\(getTimeString())")
                            .foregroundColor(.white)
                            .frame(alignment: .trailing)
                    }.frame(width: UIScreen.main.bounds.width-30)
                }.padding(.top, 20)
                .offset(x: self.draggedOffset.width)
                .gesture(DragGesture()
                    .onChanged { value in
                        self.draggedOffset = value.translation
                        
                    }
                    .onEnded{ value in
                        self.draggedOffset = CGSize.zero
                        self.ToggleDelete.toggle()
                    }
                )
                .animation(.interactiveSpring())
            } else {
                HStack() {
                    ZStack() {
                        Rectangle()
                            .fill(Color(#colorLiteral(red: 1, green: 0.4854032368, blue: 0.3797028929, alpha: 1)))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width/3)
                        HStack() {
                                VStack() {
                                    Text("\(getDateString())")
                                    .foregroundColor(Color.white)
                                    .font(Font.custom("", size: 14))
                                        .frame(width: screenWidth-140, alignment: .leading)
                                    .padding(.top, 15)
                                    Text(activity.activity ?? "No task description given.")
                                        .foregroundColor(.white)
                                        .bold()
                                        .frame(width: screenWidth-140, alignment: .leading)
                                        .padding(.bottom, 15)
                                        .lineLimit(nil)
                                }
                                // Display how many hours the activity is for!
                                Text("\(getTimeString())")
                                    .foregroundColor(.white)
                                    .frame(alignment: .trailing)
                            }.frame(width: UIScreen.main.bounds.width-30)
                        }.padding(.top, 20)
                        .frame(alignment: .leading)
                        .offset(x: self.draggedOffset.width)
                        .gesture(DragGesture()
                            .onChanged { value in
                                self.draggedOffset = value.translation
                                
                            }
                            .onEnded{ value in
                                self.draggedOffset = CGSize.zero
                                self.ToggleDelete.toggle()
                            }
                        )
                        .animation(.interactiveSpring())
                    ZStack() {
                        Rectangle()
                            .fill(Color(#colorLiteral(red: 1, green: 0.1165440292, blue: 0.255184394, alpha: 1)))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
                    }
                    }
                /*
                HStack() {
                    ZStack() {
                        Rectangle()
                            .fill(Color(#colorLiteral(red: 1, green: 0.4854032368, blue: 0.3797028929, alpha: 1)))
                            .cornerRadius(8)
                            .frame(width: UIScreen.main.bounds.width-45)
                        HStack() {
                            VStack() {
                                Text("\(getDateString())")
                                .foregroundColor(Color.white)
                                .font(Font.custom("", size: 14))
                                    .frame(width: screenWidth-140, alignment: .leading)
                                .padding(.top, 15)
                                Text(activity.activity ?? "No task description given.")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(width: screenWidth-140, alignment: .leading)
                                    .padding(.bottom, 15)
                                    .lineLimit(nil)
                            }
                            // Display how many hours the activity is for!
                            Text("\(getTimeString())")
                                .foregroundColor(.white)
                                .frame(alignment: .trailing)
                        }.frame(width: UIScreen.main.bounds.width-30)
                    }.padding(.top, 20)
                    .frame(alignment: .leading)
                    .offset(x: self.draggedOffset.width)
                    .gesture(DragGesture()
                        .onChanged { value in
                            self.draggedOffset = value.translation
                            
                        }
                        .onEnded{ value in
                            self.draggedOffset = CGSize.zero
                            self.ToggleDelete.toggle()
                        }
                    )
                    .animation(.interactiveSpring())
                } */
            }
        }
    }
    func getTimeString() -> String {
        var timeString: String = ""
        let getActivityTime = activity.activityTime
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        timeString = formatter.string(from: getActivityTime!)
        
        return timeString
    }
    func getDateString() -> String {
        var dateString: String = ""
        let getActivityDate = activity.activityDate
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        dateString = formatter.string(from: getActivityDate!)
        
        return dateString
    }
}

struct TaskRow: View {
    var task: Task
    @State private var draggedOffset: CGSize = .zero
    @State private var ShowDelete = false
    @State private var ToggleDelete = false
    var checkOffset: Bool = false

    
    var body: some View {
        HStack() {
            if(ToggleDelete == false) {
                Text(task.task ?? "No task description given.")
                    .font(Font.custom("Comfortaa-Light", size: 15))
                    .foregroundColor(.black)
                    .padding(10)
                    .offset(x: self.draggedOffset.width)
                    .gesture(DragGesture()
                        .onChanged { value in
                            self.draggedOffset = value.translation
                            
                        }
                        .onEnded{ value in
                            self.draggedOffset = CGSize.zero
                            self.ToggleDelete.toggle()
                            /*
                            if(value.translation.width > -50) {
                                toggleDelete = true
                            } else {
                                print("This is a tricky one")
                            }*/
                        }
                    )
                    .animation(.interactiveSpring())
            } else {
                
                Text(task.task ?? "No task description given.")
                    .foregroundColor(.black)
                    .padding(10)
                    .offset(x: self.draggedOffset.width)
                    .gesture(DragGesture()
                        .onChanged { value in
                            self.draggedOffset = value.translation
                            
                        }
                        .onEnded{ value in
                            self.draggedOffset = CGSize.zero
                            self.ToggleDelete.toggle()
                        }
                )
                .animation(.interactiveSpring())
                Button(action: {
                    print("It worked")
                }) {
                    Text("Delete")
                        //.bold()
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(5)
                }.frame(width: 80, height: 40, alignment: .trailing)
                
            }
        }.frame(width: UIScreen.main.bounds.width-20, alignment: .leading)
            .padding(.leading, 20)
            .padding(.trailing, 30)
    }
}

struct ShowTasksOnMain: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    //@FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false))
    ) var notCompletedTasks: FetchedResults<Task>
    
    @State public var getTaskAmount: Int = 0
    
    var body: some View {
        HStack() {
            ScrollView() {
                VStack() {
                    /*
                    Text("Tasks:")
                        .bold()
                        .underline()
                        .frame(width: 350, alignment: .leading)
                        .padding(.bottom, 5)
                    */
                    // Gets variable notCompletedTasks from task class
                    ForEach(notCompletedTasks){ task in
                        Button(action: {
                            // Updates the class
                            self.getTaskAmount = self.getTaskAmount - 1
                            self.updateTask(task)
                        }) {
                            TaskRow(task: task)
                        }
                    }.frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                }
                Divider()
            }.padding(.top, 10)
            .frame(alignment: .top)
        }
    }
    
    func updateTask(_ task: Task) {
        let isComplete = true
        let taskID = task.id! as NSUUID
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskID as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            let test = try managedObjectContext.fetch(fetchRequest)
            let taskUpdate = test[0] as! NSManagedObject
            taskUpdate.setValue(isComplete, forKey: "isComplete")
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
}

struct ShowCompletedTasks: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: true))
    ) var completedTasks: FetchedResults<Task>
    
    @State private var draggedOffset: CGSize = .zero
    
    var body: some View {
        Section {
            ScrollView() {
                Divider()
                VStack {
                    ForEach(completedTasks) { task in
                        // Gets variable notCompletedTasks from task class
                        Button(action: {
                            self.updateTask(task)
                        }) {
                            TaskRow(task: task)
                            
                        }
                    }.frame(width: UIScreen.main.bounds.width, alignment: .leading)
                }
                
                Divider()
            }.padding(.top, 10)
            .frame(alignment: .top)
            /*VStack {
                Text("Completed task 1")
                    .padding(5)
                Text("Completed task 1")
                    .padding(5)
                Text("Completed task 1")
                    .padding(5)
            }.padding(30)*/
        }.background(Color.white)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .topLeading)
    }
    
    func updateTask(_ task: Task) {
        let isComplete = false
        let taskID = task.id! as NSUUID
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskID as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            let test = try managedObjectContext.fetch(fetchRequest)
            let taskUpdate = test[0] as! NSManagedObject
            taskUpdate.setValue(isComplete, forKey: "isComplete")
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    /*func deleteTask() {
        
    }*/
}

struct ContentView: View {
    var animation: Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(2)
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    //@FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: false))
    ) var notCompletedTasks: FetchedResults<Task>
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: true))
    ) var completedTasks: FetchedResults<Task>
    
    @FetchRequest(
        entity: Activities.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Activities.activityDate, ascending: false)],
        predicate: NSPredicate(format: "oldDate == %@", NSNumber(value: false))
    ) var notOldDate: FetchedResults<Activities>
    
    let defaults = UserDefaults.standard
    
    @State var addTasks: Int = 0
    @State private var showDetail: Bool = false
    @State private var showModal: Bool = false
    @State private var showSecondModal: Bool = false
    @State private var longer: Bool = false
    @State var screenWidth = UIScreen.main.bounds.size.width
    @State var pickerSelectedItem = 0
    var check: Bool = true
    
    @State public var getTaskAmount: Int = 0
    
    var body: some View {
        //Color(#colorLiteral(red: 0.9885081649, green: 0.6925138937, blue: 0.3447500459, alpha: 1)).edgesIgnoringSafeArea(.all)
        NavigationView {
            // SECTION -> Shows under title, completed tasks + Drop down
            Section {
                VStack() {
                    Divider().padding(5)
                        HStack() {
                            
                            // Completed Tasks text + getting how many are completed
                            Text("Completed Tasks (" + String(getCompletedTasks()) + ")")
                                .frame(width: screenWidth-80, height: 40, alignment: .leading)
                                .font(Font.custom("Comfortaa-Light", size: 17))
                            // Button adds 'icon' to drop down completed tasks
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.showDetail.toggle()
                                }
                            }) {
                                // 'Icon' image, rotates on click to show completed tasks
                                Image("icon")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .trailing)
                                    .rotationEffect(.degrees(showDetail ? 180 : 0))
                                    .animation(.easeInOut)
                            }.padding(.trailing, 20)
                            
                        }.frame(alignment: .top)
                    
                        if(showDetail) {
                            ShowCompletedTasks()
                                //.transition(.move(edge: .top))
                                //.opacity(showDetail ? 1: 0)
                        }
                    Divider()
                    Spacer()
                }
         
            }// Call the title of the page
            // Second Section tries to see if there is any data, if none dispalys text plus image
            Section {
                VStack {
                    
                    // If drop down completed tasks is true:
                    if(showDetail){
                    } else {
                        Spacer()
                        ZStack() {
                            Picker(selection: $pickerSelectedItem, label: Text("")){
                                Text("Activities").tag(0)
                                Text("Tasks").tag(1)
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal, 24)
                                .frame(alignment: .top)
                                .padding(.top, 80)
                        }
                        // See if picker is selected on tasks or activities, 1 is tasks, 0 is activities
                        if(pickerSelectedItem == 1) {
                            if(getRecordsCountForTasks() == 0) {
                                VStack() {
                                    NodataView()
                                }
                            } else {
                                ShowTasksOnMain()
                            }
                        } else {
                            
                            if(getRecordCountForActivities() == 0) {
                                VStack() {
                                    NodataView()
                                }
                            } else {
                                ShowActivitiesOnMain()
                            }
 
                            // For activities:
                            // Get date the user enters
                            // If the date is before the date today, do not display!
                            // If the date is after the date today, display!
                        }
                    }
                    /*
                    if (getRecordsCountForTasks() == 0) {
                        // No Data View shows image and text data when there is no records in the count
                        if (showDetail) {
                        } else {
                            VStack() {
                            NodataView()
                                .offset(y: self.getRecordsCountForTasks() == 0 ? -UIScreen.main.bounds.height/10 : -UIScreen.main.bounds.height)
                                .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10, initialVelocity: 0))
                            }
                        }
                    // Else try to receive data thats been added
                    } else {
                        if(showDetail) {
                        } else {
                            Section {
/* !!!!!!!!!!!!!!!!!!WRITE ABOUT THIS!!!!!!!!!!!!!!!!!!!!!!
                                Spacer()
                                Picker(selection: $pickerSelectedItem, label: Text("")){
                                    Text("Tasks").tag(0)
                                    Text("Activities").tag(1)
                                }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.horizontal, 24)
                                    .frame(alignment: .top)
                                    .padding(.top, 80)
 *///!!!!!!!!!!!!!!!!WRITE ABOUT THIS!!!!!!!!!!!!!!!!!!!!!!
                                Section {
                                    //Display tasks....
                                    if(pickerSelectedItem == 0) {
                                        ActivityRow()
                                    } else {
                                        ShowTasksOnMain()
                                    }
                                }
                                
                            }
                        }
                    }*/
                }.frame(width: 30, height: 30, alignment: .center)
                
            }
            
            /* Display activities!!!
            Section {
                VStack() {
                    Text("Activities:")
                }
            }*/
            // Section used for adding button at the bottom of page to add tasks and activities
            Section {
                HStack() {
                    Button(action: {
                        //self.testingDeleteAllTasks()
                        self.showModal.toggle()
                    }) {
                        // Button for adding a task -> TASK
                        HStack() {
                            Image(systemName: "plus")
                                .font(.title)
                                .rotationEffect(.degrees(showModal ? -180 : 0))
                                .animation(.easeInOut)
                            Text("Task")
                                .bold()
                                .padding(.leading, 10)
                        }
                        .padding()
                        .padding(.trailing, 20)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(50)
                        
                        
                    }.padding(.trailing, 5)
                    //Adding a modal page!
                    .sheet(isPresented: self.$showModal) {
                        ModalViewTasks().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                    // Button for adding an activity -> ACTIVITY
                    Button(action: {
                        //self.testingDeleteAllTasks()
                        //self.testingDeleteAllActivities()
                        self.suggestiveRevision()
                        self.showSecondModal.toggle()
                    }) {
                        HStack() {
                            Image(systemName: "plus")
                                .font(.title)
                                .rotationEffect(.degrees(showSecondModal ? -180 : 0))
                                .animation(.easeInOut)
                            Text("Activity")
                                .bold()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(50)
                    }.sheet(isPresented: self.$showSecondModal) {
                        ModalViewActivity().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }.frame(alignment: .bottom)
                
            }
                .navigationBarTitle("DAYS")
                
        }
        
    }
    
    public func suggestiveRevision() {
        // Get only time
        let fetchRequest = NSFetchRequest<Activities>(entityName: "Activities")
        fetchRequest.predicate = NSPredicate(format: "activityTime == %@")
        
        do {
            let fetchActivities = try managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for item in fetchActivities {
                print((item as AnyObject).value(forKey: "activityDate")!)
            }
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    public func testingDeleteAllTasks() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedObjectContext.execute(batchDeleteRequest)

        } catch {
            print(error)
        }
    }
    
    public func testingDeleteAllActivities() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activities")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            print(error)
        }
    }
    
    public func getCompletedTasks() -> Int {
        var count: Int = 0
        completedTasks.forEach {_ in
            count = count + 1
        }
        print("Completed tasks: " + String(count))
        return count
    }
    /*
    func updateTask(_ task: Task) {
        let isComplete = true
        let taskID = task.id! as NSUUID
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskID as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            let test = try managedObjectContext.fetch(fetchRequest)
            let taskUpdate = test[0] as! NSManagedObject
            taskUpdate.setValue(isComplete, forKey: "isComplete")
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }*/
    
    func getRecordsCountForTasks() -> Int{
        
        var count: Int = 0
        notCompletedTasks.forEach {_ in
            count = count + 1
        }
        print("Not Completed Tasks: " + String(count))
        return count
    }
    
    func getRecordCountForActivities() -> Int {
        var count: Int = 0
        notOldDate.forEach {_ in
            count = count + 1
        }
        print("Not old activities: " + String(count))
        return count
        
    }
}

struct ModalViewTasks: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var continueBtn: Bool = false
    @State private var taskName: String = ""
    
    var body: some View {
        NavigationView {
            Section {
                VStack() {
                    Text("Add some tasks!")
                        .font(.headline)
                        .bold()
                    Text("It all saves.")
                }.frame(alignment: .top)
            }
            // Section for bottom finish button!
            Section {
                VStack(){
                    TextField("Enter task: ",text: $taskName)
                    Button(action: {
                        let saveTask = Task(context: self.managedObjectContext)
                        saveTask.task = self.taskName
                        saveTask.date = Date()
                        saveTask.id = UUID()
                        saveTask.isComplete = false
                        do {
                            
                            try self.managedObjectContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        self.continueBtn.toggle()
                    }) {
                    Text("Continue")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                    }
                }.frame(alignment: .bottom)
            }.padding(.bottom, 10)
            
        }
    }

}

struct ModalViewActivity: View {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var continueBtnTwo: Bool = false
    @State private var activityName: String = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var btnSubmit: Bool = false
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField("Activity:", text: $activityName)
                Section(header: Text("Date and time")) {
                    DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .date){
                        Text("Activity Date: ")
                    }
                    DatePicker(selection: $selectedTime, displayedComponents: .hourAndMinute) {
                        Text("Activity Time: ")
                    }
                }
                Button(action: {
                    let saveActivity = Activities(context: self.managedObjectContext)
                    saveActivity.activity = self.activityName
                    saveActivity.activityDate = self.selectedDate
                    saveActivity.activityTime = self.selectedTime
                    saveActivity.activityId = UUID()
                    saveActivity.oldDate = false
                    do {
                        
                        try self.managedObjectContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                    self.continueBtnTwo.toggle()
                }) {
                    Text("Submit")
                }
            }.navigationBarTitle("Add Activity")
        }.padding(.bottom, 10)
            /*
            VStack() {
                DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .date) {
                    Text("")
                }.padding(30)
                    .frame(width: UIScreen.main.bounds.width-160, height: 40)
                Text("Selected Date is \(selectedDate, formatter: dateFormatter)")
            }
            VStack() {
                TextField("Activity:", text: $activityName)
                Button(action: {
                    let saveActivity = Activities(context: self.managedObjectContext)
                    saveActivity.activity = self.activityName
                    saveActivity.activityDate = Date()
                    saveActivity.activityId = UUID()
                    saveActivity.oldDate = false
                    do {
                        
                        try self.managedObjectContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                    self.continueBtnTwo.toggle()
                }) {
                    Text("Continue")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                }
            }.frame(alignment: .bottom) */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
