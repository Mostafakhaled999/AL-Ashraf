import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/widgets/grid_card.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        bottom: Radius.circular(40))),
                pinned: false,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipRRect(
                    child: Hero(
                      tag: 'mainScreen',
                      child: Image.asset(
                        kHomeScreenImage,
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
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("أحب محمدا",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                ),
              ])),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => GestureDetector(
                      child: GridCard(
                          cardName: kHomeScreenCardNames[index],
                          cardWidget: Lottie.asset(
                              kAnimatedHomeIconsPath[index].toString(),
                              fit: BoxFit.cover)),
                      onTap: ()=> Navigator.pushNamed(context, kScreenRouteNames[index]),
                    ),
                    childCount: kHomeScreenCardNames.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              )
            ]),
          ),
        ));
  }
}
