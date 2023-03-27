//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Наталья Босякова on 27.02.2023.
//

import UIKit
import CoreData
import StorageService
import RealmSwift

class CoreDataManager {
    
    var posts: [PostDB] = []
    var favoritePosts: [FavoritePostDB] = []
    static let sharedManager = CoreDataManager()
    let userName: String = {
        var realm = try! Realm()
        if let autorization = realm.object(ofType: CurrentUserAutorization.self, forPrimaryKey: "currentUserAutorization") {
            return autorization.login
            }
        else {
            return ""
        }
        }()
    
    private init() {
        reloadPosts()
        reloadFavoritePosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Navigation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addPostToFavorite(post: PostDB) {
        
        let newFavoritePost = FavoritePostDB(context: persistentContainer.viewContext)
        newFavoritePost.post = post
        newFavoritePost.user = getUserDB()
        newFavoritePost.dateAdded = Date()
        saveContext()
        reloadFavoritePosts()
        
    }
    
    func deletePostFromFavorite(post: PostDB) {
        
        let fetchRequest = FavoritePostDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "post = %@ and user.name = %@", argumentArray:[post, userName])
        if let results = try? persistentContainer.viewContext.fetch(fetchRequest) {
            for object in results {
                persistentContainer.viewContext.delete(object)
            }
            saveContext()
            reloadFavoritePosts()
        }

    }
    
    func getUserDB()->UserDB? {
        
        let fetchRequest = UserDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name = %@", userName
        )
        do {
            let favoritePost = try persistentContainer.viewContext.fetch(fetchRequest)
            if favoritePost.count > 0 {
                return favoritePost[0]
            }
            else {
                let newUser = UserDB(context: persistentContainer.viewContext)
                newUser.name = userName
                saveContext()
                return newUser
            }
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    func getIsFavorite(post: PostDB)->Bool {
        
        let fetchRequest = FavoritePostDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "post = %@ and user.name = %@", argumentArray:[post, userName])
        if let results = try? persistentContainer.viewContext.fetch(fetchRequest) {
            return results.count > 0
        }
        else {
            return false
        }

    }
    
    private func getPosts() {
        do {
            let fetchRequest = PostDB.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
            let postsFetched = try persistentContainer.viewContext.fetch(fetchRequest)
            posts = postsFetched
        }
        catch {
            posts = []
            print(error.localizedDescription)
        }
    }

    func reloadPosts() {
        
        //createPosts()
        
        getPosts()
        
        if posts.count == 0 {
            createPosts()
        }
    }
    
    func reloadFavoritePosts() {
        
        favoritePosts = getUserDB()!.favoritePostsSorted
        
    }
    
    private func createPosts() {
        
        delete(entityName: "PostDB")
        delete(entityName: "UserDB")
        delete(entityName: "FavoritePostDB")
        saveContext()
        fillPosts()
        getPosts()
        
    }
    
    func delete(entityName: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func fillPosts() {
        
        let authors = ["Alice", "Bob", "Carol", "Dave"]
        let descriptions = [
            "the best day",
            "Vacation 2024. Исследования установили, что даже ожидание отпуска делает человека счастливее и повышает производительность труда. Связано это с тем, что в предвкушении отдыха специалист становится более стрессоустойчивым и собранным. Работа без отпуска накапливает стресс и хроническую усталость.",
            "Dave's party",
            "~ ♡ ~"]
        
        var imageNumber = 0
        
        for index in 0...3 {
            let newPost = PostDB(context: persistentContainer.viewContext)
            newPost.author = authors[index]
            newPost.postDescription = descriptions[index]
            newPost.dateAdded = Date()
            newPost.imageData = UIImage(named: "PostImage"+String(imageNumber))!.pngData()
            imageNumber = imageNumber + 1
            newPost.likes = Int16.random(in: 1...10)
            newPost.views = Int16.random(in: newPost.likes...100)
            saveContext()
        }
    }
}

extension UserDB {
    var favoritePostsSorted: [FavoritePostDB] {
        print("userFavoritePosts.count: \(self.userFavoritePosts!.count)")
        return self.userFavoritePosts?.sortedArray(using: [NSSortDescriptor(key: "dateAdded", ascending: true)]) as? [FavoritePostDB] ?? []
    }
}
