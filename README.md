# ActorPopularity

1- Uygulama çalışmaya başladığında apiRequest() fonksiyonunu çağırıyor, verileri çekiyor.
2- Aktörler popülerliğe göre sıralı bir şekilde tableView'e ekleniyor.
3- Aşağıya doğru scroll yaptıkça apiRequest() tekrar çağırılıyor.
4- Search yaparken yazdığımız text arama butonuna bastıktan sonra query oluşturuyor ve buna göre url oluşturuluyor. Arama sonuçları tableViewde gösteriliyor. Sonuç yoksa labelda "No results" yazıyor.
5- Herhangi bir aktörü tablodan seçtiğimizde bizi başka bir viewController'a (ActorViewController) navigate ediyor.
6- ActorViewController'da aktörün fotoğrafı, ismi ve popülerliği gösteriliyor.
