import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/choose_form.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class WelcomePage1 extends StatefulWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  State<WelcomePage1> createState() => _WelcomePage1State();
}

class _WelcomePage1State extends State<WelcomePage1> {
  @override
  void dispose() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    super.dispose();
    auth.dispose();
  }

  List<ContentConfig> slides = [];

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notification'),
            content:
                const Text('App của chúng tôi muốn truy cập quyền thông báo'),
            actions: [
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text(
                  'Đồng ý',
                  style: TextStyle(color: Colors.teal, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Hủy bỏ',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }
    });
    super.initState();
    slides.add(
      const ContentConfig(
        title: "ỨNG DỤNG CHĂM SÓC VÀ\nPHỤC HỒI CHỨC NĂNG",
        maxLineTitle: 30,
        styleTitle: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roadbrush',
          shadows: [
            Shadow(
                // bottomLeft
                offset: Offset(-1.5, -1.5),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.5, -1.5),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.5),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.5, 1.5),
                color: Colors.black),
          ],
        ),
        pathImage: "assets/images/welcome2.png",
        heightImage: 300,
        description: "Cùng bạn cải thiện,\nduy trì sức khoẻ.",
        styleDescription: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Color.fromARGB(255, 46, 161, 226),
      ),
    );
    slides.add(
      const ContentConfig(
        title: "Tư liệu miễn phí",
        marginTitle: EdgeInsets.symmetric(vertical: 40),
        styleTitle: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roadbrush',
          shadows: [
            Shadow(
                // bottomLeft
                offset: Offset(-1.5, -1.5),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.5, -1.5),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.5),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.5, 1.5),
                color: Colors.black),
          ],
        ),
        pathImage: "assets/images/welcome2.png",
        textAlignDescription: TextAlign.start,
        styleDescription: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
        description:
            "HEH có các bài tập Trị Liệu bao gồm nội dung tập và video miễn phí.\n\nNgoài ra bạn có thể tập chung với người thân của mình để cùng cãi thiện sức khỏe của bản thân.\n\nBạn cũng có thể lưu lại bài tập riêng của mình.",
        backgroundColor: Color.fromARGB(255, 46, 161, 226),
      ),
    );
    slides.add(
      const ContentConfig(
        title: "Dịch vụ tư vấn",
        marginTitle: EdgeInsets.symmetric(vertical: 40),
        styleTitle: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roadbrush',
          shadows: [
            Shadow(
                // bottomLeft
                offset: Offset(-1.5, -1.5),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.5, -1.5),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.5),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.5, 1.5),
                color: Colors.black),
          ],
        ),
        pathImage: "assets/images/welcome2.png",
        description:
            "Bạn sẽ dược tư vấn miễn phí bởi Chuyên Viên Trị Liệu.\n\nĐể góp phần bảo vệ môi trường cũng như là tiện lợi cho bạn.\n\nHEH sẽ cung cấp dịch vụ trả phí với hình thức Video Call, Chuyên Viên Trị Liệu sẽ tư vấn, theo dõi bạn.\n\n Ngoài ra bạn có thể chọn Chuyên VIên mà mình mong muốn",
        textAlignDescription: TextAlign.start,
        styleDescription: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
        backgroundColor: Color.fromARGB(255, 46, 161, 226),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        key: scaffoldKey,
        renderSkipBtn: const Text("Bỏ qua",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15)),
        renderNextBtn: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text("Tiếp theo",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
        ),
        renderDoneBtn: const Text("Kết thúc",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15)),
        scrollPhysics: const ClampingScrollPhysics(),
        indicatorConfig: const IndicatorConfig(
            colorActiveIndicator: Colors.white,
            typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
            colorIndicator: Colors.black,
            spaceBetweenIndicator: 10),
        listContentConfig: slides,
        onDonePress: () {
          Navigator.push(scaffoldKey.currentContext!,
              MaterialPageRoute(builder: (context) => const ChooseForm()));

        },
        onSkipPress: () {
          Navigator.push(scaffoldKey.currentContext!,
              MaterialPageRoute(builder: (context) => const ChooseForm()));
        },
      ),
    );
  }
}
