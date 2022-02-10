
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermoji_assets/fluttermojimodel.dart';
import 'package:star_wars/class/favorites.dart';
import 'package:star_wars/functions/sql.dart';
import 'package:star_wars/functions/swapi.dart';
import 'package:star_wars/themes/custom_decoration.dart';
import 'package:star_wars/themes/textstyle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

Color gold = const Color(0xFFC0AA05);

bool chooseAvatar = false; //quando clica no avatar

List<String> myFavorite = []; //lista com favoritos selecionados

List<String> charactersList = []; //lista com todos os personagens provenientes do API SWAPI
List<String> moviesList = [];     //lista com todos os filmes provenientes do API SWAPI

//Tab
late TabController _tabController;
int selectedMenuGlobal = 0; //Selected tab
  //Filmes = 0
  //Personagens = 1
  //favoritos =2
  //site = 3
bool showSite = false;

////////////////////////////////////////////////////////////////////////////
//                               INIT                                     //
////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {

    //GET LOCAL DATA FROM SQLFLITE
    getSQLData();

    //TAB CONTROL
    tabControl();

    //SWAPI: API STAR WARS
    // now get our initial list of SWAPI options
    //Existem 83 personagens na documentação do SWAPI
    for(int i=1;i<84;i++){
      getAPIcharacters(i);
    }
    //Existem 6 filmes na documentação do SWAPI
    for(int i=1;i<7;i++){
      getAPImovies(i);
    }

    super.initState();
  }

  tabControl(){
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      selectedMenuGlobal = _tabController.index;
      setState(() {});
    });

  }
  getAPImovies(int i){
    SWAPI _api = SWAPI();
    _api.getRawDataFromURL('https://swapi.dev/api/films/$i').then( (result) {
      if(result.statusCode == 200){
        //Se a resposta pra url for positiva:
        final name = jsonDecode(result.body)['title'];
        final episodeID = jsonDecode(result.body)['episode_id'];

        moviesList.add('Episode $episodeID: $name');
        setState(() {});
      }
    });
  }
  getAPIcharacters(int i){
    SWAPI _api = SWAPI();
    _api.getRawDataFromURL('https://swapi.dev/api/people/$i').then( (result) {
      if(result.statusCode == 200){

        //Se a resposta pra url for positiva:
        String name = jsonDecode(result.body)['name'].toString();
        name = name.replaceAll('Ã©', 'é'); //nomes com 'é' ficam alterados com o jsonDecode
        charactersList.add(name);
        setState(() {});
      }
    });
  }

  getSQLData() async {
    //Pega lista com todos os favoritos selecionados, salvos no SQL
    List<Favorite> favsList = await Sql().funcFavorites();

    for(var favoriteObject in favsList){
        //adiciona o objeto salvo na lista de favoritos
        myFavorite.add(favoriteObject.name);
    }

  }

////////////////////////////////////////////////////////////////////////////
//                               DISPOSE                                  //
////////////////////////////////////////////////////////////////////////////
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

          //BACKGROUND COM UM FUNDO ESPACIAL
          Image.asset('assets/space.jpg',height: _height,fit: BoxFit.fill),

          Column(
            children: [
              const SizedBox(height: 30),

              appBarWidget(),
              const SizedBox(height: 8),

              showSite
                  ?  Expanded(child: listWidget(selectedMenu: 3)) //SITE
                  :  Expanded(child: Column(
                    children: [
                      tabBarWidget(), //LAYOUT DAS TABS
                      Expanded(child: listSelectedWidget()), //LISTA COM NOMES
                    ],
                  )), //tabs com a lista

            ],
          ),

          //Quando clica em editar o avatar
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

        //SITE OFICIAL
        GestureDetector(
          onTap:() async {
            showSite = !showSite;
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
              boxShadow: customBorderShadow(),
          ),
          child: const Text('Site Oficial',style: EstiloTextoBranco.text20,),
        ),
        ),

        //LOGO STAR WARS
        Expanded(child: Image.asset('assets/star wars.png',height: 40)),

        //AVATAR
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

  //TABS
  Widget tabBarWidget(){
    return Container(
      color: gold.withOpacity(0.2),
      child: TabBar(
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
    );
  }

  //SELEÇÃO DAS TABS
  Widget listSelectedWidget(){
    return TabBarView(
        controller: _tabController,
        children: [
          listWidget(selectedMenu: 0),
          listWidget(selectedMenu: 1),
          listWidget(selectedMenu: 2),
        ]);
  }

  //WIDGET DE SELEÇÃO DAS LISTAS
  Widget listWidget({required int selectedMenu}){
    List list = [];
    if(selectedMenu == 0){
      list = List.from(moviesList);
      list.sort();
    }else if(selectedMenu == 1){
      list = List.from(charactersList);
      list.sort();
    }else if(selectedMenu == 2){
      list = List.from(myFavorite);
      list.sort();
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
      //Se clicou no botão 'SITE OFICIAL'
      return InAppWebView(
        initialUrlRequest : URLRequest(url: Uri.parse('https://www.starwars.com/community')),
      );

    }

  }

  Widget moviesRow({required String name}){
    bool isFavorite = myFavorite.contains(name);
    return GestureDetector(
      onTap:(){
        showSearchSnackbar(name); //pesquisa no google imagens
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        decoration: customBoxDecoration(),
        child: Row(
          children: [

            Expanded(
              child: Text(name,textAlign: TextAlign.center,style: EstiloTextoBranco.text20),
            ),

            GestureDetector(
              onTap: () async {
                if(myFavorite.contains(name)){
                  Favorite fav = Favorite(id: myFavorite.indexOf(name), name: name);
                  Sql().deleteFavorite(fav.id);
                  myFavorite.remove(name);
                }else{
                  myFavorite.add(name);
                  Favorite fav = Favorite(id: myFavorite.indexOf(name), name: name);
                  Sql().insertFavorite(fav);
                }
                //print(await Sql().funcFavorites());
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
    bool isFavorite = myFavorite.contains(name);
    return GestureDetector(
      onTap: (){
        showSearchSnackbar(name); //pesquisa no google imagens
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        decoration: customBoxDecoration(),
        child: Row(
          children: [

            Expanded(
              child: Text(name,textAlign: TextAlign.center,style: EstiloTextoBranco.text34),
            ),

            GestureDetector(
              onTap: (){
                if(myFavorite.contains(name)){
                  Favorite fav = Favorite(id: myFavorite.indexOf(name), name: name);
                  Sql().deleteFavorite(fav.id);
                  myFavorite.remove(name);
                }else{
                  myFavorite.add(name);
                  Favorite fav = Favorite(id: myFavorite.indexOf(name), name: name);
                  Sql().insertFavorite(fav);
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
    bool isMovieFavorite = moviesList.contains(name);

    return GestureDetector(
      onTap: (){
        showSearchSnackbar(name); //pesquisa no google imagens
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

        setState(() {});
      },
      child: Container(
        color: Colors.blue[300],
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
                outerTitleText: 'Customizar:',
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
            initialUrlRequest : URLRequest(url: Uri.parse('https://www.google.com/search?q=$name&sxsrf=APq-WBuhTTCnORTogrteAg85xJPmKcRayA:1644381017165&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiQzpzT5PH1AhWZppUCHbtgDWMQ_AUoBHoECAEQBg&biw=1318&bih=669&dpr=1')),
          ),
        ));
  }

}

