// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../global/global.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/tab_screens_controller.dart';

class FavoritesView extends StatefulWidget {
  bool isFavoriteSentClicked = true;
   FavoritesView({super.key, required this.isFavoriteSentClicked});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final TabScreensController controller = Get.put(TabScreensController());

  bool isFavoriteSentClicked = true;
  List<String> favoriteSentList = [];
  List<String> favoriteReceivedList = [];
  List favoritesList = [];

  getFavoriteListKeys() async  {
    if(isFavoriteSentClicked)
    {
      var favoriteSentDocument = await FirebaseFirestore.instance
          .collection("sellers")
          .doc(currentUserID.toString()).collection("favoritesSent")
          .get();

      for(int i=0; i<favoriteSentDocument.docs.length; i++)
      {
        favoriteSentList.add(favoriteSentDocument.docs[i].id);
      }

      print("favoriteSentList = $favoriteSentList");
      getKeysDataFromUsersCollection(favoriteSentList);
    }
    else
    {
      var favoriteReceivedDocument = await FirebaseFirestore.instance
          .collection("sellers")
          .doc(currentUserID.toString()).collection("favorites")
          .get();

      for(int i=0; i<favoriteReceivedDocument.docs.length; i++)
      {
        favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
      }

      print("favoriteReceivedList = $favoriteReceivedList");
      getKeysDataFromUsersCollection(favoriteReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async {
    var allUsersDocument = await FirebaseFirestore.instance.collection("sellers").get();

    for(int i=0; i<allUsersDocument.docs.length; i++)
    {
      for(int k=0; k<keysList.length; k++)
      {
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[k])
        {
          favoritesList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      favoritesList;
    });

    print("favoritesList = $favoritesList");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFavoriteListKeys();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextButton(
                onPressed: ()
                {
                  favoriteSentList.clear();
                  favoriteSentList = [];
                  favoriteReceivedList.clear();
                  favoriteReceivedList = [];
                  favoritesList.clear();
                  favoritesList = [];

                  setState(() {
                    isFavoriteSentClicked = true;
                  });

                  getFavoriteListKeys();
                },
                child: Text(
                  "My Favorites",
                  style: TextStyle(
                    color: isFavoriteSentClicked ? Colors.white : Colors.grey,
                    fontWeight: isFavoriteSentClicked ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),

              const Text(
                "   |   ",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              TextButton(
                onPressed: ()
                {
                  favoriteSentList.clear();
                  favoriteSentList = [];
                  favoriteReceivedList.clear();
                  favoriteReceivedList = [];
                  favoritesList.clear();
                  favoritesList = [];

                  setState(() {
                    isFavoriteSentClicked = false;
                  });

                  getFavoriteListKeys();
                },
                child: Text(
                  "Liked Me",
                  style: TextStyle(
                    color: isFavoriteSentClicked ? Colors.grey : Colors.white,
                    fontWeight: isFavoriteSentClicked ? FontWeight.normal : FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),


            ],
          ),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return favoritesList.isEmpty
        ? const Center(
      child: Icon(Icons.person_off_sharp, color: Colors.white, size: 60,),
    )
        : GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8),
      children: List.generate(favoritesList.length, (index) {
        var eachFavorite = favoritesList[index] as dynamic;
        return GridTile(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              color: Colors.blue.shade200,
              child: GestureDetector(
                onTap: ()
                {

                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(eachFavorite['image']),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Spacer(),

                          //name - age
                          wText(
                            eachFavorite['name'] + ", " ,
                            color: Colors.white,
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          //icon - city - country
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                wText(
                                  eachFavorite['city'] + ", " ,
                                  color: Colors.white,
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  _buildFavorites() {
    return GridView.count(crossAxisCount: 2,
        children: List.generate(
            favoritesList.length, (index) {
              var eachFavorite = favoritesList[index] as dynamic;
          return GridTile(
              child: Padding(padding: EdgeInsets.all(6.0),
                child: Card(
                  color: Colors.blue.shade200,
                  child: GestureDetector(
                    onTap: (){},
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(eachFavorite['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                  ),
                ),
              )
          );
        })
    );
  }

  _buildFavoritesSent() {
    return GridView.count(crossAxisCount: 2,
        children: List.generate(
            favoritesList.length, (index) {
              var eachFavorite = favoritesList[index] as dynamic;
          return GridTile(
              child: Padding(padding: EdgeInsets.all(6.0),
                child: Card(
                  color: Colors.blue.shade200,
                  child: GestureDetector(
                    onTap: (){},
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(eachFavorite['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                  ),
                ),
              )
          );
        })
    );
  }



}
