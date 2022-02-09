
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:star_wars/functions/class.dart';
import 'package:star_wars/functions/global.dart';
import 'package:star_wars/functions/sql.dart';
import 'package:star_wars/themes/textstyle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

Color gold = Color(0xFFC0AA05);
int selectedMenuGlobal = 0;
bool showSite = false;
bool chooseAvatar = false;

List<String> favoriteMovie = [];
List<String> favoriteCharacter= [];
//Tab
late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      selectedMenuGlobal = _tabController.index;setState(() {

      });
    });
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
////////////////////////////////////////////////////////////////////////////
//                               BUILD                                    //
////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [

          Image.asset('assets/space.jpg',height: _height,fit: BoxFit.fill),

          Column(
            children: [

              const SizedBox(height: 30),

              appBarWidget(),

              const SizedBox(height: 8),

              showSite
                  ? Expanded(child: listWidget(selectedMenu: 3))
                  :  Expanded(
                    child: Column(
                      children: [

                        TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15.0,
                              ),
                              color: selectedMenuGlobal<=2 ? gold : Colors.transparent,
                            ),
                            tabs: const [
                              Tab(text: 'Filmes'),
                              Tab(text: 'Personagens'),
                              Tab(text: 'Favoritos'),
                            ]),

                        Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            listWidget(selectedMenu: 0),
                            listWidget(selectedMenu: 1),
                            listWidget(selectedMenu: 2),
                          ]),
              ),
                      ],
                    ),
                  ),

            ],
          ),
          chooseAvatar ? chooseAvatarWidget() : Container(),
        ],
      ),

    );
  }
////////////////////////////////////////////////////////////////////////////
//                               WIDGETS                                  //
////////////////////////////////////////////////////////////////////////////
  Widget appBarWidget(){
    return Row(
      children: [

        GestureDetector(
          onTap:() async {
            //showSite = !showSite;
            Sql.instance.update(const Favorites(name: 'oi'));
            List<Favorites> favs = [];
            favs = await Sql.instance.readAllFavorites();
            print(favs);
            setState(() {});
        },child:
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: showSite ? gold : Colors.black26,
              border: Border.all(
                width: 2.0,
                color: gold,
              ),
              boxShadow: [
                BoxShadow(
                  color: gold,
                  blurRadius: 8.0,
                  blurStyle: BlurStyle.outer
                ),
              ],
          ),
          child: const Text('Show Site',style: EstiloTextoBranco.text20,),
        ),
        ),

        Expanded(child: Image.asset('assets/star wars.png',height: 40)),


        GestureDetector(
          onTap: (){
            chooseAvatar = true;
            setState(() {});
          },child: CircleAvatar(
          backgroundColor: gold,
            radius: 33,
            child: FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 30,
        ),
          ),
        )
      ],
    );
  }

  Widget listWidget({required int selectedMenu}){
    List list = [];
    if(selectedMenu == 0){
      list = Global().moviesStarWars;
      list.sort();
    }else if(selectedMenu == 1){
      list = Global().charactersStarWars;
      list.sort();
    }else{
      List tempListMovies = List.from(favoriteMovie);
      tempListMovies.sort();
      List tempListCharacters = List.from(favoriteCharacter);
      tempListCharacters.sort();
      list = tempListMovies + tempListCharacters;
    }

    if(selectedMenu<=2) {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {

            if(selectedMenu==0) {
              return moviesRow(name: list[index]);
            }else if(selectedMenu==1) {
              return charactersRow(name: list[index]);
            }else{
              return favoritesRow(name: list[index]);
            }

          }
      );
    }else{

      return InAppWebView(
        initialUrlRequest : URLRequest(url: Uri.parse('https://www.starwars.com/community')),
      );

    }

  }


  Widget moviesRow({required String name}){
    bool isFavorite = favoriteMovie.contains(name);
    return GestureDetector(
      onTap:(){
        showSearchSnackbar(name);
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            width: 2.0,
            color: gold,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          boxShadow: customBorderShadow(),
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(name,textAlign: TextAlign.center,style: EstiloTextoBranco.text20),
            ),

            GestureDetector(
              onTap: (){
                if(favoriteMovie.contains(name)){
                  favoriteMovie.remove(name);
                }else{
                  favoriteMovie.add(name);
                }
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.favorite,size:40,color: isFavorite ? Colors.red : Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget charactersRow({required String name}){
    bool isFavorite = favoriteCharacter.contains(name);
    return GestureDetector(
      onTap: (){
        showSearchSnackbar(name);
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            width: 2.0,
            color: gold,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          boxShadow: customBorderShadow(),
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(name,textAlign: TextAlign.center,style: EstiloTextoBranco.text34),
            ),

            GestureDetector(
              onTap: (){
                if(favoriteCharacter.contains(name)){
                  favoriteCharacter.remove(name);
                }else{
                  favoriteCharacter.add(name);
                }
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.favorite,size:40,color: isFavorite ? Colors.red : Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget favoritesRow({required String name}) {
    bool isMovieFavorite = favoriteMovie.contains(name);

    return GestureDetector(
      onTap: (){
        showSearchSnackbar(name);
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            width: 4.0,
            color: isMovieFavorite ? Colors.red : Colors.green,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(name, textAlign: TextAlign.center,
                  style: EstiloTextoBranco.text20),
            ),

          ],
        ),
      ),
    );
  }

  Widget chooseAvatarWidget(){
    return GestureDetector(
      onTap: () async {
        chooseAvatar=false;
        String get = await FluttermojiFunctions().encodeMySVGtoString();
        setState(() {});
      },
      child: Container(
        color: Colors.black38,
        child: Column(
          children: [
            const Spacer(),
            FluttermojiCircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 100,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: FluttermojiCustomizer(
                // showSaveWidget: true,
              ),
            ),
          ],
        ),
      ),
    );
  }


  showSearchSnackbar(String name){
    final snackBar = snackBarUrl(name);
// Encontra o Scaffold na árvore de Widgets e o usa para exibir o SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  SnackBar snackBarUrl(String name){
    return SnackBar(
        duration: const Duration(minutes: 5),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: (){},
        ),
        content:
        SizedBox(
          height: 500,
          child: InAppWebView(
            initialUrlRequest : URLRequest(url: Uri.parse('https://www.google.com/search?q=${name}&sxsrf=APq-WBuhTTCnORTogrteAg85xJPmKcRayA:1644381017165&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiQzpzT5PH1AhWZppUCHbtgDWMQ_AUoBHoECAEQBg&biw=1318&bih=669&dpr=1')),
          ),
        ));
  }
  List<BoxShadow> customBorderShadow(){
    return [BoxShadow(
        color: gold,
        blurRadius: 10.0,
        blurStyle: BlurStyle.outer
    )];
  }
}

