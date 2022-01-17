import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: CustomScrollView(slivers: [
      SliverAppBar(
    shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadiusDirectional.vertical(bottom: Radius.circular(40))),
    pinned: false,
    floating: false,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      background: ClipRRect(
            child: Hero(
              tag: 'mainScreen',
              child: Image.asset(
                KhomeScreenImage,
                fit: BoxFit.fitWidth,
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
      ),
    ),
    expandedHeight: MediaQuery.of(context).size.height * 0.34,
      ),
              SliverList(
                  delegate: SliverChildListDelegate([
                   const Center(
                      child:  Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("أحب محمدا",
                            style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                      ),
                    ),])),
              SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                  (context,index) => Text('$index'),
                childCount: KhomeScreenCardNames.length
              ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),

              )]),
          ),
        ));
  }
}
