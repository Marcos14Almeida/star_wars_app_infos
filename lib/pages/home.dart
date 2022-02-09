
import 'package:flutter/material.dart';
import 'package:star_wars/functions/global.dart';
import 'package:star_wars/themes/textstyle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

int selectedMenu = 0;

////////////////////////////////////////////////////////////////////////////
//                               BUILD                                    //
////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        appBarWidget(),

        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          selectCategoryWidget(name: 'Filmes', value: 0),
          selectCategoryWidget(name: 'Personagens', value: 1),
          selectCategoryWidget(name: 'Favoritos', value: 2),
        ],
        ),

        listWidget(selectedMenu: selectedMenu),
      ],
    );
  }

////////////////////////////////////////////////////////////////////////////
//                               WIDGETS                                  //
////////////////////////////////////////////////////////////////////////////
  Widget appBarWidget(){
    return Row(
      children: [

        GestureDetector(onTap:(){

        },child: Text('Show Site'),
        ),

        const Spacer(),

        GestureDetector(
          onTap: (){

          },child: CircleAvatar(radius: 30),
        )
      ],
    );
  }

  Widget selectCategoryWidget({required String name, required int value}){
    return
        GestureDetector(
            onTap:(){
              selectedMenu = value;
              setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name,style: EstiloTextoPreto.text22),
          ),
        );

  }

  Widget listWidget({required int selectedMenu}){
    List list = [];
    if(selectedMenu == 0){
      list = Global().moviesStarWars;
    }else if(selectedMenu == 1){
      list = Global().charactersStarWars;
    }else{
      list = [];
    }

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context,int index){
          return moviesRow(name: list[index]);
        }
    );

  }


  Widget moviesRow({required String name}){
    bool isFavorite = false;
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Colors.purple,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Row(
        children: [

          Flexible(
            flex: 80,
            child: Text(name,textAlign: TextAlign.center,style: EstiloTextoBranco.text20),
          ),

          Flexible(
            flex: 20,
            child: Icon(Icons.favorite,color: isFavorite ? Colors.red : Colors.white),
          ),

        ],
      ),
    );
  }

  Widget charactersRow(){
    bool isFavorite = false;
    return Row(
      children: [

        Flexible(
          flex: 20,
          child: Icon(Icons.favorite,color: isFavorite ? Colors.red : Colors.white),
        ),
      ],
    );
  }

}



