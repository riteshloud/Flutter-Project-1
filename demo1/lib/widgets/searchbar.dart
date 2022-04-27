// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../screens/Profile/profile_screen.dart';
import '../helpers/colors.dart';
import '../helpers/constant.dart';
import '../helpers/singleton.dart';
import '../helpers/strings.dart';

class SearchBarWidget extends StatefulWidget {
  var searchHint;
  Function doneFunction;
  var title = "";
  Function makePostFunction;
  Function refreshList;
  var fromCommunity = false;
  var requireBackArrow = false;
  var visibleProfile = true;
  SearchBarWidget(
      this.searchHint,
      this.doneFunction,
      this.title,
      this.makePostFunction,
      this.refreshList,
      this.fromCommunity,
      this.requireBackArrow,
      this.visibleProfile,
      {Key? key})
      : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  var _isSearch = false;
  final searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();

  @override
  void initState() {
    setState(() {
      Singleton.instance.userProfile;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorCodes.navbar,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Visibility(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: PlatformIconButton(
                    padding: const EdgeInsets.only(right: 30),
                    onPressed: () => {Navigator.of(context).pop()},
                    icon: Image.asset(
                      "",
                      width: 26,
                      height: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
                visible: widget.requireBackArrow,
              ),
              Expanded(
                child: Container(
                  decoration: GlobalStyleAndDecoration.textFieldBoxDecoration,
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.doneFunction(1, value);
                      } else {
                        widget.doneFunction(0, value);
                      }
                    },
                    controller: searchController,
                    focusNode: searchNode,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          _isSearch ? Icons.close : Icons.search,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: widget.searchHint,
                      hintStyle: Singleton.instance.setTextStyle(
                        textColor: ColorCodes.hintcolor,
                        fontFamily: Constant.robotoFontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Visibility(
                visible: widget.visibleProfile,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                isViewProfile: false,
                                userID: "",
                              )),
                    ).then((value) {
                      widget.doneFunction(0, "");
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    // margin: const EdgeInsets.only(right: 16, top: 40),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: (Singleton.instance.userProfile.isEmpty)
                          ? Singleton.instance.placeholderWidget(30, 30)
                          : CachedNetworkImage(
                              memCacheHeight: null,
                              memCacheWidth: 200,
                              imageUrl: Singleton.instance.userProfile,
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Singleton.instance.placeholderWidget(30, 30),
                              errorWidget: (context, url, error) =>
                                  Singleton.instance.placeholderWidget(30, 30),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          //const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: PlatformText(
                  widget.title.toUpperCase(),
                  style: Singleton.instance.setTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: Constant.robotoCondensedFontFamily,
                      textColor: Colors.white),
                ),
              ),
              Visibility(
                visible: widget.fromCommunity,
                child: GestureDetector(
                  onTap: () {
                    widget.makePostFunction();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.newPost,
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_12,
                            fontWeight: FontWeight.w700,
                            fontFamily: Constant.oxaniumFontFamily,
                            textColor: ColorCodes.yellow),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Image.asset(
                        "",
                        height: 12,
                        width: 12,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
