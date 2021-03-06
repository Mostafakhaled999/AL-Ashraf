import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:al_ashraf/widgets/cards.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    if(mounted)
      {
        //showDialog(context: Get.context!, builder: (context)=>AlertDialog(title: Text('asdsadasd'),));
      }

    super.initState();
  }
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
                        kHomeScreenImgPath,
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
                    child: Text("?????? ??????????",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                ),
              ])),
              CardGridList(
                gridCardNames: kHomeScreenCardNames,
                gridCardImages: (index) => Lottie.asset(
                    kAnimatedHomeImgsPath[index],
                    fit: BoxFit.cover),
                onPress: (index) =>
                    Navigator.pushNamed(context, kHomeScreenRouteNames[index]),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 10,)
                  ])),
              SliverGrid(
                delegate: SliverChildListDelegate([
                  ExtraHomeScreenCards.shareAppCard(),
                  ExtraHomeScreenCards.rateAppCard(),
                ]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),

            ]),
          ),
        ));
  }
}
