// ignore_for_file: prefer_const_constructors

import 'package:assignment/commonWidgets/header.dart';
import 'package:assignment/model/astrologer_model.dart';
import 'package:assignment/service/astrologer_provider.dart';
import 'package:assignment/view/filterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AstrologyScreen extends StatefulWidget {
  const AstrologyScreen({Key? key}) : super(key: key);

  @override
  State<AstrologyScreen> createState() => _AstrologyScreenState();
}

class _AstrologyScreenState extends State<AstrologyScreen> {
  Menu selected = Menu.EHTL;
  late Size size;
  bool _showSearchBar = true;
  final textController = TextEditingController();
  final focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _loadAstrologers();
    });
    super.initState();
  }

  _loadAstrologers() {
    Provider.of<AstrologerProvider>(context, listen: false).getAstrologers();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Column(
      children: [
         SizedBox(height: size.height * 0.02),
        _topBar(),
        SizedBox(height: size.height * 0.02),
        _buildHeader(),
        _showSearchBar ? _buildSearchBar() : Container(),
        _buildList()
      ],
    );
  }

  _topBar() {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
      child:Header()
    );
  }

  _buildList() {
    return Expanded(child:
        Consumer<AstrologerProvider>(builder: (context, provider, child) {
      return ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: provider.datalist.length,
          itemBuilder: (context, i) {
            return _details(provider.datalist[i]);
          });
    }));
  }

  _details(Data data) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageColumn(data.images.large?.imageUrl ?? ""),
                SizedBox(width: size.width * 0.03),
                _infoColumn(data),
                const Spacer(),
                // Expanded(child:Spacer()),
                _expColumn(data)
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  _imageColumn(String url) {
    return CachedNetworkImage(
      width: size.width * 0.25,
      imageUrl: url,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          Icon(Icons.person, size: size.height * 0.1),
    );
  }

  _infoColumn(Data data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${data.firstName} ${data.lastName}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.home_outlined,
              color: Colors.orange,
              size: size.width * 0.03,
            ),
            SizedBox(width: size.width * 0.02),
            Container(width: size.width * 0.4, child: Text(getSkills(data)))
          ],
        ),
        //SizedBox(height:size.height*0.01),
        Row(
          children: [
            Icon(
              Icons.language,
              color: Colors.orange,
              size: size.width * 0.03,
            ),
            SizedBox(width: size.width * 0.02),
            Text(getLanguages(data))
          ],
        ),
        //SizedBox(height:size.height*0.01),
        Row(
          children: [
            Icon(
              Icons.attach_money,
              color: Colors.orange,
              size: size.width * 0.03,
            ),
            SizedBox(width: size.width * 0.01),
            Text("${data.minimumCallDurationCharges.toInt()}/Min",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: size.height * 0.016),
        Padding(
          padding: EdgeInsets.only(left: size.width * 0.04),
          child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.7),
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(children: [
                Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                SizedBox(width: size.width * 0.03),
                Text("Talk on Call",
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width * 0.03))
              ])),
        )
      ],
    );
  }

  _expColumn(Data data) {
    return Text("${data.experience.toInt()} Years");
  }

  _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      margin: EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.search,
              color: Colors.orange,
              size: size.width * 0.06,
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Astrologer",
                hintStyle:
                    TextStyle(color: Colors.grey, fontSize: size.width * 0.03),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.black,
              ),
              onChanged: (val) {
                Provider.of<AstrologerProvider>(context, listen: false)
                    .filterOnSearch(val);
              },
            ),
          ),
          InkWell(
            onTap: () {
              textController.clear();
              Provider.of<AstrologerProvider>(context, listen: false)
                  .getAstrologers();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.clear,
                color: Colors.orange,
                size: size.width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Talk to an Astrologer",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
          ),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                    });
                  },
                  child: Image.asset("assets/images/search.png",
                      width: size.width * 0.07)),
              SizedBox(width: size.width * 0.02),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilterScreen()));
                  },
                  child: Image.asset("assets/images/filter.png",
                      width: size.width * 0.07)),
              SizedBox(width: size.width * 0.02),
              _popupMenuButton()
            ],
          )
        ],
      ),
    );
  }

  PopupMenuButton<Menu> _popupMenuButton() {
    return PopupMenuButton(
        child: Image.asset("assets/images/sort.png", width: size.width * 0.07),
        onSelected: (Menu m) {
          setState(() {
            focusNode.unfocus();
            selected = m;
            if (m == Menu.ELTH) {
              Provider.of<AstrologerProvider>(context, listen: false)
                  .sortExpLTH();
            } else if (m == Menu.EHTL) {
              Provider.of<AstrologerProvider>(context, listen: false)
                  .sortExpHTL();
            } else if (m == Menu.PHTL) {
              Provider.of<AstrologerProvider>(context, listen: false)
                  .sortPriceHTL();
            } else {
              Provider.of<AstrologerProvider>(context, listen: false)
                  .sortPriceLTH();
            }
          });
        },
        itemBuilder: (context) {
          return <PopupMenuEntry<Menu>>[
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    selected == Menu.EHTL
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: size.width * 0.05,
                    color: selected == Menu.EHTL ? Colors.orange : null,
                  ),
                  SizedBox(width: size.width * 0.05),
                  Text("Experience- high to low"),
                ],
              ),
              value: Menu.EHTL,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                      selected == Menu.ELTH
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected == Menu.ELTH ? Colors.orange : null,
                      size: size.width * 0.05),
                  SizedBox(width: size.width * 0.05),
                  Text("Experience- low to high"),
                ],
              ),
              value: Menu.ELTH,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                      selected == Menu.PHTL
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected == Menu.PHTL ? Colors.orange : null,
                      size: size.width * 0.05),
                  SizedBox(width: size.width * 0.05),
                  Text("Price- high to low"),
                ],
              ),
              value: Menu.PHTL,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                      selected == Menu.PLTH
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected == Menu.PLTH ? Colors.orange : null,
                      size: size.width * 0.05),
                  SizedBox(width: size.width * 0.05),
                  Text("Price- low to high"),
                ],
              ),
              value: Menu.PLTH,
            ),
          ];
        });
  }
}

enum Menu { EHTL, ELTH, PHTL, PLTH }
