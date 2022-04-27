// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../helpers/singleton.dart';
import '../../../../helpers/strings.dart';
import '../../../../helpers/constant.dart';
import '../../../../helpers/colors.dart';
import '../../../../helpers/api_constant.dart';
import '../../../../models/related_courses_response_model.dart';
import '../../../../models/get_course_response_model.dart';
import '../../../../models/course_detail_response_model.dart';
import '../../../../service/api_service.dart';
import '../../../../widgets/common/common_button.dart';
import '../../../../widgets/common/safearea_widget.dart';

class QuizScreenDynamic extends StatefulWidget {
  final int? videoIndex;
  List<LessionList>? videoList;
  Course? courseItem;
  QuizPayload objQuiz;
  CourseDetailInnerData objCourseDetail;

  QuizScreenDynamic({
    this.videoIndex,
    this.videoList,
    Key? key,
    this.courseItem,
    required this.objQuiz,
    required this.objCourseDetail,
  }) : super(key: key);

  @override
  _QuizScreenDynamicState createState() => _QuizScreenDynamicState();
}

class _QuizScreenDynamicState extends State<QuizScreenDynamic> {
  int questionIndex = 0;
  int currentQuestion = 1;

  String appBarTitle = "";

  backPress() {
    Navigator.pop(context);
  }

  void checkOption() {
    var objCurrerentQuestion = widget.objQuiz.arrQuestions![questionIndex];
    var count = objCurrerentQuestion.arrAnswers!
        .where((c) => c.isSelected == true)
        .toList()
        .length;
    if (count <= 0) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.appName, "Please select 1 option.");
    } else {
      setState(() {
        if (questionIndex < widget.objQuiz.arrQuestions!.length - 1) {
          questionIndex = questionIndex + 1;
          currentQuestion = currentQuestion + 1;
        } else {
          List<Map<String, dynamic>> arrQuizData = [];
          for (int i = 0; i < widget.objQuiz.arrQuestions!.length; i++) {
            Map<String, dynamic> objQuizData = {};
            var objQuestion = widget.objQuiz.arrQuestions![i];
            objQuizData["question_id"] = objQuestion.id;

            for (int j = 0; j < objQuestion.arrAnswers!.length; j++) {
              var objAnswer = objQuestion.arrAnswers![j];

              if (objAnswer.isSelected == true) {
                objQuizData["answer"] = objAnswer.value;
              }
            }

            arrQuizData.add(objQuizData);
          }

          var strQuizData = jsonEncode(arrQuizData);
          submitQuizAPI(strQuizData);
        }
        appBarTitle = "$currentQuestion/${widget.objQuiz.arrQuestions!.length}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appBarTitle = "$currentQuestion/${widget.objQuiz.arrQuestions!.length}";
    return ColoredSafeArea(
      color: ColorCodes.navbar,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: Singleton.instance.CommonAppbar(
              appbarText: appBarTitle,
              leadingClickEvent: backPress,
              endText: Strings.submit.toUpperCase(),
              endTextClickEvent: checkOption),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: ColorCodes.yellow,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      "QUIZ",
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_13,
                          fontFamily: Constant.oxaniumFontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "OBEDIENCE FUNDAMENTALS",
                    style: Singleton.instance.setTextStyle(
                        fontSize: TextSize.text_22,
                        fontFamily: Constant.robotoCondensedFontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.objQuiz.arrQuestions![questionIndex].question!
                        .toUpperCase(),
                    style: Singleton.instance.setTextStyle(
                        fontSize: TextSize.text_14,
                        fontFamily: Constant.oxaniumFontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  ListView.builder(
                    shrinkWrap: true,
                    // itemCount: mycourse.getCourses.length,
                    itemCount: widget.objQuiz.arrQuestions![questionIndex]
                        .arrAnswers!.length,
                    itemBuilder: (context, index) {
                      var objOption = widget.objQuiz
                          .arrQuestions![questionIndex].arrAnswers![index];
                      return GestureDetector(
                        onTap: () {
                          var count = widget
                              .objQuiz.arrQuestions![questionIndex].arrAnswers!
                              .where((c) => c.isSelected == true)
                              .toList()
                              .length;

                          if (count > 0) {
                            var obj = widget.objQuiz
                                .arrQuestions![questionIndex].arrAnswers!
                                .firstWhere(
                                    (element) => element.isSelected == true);

                            for (var element in widget.objQuiz
                                .arrQuestions![questionIndex].arrAnswers!) {
                              element.isSelected = false;
                            }

                            if (obj.value ==
                                widget.objQuiz.arrQuestions![questionIndex]
                                    .arrAnswers![index].value) {
                              setState(() {});
                            } else {
                              widget.objQuiz.arrQuestions![questionIndex]
                                      .arrAnswers![index].isSelected =
                                  !widget.objQuiz.arrQuestions![questionIndex]
                                      .arrAnswers![index].isSelected;
                              setState(() {});
                            }
                          } else {
                            for (var element in widget.objQuiz
                                .arrQuestions![questionIndex].arrAnswers!) {
                              element.isSelected = false;
                            }

                            widget.objQuiz.arrQuestions![questionIndex]
                                    .arrAnswers![index].isSelected =
                                !widget.objQuiz.arrQuestions![questionIndex]
                                    .arrAnswers![index].isSelected;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          color: objOption.isSelected
                              ? ColorCodes.yellow
                              : ColorCodes.unselectedColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              objOption.isSelected
                                  ? Image.asset("", height: 26, width: 26)
                                  : Image.asset("", height: 26, width: 26),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  objOption.value,
                                  style: Singleton.instance.setTextStyle(
                                      fontSize: TextSize.text_14,
                                      fontFamily: Constant.robotoFontFamily,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CommonButton(
                      onPressed: () {
                        checkOption();
                      },
                      title: Strings.submit.toUpperCase(),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void submitQuizAPI(String quizData) {
    late Map<String, String> body;
    body = {
      ApiParamters.secret: widget.objQuiz.secret ?? "",
      ApiParamters.quiz_data: quizData,
    };

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.submitQuiz);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
          } else if (response.statusCode == 500) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          Singleton.instance.hideProgress();
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
        }
      }
    });
  }
}
