
import 'package:flutter/material.dart';
import 'package:star_wars/themes/textstyle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBarWidget(),

      ],
    );
  }

  Widget appBarWidget(){
    return Row(
      children: [

        GestureDetector(onTap:(){

        },child: Text('Show Site'),
        ),

      ],
    );
  }

  Widget selectCategoryWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap:(){

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Filmes'),
          ),
        ),
        GestureDetector(
          onTap:(){

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Personagens'),
          ),
        ),
        GestureDetector(
          onTap:(){

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Favoritos'),
          ),
        ),
      ],
    );
  }

  Widget listWidget({required String variable}){
    List list = [];
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



