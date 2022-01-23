import 'package:al_ashraf/constants/constants.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom:15.0),
      child: Container(

        height: 39,
        margin: EdgeInsets.only(left: 25, right: 25, top: 18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
        child: Stack(
          children: <Widget>[
            TextField(
              //enabled: false,
              readOnly: true,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.only(left: 19, right: 55, bottom: 8),
                  border: InputBorder.none,
                  hintText: 'بحث ..',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600)),
              onTap: () {

                // showSearch(
                //   context: context,
                //   delegate: SearchBar(diwanOrNathr: 'diwan'),
                // );
              },
            ),
            Positioned(
              right: 0,
              child:Image(image: AssetImage(kBackGroundSrchBarImgPath),
                color: Colors.green[400],
              ),
            ),
            Positioned(
              top: 8,
              right: 9,
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
